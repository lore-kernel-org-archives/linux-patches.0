Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDCCF515973;
	Wed, 30 Sep 2026 15:36:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790782587; cv=none; b=K8dXgUr+y2GiBTwE+6ZPzA/YrS0k/ODE8j1r2XQmSuARdojF+0zT1SjRT1kR7rVdLfDqWBpersb0g4juZQ9F7SJ834utjEiflgMZXE6Pa+zR+PUxtWCAiSE1+N0t9kytRj7zshFtTHzFcmvKMKDZMmwJoH36oZbmaU4PIAzOdDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790782587; c=relaxed/simple;
	bh=hlF10SjoQhIBnEBWv/CWyao8bUmv+KFTzCZ1x6DUq7s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DjsNFleeS3XgPVaKAHvX5etBSTLnvzDtSeKbWuRnQOBqwMORyhXTsl8SfSSyVGQW6PvY/VUZEnQma26CuQ8j0SvZz7ezp1hX31J+6BUxEQd9blFDywdP/RmNUv5x5PZj52VbY2D+Lgekgq9uuGCNzjvR/LJMzaHjvcgoCNrDmEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q+L/MMjo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q+L/MMjo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC3621F000FF;
	Wed, 30 Sep 2026 15:36:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790782578;
	bh=+uSjf2Uwo6VT+WsAVCjAr+Lqv5/CU7bxC/XNCOiE+YE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q+L/MMjoHA2fB8l/v2XSOhe0cyUiQ1Kx2ZkdVzKBZlFd/CaPOcLJoE/YT6+1SIQJY
	 hCHcxj0lIE7lxz2pbcI65zBOgbqeNpow2zCEBWVSpsyACpFlWBZZ96z9lZ4ZAP+WkQ
	 tp5gGtF0B+1rGDm2DpZcRp7Ju8SVgcRLXIUd1g/U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?C=C3=A1ssio=20Gabriel?= <cassiogabrielcontato@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 095/595] ALSA: seq: oss: Reject reads that cannot fit the next event
Date: Wed, 30 Sep 2026 17:19:48 +0200
Message-ID: <20260930152349.781959480@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index e89a2d8bf4f2f..312b56ff26695 100644
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



