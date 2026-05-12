Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CF90385D85;
	Tue, 12 May 2026 17:43:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778607813; cv=none; b=Mj0KT4kBI3SByErq+Mjv4JXJ3xT6tHzZtzlq8zCZmas0h/o13cVqcH0I/vEGF0uQlx5Fu+cdVAk9SnYceTVmP7RyCDgJ2bGF03RsSzctJxhhm8KqJ+ee5rskMFVAd6d88nUiA0c/KbLiZ9i771jhifw3t4NN/HCidlw7ILFiU2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778607813; c=relaxed/simple;
	bh=Ok/O9zKOP8uPw6AVc7QI+Do3b3tnRbZPjqTabCi2K7M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sRePDgrjZDHuJS+esnVI7linMV7VDIBpRPv+aVRluEqen/rhpArrCHqMdPOhLFCGZOei7tkZEHF/1A/fNVChZRs3WRhtDxS4NdFtISHadHlH9rc5j+yumowRM14qS69W4eVXmuYvc8U2HOiiDuckEmBlwLXVH1OdV6oQNkFe/Ok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LM6wmHgR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LM6wmHgR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7031C2BCB0;
	Tue, 12 May 2026 17:43:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778607813;
	bh=Ok/O9zKOP8uPw6AVc7QI+Do3b3tnRbZPjqTabCi2K7M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LM6wmHgRncn+XWStfLNgJ2yex308hpZY0XIKYedo5YEySaFBKwTFdHAa3ExYpSosU
	 8pvHDi7xeXlZlcmka2wdRZye5IgxNPzCpBukEQJykZnEsz7j1TuQb40VrIcfqIiVb9
	 LONBFdU5lJFGy5t3XhfPh7GZ2c5DLxYQaoWseYmM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.12 044/206] ALSA: usb-audio: Avoid potential endless loop in convert_chmap_v3()
Date: Tue, 12 May 2026 19:38:16 +0200
Message-ID: <20260512173933.767146142@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173932.810559588@linuxfoundation.org>
References: <20260512173932.810559588@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -352,6 +352,8 @@ snd_pcm_chmap_elem *convert_chmap_v3(str
 		if (len < sizeof(*cs_desc))
 			break;
 		cs_len = le16_to_cpu(cs_desc->wLength);
+		if (cs_len < sizeof(*cs_desc))
+			break;
 		if (len < cs_len)
 			break;
 		cs_type = cs_desc->bSegmentType;


