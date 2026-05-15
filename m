Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B77743FBB5C;
	Fri, 15 May 2026 16:14:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861670; cv=none; b=LmG5ccmBNIn0/XvCZPY5IS4tTspaf3z0D+oVSxUL+DgAlHn+WEwv6UOMdI+nuntqSyhDbBHIk1tRxnm8j9JSBGx+qph1mLkjKRi3ghBZTCQ1aQ6i5PqllVShgMMp/VHYYS2znaGHg6D0XGjwCxJBO6/Er9AySHTcDHNc3HxzKCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861670; c=relaxed/simple;
	bh=uh7qzifK5HNNXhdm20gHH6m6mZD6bLT7k0GiqL8TqLE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=R9EDT+Kdfh4jd34g8A/nq4XJtz2NwVN/Smp7IxDirShLGd0vNYVQLgf35/bggeLySAXMLOX3fjo8Ho8tB2acoLKyMqiBKY+bQoC6ok/E3Qes3m6yX/fXUEtyqJ9TL3t2MssadZ+Wt9r3PR9Jri+HDy/OFOr3PhTK/EF85LJcIrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i49pYuIS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i49pYuIS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C587C2BCB0;
	Fri, 15 May 2026 16:14:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861670;
	bh=uh7qzifK5HNNXhdm20gHH6m6mZD6bLT7k0GiqL8TqLE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i49pYuIS6MpCHvw/6U8jTSuYKWd+LKwHyMMpJNHtV0S3YF1DupWREN6iBTOIvUUtG
	 GyWzqcAhrmg3oivV3ASpw1EP7hwTkVsU7m4G6JAocZzIOTRG8H4K/0QhqbpcirG8vo
	 pji1XIRv/uBLj9chutsEs4RIJJT0fYZILS2NCN9Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?C=C3=A1ssio=20Gabriel?= <cassiogabrielcontato@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 417/474] ALSA: seq: Fix UMP group 16 filtering
Date: Fri, 15 May 2026 17:48:46 +0200
Message-ID: <20260515154724.082754114@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cássio Gabriel <cassiogabrielcontato@gmail.com>

[ Upstream commit 92429ca999db99febced82f23362a71b2ba4c1d8 ]

The sequencer UAPI defines group_filter as an unsigned int bitmap.
Bit 0 filters groupless messages and bits 1-16 filter UMP groups 1-16.

The internal snd_seq_client storage is only unsigned short, so bit 16
is truncated when userspace sets the filter. The same truncation affects
the automatic UMP client filter used to avoid delivery to inactive
groups, so events for group 16 cannot be filtered.

Store the internal bitmap as unsigned int and keep both userspace-provided
and automatically generated values limited to the defined UAPI bits.

Fixes: d2b706077792 ("ALSA: seq: Add UMP group filter")
Cc: stable@vger.kernel.org
Signed-off-by: Cássio Gabriel <cassiogabrielcontato@gmail.com>
Link: https://patch.msgid.link/20260506-alsa-seq-ump-group16-filter-v1-1-b75160bf6993@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/core/seq/seq_clientmgr.c  |    2 +-
 sound/core/seq/seq_clientmgr.h  |    5 ++++-
 sound/core/seq/seq_ump_client.c |    2 +-
 3 files changed, 6 insertions(+), 3 deletions(-)

--- a/sound/core/seq/seq_clientmgr.c
+++ b/sound/core/seq/seq_clientmgr.c
@@ -1333,7 +1333,7 @@ static int snd_seq_ioctl_set_client_info
 	if (client->user_pversion >= SNDRV_PROTOCOL_VERSION(1, 0, 3))
 		client->midi_version = client_info->midi_version;
 	memcpy(client->event_filter, client_info->event_filter, 32);
-	client->group_filter = client_info->group_filter;
+	client->group_filter = client_info->group_filter & SND_SEQ_GROUP_FILTER_MASK;
 
 	/* notify the change */
 	snd_seq_system_client_ev_client_change(client->number);
--- a/sound/core/seq/seq_clientmgr.h
+++ b/sound/core/seq/seq_clientmgr.h
@@ -14,6 +14,9 @@
 
 /* client manager */
 
+#define SND_SEQ_GROUP_FILTER_MASK	GENMASK(SNDRV_UMP_MAX_GROUPS, 0)
+#define SND_SEQ_GROUP_FILTER_GROUPS	GENMASK(SNDRV_UMP_MAX_GROUPS, 1)
+
 struct snd_seq_user_client {
 	struct file *file;	/* file struct of client */
 	/* ... */
@@ -40,7 +43,7 @@ struct snd_seq_client {
 	int number;		/* client number */
 	unsigned int filter;	/* filter flags */
 	DECLARE_BITMAP(event_filter, 256);
-	unsigned short group_filter;
+	unsigned int group_filter;
 	snd_use_lock_t use_lock;
 	int event_lost;
 	/* ports */
--- a/sound/core/seq/seq_ump_client.c
+++ b/sound/core/seq/seq_ump_client.c
@@ -370,7 +370,7 @@ static void setup_client_group_filter(st
 	cptr = snd_seq_kernel_client_get(client->seq_client);
 	if (!cptr)
 		return;
-	filter = ~(1U << 0); /* always allow groupless messages */
+	filter = SND_SEQ_GROUP_FILTER_GROUPS; /* always allow groupless messages */
 	for (p = 0; p < SNDRV_UMP_MAX_GROUPS; p++) {
 		if (client->ump->groups[p].active)
 			filter &= ~(1U << (p + 1));


