Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE8751D68D
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:24:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rdcrP1Yy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28197C433CA;
	Wed,  4 Oct 2023 18:24:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696443857;
	bh=Oy9DM5uBD3yP8eWGAuGeh203mOkDYvN2ojHksSipIac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rdcrP1YypI0pzeaFKgD2kSaH37NHJYH+jYT7M4CkcmHWlYyOYJ9yIZ9PQkeAtYhCT
	 4oOS94pf6Chwwwo6EYysXNH/H3cehqP4gNIMl1AuKddObSZROOA9zVoG/xwA9cCUVF
	 +T4AeYkRb+8bNZ2wy9X3+/VwryXw+WsUYoKMEQkA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Dobriyan <adobriyan@gmail.com>,
	Kees Cook <keescook@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 044/321] uapi: stddef.h: Fix __DECLARE_FLEX_ARRAY for C++
Date: Wed,  4 Oct 2023 19:53:09 +0200
Message-ID: <20231004175231.205660239@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175229.211487444@linuxfoundation.org>
References: <20231004175229.211487444@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexey Dobriyan <adobriyan@gmail.com>

[ Upstream commit 32a4ec211d4164e667d9d0b807fadf02053cd2e9 ]

__DECLARE_FLEX_ARRAY(T, member) macro expands to

	struct {
		struct {} __empty_member;
		T member[];
	};

which is subtly wrong in C++ because sizeof(struct{}) is 1 not 0,
changing UAPI structures layouts.

This can be fixed by expanding to

	T member[];

Now g++ doesn't like "T member[]" either, throwing errors on
the following code:

	struct S {
		union {
			T1 member1[];
			T2 member2[];
		};
	};

or

	struct S {
		T member[];
	};

Use "T member[0];" which seems to work and does the right thing wrt
structure layout.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Fixes: 3080ea5553cc ("stddef: Introduce DECLARE_FLEX_ARRAY() helper")
Link: https://lore.kernel.org/r/97242381-f1ec-4a4a-9472-1a464f575657@p183
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/linux/stddef.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/include/uapi/linux/stddef.h b/include/uapi/linux/stddef.h
index c027b2070d790..5c6c4269f7efe 100644
--- a/include/uapi/linux/stddef.h
+++ b/include/uapi/linux/stddef.h
@@ -29,6 +29,11 @@
 		struct TAG { MEMBERS } ATTRS NAME; \
 	}
 
+#ifdef __cplusplus
+/* sizeof(struct{}) is 1 in C++, not 0, can't use C version of the macro. */
+#define __DECLARE_FLEX_ARRAY(T, member)	\
+	T member[0]
+#else
 /**
  * __DECLARE_FLEX_ARRAY() - Declare a flexible array usable in a union
  *
@@ -44,6 +49,7 @@
 		struct { } __empty_ ## NAME; \
 		TYPE NAME[]; \
 	}
+#endif
 
 #ifndef __counted_by
 #define __counted_by(m)
-- 
2.40.1



