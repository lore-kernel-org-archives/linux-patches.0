Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062950;
	b=hEvDCYRyttlc20CcInQeCa07jKBOrxKiRDglTIWo/z8lUz+FNPcaWf+NVzvuk9nQ/d56
	 +RdFFn2xK3pd9lmsK61eq71OpieY/bEljyS7A0Eit9oF/qpW3fP6kJGuSGad2hZlN8vU7
	 uR72/kDidGwnBIbFGrxPgIFpijoV+NeU3K2a6FjA9r4DcS4zgcj12DYlQ6XnteG5387ZG
	 yCNM2tgh4V1M0PXEJHblVM2Ts0DxNCvOdFjWUHi3NKJz5s5i3BfQ3h/QFAjJo2UC/v1K2
	 nq1X/V0PshFRZzjJfd5h6al82Twy5WxHXNHH1sM4Gx+EeMklne3qE/YD6J0xKYW6znw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062950;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xCHXLz/7cigrazwUjQ/7ck3lyURoQqjqS8+ojS2X+rA=;
	b=hjhfOz7aKSVw7YTftprBXdPJ57D7A5/2uMAGoSG5HOWM1C1v9s6w0suBuNuK+G676sJ6
	 ZynA+JeDdIrhg/Hbc9sYnCaYemp5YYA6ICXgw1NI252uwk8hwji/cXHt/KQzqJTUJeztV
	 vMRvEZh9uMMkrYDB36JXV6MHEyv0546o14JfsuPoVUm/m+QajyEf6XnFWR20P9P1VQ3wy
	 qsNu8Q50jf1NInED8SApIyY/J96Sa553wjvSv6ViRWpQRp8vBwJrhzYn2Dfi3Nr94Kp2x
	 FtX0wEkD+kidedKxYQnAEAxzfZg8g4D+S7fGHRbAXgUMHlT31FyHyyidPSLKdbYrr0w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jjk4qMEE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FF2A606A32C;
	Sat,  7 Nov 2026 14:49:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jjk4qMEE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F9C11F0089F;
	Sat,  7 Nov 2026 14:49:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062950;
	bh=xCHXLz/7cigrazwUjQ/7ck3lyURoQqjqS8+ojS2X+rA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jjk4qMEEm+utvxlJxd+yp0cQpcPbHXuUWuWItCN2sAHGA/vyYQfZCFEItgz8u7AtF
	 uY+l7XPao/W5x8cY7aDN6FikYh8C9VMVDFwn5/pcWGai2FlCGsRebz87qN5Hoyo1U5
	 HdoiIIETmfa+EJ1IpAqCJuLG1psb/YhudcYz1R1g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 215/869] media: au0828: Fix media device leak in au0828_usb_probe()
Date: Sat,  7 Nov 2026 08:48:17 -0500
Message-ID: <20261107134859.228996857@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit 7b7a69c91c0537d48150942d9707614a4fdd3766 ]

au0828_media_device_init() takes a reference to a media device with
media_device_usb_allocate().  When au0828_v4l2_device_register()
fails right after, the error path only unregisters the entities and
frees au0828_dev, so that reference is never released.

Release it with media_device_delete() on that path.

Fixes: 812658d88d26 ("media: change au0828 to use Media Device Allocator API")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/au0828/au0828-core.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/media/usb/au0828/au0828-core.c b/drivers/media/usb/au0828/au0828-core.c
index 1e246b47766dd..c7ff52044bd25 100644
--- a/drivers/media/usb/au0828/au0828-core.c
+++ b/drivers/media/usb/au0828/au0828-core.c
@@ -697,6 +697,10 @@ static int au0828_usb_probe(struct usb_interface *interface,
 	retval = au0828_v4l2_device_register(interface, dev);
 	if (retval) {
 		au0828_usb_v4l2_media_release(dev);
+#ifdef CONFIG_MEDIA_CONTROLLER
+		media_device_delete(dev->media_dev, KBUILD_MODNAME,
+				    THIS_MODULE);
+#endif
 		mutex_unlock(&dev->lock);
 		kfree(dev);
 		return retval;
-- 
2.53.0



