Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B705754BFE;
	Tue, 27 Feb 2024 14:30:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709044247; cv=none; b=XKVBz4x9kV5/jgEbhArJKShcRhiF5h3fPhFPWzp2sIAb9MCFqfI3eNn8qIlcvYdfwc+9AVkwdkorvjRqav3hn4+4panRilPcwSRsaZyUr0HsngpYNOfLsZQU32BuFZqUuFBSMgZ3aLba6u31erLX69T53Zl/Sg3cB//uBTTSL6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709044247; c=relaxed/simple;
	bh=vDHOPQRgTPaE/UQR7zqGSgpUQZyei9xNaMIJhVG/SVM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=STW0dIMyrNAWl+6nH2TcRoNlS7H+AgHo2pF6XpvQGzCOH3TwRPkkrOPLxlI+v4MSd520LH0pUddqTMsVK9m/jydllDXFJHuEHwBxJJe9ljrgv6Taz128kgQSbO2lk33M/5z9Nz1B9G6QBEHeftfingi5HBM76suhFaG/jWTXd24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ci62WQZQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ci62WQZQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E806C433F1;
	Tue, 27 Feb 2024 14:30:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709044247;
	bh=vDHOPQRgTPaE/UQR7zqGSgpUQZyei9xNaMIJhVG/SVM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ci62WQZQPkUeTN2toRoCaTojXtDn2FJSpibeinzHfmTO13AhxVIcb5DAvQYEGGKhm
	 cJEoSzpaOAeAV69ClnuoupR+2RglI+Z24kzzgCHYrrfUuKN2jq0O1H/NcWCtrXjko9
	 An7RwfhMgmVv82G93HdCsNxE9Lbe0Sxoi9qTDtus=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 116/122] drm/syncobj: make lockdep complain on WAIT_FOR_SUBMIT v3
Date: Tue, 27 Feb 2024 14:27:57 +0100
Message-ID: <20240227131602.498289910@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131558.694096204@linuxfoundation.org>
References: <20240227131558.694096204@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Christian König <christian.koenig@amd.com>

[ Upstream commit 7621350c6bb20fb6ab7eb988833ab96eac3dcbef ]

DRM_SYNCOBJ_WAIT_FLAGS_WAIT_FOR_SUBMIT can't be used when we hold locks
since we are basically waiting for userspace to do something.

Holding a lock while doing so can trivial deadlock with page faults
etc...

So make lockdep complain when a driver tries to do this.

v2: Add lockdep_assert_none_held() macro.
v3: Add might_sleep() and also use lockdep_assert_none_held() in the
    IOCTL path.

Signed-off-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://patchwork.freedesktop.org/patch/414944/
Stable-dep-of: 3c43177ffb54 ("drm/syncobj: call drm_syncobj_fence_add_wait when WAIT_AVAILABLE flag is set")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_syncobj.c | 12 ++++++++++++
 include/linux/lockdep.h       |  5 +++++
 2 files changed, 17 insertions(+)

diff --git a/drivers/gpu/drm/drm_syncobj.c b/drivers/gpu/drm/drm_syncobj.c
index 738e60139db90..4c3c8f8da0215 100644
--- a/drivers/gpu/drm/drm_syncobj.c
+++ b/drivers/gpu/drm/drm_syncobj.c
@@ -387,6 +387,15 @@ int drm_syncobj_find_fence(struct drm_file *file_private,
 	if (!syncobj)
 		return -ENOENT;
 
+	/* Waiting for userspace with locks help is illegal cause that can
+	 * trivial deadlock with page faults for example. Make lockdep complain
+	 * about it early on.
+	 */
+	if (flags & DRM_SYNCOBJ_WAIT_FLAGS_WAIT_FOR_SUBMIT) {
+		might_sleep();
+		lockdep_assert_none_held_once();
+	}
+
 	*fence = drm_syncobj_fence_get(syncobj);
 
 	if (*fence) {
@@ -951,6 +960,9 @@ static signed long drm_syncobj_array_wait_timeout(struct drm_syncobj **syncobjs,
 	uint64_t *points;
 	uint32_t signaled_count, i;
 
+	if (flags & DRM_SYNCOBJ_WAIT_FLAGS_WAIT_FOR_SUBMIT)
+		lockdep_assert_none_held_once();
+
 	points = kmalloc_array(count, sizeof(*points), GFP_KERNEL);
 	if (points == NULL)
 		return -ENOMEM;
diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
index 2c2586312b447..3eca9f91b9a56 100644
--- a/include/linux/lockdep.h
+++ b/include/linux/lockdep.h
@@ -321,6 +321,10 @@ extern void lock_unpin_lock(struct lockdep_map *lock, struct pin_cookie);
 		WARN_ON_ONCE(debug_locks && !lockdep_is_held(l));	\
 	} while (0)
 
+#define lockdep_assert_none_held_once()	do {				\
+		WARN_ON_ONCE(debug_locks && current->lockdep_depth);	\
+	} while (0)
+
 #define lockdep_recursing(tsk)	((tsk)->lockdep_recursion)
 
 #define lockdep_pin_lock(l)	lock_pin_lock(&(l)->dep_map)
@@ -394,6 +398,7 @@ static inline void lockdep_unregister_key(struct lock_class_key *key)
 #define lockdep_assert_held_write(l)	do { (void)(l); } while (0)
 #define lockdep_assert_held_read(l)		do { (void)(l); } while (0)
 #define lockdep_assert_held_once(l)		do { (void)(l); } while (0)
+#define lockdep_assert_none_held_once()	do { } while (0)
 
 #define lockdep_recursing(tsk)			(0)
 
-- 
2.43.0



