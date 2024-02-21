Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79A4D7E78F;
	Wed, 21 Feb 2024 14:07:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708524440; cv=none; b=D6B/G07pB9uQyYbwFNrgfZarDlxxzzBr66wCocCpb6eb7JjEM/eeziINSvCklCRl+noBya3D9va81OVM0RG3momEwgZde0+f1Da3ogJ22R3+qOO0WxRu4f6k1thFQDUiZ4X+dmA+dk9GYkRUicbZpFK55qfEVzDd7YyxyFwakJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708524440; c=relaxed/simple;
	bh=uKgKyIokow+9Rcxaj7gKw+xoA6q/S/uDnHWZFt19g4M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FtGRY3RJNDa1/2dW2SyDJ96hfQqRRAo4mAmlC0lvVLo91GqML3jrdRYypM6SG4nngUtLIoQAGvcacWkpB8gRUu7pOk5dVlZSxg4XC5UFlT4iZNwRhQxsBkAEzGazmMot3RbjFftobEm2DUUCnyXOoWCFEe3xTkc4/Lt9p8D8sBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oh+dXc9p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oh+dXc9p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE714C433F1;
	Wed, 21 Feb 2024 14:07:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708524440;
	bh=uKgKyIokow+9Rcxaj7gKw+xoA6q/S/uDnHWZFt19g4M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oh+dXc9pdtp2ZcnwcIIH4BdcVBT2YYgzqEoS4f0ntCozJTxx/TP/tKGWVAhDEkv0P
	 WUJepb3DAfT/TOKJSHgMzwYtr9Hl0zSZpuFZIsbnUEsTSoBuU3iE6ZhsKzKdsZVsnQ
	 iVUx/cRVhJ7aR03/Y6pDkVVMJiLOEPkF5OetdWHg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Dobriyan <adobriyan@gmail.com>,
	Kees Cook <keescook@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 244/379] uapi: stddef.h: Fix __DECLARE_FLEX_ARRAY for C++
Date: Wed, 21 Feb 2024 14:07:03 +0100
Message-ID: <20240221130002.129694812@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
 include/uapi/linux/stddef.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/include/uapi/linux/stddef.h b/include/uapi/linux/stddef.h
index 7837ba4fe728..46c7bab501cb 100644
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
@@ -45,3 +50,5 @@
 		TYPE NAME[]; \
 	}
 #endif
+
+#endif
-- 
2.43.0



