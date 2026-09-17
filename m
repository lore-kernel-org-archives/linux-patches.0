Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 141C14EF153;
	Thu, 17 Sep 2026 17:16:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665419; cv=none; b=GQlf7SpYO/Th3dDG/iFEhs7m61eLFDtRvJ73KqrjrZJo1KRycHaek2xOKpBhpslVEo2R1VhufYKFPUpIZbu5jwlaYdiMv6f7UIGOIQIPxT1MJ4qy4QSnvRL3wgO31RrDgnbVdRmj3yysMcOtq0Z+i0sge6tQgpS5JFCwG96qRHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665419; c=relaxed/simple;
	bh=A3nkvJ/+YEN7eEUuZC4pWT4ODvciv0jWkP9SmyZnXiw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KNTl/RqBWCgC3fcnfVXMqKSzbz+fqmvJZ28dumQbhqga9LP+axLqUA2DI56AjUyTigpUDMrpzcAaoMVsJhs2HCdr1iWIl8b/WJQNAAs4CIa+OjpCZzbQqZWVPGAFam8X8nukAKzDpk/+dD85UesdmBmFLWJPzlrvmrQLIJsMVao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D+tenSsu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D+tenSsu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DFAB1F00893;
	Thu, 17 Sep 2026 17:16:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665417;
	bh=h8Sz9Qj8p4mQgrWDfY2zzfPgk09s5gmQ6qoWtju05cA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D+tenSsutKJcyCCHBeIR91Xqqtw4lxaQqPE/aHCv5UyJeP2jMcAv02essHULCGFpW
	 QzZh2alTti8YcP+6A6cbHNuFDhZx15wEuJM1hkjvN11/ZUk+5akziRtICjqBqSjIoa
	 LE40rCGn+1yL+00vqpU3bd428JxkOfaAXSS5W8K0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0699/1250] ALSA: dummy: Report a change when one capture switch channel moves
Date: Thu, 17 Sep 2026 16:08:14 +0100
Message-ID: <20260917151610.836611313@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: HyeongJun An <sammiee5311@gmail.com>

[ Upstream commit 83162eeaf78c71ff6f6fa31dc95e3b6e90ee593f ]

The snd_dummy_capsrc_put() builds its change flag with &&, so it reports
a change only when both channels move at once.  Writing a single channel
stores the new value and returns 0, the control core then sends no
SNDRV_CTL_EVENT_MASK_VALUE, and a second reader keeps showing the old
setting until it polls again.

The volume put a few lines above compares the same pair of channels with
||.

The mixer selftest already reports this.  With snd-dummy loaded it fails
event_missing on all five capture switches:

  # CD Capture Switch.1 orig 0 read 1, is_volatile 0
  not ok 13 event_missing.Dummy.9

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Assisted-by: Claude:claude-opus-5
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Link: https://patch.msgid.link/20260901153921.3971-1-sammiee5311@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/drivers/dummy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/drivers/dummy.c b/sound/drivers/dummy.c
index bf20c1009707f..b871fa34bf1bd 100644
--- a/sound/drivers/dummy.c
+++ b/sound/drivers/dummy.c
@@ -782,7 +782,7 @@ static int snd_dummy_capsrc_put(struct snd_kcontrol *kcontrol, struct snd_ctl_el
 	left = ucontrol->value.integer.value[0] & 1;
 	right = ucontrol->value.integer.value[1] & 1;
 	guard(spinlock_irq)(&dummy->mixer_lock);
-	change = dummy->capture_source[addr][0] != left &&
+	change = dummy->capture_source[addr][0] != left ||
 	         dummy->capture_source[addr][1] != right;
 	dummy->capture_source[addr][0] = left;
 	dummy->capture_source[addr][1] = right;
-- 
2.53.0



