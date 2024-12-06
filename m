Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51690149C51;
	Fri,  6 Dec 2024 15:25:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733498733; cv=none; b=SBYWCLwQ5+ytoG3mAzcjyXPCsDN/YcoQk8tRTT5E0IoTJUG2FA4u0F5dEO9LOjeKK7/KW+Zq2pSd3gr664i0oyX69KkKzmQqEZ3fIe38giNEa6kEf43pbGhjl3yYK4+jQ0yWLyerWe2lkpfYjBuo/JpJWqbNFeP3DvIRIBIcEFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733498733; c=relaxed/simple;
	bh=HVTlBSypLR2mIud434xm6/WU/QawF/UR4SF/+UY/zD8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b/+D8+lrhGSAQ7KYeNltxgv60/9vBO1oFmb2Na6KXSHdbw//C2ARHYHisGDLYNDx0IQbAH54VAvr9LNvZnzvnOsnnDQu8/uV+tGrdN3IOi3nuX0TTdABct1Fog6TwsE4jmhp6uoc2uSwyyIWfbZrin8iMpckCmCJSDSMJ6lHfVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yuzNniXC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yuzNniXC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4BA8C4CED1;
	Fri,  6 Dec 2024 15:25:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733498733;
	bh=HVTlBSypLR2mIud434xm6/WU/QawF/UR4SF/+UY/zD8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yuzNniXC1eFJnhNE84pIguHOjro6Kj0rBCb4MWBlATxTo/l4MspbYIDoGbWzaN+5g
	 cZaLdLzdH8OSpF/GMFTAbMSX2+UX7aCFNPyuqkLUaX9kH2tWqBwj4UxzadkL5q+MhM
	 WiFvipL5yQSZhwZAD+xOpfZPatsb7W7VRK5DGJWs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steffen Dirkwinkel <s.dirkwinkel@beckhoff.com>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Subject: [PATCH 6.6 672/676] drm: xlnx: zynqmp_dpsub: fix hotplug detection
Date: Fri,  6 Dec 2024 15:38:11 +0100
Message-ID: <20241206143719.618807520@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

From: Steffen Dirkwinkel <s.dirkwinkel@beckhoff.com>

commit 71ba1c9b1c717831920c3d432404ee5a707e04b4 upstream.

drm_kms_helper_poll_init needs to be called after zynqmp_dpsub_kms_init.
zynqmp_dpsub_kms_init creates the connector and without it we don't
enable hotplug detection.

Fixes: eb2d64bfcc17 ("drm: xlnx: zynqmp_dpsub: Report HPD through the bridge")
Cc: stable@vger.kernel.org
Signed-off-by: Steffen Dirkwinkel <s.dirkwinkel@beckhoff.com>
Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241028134218.54727-1-lists@steffen.cc
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xlnx/zynqmp_kms.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/xlnx/zynqmp_kms.c
+++ b/drivers/gpu/drm/xlnx/zynqmp_kms.c
@@ -506,12 +506,12 @@ int zynqmp_dpsub_drm_init(struct zynqmp_
 	if (ret)
 		return ret;
 
-	drm_kms_helper_poll_init(drm);
-
 	ret = zynqmp_dpsub_kms_init(dpsub);
 	if (ret < 0)
 		goto err_poll_fini;
 
+	drm_kms_helper_poll_init(drm);
+
 	/* Reset all components and register the DRM device. */
 	drm_mode_config_reset(drm);
 


