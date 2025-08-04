Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F43EA48;
	Mon,  4 Aug 2025 00:35:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754267755; cv=none; b=hjrICAXj6pXAH/BN3MmGmKK2m9I4+OZYqXbRcCwWiSvNR82x5GfveVd8AlgCWpT4jf8h7oSmtCsvD2eBbtcfAZJilcID87smqJPqSRPHuwWkxf5Amk7vHWfbitz8jExK9trJp3evKOKi3b35+18Y2rPp/p13bpeWTDCa2j+upEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754267755; c=relaxed/simple;
	bh=R29082AZXygxeuzvFwcWe7kocKtOuvB0yh4pFJahn18=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=fn9R54ajNPF153hy6jeV+iMtVtYBFQzx7x2ur4kV+oTXoHdsrYYSKlexrQdOgGQLM54uxTk7v2sz8lWW8hZy9HNa3U8Jja10/7RM3aultG6+mKHE95HKmYquJ1Zr5gQ9QHB4ghTz8xs+ftNa1NeCiFwnNuQ5+neAL3vdqi8Xtuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SfvRtOtA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SfvRtOtA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50DC8C4CEF0;
	Mon,  4 Aug 2025 00:35:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754267754;
	bh=R29082AZXygxeuzvFwcWe7kocKtOuvB0yh4pFJahn18=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SfvRtOtAOdKmDCTepAMYoua549HO0A0BMdoFug1z6RjBU9B2VoaRcXzEYfYVdZKs1
	 HUWqv7RSSCXAJxyfR4Qz+Pq/uimK0KYwouce99cISBFMEyd3u9SU9iEiOrzjAPSao/
	 Dbe8JXQDAPnPJYAvvMB6yl9dspx0bB68zmsWuqSGN9PXLNzL4Lt7PjfHM2gDHw+2IT
	 enqbUfh7a67sQVAOKnvsw2vQM/y1GOJWGVpNgSEjY36VwYHQJso5YtdIiDw4043bg7
	 mx2PYn2mTl8lb04uHSXjznm2QRePoER3olAg1OxaMXg2jdgDasRllDgyVJXBls7gdr
	 B7FOkfOoRsPkg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Takashi Iwai <tiwai@suse.de>,
	Joakim Zhang <joakim.zhang@cixtech.com>,
	Sasha Levin <sashal@kernel.org>,
	vulab@iscas.ac.cn,
	Julia.Lawall@inria.fr,
	thorsten.blum@linux.dev,
	linux@treblig.org
Subject: [PATCH AUTOSEL 6.6 41/59] ALSA: hda: Disable jack polling at shutdown
Date: Sun,  3 Aug 2025 20:33:55 -0400
Message-Id: <20250804003413.3622950-41-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250804003413.3622950-1-sashal@kernel.org>
References: <20250804003413.3622950-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.6.101
Content-Transfer-Encoding: 8bit

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 1adcbdf54f76e1004bdf71df4eb1888c26e7ad06 ]

Although the jack polling is canceled at shutdown in
snd_hda_codec_shutdown(), it might be still re-triggered when the work
is being processed at cancel_delayed_work_sync() call.  This may
result in the unexpected hardware access that should have been already
disabled.

For assuring to stop the jack polling, clear codec->jackpoll_interval
at shutdown.

Reported-by: Joakim Zhang <joakim.zhang@cixtech.com>
Closes: https://lore.kernel.org/20250619020844.2974160-4-joakim.zhang@cixtech.com
Tested-by: Joakim Zhang <joakim.zhang@cixtech.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20250623131437.10670-2-tiwai@suse.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

**Backport Status: YES**

This commit should be backported to stable kernel trees. Here's my
extensive analysis:

## Bug Fix Analysis

The commit fixes a **race condition** during codec shutdown where jack
polling work could be re-triggered even after attempting to cancel it.
This is evident from the commit message: "it might be still re-triggered
when the work is being processed at cancel_delayed_work_sync() call."

The race condition occurs because:
1. `cancel_delayed_work_sync()` waits for the current work to complete
2. While waiting, if the work function (`hda_jackpoll_work`) is
   executing, it checks `codec->jackpoll_interval` at line 635 of the
   original code
3. If `jackpoll_interval` is still non-zero, the work reschedules itself
   with `schedule_delayed_work(&codec->jackpoll_work,
   codec->jackpoll_interval)` at line 641
4. This creates a situation where hardware access occurs after shutdown
   has supposedly completed

## Code Change Analysis

The fix is **minimal and surgical** - just one line added:
```c
codec->jackpoll_interval = 0; /* don't poll any longer */
```

This is placed **before** the `cancel_delayed_work_sync()` call,
ensuring that even if the work function is currently running, it won't
reschedule itself because the interval check at the beginning of
`hda_jackpoll_work()` will fail.

## Impact Assessment

1. **User-visible bug**: Yes - unexpected hardware access during
   shutdown can cause system hangs, crashes, or hardware-related issues
2. **Fix size**: Extremely small - single line addition
3. **Risk assessment**: Very low - setting a value to 0 before canceling
   work is a safe operation
4. **Subsystem criticality**: ALSA HD-Audio is widely used, but this
   specific fix is in the shutdown path
5. **Testing**: The commit has been tested by the reporter (Joakim
   Zhang)

## Stable Tree Criteria

This commit meets stable tree requirements:
- Fixes a real bug (race condition causing unexpected hardware access)
- Minimal change (1 line)
- Clear fix with obvious correctness
- No new features or architectural changes
- Only affects the shutdown path, limiting scope
- Has been tested by the bug reporter

The fix prevents potential system instability during shutdown, making it
an important candidate for stable backporting.

 sound/pci/hda/hda_codec.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/hda_codec.c b/sound/pci/hda/hda_codec.c
index 2d4b7527b840..80c3084189b0 100644
--- a/sound/pci/hda/hda_codec.c
+++ b/sound/pci/hda/hda_codec.c
@@ -3038,6 +3038,7 @@ void snd_hda_codec_shutdown(struct hda_codec *codec)
 	if (!codec->core.registered)
 		return;
 
+	codec->jackpoll_interval = 0; /* don't poll any longer */
 	cancel_delayed_work_sync(&codec->jackpoll_work);
 	list_for_each_entry(cpcm, &codec->pcm_list_head, list)
 		snd_pcm_suspend_all(cpcm->pcm);
-- 
2.39.5

