Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B0762500DA;
	Tue,  3 Dec 2024 15:30:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239809; cv=none; b=L1n4K1ooY7xNbqohgfAQGfeC4F0OYdmNArqB8S+5hn0n3VnxKIcDtZWYcjF8XoU9ejsUExDVFyWDNT3iJ5K/J4pjVcrtJpPpgUTu+5omguYZ+CojVR3uyJE9YiPiH9zaxyt2/GFqZlfGqZp3ByV1nWhur6h4nl/CarEA87aOAM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239809; c=relaxed/simple;
	bh=VKyB55eRUQOrhXpuDYVzKsyK+OCJl9/Hti7WlMJZEuI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T6DvzAaJtFaIAVwgyaw4ESnTr1ZWOupAGCrAJCgp1hqURMCjEWb1ug9IDS7w8dfd9UL3QGct0qmgtB5A1EzWkC+r1IwICrrVxaSSaT876UP+bcKBwsECqBJ1FH28zAlPjk1QzZGd8n0mcwl8J7n3mTjy8E+cWf7SFVlmggqkTqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b6gdIvv8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b6gdIvv8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C88F0C4CECF;
	Tue,  3 Dec 2024 15:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239809;
	bh=VKyB55eRUQOrhXpuDYVzKsyK+OCJl9/Hti7WlMJZEuI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b6gdIvv85GpkdKHDJBi2tYoEF4Phuv0LyNT3P1JCEv3WS9EAOb0EQgEOMuRwnXtPF
	 jbmwcF1sjh8ulooJD3YqdA8Nvs97yW3EqfKfIF3aK1b1DQtghGHUDUDk6wNYaEsssb
	 49yC5mW+e974tgPWScid1oWIY0VPtAOE09xqxCoU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+4bf62a7b1d0f4fdb7ae2@syzkaller.appspotmail.com,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.11 740/817] ALSA: pcm: Add sanity NULL check for the default mmap fault handler
Date: Tue,  3 Dec 2024 15:45:12 +0100
Message-ID: <20241203144024.882717934@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3789,9 +3789,11 @@ static vm_fault_t snd_pcm_mmap_data_faul
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


