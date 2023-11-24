Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D525F31759;
	Fri, 24 Nov 2023 19:12:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tkpU8xHS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 605D4C433C8;
	Fri, 24 Nov 2023 19:12:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700853179;
	bh=SjUztJBfEddu0RRbAB4M1vbzu5/Tbc4G0bN91Cido94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tkpU8xHSgFOdDBwBH3mxyHwEMSEa0HgGlRsU5IuJnFePMwDnnjFsIexWGsyaU6Cbk
	 yDU6UaDrMoy43VnU46uC94+7xOtB0pD5Jc4izfBwI9EnrH+Tah4PAOpVzr6+46w3cZ
	 5FGtyquGn7NpnzT0BD/wrlewgd1UVa6fOTTvG6Bw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pratyush Yadav <p.yadav@ti.com>,
	Julien Massot <julien.massot@collabora.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Maxime Ripard <mripard@kernel.org>,
	Jai Luthra <j-luthra@ti.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 086/297] media: cadence: csi2rx: Unregister v4l2 async notifier
Date: Fri, 24 Nov 2023 17:52:08 +0000
Message-ID: <20231124172003.258790105@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172000.087816911@linuxfoundation.org>
References: <20231124172000.087816911@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pratyush Yadav <p.yadav@ti.com>

[ Upstream commit b2701715301a49b53d05c7d43f3fedc3b8743bfc ]

The notifier is added to the global notifier list when registered. When
the module is removed, the struct csi2rx_priv in which the notifier is
embedded, is destroyed. As a result the notifier list has a reference to
a notifier that no longer exists. This causes invalid memory accesses
when the list is iterated over. Similar for when the probe fails.
Unregister and clean up the notifier to avoid this.

Fixes: 1fc3b37f34f6 ("media: v4l: cadence: Add Cadence MIPI-CSI2 RX driver")

Signed-off-by: Pratyush Yadav <p.yadav@ti.com>
Tested-by: Julien Massot <julien.massot@collabora.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Reviewed-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Reviewed-by: Maxime Ripard <mripard@kernel.org>
Signed-off-by: Jai Luthra <j-luthra@ti.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/cadence/cdns-csi2rx.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/media/platform/cadence/cdns-csi2rx.c
+++ b/drivers/media/platform/cadence/cdns-csi2rx.c
@@ -407,8 +407,10 @@ static int csi2rx_parse_dt(struct csi2rx
 							   fwh,
 							   struct v4l2_async_subdev);
 	of_node_put(ep);
-	if (IS_ERR(asd))
+	if (IS_ERR(asd)) {
+		v4l2_async_notifier_cleanup(&csi2rx->notifier);
 		return PTR_ERR(asd);
+	}
 
 	csi2rx->notifier.ops = &csi2rx_notifier_ops;
 
@@ -471,6 +473,7 @@ static int csi2rx_probe(struct platform_
 	return 0;
 
 err_cleanup:
+	v4l2_async_notifier_unregister(&csi2rx->notifier);
 	v4l2_async_notifier_cleanup(&csi2rx->notifier);
 err_free_priv:
 	kfree(csi2rx);
@@ -481,6 +484,8 @@ static int csi2rx_remove(struct platform
 {
 	struct csi2rx_priv *csi2rx = platform_get_drvdata(pdev);
 
+	v4l2_async_notifier_unregister(&csi2rx->notifier);
+	v4l2_async_notifier_cleanup(&csi2rx->notifier);
 	v4l2_async_unregister_subdev(&csi2rx->subdev);
 	kfree(csi2rx);
 


