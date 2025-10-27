Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 730F331DD87;
	Mon, 27 Oct 2025 19:28:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761593280; cv=none; b=rzOdTqGVtXs/KFlz2wiWKTWhkWbeZNH5L3z1koAJhrSUKTKKBa5QG7LXUaJlw7QrLZtlsjbf29foPYxDBenZuyDGO+J/62cbfrTDXF8uyxAh31cwc4iEcGVffNsyNaK7lSTZjo5oaXWrWHzQAqzzwCgEs9RmQPucqpSQZzREi88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761593280; c=relaxed/simple;
	bh=ZNNc/L2eU4VtD8q0pYPB7A/bMPJ/XSB5w1coDUcW25Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TH8E0nJeq7jAO7IS62RzDN4NbCPWljutNe4yeJ3pw8AZs4DtJZxfpIcN4ScVk+nep9E2fNuuV/kSikhvjrVm7eJSqEnQpA2JY0tL0APLWOA94is2JiVuK0YSgI7pC9iFNRKi4TAyyf2FETYS4N4cvbL3Le0V5Ydske11/laY/6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I2Ij4kO5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I2Ij4kO5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFC2EC4CEF1;
	Mon, 27 Oct 2025 19:27:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761593280;
	bh=ZNNc/L2eU4VtD8q0pYPB7A/bMPJ/XSB5w1coDUcW25Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I2Ij4kO5l/Z5C6jlCHXb25gBYiblNfpZ3F0M5WZnxSmIZvKR902vd9dR/QKqAGDHf
	 qxTTca5QVmWdVvMVEkmxU0gJqQLrKi24DJ5Du/nA67TIhfJsTDU55WpsajjmyklpM+
	 EEy9AsV5aDoV2rs64f2zKEv7bIB4v3U4oGS6YIHo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harry Yoo <harry.yoo@oracle.com>,
	Hao Ge <gehao@kylinos.cn>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>
Subject: [PATCH 6.17 083/184] slab: Fix obj_ext mistakenly considered NULL due to race condition
Date: Mon, 27 Oct 2025 19:36:05 +0100
Message-ID: <20251027183517.133576834@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183514.934710872@linuxfoundation.org>
References: <20251027183514.934710872@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hao Ge <gehao@kylinos.cn>

commit 7f434e1d9a17ca5f567c9796c9c105a65c18db9a upstream.

If two competing threads enter alloc_slab_obj_exts(), and the one that
allocates the vector wins the cmpxchg(), the other thread that failed
allocation mistakenly assumes that slab->obj_exts is still empty due to
its own allocation failure. This will then trigger warnings with
CONFIG_MEM_ALLOC_PROFILING_DEBUG checks in the subsequent free path.

Therefore, let's check the result of cmpxchg() to see if marking the
allocation as failed was successful. If it wasn't, check whether the
winning side has succeeded its allocation (it might have been also
marking it as failed) and if yes, return success.

Suggested-by: Harry Yoo <harry.yoo@oracle.com>
Fixes: f7381b911640 ("slab: mark slab->obj_exts allocation failures unconditionally")
Cc: <stable@vger.kernel.org>
Signed-off-by: Hao Ge <gehao@kylinos.cn>
Link: https://patch.msgid.link/20251023143313.1327968-1-hao.ge@linux.dev
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/slub.c |   16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1976,9 +1976,9 @@ static inline void mark_objexts_empty(st
 	}
 }
 
-static inline void mark_failed_objexts_alloc(struct slab *slab)
+static inline bool mark_failed_objexts_alloc(struct slab *slab)
 {
-	cmpxchg(&slab->obj_exts, 0, OBJEXTS_ALLOC_FAIL);
+	return cmpxchg(&slab->obj_exts, 0, OBJEXTS_ALLOC_FAIL) == 0;
 }
 
 static inline void handle_failed_objexts_alloc(unsigned long obj_exts,
@@ -2000,7 +2000,7 @@ static inline void handle_failed_objexts
 #else /* CONFIG_MEM_ALLOC_PROFILING_DEBUG */
 
 static inline void mark_objexts_empty(struct slabobj_ext *obj_exts) {}
-static inline void mark_failed_objexts_alloc(struct slab *slab) {}
+static inline bool mark_failed_objexts_alloc(struct slab *slab) { return false; }
 static inline void handle_failed_objexts_alloc(unsigned long obj_exts,
 			struct slabobj_ext *vec, unsigned int objects) {}
 
@@ -2033,8 +2033,14 @@ int alloc_slab_obj_exts(struct slab *sla
 	vec = kcalloc_node(objects, sizeof(struct slabobj_ext), gfp,
 			   slab_nid(slab));
 	if (!vec) {
-		/* Mark vectors which failed to allocate */
-		mark_failed_objexts_alloc(slab);
+		/*
+		 * Try to mark vectors which failed to allocate.
+		 * If this operation fails, there may be a racing process
+		 * that has already completed the allocation.
+		 */
+		if (!mark_failed_objexts_alloc(slab) &&
+		    slab_obj_exts(slab))
+			return 0;
 
 		return -ENOMEM;
 	}


