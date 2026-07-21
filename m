Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 035C835C6B3;
	Tue, 21 Jul 2026 21:52:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670769; cv=none; b=HmQvutO9CnBBfkFwUS0gKVg+Ny68nqga41wM6dKm/ZIWe9dtwkUol6sAQpjPfDqhBFQtQ8tIGKAyJM6Wt0L+iV8SQkB/PR2SgN6iVyzyIwyasPGAJ68k/Yh6+MrMCgrPiv+7hNYfo55hs37JqbJ0UnpsOxYhB/cPh5lzYmaLb7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670769; c=relaxed/simple;
	bh=qg5f9x4Fknp2t681JR+vW1gSz2s0LA9gHv72nCezjX4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kMtMOHBOFlCmE5Kmh53u0EpOrapRyH9Gv0faRDJzD3MLrDJ6R0ZbemDeQEK9FKcmCLibYP2KThp8YTCpsA5rwPUBTZPkqUnPuAkzQzJTaPkcUtN+XIzL3K0/1+LjXZlBn0EXwNyVmCJiciXjYlTOcjEzcLDKj2QoU4K7+uI5U0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Iy/viDGz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Iy/viDGz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6887D1F000E9;
	Tue, 21 Jul 2026 21:52:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670767;
	bh=KLjxQuJ25XIU7PRfY51AjGy18QmhKoPbt5MrRrhPT3M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Iy/viDGzTIxndYG4JAQDFcUCgtdm1+G26MM98baqsekAi2XLjLJ+isp20zSvXiVez
	 j8HsVpbTXUdjAL/SbOxmlXmohBsN9TwCh5nXOtIZuA403ISDhyNYhGP6vkb46PvC+X
	 DGEajjNaSCPuDH30xDhR89r4pKz372vtalDPS3RE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <error27@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.1 1056/1067] ALSA: seq: Avoid confusion of aligned read size
Date: Tue, 21 Jul 2026 17:27:37 +0200
Message-ID: <20260721152448.208808263@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 8c15a18331191b67bdce54d21af068baec044baf upstream.

Currently the read event packet size in snd_seq_read() is defined by
client->midi_version value that is guaranteed to be zero if UMP isn't
enabled.  But the static analyzer doesn't know of the fact, and it
still suspects as if it were leading to a potential overflow.

Add the more explicit check of CONFIG_SND_SEQ_UMP to determine the
aligned_size value for avoiding the confusion.

Fixes: 46397622a3fa ("ALSA: seq: Add UMP support")
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <error27@gmail.com>
Closes: https://lore.kernel.org/r/202305261415.NY0vapZK-lkp@intel.com/
Link: https://lore.kernel.org/r/20230605144758.6677-2-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/core/seq/seq_clientmgr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/core/seq/seq_clientmgr.c
+++ b/sound/core/seq/seq_clientmgr.c
@@ -441,7 +441,7 @@ static ssize_t snd_seq_read(struct file
 	err = 0;
 	snd_seq_fifo_lock(fifo);
 
-	if (client->midi_version > 0)
+	if (IS_ENABLED(CONFIG_SND_SEQ_UMP) && client->midi_version > 0)
 		aligned_size = sizeof(struct snd_seq_ump_event);
 	else
 		aligned_size = sizeof(struct snd_seq_event);


