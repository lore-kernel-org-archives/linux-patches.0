Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B4722BE621;
	Thu, 28 May 2026 20:52:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780001552; cv=none; b=leDdc82yUcijGw5Gae2yEFTNFMcSuF5jfNSfs8GtHjxBAqxVfNGoV0sD7CYdhK/TN+j56ajsxnZkk6KNV7EBUv3GGHezPFsfO9Lylmm+Hh9JQBxEigJvuTRhyXA3ArlcLbbTEG27qPimWGMs4uE7S/KC8xO0OF1oBxOoUZgQw+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780001552; c=relaxed/simple;
	bh=iaCMspkGa++66tqzHYJ3VMKAaGLpU7Ck4/yr2hkz2Ds=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EhS/GJ85kH57OMab2dkuJ69Bs488SDXOm9T0NfVDpxznfG6bx8vUCvfsd7PTWCJmtzBTt6Il0VlxTxhzzatN2omjcN8/IyOYpyCpDTvV5n+7q2xgcIJuTrv4V0ZE1DOa9/3Imlrrg0PBABdZeB7emrllXZU73vYaHcB1DMtsT98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gSK+z2Oc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gSK+z2Oc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9EBF1F000E9;
	Thu, 28 May 2026 20:52:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780001551;
	bh=5cKyA2GE2eFyFvSMbl4e9TZQt3WOxoK6n31I17lPMKg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gSK+z2Ocq8ls8A+HqqICsVFTz+7RErk7710LlHpk00IzXn1mjgAg/S58dGn6Wfvrt
	 5b37h+iTJhker/0QCnPmFQYrbCgNPl158lyjt0819kvPOm7RFHdykHwSoDEsUUhOhn
	 bWOg+ESsGAxYyP6lfvbHjn67Mrr6PtqCw13jUIHU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 168/186] ALSA: seq: ump: Use guard() for locking
Date: Thu, 28 May 2026 21:50:48 +0200
Message-ID: <20260528194933.500111810@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194928.941004471@linuxfoundation.org>
References: <20260528194928.941004471@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 6487e363714c28c4b62ac149e7d907cfeeedb3ad ]

We can simplify the code gracefully with new guard() macro and co for
automatic cleanup of locks.

Only the code refactoring, and no functional changes.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://lore.kernel.org/r/20240227085306.9764-19-tiwai@suse.de
Stable-dep-of: 60a1969fae62 ("ALSA: seq: Serialize UMP output teardown with event_input")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/seq/seq_ump_client.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/sound/core/seq/seq_ump_client.c b/sound/core/seq/seq_ump_client.c
index 55923ee6c97ae..389516f09f099 100644
--- a/sound/core/seq/seq_ump_client.c
+++ b/sound/core/seq/seq_ump_client.c
@@ -106,21 +106,19 @@ static int seq_ump_process_event(struct snd_seq_event *ev, int direct,
 static int seq_ump_client_open(struct seq_ump_client *client, int dir)
 {
 	struct snd_ump_endpoint *ump = client->ump;
-	int err = 0;
+	int err;
 
-	mutex_lock(&ump->open_mutex);
+	guard(mutex)(&ump->open_mutex);
 	if (dir == STR_OUT && !client->opened[dir]) {
 		err = snd_rawmidi_kernel_open(&ump->core, 0,
 					      SNDRV_RAWMIDI_LFLG_OUTPUT |
 					      SNDRV_RAWMIDI_LFLG_APPEND,
 					      &client->out_rfile);
 		if (err < 0)
-			goto unlock;
+			return err;
 	}
 	client->opened[dir]++;
- unlock:
-	mutex_unlock(&ump->open_mutex);
-	return err;
+	return 0;
 }
 
 /* close the rawmidi */
@@ -128,11 +126,10 @@ static int seq_ump_client_close(struct seq_ump_client *client, int dir)
 {
 	struct snd_ump_endpoint *ump = client->ump;
 
-	mutex_lock(&ump->open_mutex);
+	guard(mutex)(&ump->open_mutex);
 	if (!--client->opened[dir])
 		if (dir == STR_OUT)
 			snd_rawmidi_kernel_release(&client->out_rfile);
-	mutex_unlock(&ump->open_mutex);
 	return 0;
 }
 
-- 
2.53.0



