Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E236243E06C;
	Tue, 21 Jul 2026 22:30:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673009; cv=none; b=qKrlak4MySWafYg3vvsYdXZ18v0q3sMJEdn05g6hA4ZfK2si0Za5IU8yGpdwRM+7OtnMCSt8pHlzZrNR3HM40gsCpNSm1lyOQAHgW40uFTt5aFxrRjqjkiJ5oi/5iRNQryAvScxxdQfUf/EJzVlsR/G8mXYjRMi6gViWtX0o3vg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673009; c=relaxed/simple;
	bh=U2MiETABvIRGeqAWo9irXWV2tTOWgUy9olnNOE9o674=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y5C/WJ9SMSosDc+/e1hE1TAXhQSOJS+j8be9pRZ+BwRQXPhQzKLQxYwkR6dXsDAP7o97sRs2NqCKBUhzutVN9H9gWqLhDi4E+UcXE1MQ957dRM6R1eaFUqrWxNTTi1hvwnqAZ+GqMTzYM/fXEAvaIIBkkqYCMfV0Gs/teyAHusU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k5yzaCNI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k5yzaCNI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54DE21F000E9;
	Tue, 21 Jul 2026 22:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673007;
	bh=dhI2vJcOTHVISZtWmOy96oJ22tQuKSw81erkkRoFK7k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k5yzaCNIhlzDJXs/cfo+WWpJlbut83NqDmL1cpH+Nc484c6j+LOpWlwqkxYV5c4F7
	 hzTPPWjZpVyaG5rhYCx0yu5EDwemjDWPn2y3xZRCtLGCCVng6eDAL0RLRRilAvHN/N
	 C+Dk+g3J1cOQtqlqxjK4wt2+aUCU8ZT1XY3E0oII=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 840/843] ALSA: seq: Skip event type filtering for UMP events
Date: Tue, 21 Jul 2026 17:27:55 +0200
Message-ID: <20260721152424.975415076@linuxfoundation.org>
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

commit 32108c22ac619c32dd6db594319e259b63bfb387 upstream.

UMP events don't use the event type field, hence it's invalid to apply
the filter, which may drop the events unexpectedly.
Skip the event filtering for UMP events, instead.

Fixes: 46397622a3fa ("ALSA: seq: Add UMP support")
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20240819084156.10286-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/core/seq/seq_clientmgr.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/sound/core/seq/seq_clientmgr.c
+++ b/sound/core/seq/seq_clientmgr.c
@@ -528,6 +528,9 @@ static struct snd_seq_client *get_event_
 		return NULL;
 	if (! dest->accept_input)
 		goto __not_avail;
+	if (snd_seq_ev_is_ump(event))
+		return dest; /* ok - no filter checks */
+
 	if ((dest->filter & SNDRV_SEQ_FILTER_USE_EVENT) &&
 	    ! test_bit(event->type, dest->event_filter))
 		goto __not_avail;


