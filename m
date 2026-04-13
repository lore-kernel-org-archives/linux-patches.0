Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEFA62FFFBE;
	Mon, 13 Apr 2026 16:22:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097335; cv=none; b=sqAlJpSUC0V1lhR27aS4eh+GFLYOM/sWdHpPjC1Q+i+eMrCrloW+0TcyEeTp3Y4iO00ZdRSG5DbB+mEn9+6A/vwHej7z0rWZgl2cmCXddC4T1+4uMCFxVvt4tHrgQgWyo7Ee133lr1CcCTLiuNnyL2gUSdVFB3vrJawSKxglMmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097335; c=relaxed/simple;
	bh=eoh3XpO6gywgHJvYSS786ouQRJE0Sn9QjZcIQW95nX4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XjDvYMAjQuUx8YCiQLJVzp+D0k/KbZty0WMhtrBcYLSD0PFXgt7DnGihpz2vDB66Mc99MyeV+/R7dAJan9OZyp/VZGcJtfdEa4xQapid1JFj6t3NVBT8i5Q43nw+6+3aobXg4+NKMMCIdGh0Oh7RCnHFq4euqPVt99TSJYOYyiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ea10nOt5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ea10nOt5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 450F2C2BCAF;
	Mon, 13 Apr 2026 16:22:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097334;
	bh=eoh3XpO6gywgHJvYSS786ouQRJE0Sn9QjZcIQW95nX4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ea10nOt53PiYvCeIwFVm/10MgLtR3uyx067cAgT6zw1UpThsAi/m6RIKiDA+pe2Au
	 5C81KhXyMQxH48/BYgoIJkH3lrdkJMbjjIuxQRe7GWEJwZIxis51Kwbopdd84JDKwV
	 PFOk8kcPXRjCKhZpkB+JC3Z/1bm+qiQHySmM9/rw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 097/570] ALSA: usb-audio: Check max frame size for implicit feedback mode, too
Date: Mon, 13 Apr 2026 17:53:48 +0200
Message-ID: <20260413155834.077063590@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 7cb2a5422f5bbdf1cf32eae0eda41000485b9346 ]

When the packet sizes are taken from the capture stream in the
implicit feedback mode, the sizes might be larger than the upper
boundary defined by the descriptor.  As already done for other
transfer modes, we have to cap the sizes accordingly at sending,
otherwise this would lead to an error in USB core at submission of
URBs.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=221076
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20260225085233.316306-3-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/endpoint.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/usb/endpoint.c b/sound/usb/endpoint.c
index 6ba99ff2cefcf..22eb5de94c2be 100644
--- a/sound/usb/endpoint.c
+++ b/sound/usb/endpoint.c
@@ -223,6 +223,7 @@ int snd_usb_endpoint_next_packet_size(struct snd_usb_endpoint *ep,
 
 	packet = ctx->packet_size[idx];
 	if (packet) {
+		packet = min(packet, ep->maxframesize);
 		if (avail && packet >= avail)
 			return -EAGAIN;
 		return packet;
-- 
2.51.0



