Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BFA21DC759;
	Tue,  8 Oct 2024 12:37:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391058; cv=none; b=tJcgDTNRD+qhFWwVClgdjgSuxJSKxDhoi1jfbX8Va7dHnraJ+B4tkH2Twkm6xBCwWXhZvxp5yM1HAKjKuy/Cdqd+78dB2v8tvAmKaN9MA5fvqMpQbotIE1dtySzALs49pq292p7fTL23iGGTFcCupPnLSrh1U44A5+0P5WYUqbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391058; c=relaxed/simple;
	bh=FIr69hKpm8kjTzDfyaIlGgDylVe423PsxEYrEEpfV48=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bYER4N5Ow7NdQie/gbcVkM9nboWf+baKVAzkQgJPnt7SF18jS6E82BuRsW+p+qxoH4LeAZx5KDFcGjrB8eKImraYLgWivABAe3RmkGOAfm7a3iQfylrMwV2aJ23oAn5tCo41W1eLEJJnVH5znaZmQ7WrvhpRNkn13+gMg8v0x/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zAVW9UTU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zAVW9UTU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B831BC4CEC7;
	Tue,  8 Oct 2024 12:37:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391058;
	bh=FIr69hKpm8kjTzDfyaIlGgDylVe423PsxEYrEEpfV48=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zAVW9UTUbk4icFvLlSD08yIzVgCquMZB4HFmgVmPN4qSoMx4B1WdAjVMVjXtiR4CL
	 bpO51jKHgfIPk7tDGVPUosUO8AWJkMFg7RzMHm+pSPoFwa3952q/xsjyxVpAuynboZ
	 0um8w/pneYW4O4JkW9e0geYEpPNyc9712s5cnzS0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.10 478/482] ALSA: control: Fix leftover snd_power_unref()
Date: Tue,  8 Oct 2024 14:09:01 +0200
Message-ID: <20241008115707.320681783@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit fef1ac950c600ba50ef4d65ca03c8dae9be7f9ea upstream.

One snd_power_unref() was forgotten and left at __snd_ctl_elem_info()
in the previous change for reorganizing the locking order.

Fixes: fcc62b19104a ("ALSA: control: Take power_ref lock primarily")
Link: https://github.com/thesofproject/linux/pull/5127
Link: https://patch.msgid.link/20240801064203.30284-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/core/control.c |    1 -
 1 file changed, 1 deletion(-)

--- a/sound/core/control.c
+++ b/sound/core/control.c
@@ -1165,7 +1165,6 @@ static int __snd_ctl_elem_info(struct sn
 	info->access = 0;
 #endif
 	result = kctl->info(kctl, info);
-	snd_power_unref(card);
 	if (result >= 0) {
 		snd_BUG_ON(info->access);
 		index_offset = snd_ctl_get_ioff(kctl, &info->id);


