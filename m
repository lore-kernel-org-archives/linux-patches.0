Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 505703955F4;
	Tue, 21 Jul 2026 15:54:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649293; cv=none; b=nztHMh+Al6gReiicKpVKsh0Eo49HUi6YC0bU7v4tqnfiZR6eHKUYALiGs0j6gwzNZBVXbJT400uQmTv362jWNDEsz1lQYGdByuL+1q8i7VMmrG3QH+O2g0QbLKS9HL6J3eHOEcdhmJPN9X6nqmPv4H53a+kqbsMhbkmMv9eMPQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649293; c=relaxed/simple;
	bh=AlTCYe5UHxZyUeA2EHPOD2G2HNBHHDDf+lOA12gbR7Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wy08t9oqytTqVSjCuXXaKg7XcK+YG0SRqa+YkOAwQrNkGM6nfJjRJxO0R+ccUfisc4vPU4OAHki2C5Wx2rKnO/utNjaopWKUj01vNmQCEgRBn4opFBieDjlGBN9H6s6I+HLaQsCgNvQYU04fb96wwj7lZHXk/37rhuiHEqbUFkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JK4z0XiZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JK4z0XiZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5C921F000E9;
	Tue, 21 Jul 2026 15:54:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649292;
	bh=F6RCUUyDq4bme9qrg/KIBLpRIrK/FmRkLoba7R1MI6A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JK4z0XiZtfhNub4rSZfry7MPbYNtz9fG1oQsZDiJC7nGG4LS0nz78QG3bMKuIqwqi
	 3w927l98fv7Qor1byHuPjFHKqluyqKNgDMcFCsS3DZT2EszkHAOJMxjZiw9r5ZVa6t
	 KspxX1jfN3MK7YsSZtxruZOZ048ZSyz4DzQ/m6dM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0523/2077] ALSA: seq: Fix partial userptr event expansion
Date: Tue, 21 Jul 2026 17:03:16 +0200
Message-ID: <20260721152605.144202060@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 670f6599e002da..209b08c2a94088 100644
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



