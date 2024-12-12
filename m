Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D80920969B;
	Thu, 12 Dec 2024 16:17:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734020233; cv=none; b=BwwFQt3HXox4OUu0/zWa2yK0QNOSKyd7bAE8XiZT8XOL6ro/BTdxo00JD7IVtsLOyZuAmnLa0COuw14C30X1ug/vtXqdoQ4/kklb7nb6j39zgTy1CO4WCWI5unTXR+ZZGCI6DaiiLpg1aHmfhcadI30JCDsYnRrSA50QatqlD3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734020233; c=relaxed/simple;
	bh=rIW+KqdmjCNFeAW/Oq9g018fWY1rVDrlaSl84TMckCo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SlPsfil8aEjZo+kRcwr892V1zKjlLfbUpQgMVvMfmZU1QyRlGh6XbNjjkDtPei+55A6k0RORj1m7vh1ivUhVpl6FWQLW9x7fp3pB4hQpOajfDoDsA823Y5bjEq+vqBLocsMJbF7qVObAVYUDAnx5MGQ1spYkhTVBz+bXphZH8Wo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dj7nEg/E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dj7nEg/E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E740C4CECE;
	Thu, 12 Dec 2024 16:17:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734020233;
	bh=rIW+KqdmjCNFeAW/Oq9g018fWY1rVDrlaSl84TMckCo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dj7nEg/EdZEc6rI9XGf0MTb9NwcM2uqGjKEXTPKKxL9DRLt2Ob7yB/UUnq8Q14TwT
	 CTeCQ0RqoWhr6qg0s9u3ER1sBYxxMXC5dHXnlEZGreBXUwgEIF1gj2SigRL7SVN9HT
	 n9EldGaMpmb4PILLJDddXmjNoUOVEEdP44b/Uc3s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+4bf62a7b1d0f4fdb7ae2@syzkaller.appspotmail.com,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.1 412/772] ALSA: pcm: Add sanity NULL check for the default mmap fault handler
Date: Thu, 12 Dec 2024 15:55:57 +0100
Message-ID: <20241212144406.944821422@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3785,9 +3785,11 @@ static vm_fault_t snd_pcm_mmap_data_faul
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


