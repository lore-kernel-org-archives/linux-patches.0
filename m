Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C3D715C120;
	Mon,  6 Jan 2025 15:27:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177262; cv=none; b=GMPvRsaddngHZZCV5KCZqPQaGlXGV21eBmwKvWyBHs+1odLy0FSoHIdj/Ig5DaexORCkEFibMFYjsP2TsR32ra95gC1GjcTljkh4sCRjTXWbOrAnn8aD3C9l+aI18D6yEpx8nZ2/eckjqAF+X3D/AyPFge3u48C1B9yDzfUUhv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177262; c=relaxed/simple;
	bh=J/xnrYvBChV4FW40mIlUIahcTNCu36Fs9fxa3npnwP8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jG8JiaCbZjbaBFg6NJ+HUH5YDBAijB0ewnJ/8ucdfRRRBHnn9rJ9utW9PEtz2tDE4WRwYR221ECFTGIAwxSVzuqnQMLgyCh//ivyT0LPvZ2RVE1tgKc6JlMkix6chSm62qwScC9GJyMy6BxhbOTgQp9iCcrxU4iYxLbmO4J1Fag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ADwwhcj3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ADwwhcj3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7F34C4CED2;
	Mon,  6 Jan 2025 15:27:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177262;
	bh=J/xnrYvBChV4FW40mIlUIahcTNCu36Fs9fxa3npnwP8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ADwwhcj34y1rejCdB36+MRODwvoBH/8TGWnkJPBPUmdJtb7LDlocUjdS1aPzp1XkQ
	 egpnSA2xS7KgsYZdyHnDR8tbXuSarfmuqGpnavfmvY6Q+T8U821PGoN5pvJQN+2mCb
	 8vcVwrimyJZe/l9g0i22szsODIu+w4/jEmGLTsHw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Uros Bizjak <ubizjak@gmail.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 106/222] cleanup: Remove address space of returned pointer
Date: Mon,  6 Jan 2025 16:15:10 +0100
Message-ID: <20250106151154.610373855@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151150.585603565@linuxfoundation.org>
References: <20250106151150.585603565@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Uros Bizjak <ubizjak@gmail.com>

[ Upstream commit f730fd535fc51573f982fad629f2fc6b4a0cde2f ]

Guard functions in local_lock.h are defined using DEFINE_GUARD() and
DEFINE_LOCK_GUARD_1() macros having lock type defined as pointer in
the percpu address space. The functions, defined by these macros
return value in generic address space, causing:

cleanup.h:157:18: error: return from pointer to non-enclosed address space

and

cleanup.h:214:18: error: return from pointer to non-enclosed address space

when strict percpu checks are enabled.

Add explicit casts to remove address space of the returned pointer.

Found by GCC's named address space checks.

Fixes: e4ab322fbaaa ("cleanup: Add conditional guard support")
Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20240819074124.143565-1-ubizjak@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/cleanup.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/cleanup.h b/include/linux/cleanup.h
index f0c6d1d45e67..64b8600eb8c0 100644
--- a/include/linux/cleanup.h
+++ b/include/linux/cleanup.h
@@ -123,7 +123,7 @@ static __maybe_unused const bool class_##_name##_is_conditional = _is_cond
 	__DEFINE_CLASS_IS_CONDITIONAL(_name, false); \
 	DEFINE_CLASS(_name, _type, if (_T) { _unlock; }, ({ _lock; _T; }), _type _T); \
 	static inline void * class_##_name##_lock_ptr(class_##_name##_t *_T) \
-	{ return *_T; }
+	{ return (void *)(__force unsigned long)*_T; }
 
 #define DEFINE_GUARD_COND(_name, _ext, _condlock) \
 	__DEFINE_CLASS_IS_CONDITIONAL(_name##_ext, true); \
@@ -204,7 +204,7 @@ static inline void class_##_name##_destructor(class_##_name##_t *_T)	\
 									\
 static inline void *class_##_name##_lock_ptr(class_##_name##_t *_T)	\
 {									\
-	return _T->lock;						\
+	return (void *)(__force unsigned long)_T->lock;			\
 }
 
 
-- 
2.39.5



