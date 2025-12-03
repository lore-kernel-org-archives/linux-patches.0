Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B237A30C37A;
	Wed,  3 Dec 2025 15:41:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776498; cv=none; b=cD3ghbeiliHHiiqJM82dpgWVIfoWXrgZE/YWCG0GYJDVxKWpGhVowL7Hj6kRlSWAM2FUWMLI4aDj/YxBGFnNCjlTctwgVlc15rqmktzw5I8HY7kDBqM7mfhyoSs5R7WBeXIfYdFpfEYWDEw3fAIoEWN4hi+QL+K8eVewt2sPzqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776498; c=relaxed/simple;
	bh=skWwdF2yERqkcChDT0IL7CgMH4YgpDagwk7ZlLfcTsw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PqMrUPaRyay/sEv9pAbIQXwzNRrEmvc0GekBpRvK1JCdUfaQf0ltRn2C0E43sLlBut5pNBUTHr0ilT83d/iWD4oecncHOmUjBUqhqy97nGA89KasVNYucAajFv6qC0qgNrvgbzWSM0ztiOzKPGJDixirj51fosWyAoEH75nNTEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IYVA8ABI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IYVA8ABI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E8FDC4CEF5;
	Wed,  3 Dec 2025 15:41:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764776498;
	bh=skWwdF2yERqkcChDT0IL7CgMH4YgpDagwk7ZlLfcTsw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IYVA8ABIY7LN90rnMe8K3dB98jCsyIuGE9xWeG6Bm8QirtyPYJvSmSLOnJH/Yizq/
	 JQDD4NAut7+pKFOuRQhPPfNqMBsLGEDj26UpRH28NR1zcSE9Ilp3oq86HTNp7RnPBp
	 4e42SLvvWndKVTpRThxUe6RPpCU3EWnayAe3Ek3w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haein Lee <lhi0729@kaist.ac.kr>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 199/300] ALSA: usb-audio: Fix NULL pointer dereference in snd_usb_mixer_controls_badd
Date: Wed,  3 Dec 2025 16:26:43 +0100
Message-ID: <20251203152407.997164743@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152400.447697997@linuxfoundation.org>
References: <20251203152400.447697997@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haein Lee <lhi0729@kaist.ac.kr>

[ Upstream commit 632108ec072ad64c8c83db6e16a7efee29ebfb74 ]

In snd_usb_create_streams(), for UAC version 3 devices, the Interface
Association Descriptor (IAD) is retrieved via usb_ifnum_to_if(). If this
call fails, a fallback routine attempts to obtain the IAD from the next
interface and sets a BADD profile. However, snd_usb_mixer_controls_badd()
assumes that the IAD retrieved from usb_ifnum_to_if() is always valid,
without performing a NULL check. This can lead to a NULL pointer
dereference when usb_ifnum_to_if() fails to find the interface descriptor.

This patch adds a NULL pointer check after calling usb_ifnum_to_if() in
snd_usb_mixer_controls_badd() to prevent the dereference.

This issue was discovered by syzkaller, which triggered the bug by sending
a crafted USB device descriptor.

Fixes: 17156f23e93c ("ALSA: usb: add UAC3 BADD profiles support")
Signed-off-by: Haein Lee <lhi0729@kaist.ac.kr>
Link: https://patch.msgid.link/vwhzmoba9j2f.vwhzmob9u9e2.g6@dooray.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/mixer.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/usb/mixer.c b/sound/usb/mixer.c
index c84e25b2b1fb9..6b9a472ea43cb 100644
--- a/sound/usb/mixer.c
+++ b/sound/usb/mixer.c
@@ -2999,6 +2999,8 @@ static int snd_usb_mixer_controls_badd(struct usb_mixer_interface *mixer,
 	int i;
 
 	assoc = usb_ifnum_to_if(dev, ctrlif)->intf_assoc;
+	if (!assoc)
+		return -EINVAL;
 
 	/* Detect BADD capture/playback channels from AS EP descriptors */
 	for (i = 0; i < assoc->bInterfaceCount; i++) {
-- 
2.51.0



