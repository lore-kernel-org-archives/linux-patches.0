Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB23B4EF14A;
	Thu, 17 Sep 2026 17:53:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667588; cv=none; b=UEShl24Q9O84sLuZwWZi+XzueT9hTNEcE5G/4XF+0R4lUE3qxf9KCsy7tS7AVCNW0EYcW6BDSIQlxRfUdbm6FjnOsjUEYxogHfSkWEu093DbG+1dlJosP9cRKRCfakJ3/D8Ks+Uq4x9aZ3u7ZNIjbw6v1jZiuS2+CQK6GvGHmRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667588; c=relaxed/simple;
	bh=+eFdiTf4iREULv0fFfrvmnP5cuiIcb68EmJrEOLtKDo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gcPfhQI7v4DWwvfLZDc64j8EmeWbNaT8aM8byoXE6dnNLRsVGrJigUwhoLHv/fC28bst59Mi0b9xgCdhW9TjyrFPAs6eYq6gT+59dxte3mH1F2dwNCG96mkFj6ynYi9armgKZhxJ+EmzccmJys41yFl+oz0iSUK7LsXDxxpr7jg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f8bwkmrJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f8bwkmrJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CABB71F000FF;
	Thu, 17 Sep 2026 17:53:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667586;
	bh=a+yAmGgdwCieODC+ohBsIq9FhDB94xDCGJfFQvZ/AQ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f8bwkmrJqpZ6HNwa1KDGxXNFVOtan8hQeKtB040bGoJ6W0izuln3EVDvoyoQ4ug23
	 e8PzUoViEx28mdjNCjjlZNAU9fYdbyPca3yc2dkdWuQdRyndukRKqorbTvBnfwGVJ+
	 EkzOBs2CujFgKAGjv1sMHmFBw4FGRu3dTo/7oFbE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?C=C3=A1ssio=20Gabriel?= <cassiogabrielcontato@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0143/1102] ALSA: seq: Remove arbitrary prioq insertion limit
Date: Thu, 17 Sep 2026 16:01:26 +0100
Message-ID: <20260917151543.113367042@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cássio Gabriel <cassiogabrielcontato@gmail.com>

[ Upstream commit 3fcc84f1f8d28cc1966b859cef33c858ff531766 ]

The sequencer priority queue insertion path uses a hardcoded traversal
limit of 10000 entries.  The value is intended to catch a corrupted list,
but it also becomes a real limit for valid queues.

The event pool limit is per client, while a sequencer queue can be shared
by multiple clients.  A queue can therefore legitimately contain more than
10000 events.  In that case, inserting an event that has to be placed past
the arbitrary limit fails with -EINVAL.

Use the queue's own cell count as the traversal bound instead.  This keeps
the protection against inconsistent list accounting or cyclic lists without
rejecting valid large queues.

Signed-off-by: Cássio Gabriel <cassiogabrielcontato@gmail.com>
Link: https://patch.msgid.link/20260525-alsa-seq-prioq-limit-v1-1-16c348df5ff7@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/seq/seq_prioq.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/sound/core/seq/seq_prioq.c b/sound/core/seq/seq_prioq.c
index e649485a87722..8c9a293cb5b51 100644
--- a/sound/core/seq/seq_prioq.c
+++ b/sound/core/seq/seq_prioq.c
@@ -132,7 +132,7 @@ int snd_seq_prioq_cell_in(struct snd_seq_prioq * f,
 			  struct snd_seq_event_cell * cell)
 {
 	struct snd_seq_event_cell *cur, *prev;
-	int count;
+	int remaining;
 	int prior;
 
 	if (snd_BUG_ON(!f || !cell))
@@ -162,10 +162,16 @@ int snd_seq_prioq_cell_in(struct snd_seq_prioq * f,
 	prev = NULL;		/* previous cell */
 	cur = f->head;		/* cursor */
 
-	count = 10000; /* FIXME: enough big, isn't it? */
+	remaining = f->cells;
 	while (cur != NULL) {
 		/* compare timestamps */
 		int rel = compare_timestamp_rel(&cell->event, &cur->event);
+
+		if (remaining-- <= 0) {
+			pr_err("ALSA: seq: inconsistent prioq cell count\n");
+			return -EINVAL;
+		}
+
 		if (rel < 0)
 			/* new cell has earlier schedule time, */
 			break;
@@ -176,10 +182,6 @@ int snd_seq_prioq_cell_in(struct snd_seq_prioq * f,
 		/* move cursor to next cell */
 		prev = cur;
 		cur = cur->next;
-		if (! --count) {
-			pr_err("ALSA: seq: cannot find a pointer.. infinite loop?\n");
-			return -EINVAL;
-		}
 	}
 
 	/* insert it before cursor */
-- 
2.53.0



