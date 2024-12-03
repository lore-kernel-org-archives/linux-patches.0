Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 052521F893F;
	Tue,  3 Dec 2024 16:16:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242566; cv=none; b=lZoPfnl15h/BtR0/qLQsUU0xL5/gqp9BazDM49+e9l0/VDbIRtnkyt4XG6mPDGerxhv27fmc45IzsrB0guST7JFmOsScCogrJoSIWF6zUMZw7IWNBI0PJvL638HWE6lLUMoyXrkCPHe+jhsbDxkbkX+AQWTwPAcX+AEQ2Jd3f24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242566; c=relaxed/simple;
	bh=VSn0xBP9zb71nDj1jFHpuw2Mxk7JUs7Ep4ny5wHOLJQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OGjNjpvVpJ/q+x+rrVJjc4rsa61t3C7oL1XkTagYJcjbqbjvz9bAsBNSOT9HcrLudr4cla6H2Bak+4/bMU+pUnTna0dUX+1DXbxD5Pi2bwUgenRfGviyOFdDFStTO0iZRpf6cqKEbu8EGd/++zLt4VjAVUQ3e96LBRtsfenInG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wricZYLV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wricZYLV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72149C4CECF;
	Tue,  3 Dec 2024 16:16:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733242565;
	bh=VSn0xBP9zb71nDj1jFHpuw2Mxk7JUs7Ep4ny5wHOLJQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wricZYLVtTKwaXYVzMvbQc0EWRjjaDq2myz5zbZkP0axoyi6CatugVKOFb5HpmHb1
	 Run76EPb/tcc2BlWrMzT0GoQ3UAB6bG+p8L+1bIgYfmycDelayPtVA+CJmU28uez/n
	 9NzKry/2GkM/YejWBxrflKCOsJbI6jkxYAj2e2Eg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+4bf62a7b1d0f4fdb7ae2@syzkaller.appspotmail.com,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.12 742/826] ALSA: pcm: Add sanity NULL check for the default mmap fault handler
Date: Tue,  3 Dec 2024 15:47:49 +0100
Message-ID: <20241203144812.708548547@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3793,9 +3793,11 @@ static vm_fault_t snd_pcm_mmap_data_faul
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


