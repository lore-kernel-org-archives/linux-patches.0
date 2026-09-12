Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93BE93644D1;
	Sat, 12 Sep 2026 07:17:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789197465; cv=none; b=MoBaZUH5lO4Yj8/Z69+SOx+LzUrSWlcUWD2laK8t8vVobEDNXmMHtGzJBH1gkPqV8seP4915rRO1hZ4J6iOfwqs/afZhxsFrntMkdnNMLv8oidj3HG1+E2JIENcPGIE9kfDog/Qjk+prnXwflGHKsIZu6jgEpNxXjUNSoqQ+25U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789197465; c=relaxed/simple;
	bh=UmjB72H1Syk0G6cjcbAHvRB+K65tsiZot6F57KfdaPY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LhPQqnja1O0LLBk0iPCqxxG3NZNUX1rrakka/Z0AbGGVYqKx736S6K6DHDigAtUC1YREGHSySPRbvZ7AlnvJRSYTc6G9uPhKSuc69NCCK9qnklSuT/B3K3n2PMwVu7jljl63EQPtuCPhrNonm20UBrY7ncA0vLOs0vu5akPmCuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SScO+6Fk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SScO+6Fk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CA711F000FF;
	Sat, 12 Sep 2026 07:17:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789197464;
	bh=VwIzoFVTn4kL1AlVbtaQVN1aB+i1OBMFL0LfpzUtNZA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SScO+6Fkd0xjtinUBwU19WZ4gEgbKDce3gDGtWv9oQidmIm7OCWYf55co1iEjDeXl
	 IYyMyjcfaqdeNSOhsI6REuIi11a4HIcCIGLOJPLhq7eYq+ShqlOP8HYYI8D6eDF0Uu
	 ECkee8R76zC6+m8s+9hEuWRlr3ZSwiBL2JV8yRdQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Willy Tarreau <w@1wt.eu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0178/1815] tools/nolibc: mark arg1 operand in __nolibc_syscall0() as write-only
Date: Sat, 12 Sep 2026 08:32:08 +0200
Message-ID: <20260912065653.186734424@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <linux@weissschuh.net>

[ Upstream commit a3b2181459a2c74c03ddbad585f884eefc8ff8ff ]

__nolibc_syscall0() does not set the arg1 variable before passing it to
the asm block. This uninitialized variable read is undefined behavior.
Clang can miscompile this.

Mark the asm operand as write-only to fix this.

Fixes: 8e1930296f92 ("tools/nolibc: Add support for SPARC")
Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Acked-by: Willy Tarreau <w@1wt.eu>
Link: https://patch.msgid.link/20260703-nolibc-sparc-asm-v1-1-c7fe73e2e777@weissschuh.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/include/nolibc/arch-sparc.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/include/nolibc/arch-sparc.h b/tools/include/nolibc/arch-sparc.h
index ddae9bc10dfe3..23fab40accfad 100644
--- a/tools/include/nolibc/arch-sparc.h
+++ b/tools/include/nolibc/arch-sparc.h
@@ -45,7 +45,7 @@
 									      \
 	__asm__ volatile (                                                    \
 		_NOLIBC_SYSCALL                                               \
-		: "+r"(_arg1)                                                 \
+		: "=r"(_arg1)                                                 \
 		: "r"(_num)                                                   \
 		: "memory", "cc"                                              \
 	);                                                                    \
-- 
2.53.0



