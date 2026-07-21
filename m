Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 013713B4E8F;
	Tue, 21 Jul 2026 20:34:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666044; cv=none; b=S7d68BKDpADh2sGUMs6APcX+lCI8gzQg0rXfUlWDH4IXROOX14d/oXhbpp9BQofvmwZlGDcw56TMCdXanKhxV+GJRzcWmXSTXo/m4vlsbQZ1jA5h+grGwEq2rC19KV0DsymCmc/EQp7fbzhxrbBW48ZPPZDKRGYZmrAPl/ZKOR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666044; c=relaxed/simple;
	bh=k3kA6YuNnKYsfmwzg9+cBdlCF3JgcvV8G3yhSgMuKJ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=So0oZMdON/ddGwNaztHrtkGhJv0yi1FJYZln7AEA8moTxndAOuEOPSzUCdJaKFwi6HPwW/HSpwhI30fijikFwUQ4Se/ADjoApeGPXd080VnKc9Oi3uUJjNIdEK3mjLKnY1ZndxcWIk/rYHZrExpXKaN9cMM9KRKPMIhZ8dcbImM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jYMqFmoZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jYMqFmoZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B07D1F00A3A;
	Tue, 21 Jul 2026 20:34:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666042;
	bh=zxaze2vthwtitcMvCJ0mDGGynsQcSpR4qOh3xpaTBIY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jYMqFmoZNECoNr1vX3Jey8t/zXe/qJMPoDzG8fBlxhOhM4p3iJd1s/qxx5dDlQa81
	 nfv7MFVatZf0vTSqukwMGiBWvBz87WOejMtV1SZAVa8LnJBFHqF68ZrwDCjs6eYWK3
	 2ztdwWiJ8sOLQy87GhKdQdjrJJzR8G+DdWT45aiM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0506/1266] ALSA: seq: Fix partial userptr event expansion
Date: Tue, 21 Jul 2026 17:15:43 +0200
Message-ID: <20260721152453.171693634@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index a5265789d5544e..85bcf04c74ea39 100644
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



