Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4A7333FE;
	Tue,  3 Dec 2024 15:01:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238108; cv=none; b=PL7IWWXHbnjsUyVBiG1YCt2nIt5W7aRO/E9fz/VBr7TYUNZfha409MAId9kMyDCoU5ewzumNuXA0Mqg6iwuJrHYkz6UY+BzGiRadqpY1IdCZhuUlj54v2TJvPBBHpUsPYmpdFVyxzUdhOEAomYr86RXnjkbvYnSZEzxFpmBx3QU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238108; c=relaxed/simple;
	bh=ztIe/1kHR2CxHuroQu0Kh7GudSM8EnzMyJ1deFKMgmA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E/mVd98LxxgZOzVm2t65Emg9AQ3jaMwx60WnxkmIit9qKvKoDE5AldrCRNn46qAdkZb11Y9DgvrIqvBpmdfbz4Ou73eOLQJ0OiHjSjlDEb7SyuuXy+jVz1htrpkma1vwEpqQQd8SlDBtX6dNx/2shnmrNfRQm81NFoLrSHzjatg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pz+qqilv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pz+qqilv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C146C4CECF;
	Tue,  3 Dec 2024 15:01:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238108;
	bh=ztIe/1kHR2CxHuroQu0Kh7GudSM8EnzMyJ1deFKMgmA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pz+qqilvJrfbKdtQD6Tn2T29sWaflCCAGOxQKLf91f0wg8kPNxxJ3dqCqt26eYR/3
	 roZEBLCS5uVGBFivQS3ownz2RjGbpqiylsfBSrqMOURAv1osgjQoH7PTowduyd+jPf
	 Sl2r0YwBku73ciJu2oRC6SA6niCfNcjaMvUB35vk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marco Elver <elver@google.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 137/817] kcsan, seqlock: Fix incorrect assumption in read_seqbegin()
Date: Tue,  3 Dec 2024 15:35:09 +0100
Message-ID: <20241203144001.070292567@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index c81164846f4a4..e1c11db880795 100644
--- a/include/linux/seqlock.h
+++ b/include/linux/seqlock.h
@@ -825,11 +825,7 @@ static __always_inline void write_seqcount_latch_end(seqcount_latch_t *s)
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
@@ -845,12 +841,6 @@ static inline unsigned read_seqbegin(const seqlock_t *sl)
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



