Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D04C149C69;
	Fri,  6 Dec 2024 14:54:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496860; cv=none; b=IrmzvWhtZGY0WX7/uavqqBDxoecdE9F44U+KceMg0UDojnGfgt7hGj8jeFQbsg2idgFTSgmFHoBnCzOO2V/IfQ/iYuoE7Y7hQZdBReHrKcPrb+oO2tNYAmrqPb7MiLUPsThBilI77WyPLzU0m7lskWeFKqHsLo9bxUNtDYCpKD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496860; c=relaxed/simple;
	bh=OQgkeTTmO2M0yG0DpxhcJv1zWJr0IK63ZnUQ5JAH7eM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bjRr4DlJCLc3szlhiK6F48GXwVmjNe9g953+UT7BULvwygPs0azyd+5QbwLq7OKhYEFLMI0wALlh4ZGPJhgcXmoVmt5cSJBcr/3tsT5QyetyVQIJSXQYpNirnfNf48pq7isdXHEbd8IAlxxKkhmsbKgA5tBmHPibRqxo1GAqwbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lXLTOCKM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lXLTOCKM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18909C4CED1;
	Fri,  6 Dec 2024 14:54:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496859;
	bh=OQgkeTTmO2M0yG0DpxhcJv1zWJr0IK63ZnUQ5JAH7eM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lXLTOCKMPY2wbERB2PjQThu0driu9MjvducfjUNkpIvxHdfKkDZfUyu9g7uWguUnw
	 tfgWaIwTPNut/whKR/ekI8Gjy0Mlf3oqjsqJ/j0UsNY5UkeSqUsQUoBA/HSzs4IJlK
	 ZLkzkhYxKadHltpgvIhFI4MPprZT/ZzpdWrGaKhE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marco Elver <elver@google.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 109/676] kcsan, seqlock: Fix incorrect assumption in read_seqbegin()
Date: Fri,  6 Dec 2024 15:28:48 +0100
Message-ID: <20241206143657.618028860@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Marco Elver <elver@google.com>

[ Upstream commit 183ec5f26b2fc97a4a9871865bfe9b33c41fddb2 ]

During testing of the preceding changes, I noticed that in some cases,
current->kcsan_ctx.in_flat_atomic remained true until task exit. This is
obviously wrong, because _all_ accesses for the given task will be
treated as atomic, resulting in false negatives i.e. missed data races.

Debugging led to fs/dcache.c, where we can see this usage of seqlock:

	struct dentry *d_lookup(const struct dentry *parent, const struct qstr *name)
	{
		struct dentry *dentry;
		unsigned seq;

		do {
			seq = read_seqbegin(&rename_lock);
			dentry = __d_lookup(parent, name);
			if (dentry)
				break;
		} while (read_seqretry(&rename_lock, seq));
	[...]

As can be seen, read_seqretry() is never called if dentry != NULL;
consequently, current->kcsan_ctx.in_flat_atomic will never be reset to
false by read_seqretry().

Give up on the wrong assumption of "assume closing read_seqretry()", and
rely on the already-present annotations in read_seqcount_begin/retry().

Fixes: 88ecd153be95 ("seqlock, kcsan: Add annotations for KCSAN")
Signed-off-by: Marco Elver <elver@google.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lore.kernel.org/r/20241104161910.780003-6-elver@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/seqlock.h | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/include/linux/seqlock.h b/include/linux/seqlock.h
index 484f9a179fc12..b4b4ce9a4151e 100644
--- a/include/linux/seqlock.h
+++ b/include/linux/seqlock.h
@@ -890,11 +890,7 @@ typedef struct {
  */
 static inline unsigned read_seqbegin(const seqlock_t *sl)
 {
-	unsigned ret = read_seqcount_begin(&sl->seqcount);
-
-	kcsan_atomic_next(0);  /* non-raw usage, assume closing read_seqretry() */
-	kcsan_flat_atomic_begin();
-	return ret;
+	return read_seqcount_begin(&sl->seqcount);
 }
 
 /**
@@ -910,12 +906,6 @@ static inline unsigned read_seqbegin(const seqlock_t *sl)
  */
 static inline unsigned read_seqretry(const seqlock_t *sl, unsigned start)
 {
-	/*
-	 * Assume not nested: read_seqretry() may be called multiple times when
-	 * completing read critical section.
-	 */
-	kcsan_flat_atomic_end();
-
 	return read_seqcount_retry(&sl->seqcount, start);
 }
 
-- 
2.43.0



