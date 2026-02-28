Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F3A33314C3
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:53:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301207; cv=none; b=XAKOUCBQ0H7zlkZ3daSiawvNLbI6CxXGTKP67qUxngL6V8A/5bgi48VaVbtFczzV86bU5EuI0QD3puPFcKlzUxhDlSsiRH0MBflDsTIXDRSU23JINzYTlfvj1SzqOY3O4MwDiMDFBQ31q7wAD5p7gyKU3AS1eWjo20Dr4sDZelU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301207; c=relaxed/simple;
	bh=BB4AzPl4t5kPQuqC4A5ciiadMHukm93EoLbGLMS1ymU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iibSF27MT+QFRqLPDplzPk0MQgu95E9fn27oLbuFeL/WI9Jk4n3JVX8gz/ZNng5zcIJODuEdulR62a+1iFq04+UOS5w1kR3kAxQclnHDndYqwgNDozClcLFM702RsG9LDmpBbD5Ff0KyQzdE5eTVBpP0Vrd59FwKQvaU8otPWuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pqneetvU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pqneetvU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5423C2BC87;
	Sat, 28 Feb 2026 17:53:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301207;
	bh=BB4AzPl4t5kPQuqC4A5ciiadMHukm93EoLbGLMS1ymU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pqneetvUBSR2dgsp1bvt0ed5COeFkSFd9FiImLgHeONxrz8uuxGJuI8Xl3pVFygX9
	 zx1Ib+hN7+gjwSaf7QeVn0rsMEiuUW5S3u9Rh5CKPJxeBUrdwuF1k5xJS2/W8q98CN
	 icdBIfOsWf/x/0f4Yqck8NZNAvjxgtCf325klLwNdeI6bu37vAosinlhafgCyEZktG
	 5YPu/9mZhW5LG11z6Y8AgxE8koFE+lrjM4DZwh5fUbiyNbhPxFZ2KWj69OF1lxlJ5W
	 2zXlINIRavXQqt9EhaRh2emV+POp2q8tDYRBRLupuVTgGljkySe7aHsc0f6fT2uf1u
	 mUKtZkoeRMlag==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 381/752] ALSA: usb-audio: Update the number of packets properly at receiving
Date: Sat, 28 Feb 2026 12:41:32 -0500
Message-ID: <20260228174750.1542406-381-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit cf044e44190234a41a788de1cdbb6c21f4a52e1e ]

At receiving the packets from the implicit feedback source, we didn't
update ctx->packets field but only the ctx->packet_size[] data.
In exceptional cases, this might lead to unexpectedly superfluous data
transfer (although this won't happen usually due to the nature of USB
isochronous transfer).  Fix it to update the field properly.

Link: https://patch.msgid.link/20260216141209.1849200-2-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/endpoint.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/usb/endpoint.c b/sound/usb/endpoint.c
index cc15624ecaffe..6741ce368dd1c 100644
--- a/sound/usb/endpoint.c
+++ b/sound/usb/endpoint.c
@@ -481,6 +481,7 @@ int snd_usb_queue_pending_output_urbs(struct snd_usb_endpoint *ep,
 
 		/* copy over the length information */
 		if (implicit_fb) {
+			ctx->packets = packet->packets;
 			for (i = 0; i < packet->packets; i++)
 				ctx->packet_size[i] = packet->packet_size[i];
 		}
-- 
2.51.0

