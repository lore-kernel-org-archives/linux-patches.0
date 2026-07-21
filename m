Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FD2944AB9F;
	Tue, 21 Jul 2026 22:30:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673001; cv=none; b=sBttIDYvLypBvVwLlTFshlLiUXjjRydkzJIyt5TmABv8q+7O/Q6Ge1PhORjrHfNcCmGsUSoTnLF+nErvQE3waLXO9bTIn2v693Z8P0FjjQyluD+UlfmxjPAy6+WnafZmNaIi88XOeFKntvlLwF4GKSXyhWixtklo0NAI0nyQdR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673001; c=relaxed/simple;
	bh=W5KjG1JlGY6xiBH82+RkbRgmzhk05JYhl4OhD/1hwWk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=abcvioonid4o6oZYRujDn1VLSq259wTSh4R40gZhQBkH0MlOXgmLWtr+1ItjIyaUBAKdnKwLWmElANoyVTRtYcX/HZLzsFjCPaM6Ck7yxHLA2Sbf9J1CqilO4rMBoRE5p4/w4BtUNJZTBw9e3O+US9vHIqsV+LBUT6MPTKu3Roo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wFttrj8T; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wFttrj8T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EF551F000E9;
	Tue, 21 Jul 2026 22:29:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673000;
	bh=C1du/b5r6Zb+rXPlAErGVWhs2VfcXRU+KjzYrecLkdk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wFttrj8Tk9v2GAWPaJoMSmPOSNZOnNE5KlskQuvsHymGMaBIF0BE2Qws3fjQ0qJlY
	 BcxXITnXCrgd7UynbFrXzThAwupNZ88u3hROTAausAJ8wflElNf7ebeGff6lECqmR5
	 KnqL4YbZJFBHNAcU/kvU300BgWdYr23GGQ1xCeEc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <error27@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 837/843] ALSA: seq: Avoid confusion of aligned read size
Date: Tue, 21 Jul 2026 17:27:52 +0200
Message-ID: <20260721152424.908090671@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


