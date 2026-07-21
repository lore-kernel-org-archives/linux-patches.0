Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8323D46D081;
	Tue, 21 Jul 2026 17:53:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656393; cv=none; b=XFIH4p9g6Bvxsod5lkGbFxXdJ/eOUKsjZw8TSCtef31s8b0WT9ZpojVd7pZkIB+dlVKMK6BiLatmdw7sNGfXuygmbmZZEsbePDobGBs9EuP/G39zkEn96yJcXVboC4gPpSYj3vsBmIOmjLgxUpNrad2E3o16f2gvbJgJBJr7MCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656393; c=relaxed/simple;
	bh=VnowQi0NQCbuKQa/H1wrzG9dE3FOPRrIr39M0cbbV24=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JGbn0DrSNbKshMRGvjgJ850E6R0IpCeFXexwg4As1XMywvugNl8JGUlowlRNYHzwHFefwRTtPSqFKFPjWz4vzOXn0SEXNX+eTJu4LwgWnL5ZmqRPSLNWFzAakV1jvxeeV5D6FiXUQgyudsuQ/7diY4ZWsJf8akqGvt9r9t4w0XY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TYZ9CHJ6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TYZ9CHJ6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBD101F00A3D;
	Tue, 21 Jul 2026 17:53:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656392;
	bh=IH5GFNZ3SKvFQjmMMbUyXLJwpLcj5aI4DGYF46ddVTs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TYZ9CHJ6zu0t+Ggjky0cq0sbl1W5fLn2Jr4e+WKxqEn8PP1kKw9Wieq+AKCwF7OBI
	 dZc3KtJU2oXwRDqhTebfkajidGYX/bCWEZFPoWoNZfo59f5MM3i4WFsblovkIMXwzr
	 yKB4TD9Tz+8PFEUIZ7kRNiu4WV8NDt6nVqhvas+U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0368/1611] ALSA: seq: Fix partial userptr event expansion
Date: Tue, 21 Jul 2026 17:08:04 +0200
Message-ID: <20260721152523.449071018@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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



