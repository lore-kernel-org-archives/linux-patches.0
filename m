Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 887AA1C618F;
	Thu,  6 Jun 2024 14:21:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683695; cv=none; b=HVVF/2YA/kMxKTe1cJSd/ltQWttqDYKsqnlwdxGJmdycAYN3LBVxvHfa+zDUIY+ppSCb9dQ7q69xMV14VZTLWORfyWvCe78K2qXRyT9DWryXYD/zZaXEidmHRCvoJg2aEyXWa3Bhv2XvVX1eThRCoTKhWUkq0th53eI7yXIlBds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683695; c=relaxed/simple;
	bh=/0XqRQE0mEzcV6lBqF+4xYbYMGL4hGqUlBm/MzYYjSY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g4cP56FU2dHC/ZVDzFPOApF86IZofOOnzJGZZshEgI3qdO+gIT5dmE7IXuDf/PQ2Sm0cYNTNdoWNJnF2Kex79lyalTK4edEraNb3gyYJyVfjbpNfXmm7ofyGraktioM/oYaJnZGgc4bFN25tCHmQ6ilArZuGc1Vvt3yV75FcqLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KkUaRWPk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KkUaRWPk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67940C2BD10;
	Thu,  6 Jun 2024 14:21:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683695;
	bh=/0XqRQE0mEzcV6lBqF+4xYbYMGL4hGqUlBm/MzYYjSY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KkUaRWPkfYmhKWDpYOqmq5cClgfNfkERNngn6d3GaaxiPleCz1b40efJ2tEtP7gSv
	 in2bHeNB092EyCaP8KetmOMvJ6+qo0u3WXaa9odGuKr54B2FHuVOJ/P3U4OCNjxVMi
	 rq7/J76pjbOMlwW3OPBiAWoNvfntAxsbqHhIxV6U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	Fabio Estevam <festevam@denx.de>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 569/744] media: ov2680: Clear the ret variable on success
Date: Thu,  6 Jun 2024 16:04:01 +0200
Message-ID: <20240606131750.703220860@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fabio Estevam <festevam@denx.de>

[ Upstream commit 49a9bad83b4ab5dac1d7aba2615c77978bcf3984 ]

Since commit 63b0cd30b78e ("media: ov2680: Add bus-cfg / endpoint
property verification") even when the correct 'link-frequencies'
property is passed in the devicetree, the driver fails to probe:

ov2680 1-0036: probe with driver ov2680 failed with error -22

The reason is that the variable 'ret' may contain the -EINVAL value
from a previous assignment:

ret = fwnode_property_read_u32(dev_fwnode(dev), "clock-frequency",
			       &rate);

Fix the problem by clearing 'ret' on the successful path.

Tested on imx7s-warp board with the following devicetree:

port {
	ov2680_to_mipi: endpoint {
		remote-endpoint = <&mipi_from_sensor>;
		clock-lanes = <0>;
		data-lanes = <1>;
		link-frequencies = /bits/ 64 <330000000>;
	};
};

Cc: stable@vger.kernel.org
Fixes: 63b0cd30b78e ("media: ov2680: Add bus-cfg / endpoint property verification")
Suggested-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Fabio Estevam <festevam@denx.de>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Stable-dep-of: 24034af644fc ("media: ov2680: Do not fail if data-lanes property is absent")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/ov2680.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/i2c/ov2680.c b/drivers/media/i2c/ov2680.c
index 72bab0ff8a36a..7b1d9bd0b60f3 100644
--- a/drivers/media/i2c/ov2680.c
+++ b/drivers/media/i2c/ov2680.c
@@ -1123,6 +1123,7 @@ static int ov2680_parse_dt(struct ov2680_dev *sensor)
 		goto out_free_bus_cfg;
 	}
 
+	ret = 0;
 out_free_bus_cfg:
 	v4l2_fwnode_endpoint_free(&bus_cfg);
 	return ret;
-- 
2.43.0



