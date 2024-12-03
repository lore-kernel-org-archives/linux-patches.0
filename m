Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45DB01F75AE;
	Tue,  3 Dec 2024 15:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238008; cv=none; b=e5wxCsWQsuYEfgiyjWL4ET/DW+BhWZt+jmtomr18OFv1lLSL+Q9CEIYYyiLE6fqw6KSxBY0PHwbddHwn453o4YiEjo8CHbvJe6PZw/s0u099rhGcETbX/JOxfJzXneLTXa5gnOxulru2sQt8CpBT6ahZpXjVLd/n+HIyb59CGXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238008; c=relaxed/simple;
	bh=neepnZln9XiTtzK1+D4Q2G/DpGCr+pliXn3uBa6OGwE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hhxQ85EzgebxfqXeoUznp+8+sqf8phJOZ2izVZblTRCRlePzMwyBKoF4OuZ9XuJ8b/mIKWEl4rS0JnNW61NObz+6z0O4ssOaSdomF831+O4nskfUFOm+KAlDm6gzhFfLq7fVlw7Zxdk+hJfB3msIKjMLBJYEKH3ILga+DEJ20wY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XvFQ+7XE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XvFQ+7XE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4A67C4CECF;
	Tue,  3 Dec 2024 15:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238008;
	bh=neepnZln9XiTtzK1+D4Q2G/DpGCr+pliXn3uBa6OGwE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XvFQ+7XEz6ClgfDikwK9qqqVjhgOhZQGDOW7ef/VLto0gz1rz7lR1y49apPCibeTE
	 yH2VXcAyYFBv9+ZeOGs+zV7VvegPiyp6531kEOWyGwftP95tDe95ZmCYDV2uqGVCxm
	 RG4lGnUzr21zOUODg3OtCdGUlLnEGtzihfhV5WRc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Uros Bizjak <ubizjak@gmail.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 131/817] cleanup: Remove address space of returned pointer
Date: Tue,  3 Dec 2024 15:35:03 +0100
Message-ID: <20241203144000.835462710@linuxfoundation.org>
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
index d9e613803df15..b3200ccb96186 100644
--- a/include/linux/cleanup.h
+++ b/include/linux/cleanup.h
@@ -154,7 +154,7 @@ static inline class_##_name##_t class_##_name##ext##_constructor(_init_args) \
 #define DEFINE_GUARD(_name, _type, _lock, _unlock) \
 	DEFINE_CLASS(_name, _type, if (_T) { _unlock; }, ({ _lock; _T; }), _type _T); \
 	static inline void * class_##_name##_lock_ptr(class_##_name##_t *_T) \
-	{ return *_T; }
+	{ return (void *)(__force unsigned long)*_T; }
 
 #define DEFINE_GUARD_COND(_name, _ext, _condlock) \
 	EXTEND_CLASS(_name, _ext, \
@@ -211,7 +211,7 @@ static inline void class_##_name##_destructor(class_##_name##_t *_T)	\
 									\
 static inline void *class_##_name##_lock_ptr(class_##_name##_t *_T)	\
 {									\
-	return _T->lock;						\
+	return (void *)(__force unsigned long)_T->lock;			\
 }
 
 
-- 
2.43.0



