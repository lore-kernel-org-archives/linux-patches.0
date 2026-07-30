Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFA2A217723;
	Thu, 30 Jul 2026 16:07:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427653; cv=none; b=ITsL9/fWJUAm0M0W8+r6k10WnGyXDSK3dAzKg3rz+4Uhwd/x4UEV+ZZCFFjeV+vlJLtzc6QyxwvITNMQHdStI1AKsY7z/SAP0V2FhitytM5ixBU3dxMGWCufeLxq5FO6b3r9BdBVDv5Q1lHjSjwdbv1v2UpV54M+DrY0scstQbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427653; c=relaxed/simple;
	bh=0Dv+odFv5SD8UVEuJ2ugtolMgFg3VWcVKA4J9mKN13E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aHnsP7euaHd2HwwfYOj8H3KSsD/f8ZPIyi0Up0y5Dwmq3yHJq4K/SQKLgE2pfoGp6Xm8HJ/ffTeEw1P1O7eOIbGF9R8c+sc3HCX+4WvxQ7JsBwsQtWdru2dlOYgRoyBlAiPFKvbr98ApUef4/aORapD1QP1C1bdcfsA56hlT9Pg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bip9m8D8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bip9m8D8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 385C41F000E9;
	Thu, 30 Jul 2026 16:07:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427652;
	bh=ot+0u3EgGnbDJLgbJWbqRu1FhJ+LtSxYUxOLE3byqMk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bip9m8D82rk2XFTaumaNRqpBEdAhRrG2+QjHoxtqLXzDz+01vABzHAKRVT4zjkan5
	 SaweD6CyZy7UW3Q4IPZl9KTp+1SXzecYIFWODxyBFQ25l+FEHRit4dyJ2d+BIpA4DI
	 36CJdoEbCxDf4ZN8G93QA112+mo1ECd4jCRw8xys=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiaolei Wang <xiaolei.wang@windriver.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Frank Li <Frank.Li@nxp.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.6 246/484] media: nxp: imx8-isi: Clean up already-initialized pipes on probe failure
Date: Thu, 30 Jul 2026 16:12:23 +0200
Message-ID: <20260730141428.829598761@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Xiaolei Wang <xiaolei.wang@windriver.com>

commit d970b27cc48ec42f8a72bc3a4a4ad2e5c7a36395 upstream.

When mxc_isi_pipe_init() fails partway through the channel loop or
when mxc_isi_v4l2_init() fails, the already initialized pipes are
not cleaned up.

Fix this by calling mxc_isi_pipe_cleanup() for each already-initialized
pipe in the err_xbar error path.

Fixes: cf21f328fcaf ("media: nxp: Add i.MX8 ISI driver")
Cc: stable@vger.kernel.org
Signed-off-by: Xiaolei Wang <xiaolei.wang@windriver.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260507041318.491594-5-xiaolei.wang@windriver.com
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/nxp/imx8-isi/imx8-isi-core.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/media/platform/nxp/imx8-isi/imx8-isi-core.c
+++ b/drivers/media/platform/nxp/imx8-isi/imx8-isi-core.c
@@ -503,6 +503,8 @@ static int mxc_isi_probe(struct platform
 	return 0;
 
 err_xbar:
+	while (i--)
+		mxc_isi_pipe_cleanup(&isi->pipes[i]);
 	mxc_isi_crossbar_cleanup(&isi->crossbar);
 
 	return ret;


