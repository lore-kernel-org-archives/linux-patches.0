Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B8C51F9ECD;
	Tue,  3 Dec 2024 15:37:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240278; cv=none; b=VBkZhjbw5e3UOIxTOO3IwsMRVcnfsdc2tha79HGlQAbCvhmvVYbIvKWrNKe50LfAXrbL0rjsQSEdEpUwP+6wUuye64eLOmI3uzUA85KMaYSkMkOVSi4jArSitU2+LadijU447XGheOwiXS1HSILa89J28M0QX+CvQMI9rsiPTTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240278; c=relaxed/simple;
	bh=bFFQQVWm0Z8Fa9qoR5gIV92IP0YsehTLOnT1QBUMnL8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pr6jJ93INTRYd/9xHVCNaCr4ehBiRq4UszvscrPe2oWD87R3g/SQhkyWVP5S6fGV1zztTuTqBFT+xn6nH2VKrE74LfDKygo/1DuNPv01jeTE6TItfgalPVkquEh73tOU3o0QGAsK3Wqi41nCqyZFepZ5XVhXF48ijmaSlZL/2Iw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X/KQpJn8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X/KQpJn8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5966C4CECF;
	Tue,  3 Dec 2024 15:37:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240278;
	bh=bFFQQVWm0Z8Fa9qoR5gIV92IP0YsehTLOnT1QBUMnL8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X/KQpJn8ZY7XnKEczGAazqsjmQcFumZGdd6umsvwJfb2F40G+UnF8jqjLiOLngHtn
	 PL0DozVVC8Oq2D8n595nxBIw85xxnCGLjUm09GuHBFwle3p4+C25BfvBlFnvy+eWxk
	 NoPqW2wwtwdp96n8tHLPOS43ZA2H37TPsWhVjns0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Uros Bizjak <ubizjak@gmail.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 085/826] cleanup: Remove address space of returned pointer
Date: Tue,  3 Dec 2024 15:36:52 +0100
Message-ID: <20241203144747.044310841@linuxfoundation.org>
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
index 038b2d523bf88..518bd1fd86fbe 100644
--- a/include/linux/cleanup.h
+++ b/include/linux/cleanup.h
@@ -290,7 +290,7 @@ static inline class_##_name##_t class_##_name##ext##_constructor(_init_args) \
 #define DEFINE_GUARD(_name, _type, _lock, _unlock) \
 	DEFINE_CLASS(_name, _type, if (_T) { _unlock; }, ({ _lock; _T; }), _type _T); \
 	static inline void * class_##_name##_lock_ptr(class_##_name##_t *_T) \
-	{ return *_T; }
+	{ return (void *)(__force unsigned long)*_T; }
 
 #define DEFINE_GUARD_COND(_name, _ext, _condlock) \
 	EXTEND_CLASS(_name, _ext, \
@@ -347,7 +347,7 @@ static inline void class_##_name##_destructor(class_##_name##_t *_T)	\
 									\
 static inline void *class_##_name##_lock_ptr(class_##_name##_t *_T)	\
 {									\
-	return _T->lock;						\
+	return (void *)(__force unsigned long)_T->lock;			\
 }
 
 
-- 
2.43.0



