Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062068;
	b=OS+jzVFu4rjuwL9+trwjnGClWvZkmyvNBS1aaOrfTf0AG2Qy0yq3IFKNUj1aJlSRVse9
	 ujJ/D0WNWbMqGk5DMa5UM4juOQrQeHK0EM+AnTK+8f/5kt2KZzwjP0Sg7DM0aWpQER/sA
	 w52R4JJNQ57aLBsaSP0ojRTky8eKZyGaPr81x4tN/JmZgsZKQtNdv62gTCIz3rt4EnsTQ
	 biC6aKUHXJxVQ0Ou80aR7z1+vXiPNh6YfRn47rZbBcBGbIWgJSlcrsiQiIsvHz/PePLZv
	 1SZcT9k9uOCkh5+wlz3vxOal19RjyMZ3eHz/j63o8KWGc9tVypukXSU7sqQfa2NgPAA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062068;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Cx34+HJjaI+Sx8HgNBEb1klzyWa9BM2Gv/X0dTkJr1Q=;
	b=lmwFN3ZB3o4f/0koBSpeTs71bGvdQMh1BWaMIGM/J1NPTRuPBMnOIdYXMX0YNwlKebTA
	 yRIBbzz4pK5l5h0z4yBg4h4eu/dY1YF05egLO/0B1fL91uePvZYLk28sBVz1Pa2SlOFuS
	 PzFLNYoh/qO2ZmucZuc/WQWNReY0QE6x5HpBrcmaXuQVa5ZVqF+jJ84dql0YNt7L14stQ
	 X4QKwtTakBifEPJreOgH0OQLCmii7f6EDB8/P0WeW3m26hgi3WxCKND3ktXFltlwsrfnl
	 hDcGvxFrXxaFvYP/yP+Blc2XyMki+dca67eKUZ5N6oo5uKzcvEMn9IXqQRjjBtOUgvQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VQXd7NXQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C34FE606A33B;
	Sat,  7 Nov 2026 14:34:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VQXd7NXQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 723B61F008A1;
	Sat,  7 Nov 2026 14:34:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062067;
	bh=Cx34+HJjaI+Sx8HgNBEb1klzyWa9BM2Gv/X0dTkJr1Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VQXd7NXQif/a+6wNYK7igouZaMBTJn3r3b5r/y94GUTSrUk6WY0+uxQmVHgfPCy06
	 k1gFwpTX7ZkoxBWURnVpRrBdRSSIFoh7JNdAv5Ltlfy+s8VbyG0X3z10rlw09WuSz+
	 qpdYvuexQHDjhrEpLkcCQ0cb7T1TtM66CzuD9ogE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1047/1536] media: au0828: Fix media device leak in au0828_usb_probe()
Date: Sat,  7 Nov 2026 08:51:03 -0500
Message-ID: <20261107135027.083697938@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



