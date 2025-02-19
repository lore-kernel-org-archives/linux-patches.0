Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 951921DF738;
	Wed, 19 Feb 2025 08:41:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954512; cv=none; b=KYGzlX8dR8pOq0otnwXn/j18VF3rpNg6ijs991EfKlPL7idNFXLPHQBjItCLoXtq9gfYgMIcO7tZgoAscLIBNPYq/cgSl5a14hbdnmYfOUTL44MojubS0M1ij3ut6Ad1Xz0JApF2Ulu2dAWcMCiVwwvF0Aanw9TKZ+YN/NN5k4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954512; c=relaxed/simple;
	bh=eoJK3AsJY3A2rCuidEGMd8Yt+9piasY5osYLXoCNk2M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oAozDUFnVgSDMj//w77Pp0Y3pVhwIY2VvYAeI+jKw7+9SerI+xtlPocsADB4AnP0aQb22ZhvgHXO5yyTYgvOhbE0xQnsoNdz6mYrYftcX+bz604shcXsXyxHVSdrJdim+GXH6mpeduJ2QQ3XXRhIYWiT3lfDjWdMA8Lvhvj/WMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mUxiLENT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mUxiLENT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF478C4CED1;
	Wed, 19 Feb 2025 08:41:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954512;
	bh=eoJK3AsJY3A2rCuidEGMd8Yt+9piasY5osYLXoCNk2M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mUxiLENTV+i95hurZeDuDt1WiWUN9938ioL1hAsIVtBC9B8YQCPzGltZq7nWHatMd
	 DpaKAaUD77OrKyeytIhtWmMEAbXUZHt0Uvx1AUpr2KFKXBoMIu+uobP8YXfSax+ud3
	 X5AKgf63nKKzE3cePMMQcmc1+2Xe70EwG7lnqlvw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miguel Ojeda <ojeda@kernel.org>,
	Kees Cook <kees@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 225/274] compiler.h: Move C string helpers into C-only kernel section
Date: Wed, 19 Feb 2025 09:27:59 +0100
Message-ID: <20250219082618.381905828@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082609.533585153@linuxfoundation.org>
References: <20250219082609.533585153@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kees Cook <kees@kernel.org>

[ Upstream commit cb7380de9e4cbc9a24216b722ec50e092ae83036 ]

The C kernel helpers for evaluating C Strings were positioned where they
were visible to assembly inclusion, which was not intended. Move them
into the kernel and C-only area of the header so future changes won't
confuse the assembler.

Fixes: d7a516c6eeae ("compiler.h: Fix undefined BUILD_BUG_ON_ZERO()")
Fixes: 559048d156ff ("string: Check for "nonstring" attribute on strscpy() arguments")
Reviewed-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Kees Cook <kees@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/compiler.h | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index 240c632c5b957..7af999a131cb2 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -214,6 +214,19 @@ void ftrace_likely_update(struct ftrace_likely_data *f, int val,
 	__v;								\
 })
 
+#ifdef __CHECKER__
+#define __BUILD_BUG_ON_ZERO_MSG(e, msg) (0)
+#else /* __CHECKER__ */
+#define __BUILD_BUG_ON_ZERO_MSG(e, msg) ((int)sizeof(struct {_Static_assert(!(e), msg);}))
+#endif /* __CHECKER__ */
+
+/* &a[0] degrades to a pointer: a different type from an array */
+#define __must_be_array(a)	__BUILD_BUG_ON_ZERO_MSG(__same_type((a), &(a)[0]), "must be array")
+
+/* Require C Strings (i.e. NUL-terminated) lack the "nonstring" attribute. */
+#define __must_be_cstr(p) \
+	__BUILD_BUG_ON_ZERO_MSG(__annotated(p, nonstring), "must be cstr (NUL-terminated)")
+
 #endif /* __KERNEL__ */
 
 /**
@@ -254,19 +267,6 @@ static inline void *offset_to_ptr(const int *off)
 
 #define __ADDRESSABLE_ASM_STR(sym) __stringify(__ADDRESSABLE_ASM(sym))
 
-#ifdef __CHECKER__
-#define __BUILD_BUG_ON_ZERO_MSG(e, msg) (0)
-#else /* __CHECKER__ */
-#define __BUILD_BUG_ON_ZERO_MSG(e, msg) ((int)sizeof(struct {_Static_assert(!(e), msg);}))
-#endif /* __CHECKER__ */
-
-/* &a[0] degrades to a pointer: a different type from an array */
-#define __must_be_array(a)	__BUILD_BUG_ON_ZERO_MSG(__same_type((a), &(a)[0]), "must be array")
-
-/* Require C Strings (i.e. NUL-terminated) lack the "nonstring" attribute. */
-#define __must_be_cstr(p) \
-	__BUILD_BUG_ON_ZERO_MSG(__annotated(p, nonstring), "must be cstr (NUL-terminated)")
-
 /*
  * This returns a constant expression while determining if an argument is
  * a constant expression, most importantly without evaluating the argument.
-- 
2.39.5



