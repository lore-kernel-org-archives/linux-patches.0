Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C6C253A7;
	Fri,  6 Dec 2024 15:17:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733498269; cv=none; b=kxFAps1IFETjPon686T/+M17RXztlwk6zpysJCeYJncEO5uC85KiDtAxfW3hubgkHIznaqZnQBW4BJGNwKxgPxEHaDW2r/YQWdOkYafTF1X2edC377pATxarcy/p+TtbNVugjHjYGmCuhAdOLB+l1O9ZmgHleuvu4Ec8OwKT9zc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733498269; c=relaxed/simple;
	bh=jp8a4WXlYukhsYoKKyGs5Vrf7zmmQcknmXYSmOTN3Io=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k3j3Jq+pC1K3w5mjNsnB7M59ePN1SD2nP6wiM+nsMQYglPgmCNkXzn/EKFaA0TlAmEBshlXNCOD0KQYvhPbUDsuTMpZEHiKOxYV9fc8ftNU9olHhg2tQo9LC2QmoniMT1MGeWEHvJaDm4Vo77i1p6TlPPg+Xdx52u4YyLwKOcy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uK0BjK1q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uK0BjK1q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7D5AC4CEDC;
	Fri,  6 Dec 2024 15:17:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733498269;
	bh=jp8a4WXlYukhsYoKKyGs5Vrf7zmmQcknmXYSmOTN3Io=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uK0BjK1qB1P8xWvyQbWdzcayAHiPeTF1IagTHWUywu7NwLjo0M6yQuJ2C6yfDdb6M
	 QnqXNayAGAmHPvAv7KqUvtcU7DJ01DCXBjAR7qQHA14rAMZrguPoRgcqPzMJghrNvy
	 k/n3dCJM/9LEvKDc1WJwnKbZ4+3myehPYPZwAXtE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+4bf62a7b1d0f4fdb7ae2@syzkaller.appspotmail.com,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 535/676] ALSA: pcm: Add sanity NULL check for the default mmap fault handler
Date: Fri,  6 Dec 2024 15:35:54 +0100
Message-ID: <20241206143714.257608504@linuxfoundation.org>
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

From: Takashi Iwai <tiwai@suse.de>

commit d2913a07d9037fe7aed4b7e680684163eaed6bc4 upstream.

A driver might allow the mmap access before initializing its
runtime->dma_area properly.  Add a proper NULL check before passing to
virt_to_page() for avoiding a panic.

Reported-by: syzbot+4bf62a7b1d0f4fdb7ae2@syzkaller.appspotmail.com
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20241120141104.7060-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/core/pcm_native.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/sound/core/pcm_native.c
+++ b/sound/core/pcm_native.c
@@ -3794,9 +3794,11 @@ static vm_fault_t snd_pcm_mmap_data_faul
 		return VM_FAULT_SIGBUS;
 	if (substream->ops->page)
 		page = substream->ops->page(substream, offset);
-	else if (!snd_pcm_get_dma_buf(substream))
+	else if (!snd_pcm_get_dma_buf(substream)) {
+		if (WARN_ON_ONCE(!runtime->dma_area))
+			return VM_FAULT_SIGBUS;
 		page = virt_to_page(runtime->dma_area + offset);
-	else
+	} else
 		page = snd_sgbuf_get_page(snd_pcm_get_dma_buf(substream), offset);
 	if (!page)
 		return VM_FAULT_SIGBUS;


