Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77CB522966E;
	Thu, 12 Dec 2024 17:00:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734022819; cv=none; b=sMXadP9NZr9g54x82MqnOxY5oc6zcAPZCLRBuj61kj7TA1RUhebd4liqQ6hrZd9LCSXhHJHowhJi0sa11toN1+9qAGEPcXbeW/w7JKUaDofmWFwmTCTZUAhXbIOmITVdHylZPESIOdN2H8yi+T0RlshXQ1aoZ0NiIqGT0F0q6nI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734022819; c=relaxed/simple;
	bh=7AeK2c9ThierBOuPMw3gaJFrPK4KxFby4vAsSNBnMa0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BsUoAmxxx8R6r2qgahSbNeWUF3SNAo7sptHtG5oJtcuXddY93edZA+VF1S+zLqML+lnPo+YCQOjMoGr82FEKNZX4qTR9Obf2dLB7AOSqOrGUrHMzDXVTsGduScSm5b6uBzlXBw+Z3Qz7wwzcckpV4OP2QEIQVIvexTsmbQDjhBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PPFyVFhL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PPFyVFhL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D637CC4CECE;
	Thu, 12 Dec 2024 17:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734022819;
	bh=7AeK2c9ThierBOuPMw3gaJFrPK4KxFby4vAsSNBnMa0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PPFyVFhLiOKtkxL3VFadDr3QfV5S4w1u9YGni3qUFleQAAE78n1/bpUPSm4PV/wXL
	 ios4Ac/9AzynEOJ6DkMjMffTbS7G/8IEwn11TKduJWrjJzQE4FtxaXABf7EXbF0cbM
	 TJE+uFia5lCYO7ezMxvGEPuaz7onfTrdFBajRVH0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+4bf62a7b1d0f4fdb7ae2@syzkaller.appspotmail.com,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 343/565] ALSA: pcm: Add sanity NULL check for the default mmap fault handler
Date: Thu, 12 Dec 2024 15:58:58 +0100
Message-ID: <20241212144325.155954496@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3757,9 +3757,11 @@ static vm_fault_t snd_pcm_mmap_data_faul
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


