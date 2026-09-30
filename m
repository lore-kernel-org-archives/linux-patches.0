Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD7F0223DE5;
	Wed, 30 Sep 2026 18:51:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794297; cv=none; b=kdGwoAROEG5ztG3ptMKnVribO0kH3Z3VrhlWlVmtRAGM2+taCPffRJvnn8OqQ5IA4HkAj0UNMBf/h5+m0PZNKwB9eGdbGzhYM556uh2YjK8grkRUZKj9x9ZUZlBx1MesmMu2z/p+6uV8N2s02DwCYm1xradZEDJr7ocIoPjwJiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794297; c=relaxed/simple;
	bh=qeFplGWsegWhrORWLcjVlV07o4vpXJKe0JiHUV98YrA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OIEt1E6HcTLwKAOy45dzJc6IEOpQxQhawnuvKp90BHFT+0+XUs5rNcO+ydIod9eGVnoeUQshvKnXnK1dRb2Fc8jMT+311MwFIVjsXj4UVAJnB2sTY15QwNMw7iJMYiJI1H2c0zzelpPrcKsGk3MWrYCNhACd/rduwoyXhumFs30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MZ4rpT+g; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MZ4rpT+g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4A341F000FF;
	Wed, 30 Sep 2026 18:51:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794296;
	bh=PuIF2Gib0jArY49GV+SfkunBsdjQcZa3yXoEKL4Ui2g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MZ4rpT+glmBJ4qfirc+nOm7X3UCnQ0K1MgIpdJQY8urwjQ1BSXB9KBwByi0XPdsM4
	 y+L4rjoJ48WTUgVBK/iN36OIvZeS/s/WNBYkCsMEiPA+TMkJeFPfhT604hewvLOmc4
	 D8ktPITTg4hhgLUKzGoV5gOb+VDQTf8KxUbpjg4A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?C=C3=A1ssio=20Gabriel?= <cassiogabrielcontato@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0162/1193] ALSA: seq: oss: Reject reads that cannot fit the next event
Date: Wed, 30 Sep 2026 17:14:06 +0200
Message-ID: <20260930152437.796954450@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cássio Gabriel <cassiogabrielcontato@gmail.com>

[ Upstream commit 611f538253d970f4d152003841544e875828d015 ]

snd_seq_oss_read() checks whether the next queued OSS sequencer event
fits in the remaining userspace buffer before removing it from the read
queue.

The check is inverted. It currently stops when the event is smaller than
the remaining buffer, so a normal 4-byte event is not copied for an
8-byte read buffer. Conversely, an 8-byte event can be copied for a
smaller read count.

Break only when the remaining userspace buffer is smaller than the next
event, and report -EINVAL if no complete event has been copied. This
prevents an undersized read from looking like end-of-file while leaving
the event queued for a later read with a large enough buffer.

Signed-off-by: Cássio Gabriel <cassiogabrielcontato@gmail.com>
Link: https://patch.msgid.link/20260602-alsa-seq-oss-read-size-check-v1-1-10e59b1742e0@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/seq/oss/seq_oss_rw.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/sound/core/seq/oss/seq_oss_rw.c b/sound/core/seq/oss/seq_oss_rw.c
index 307ef98c44c7b..45bb458597708 100644
--- a/sound/core/seq/oss/seq_oss_rw.c
+++ b/sound/core/seq/oss/seq_oss_rw.c
@@ -57,7 +57,8 @@ snd_seq_oss_read(struct seq_oss_devinfo *dp, char __user *buf, int count)
 			break;
 		}
 		ev_len = ev_length(&rec);
-		if (ev_len < count) {
+		if (count < ev_len) {
+			err = -EINVAL;
 			snd_seq_oss_readq_unlock(readq, flags);
 			break;
 		}
-- 
2.53.0



