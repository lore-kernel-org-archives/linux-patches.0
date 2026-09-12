Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DBF3345CCE;
	Sat, 12 Sep 2026 08:58:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789203499; cv=none; b=Ij10vT3E0rjDk0ZRQZMSb4Igc0tlReD9bznjnxji9ICfZ/24BllTb/KCYhZc1bCJTYSAqkDBkJaRWzR7pQrS8LgsZTnsc/ykAs8zFQeeApXGy8CH5YjlIuinqncB+gKo3+h/2IYfgoCKaYBDBGBVVEroltv9xqCfRlnef58YU7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789203499; c=relaxed/simple;
	bh=i2TJn3K1ujOfKx+edZC0hnSQ0eIORtPd8+yQKe6j/JM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FQuHLlQxqQGIuo2OTuajZS8OA64Ya5VOfC2m5jXZzyey1PGNLFCJCFQ50L9UP2xN5nTASgUJZoGeMq49wtWBEJ/vmtrkgDGUdUGp24Yg/rSbaG080UpiyX4LKvGAw1bYdy7h//sw5FT11REzVXFEDJbI1zR22CPLqB4gJLc87qE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rfZmzqnj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rfZmzqnj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8E7A1F000FF;
	Sat, 12 Sep 2026 08:58:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789203497;
	bh=/jMuX3F2mB+PvB+PPDqDBgsaagaz4m2r6WWQBcvctyw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rfZmzqnjavENNpZcwqPTxaiYaBqcigvQHe/U9uu1qmGG3LwJGzTZm6GGpAzLy0rl+
	 9J60HX+XN4yRbJstiyu4M9OpXQFwXV4H0bDGAlUO1Ibmjs1Rd2AfWu0lLDnX77kzTy
	 hqb0hAmeM9AFhS9lTh5HcZF4i4Y05fFkkp6H/hgs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Song Liu <song@kernel.org>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1378/1815] objtool/klp: Fix vmlinux .klp.symid link error for .no_trim_symbol symbols
Date: Sat, 12 Sep 2026 08:52:08 +0200
Message-ID: <20260912065721.376372594@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josh Poimboeuf <jpoimboe@kernel.org>

[ Upstream commit 3a83d9cd3d0e66c0ef99ce84f972ed26f50c990f ]

Testing klp-build with arm64 produced the following linker error during
the original kernel build:

  `__notrim.1' referenced in section `.klp.symid' of vmlinux.o: defined in discarded section `.no_trim_symbol' of vmlinux.o

symbol_get() puts a static __notrim[] in .no_trim_symbol, which GCC
names __notrim.1, __notrim.2, etc.  Two or more built-in translation
units calling symbol_get() thus produce duplicate names, resulting in
corresponding .klp.symid references which trigger the above error.

Add .no_trim_symbol to the discarded section list so its symbols don't
get symids.

Note this issue is not specific to arm64: it just needs two built-in
symbol_get() callers.  arm64 trips over it easily because it has KVM
always compiled in vmlinux, whereas on x86 it's typically a module.

Fixes: 029223d30162 ("objtool/klp: Add .klp.symid for sympos disambiguation")
Acked-by: Song Liu <song@kernel.org>
Acked-by: Joe Lawrence <joe.lawrence@redhat.com>
Link: https://patch.msgid.link/5a3cc4cded743167dd0878220201d80f7e48e5d7.1786138493.git.jpoimboe@kernel.org
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/objtool/klp-symid.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/objtool/klp-symid.c b/tools/objtool/klp-symid.c
index cf188cdfa6079..21d8708013aba 100644
--- a/tools/objtool/klp-symid.c
+++ b/tools/objtool/klp-symid.c
@@ -31,6 +31,7 @@
 static const char * const discarded_secs[] = {
 	".discard",
 	".modinfo",
+	".no_trim_symbol",
 	"__tracepoint_check",
 };
 
-- 
2.53.0



