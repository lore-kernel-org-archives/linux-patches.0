Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 413B21863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:24:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B751EC433EF;
	Wed, 28 Dec 2022 15:24:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672241053;
	bh=VN9M4iMM4clNQxQXqqVor1g9XHH1T+QIhpc3P6vGCTE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uHms/GJi614raEFQK6Av6amAIcxd7HrITRfGCnoZtk0xc+zftI5Ztt2IiVEfTlWe0
	 FB/YnkDprHRMg+yOXetot+IZ66VrGrb7fh/LRCVddkLS3fpOxfFbrGxRe3edvHsuSP
	 C2s7bn/FG+ohDUa2sJ3JN1swGLO1EjRdAr1H3Wtk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rafael Mendonca <rafaelmendsr@gmail.com>,
	Tommaso Merciai <tommaso.merciai@amarulasolutions.com>,
	Martin Kepplinger <martink@posteo.de>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0234/1073] media: i2c: hi846: Fix memory leak in hi846_parse_dt()
Date: Wed, 28 Dec 2022 15:30:22 +0100
Message-Id: <20221228144334.382169544@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Rafael Mendonca <rafaelmendsr@gmail.com>

[ Upstream commit 80113026d415e27483669db7a88b548d1ec3d3d1 ]

If any of the checks related to the supported link frequencies fail, then
the V4L2 fwnode resources don't get released before returning, which leads
to a memleak. Fix this by properly freeing the V4L2 fwnode data in a
designated label.

Fixes: e8c0882685f9 ("media: i2c: add driver for the SK Hynix Hi-846 8M pixel camera")
Signed-off-by: Rafael Mendonca <rafaelmendsr@gmail.com>
Reviewed-by: Tommaso Merciai <tommaso.merciai@amarulasolutions.com>
Reviewed-by: Martin Kepplinger <martink@posteo.de>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/hi846.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/media/i2c/hi846.c b/drivers/media/i2c/hi846.c
index ad35c3ff3611..254031503c72 100644
--- a/drivers/media/i2c/hi846.c
+++ b/drivers/media/i2c/hi846.c
@@ -2008,22 +2008,24 @@ static int hi846_parse_dt(struct hi846 *hi846, struct device *dev)
 	    bus_cfg.bus.mipi_csi2.num_data_lanes != 4) {
 		dev_err(dev, "number of CSI2 data lanes %d is not supported",
 			bus_cfg.bus.mipi_csi2.num_data_lanes);
-		v4l2_fwnode_endpoint_free(&bus_cfg);
-		return -EINVAL;
+		ret = -EINVAL;
+		goto check_hwcfg_error;
 	}
 
 	hi846->nr_lanes = bus_cfg.bus.mipi_csi2.num_data_lanes;
 
 	if (!bus_cfg.nr_of_link_frequencies) {
 		dev_err(dev, "link-frequency property not found in DT\n");
-		return -EINVAL;
+		ret = -EINVAL;
+		goto check_hwcfg_error;
 	}
 
 	/* Check that link frequences for all the modes are in device tree */
 	fq = hi846_check_link_freqs(hi846, &bus_cfg);
 	if (fq) {
 		dev_err(dev, "Link frequency of %lld is not supported\n", fq);
-		return -EINVAL;
+		ret = -EINVAL;
+		goto check_hwcfg_error;
 	}
 
 	v4l2_fwnode_endpoint_free(&bus_cfg);
@@ -2044,6 +2046,10 @@ static int hi846_parse_dt(struct hi846 *hi846, struct device *dev)
 	}
 
 	return 0;
+
+check_hwcfg_error:
+	v4l2_fwnode_endpoint_free(&bus_cfg);
+	return ret;
 }
 
 static int hi846_probe(struct i2c_client *client)
-- 
2.35.1



