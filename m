Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4A603242BA;
	Sat, 30 May 2026 18:32:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780165922; cv=none; b=AtL9nt6KetE1R9OvzDl9iKFzU1spBmEFX44DQmYXCAKM+x2uxN1epajS3RYz4h9ZG+74YYzajY6vsq+aVJBFI9yHfU6udCus4xQKeILSJKBu3MncOQfDZ94/2lTeBJdPBVlrCcMG+E/a39zKiqg3hWCfKtZbjtSFPpW0F4MmsTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780165922; c=relaxed/simple;
	bh=xjL1Dn3Z5NwKxPlZMZ4cYukn5A8XAq/9VpGruMaWTfA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dk5/DUjzADSDirFglFPhSRLkkIMsS/+N6MMK9ClyFXGp3Q141OwkDj+hLO6eFTOW3DW4GlEGvj3npNJenvveMoNE65VxM666BfRLGjouyOPY7sc8i4GyAEO8sid+IVw42DVpx5v/YzAhNtVYFZQvnzeuVhCf6jvklCFbb5yvI0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j/p9BECf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j/p9BECf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 054BC1F00893;
	Sat, 30 May 2026 18:32:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780165921;
	bh=VtIXTYTHVRw1z+PdQ1qDRYnHujRLmZ9c1bIFPC7YiaI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j/p9BECf9Jbut0SiA9ysdHzj6qyDbbLdQMH/LkEj0XKi75tGEc3G7l6fPiOPMbL+l
	 Osvwpqz+ZAMvoYI0vG2xRXCL1QlKG4pQcc+pJJ/9bsBsqh6kIUjOswih+m4rCftldZ
	 D02nDY8umr3WSHKON6y6FHp0C6NCPFkGnaqYQD4o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 222/589] ALSA: usb-audio: Avoid potential endless loop in convert_chmap_v3()
Date: Sat, 30 May 2026 18:01:43 +0200
Message-ID: <20260530160230.813715929@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

From: Takashi Iwai <tiwai@suse.de>

commit 6e7247d8f5fefeceb0bb9cc80a5388a636b219cd upstream.

The convert_chmap_v3() has a loop with its increment size of
cs_desc->wLength, but we forgot to validate cs_desc->wLength itself,
which may lead to potential endless loop by a malformed descriptor.

Add a proper size check to abort the loop for plugging the hole.

Fixes: ecfd41166b72 ("ALSA: usb-audio: Validate UAC3 cluster segment descriptors")
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20260427152224.15276-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/stream.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/usb/stream.c
+++ b/sound/usb/stream.c
@@ -353,6 +353,8 @@ snd_pcm_chmap_elem *convert_chmap_v3(str
 		if (len < sizeof(*cs_desc))
 			break;
 		cs_len = le16_to_cpu(cs_desc->wLength);
+		if (cs_len < sizeof(*cs_desc))
+			break;
 		if (len < cs_len)
 			break;
 		cs_type = cs_desc->bSegmentType;


