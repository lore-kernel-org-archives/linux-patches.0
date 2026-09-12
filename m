Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7386732B13B;
	Sat, 12 Sep 2026 15:43:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789227833; cv=none; b=ivsm2Dtf3B8l0VneJ2ckJkBozEU2EyG+ZTEr7Vt10412ByxDL7xwy6yZ3gbnLmhn8T0LY4P48nGmPpTi6zgwo3OXmAUW+3QO7VdMDsKlzvRdMqiUQ+SPnhHSUrznJcJqPSE8As85SEClR3ZbnQCJn4hCRY1LUiZloJ+mccF7GX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789227833; c=relaxed/simple;
	bh=8O6YAAvKh71e5/PBHhKS96WdGSwZ/fGMu08VKOHdJAc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LaZc1qe3jAJ3AhuvIUHq8fs1to+K4tAStmXsdCl6W9lAD3cZpuYm/PnGKWILPutQW5dt3nTJeGgEFxFpPQjhiySKk87QPIId1A4VgNreivvCcPwOPaMuVJ4U1HFCOsSkeuT+DT9VrtzxBDN28jLZ7D5/HlwCGSeXHZbL3oDCy6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CwFr24eO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CwFr24eO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 201771F000FF;
	Sat, 12 Sep 2026 15:43:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789227832;
	bh=Cn7ZAn4APs++roZh7b4lWs1yk5n5ctTkf79hh4oXy7k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CwFr24eO5fRetjaaMeGWpm1EMwMbPrLVFeMh4rCvDurV/mgzneHgsfl0JV4GQbbdL
	 sEazkwqDy5U2mwZ++PIV3QVvsy4ixgzyb/BUAori38cf5WRoBYLYyt8B6x6fsKFdD9
	 FTTuqkVzqysMWhkWDXibk1lWQTgzfMF+AczyEhQ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0262/1191] ALSA: seq: Fix port lock leak in deliver_to_subscribers()
Date: Sat, 12 Sep 2026 08:49:50 +0200
Message-ID: <20260912065554.104081447@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

Fixes: d7e2ce72833b ("ALSA: seq: Add UMP support")
Signed-off-by: Tzung-Bi Shih <tzungbi@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/seq/seq_clientmgr.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/core/seq/seq_clientmgr.c b/sound/core/seq/seq_clientmgr.c
index 9b82fccd959cb..37930d74e3947 100644
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



