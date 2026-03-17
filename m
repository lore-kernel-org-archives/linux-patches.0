Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20DD634AB17;
	Tue, 17 Mar 2026 16:39:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773765579; cv=none; b=dxFsE7FS9mQstENoomvdWxtUmYTg8TYGT6Aa6f8xudGkxTJ1JFJ5IfJUJ4PUAc8nI7Z9O+SCqs9tzqBkM+wR7RlXwtTZXEXrnyITQERuP9gdU3yqjWRJMEGO4U8B2CgXWOzb+xkk7gIJnUCCpBZ3JWMRsspR+sH/wjixQS8AoYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773765579; c=relaxed/simple;
	bh=9xmVpsu3q6K/LNAAFx6wELRscEpczIlbrnAjBCwdYtI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oQ++brNAI9vs+ZbUfHu8L9oIt9qmR20vm/s42n6ymfFl2igItB5/lxF7JnzM581RibHQAgo33khTabPpIM675fP+mx8BsQp0G2p4q05I4Sq3bnVB22ZJn0QP/YSYHbd++minKo4sfNGnDwPMJCVIE9MfpAYR7Vxmr1b2VBrBSU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KTGZw6lQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KTGZw6lQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 472BFC4CEF7;
	Tue, 17 Mar 2026 16:39:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773765578;
	bh=9xmVpsu3q6K/LNAAFx6wELRscEpczIlbrnAjBCwdYtI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KTGZw6lQaa8YkXDnXxVveMWnJ17jrseJzB5puQuOxSkvdomcNsoS5iu69DnaKdn56
	 X7V1w0IZNtRFqubDfyMD7S911sTZi9vqZ0mHPycRvdoaUqmvqqj/7vgRIMl+1iUC4o
	 Bz8zOwwKKFiPEgMs76OQK4ki/EGsaQm+rK62N2ZE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 025/378] ALSA: usb-audio: Check max frame size for implicit feedback mode, too
Date: Tue, 17 Mar 2026 17:29:42 +0100
Message-ID: <20260317163007.904241209@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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
index 686f095290673..1a020ea558755 100644
--- a/sound/usb/endpoint.c
+++ b/sound/usb/endpoint.c
@@ -221,6 +221,7 @@ int snd_usb_endpoint_next_packet_size(struct snd_usb_endpoint *ep,
 
 	packet = ctx->packet_size[idx];
 	if (packet) {
+		packet = min(packet, ep->maxframesize);
 		if (avail && packet >= avail)
 			return -EAGAIN;
 		return packet;
-- 
2.51.0



