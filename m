Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B7B81F75B3;
	Tue,  3 Dec 2024 15:38:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240301; cv=none; b=bOF1wV55zER8yNFwQ5sfe09y5H5AzDgmjIx4Elp9ZZ0Hu4up2kU0h25xuA+C19sGFWWDVrB8krh3by8UNF31N0XWM+E8Pi06fdnTKApeLv82Puik6Ql6+ziek/bLeGYkycQSocMQoNdB8zQ/ey0tDdI81q9HROsJsV3x9DvJD30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240301; c=relaxed/simple;
	bh=GJ5DFxm/A4rGnT7YEHeisu6v/IRRuHKhAyleN6Jx7cU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EtSOVfZJfpc1R/6/KK7uWP6QVcEHGyzhgEfIhtpoDP2+IJn+O8JeYPzkyxQTHfY5X5Njv5642bKwUVL8L3idq6q3b8UVlgghbDqJMzXGWxQz7T7eT/yAm3PGQ3DaM9JdZBWFx+D0Z9Z+x1CJr80a+8E2gGnaln6kaYmzJ9ZZlIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Na18e7Ye; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Na18e7Ye"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA546C4CED6;
	Tue,  3 Dec 2024 15:38:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240301;
	bh=GJ5DFxm/A4rGnT7YEHeisu6v/IRRuHKhAyleN6Jx7cU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Na18e7YeZKzdZnLSaQN19Q/Z2ARs+iXrrcpCnbkfN6o+ruTWHnv4yfzWSh7WLOhaj
	 E5T0oKtyKHYExo9uU0PyiNabq0VLtxumUi6+cDdKvNFb0lCdd3l4gBCnwYSD3qRrmn
	 LeiGkarjC6iVnPETPGEZDqp835Tl5/XlL/GgX14Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marco Elver <elver@google.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 092/826] kcsan, seqlock: Fix incorrect assumption in read_seqbegin()
Date: Tue,  3 Dec 2024 15:36:59 +0100
Message-ID: <20241203144747.320285361@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 45eee0e5dca01..5298765d6ca48 100644
--- a/include/linux/seqlock.h
+++ b/include/linux/seqlock.h
@@ -810,11 +810,7 @@ static __always_inline void write_seqcount_latch_end(seqcount_latch_t *s)
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
@@ -830,12 +826,6 @@ static inline unsigned read_seqbegin(const seqlock_t *sl)
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



