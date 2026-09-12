Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2EA73AFB1A;
	Sat, 12 Sep 2026 18:21:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789237279; cv=none; b=k72ol94pP2ZwG3TgOaJkzeo7lQxQD4uxiBiK/t0wPsIcIztXBCc3vApCBV4b66aTqFR5PRDTuX7sv//Ww1r8r28jRrpARHH6lro53Y0nUMfbGkF6wt5P23TQFtYTWkcKfGEQP3JdPjL9rHf7tUD0udLi2b8bRgCOs4l6CtLAyC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789237279; c=relaxed/simple;
	bh=GIpuYGdnL1+kXZ/XeKuOhkSQq3kLe1VZdKgOFWUwwsg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O52IWxnL813h97LpBdOteNkb5IXXfVHxmCdR+sX7xhpQ8M/zYRvRDcNE/cT6aHhMGXMkeHYeKIePDinRIwdJhoWVowJjWojjGjXcejKcZUFrEy0SdBoWXJe2GPX1FxqbgeRkD88u+S1iNMRiWdN7hBD0Dbg+UBQsdlDSnsmcmgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q85wyKyO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q85wyKyO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 450941F000FF;
	Sat, 12 Sep 2026 18:21:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789237278;
	bh=J13Q1gFl3oNrPe/RZm89AumRWQ74GY4j346CAt6ixPI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q85wyKyOviYkZfrfBy1jsYqf8iBshpzBlERnDsRfBjOLgjgcUtkeZWUdiZ8ctSJql
	 HBAXCWwYYLPXpKAzus1FdElKnaATQllfZK34OPHxE5elrP67/bh6uJLRnTMzQC8QRP
	 8HMGlkpmD/J8rBuG4q5NAdZ2n9HdCeMnxJL7MjIQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 227/935] ALSA: seq: Fix port lock leak in deliver_to_subscribers()
Date: Sat, 12 Sep 2026 08:54:17 +0200
Message-ID: <20260912065532.032170071@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

From: Tzung-Bi Shih <tzungbi@kernel.org>

Commit 46397622a3fa ("ALSA: seq: Add UMP support") mistakenly removed
the `snd_seq_port_unlock(src_port)` call in deliver_to_subscribers().
As a result, every time an event is delivered to a subscriber, the
source port's `use_lock` atomic counter is increased but never
decreased.

The leak prevents ALSA sequencer ports from closing cleanly.  When the
client process exits or destroys the port, port_delete() hangs forever
at snd_use_lock_sync().  The process becomes stuck in an unkillable D
state, triggering the following warning:

    ALSA: seq_lock: waiting [1 left] in sound/core/seq/seq_ports.c:250

Restore the missing `snd_seq_port_unlock(src_port)`.

Note that commit 177ccf811df4 ("ALSA: seq: Support MIDI 2.0 UMP Endpoint
port") incidentally resolved this issue upstream when it refactored the
locking logic into a wrapper function.  However, since the commit
introduces a new feature and might not be suitable for stable release
branches, this targeted fix is necessary.

Fixes: 6389f2c13531 ("ALSA: seq: Add UMP support")
Signed-off-by: Tzung-Bi Shih <tzungbi@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/seq/seq_clientmgr.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/core/seq/seq_clientmgr.c b/sound/core/seq/seq_clientmgr.c
index f2feeb97765c5..bd2d7a9fab5b8 100644
--- a/sound/core/seq/seq_clientmgr.c
+++ b/sound/core/seq/seq_clientmgr.c
@@ -733,6 +733,7 @@ static int deliver_to_subscribers(struct snd_seq_client *client,
 		read_unlock(&grp->list_lock);
 	else
 		up_read(&grp->list_mutex);
+	snd_seq_port_unlock(src_port);
 	memcpy(event, &event_saved, saved_size);
 	return (result < 0) ? result : num_ev;
 }
-- 
2.53.0



