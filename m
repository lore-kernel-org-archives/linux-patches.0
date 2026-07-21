Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C96FA32B132;
	Tue, 21 Jul 2026 19:25:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661951; cv=none; b=XJcqOkDZvcwcF73ethAlGi1YHz85bPEwFzKyA9nh8x8CmSAQEVJPlgkAgPpXpIzQz0kCgYpYzOSaKi2NrROeknncVQKDwnXe2oUlq2r7/9XPxULCgFvGA6btIF3Ylw6lslTy7wru1jio3iAb5QgPjwyEs513A/t5R6CgmhnIpCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661951; c=relaxed/simple;
	bh=QTmXGA7ktYeVP6f/FPJ23S4UZjLJC6+CpH3Zpk5wKWw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MQxXt33TRiYRRNw0kaNme5xsmFF6JfO+MGzjG+j9C6pLgaf8hyPPEX+TvAZjnsWmMj5g1ZVwN7ciN89sPEjsa2a7O4bUHdxb3EBKqOGC19o0MgoxrbSVs9sAckeF54J1+efcfV3gpZD84ufCuXwRg/5FPxDw1eIR1KW9wmi3nO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hYRo55vY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hYRo55vY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 337971F000E9;
	Tue, 21 Jul 2026 19:25:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661950;
	bh=I+dsZ9Du0Y1jHJieF2TvWH7D3TuGzRSiYWdOZDg4IQQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hYRo55vYtiwtYyK9NxH9k0j77C+ejkjmjli3B9e8WpSDqfMIvytTRCI6218mJHoIJ
	 HuCoC8IwluPp2AogBv4uiDCi9JCjkczdIBYQN92V8K+I3CuEniRofgk81Mt5YxMjlF
	 Ne/zXjZRQTfEKxl1Kth453Wg5lOiVj9CtbQd2Clo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0259/1276] ALSA: seq: Fix partial userptr event expansion
Date: Tue, 21 Jul 2026 17:11:42 +0200
Message-ID: <20260721152451.880594488@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: HyeongJun An <sammiee5311@gmail.com>

[ Upstream commit 2b7bd6f548292aec92a386deebe62324d21d62a9 ]

snd_seq_expand_var_event_at() clamps the number of bytes to copy to the
remaining variable-event length, but passes the original buffer size to
expand_var_event().

For SNDRV_SEQ_EXT_USRPTR events, expand_var_event() copies exactly the
size argument from userspace.  On the final chunk, when the remaining
event data is shorter than the caller's buffer, this can read past the
declared event data and can spuriously fail with -EFAULT if the extra
bytes cross an unmapped page.

Pass the clamped length instead.  The chained and kernel-backed paths
already reclamp in dump_var_event(), but the user-pointer path handles
the size directly.

Fixes: ea46f79709b6 ("ALSA: seq: Add snd_seq_expand_var_event_at() helper")
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Link: https://patch.msgid.link/20260606040913.230213-1-sammiee5311@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/seq/seq_memory.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/core/seq/seq_memory.c b/sound/core/seq/seq_memory.c
index e7edea10027f3f..60afe351bbca81 100644
--- a/sound/core/seq/seq_memory.c
+++ b/sound/core/seq/seq_memory.c
@@ -211,7 +211,7 @@ int snd_seq_expand_var_event_at(const struct snd_seq_event *event, int count,
 	len -= offset;
 	if (len > count)
 		len = count;
-	err = expand_var_event(event, offset, count, buf, true);
+	err = expand_var_event(event, offset, len, buf, true);
 	if (err < 0)
 		return err;
 	return len;
-- 
2.53.0



