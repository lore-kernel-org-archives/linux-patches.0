Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08056222D4B;
	Thu, 12 Dec 2024 15:56:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734019001; cv=none; b=cJR9I/0kiT8rb+34kEosOWawquZ+q/JMZrRUtrEixjPaCQasM2P5bxg2vROLEkot+C7924ffGoR7Hn8o7lurNd6L1G+LskWGSVWSt+3e21szXhte56bXTsloEvNKz6+QkTREditZG02zt3k/nHPk4MCblTtCXvQiRclvsnx1+B4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734019001; c=relaxed/simple;
	bh=P3klbdE+mHRjATzGk3hLPsVTJ3o/YNC0LvIFg6DhHpw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LgMScx8Snnsr5kyn3OYDSt+RGfqI73TZjzmlcF8h+5GFSqr2XAqzuhSXOzx2IwJZaT8ueC4hqSFXuDXDZm5gfY7+yE4hpgumNaMI7HpEpibdsJwBNiMpzVk3jrzvdXfMYn1fAHLXXZyd6yojWLJtS5OnKEv7wag7z+RvnmkoWy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ete3mWVq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ete3mWVq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 507A0C4CECE;
	Thu, 12 Dec 2024 15:56:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734019000;
	bh=P3klbdE+mHRjATzGk3hLPsVTJ3o/YNC0LvIFg6DhHpw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ete3mWVqDKqLDYOQ0dQ9SbAGoBFT3stPB6zyHCRT6wh1+greOQCW9q6ihBbiHSkvG
	 6gWRfXMgKqdrNVClGAhBCcVoD87xeaZcjfbWrX+U8QKqv3tndxTJi/ATjCJcDRreN7
	 /LZmt6OJlokMERBoh3kA8mq9zHyu/3LoZydtY/C8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marco Elver <elver@google.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 089/772] kcsan, seqlock: Fix incorrect assumption in read_seqbegin()
Date: Thu, 12 Dec 2024 15:50:34 +0100
Message-ID: <20241212144353.626988805@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



