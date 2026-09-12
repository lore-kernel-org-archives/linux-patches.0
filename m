Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E4F7362120;
	Sat, 12 Sep 2026 09:46:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789206368; cv=none; b=nryyVMyofNllb7UyEmgQnDGXOygUXOmxIawYTmPs3TIlt5sNlao1NrwOuYbbwXDpvL6hhzEstH3RRXKfjFaV5bgQC7iOXOzQfxKkuKACww08t2dnPMPXtjO+BuhSaiv2X4q8SrKO13JQSzcjhbDPDmnaJkHB+X1Uj4emADYOAjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789206368; c=relaxed/simple;
	bh=UhQPl7V5kWjvGzYp8X/fBYLZRhSsh1t6g4whO60ZTXI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eQFQp1lalg8r2u9cYjLi5EN16n4c0L1a0khkeloTeRq5RGUnEAAODQjQAnv5JQbFd4+mdOmycavDFD+bc0mBTbRrJ1FlKkpJ6tfTJGo21/OS21tBYeGb9LsCQ/kCw4T2qFXUGw6Jt/CyBsVxiw/HlfJdF4XjnaU3PtHQNlt7WOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q5gbCfhH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q5gbCfhH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06BCC1F000FF;
	Sat, 12 Sep 2026 09:46:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789206366;
	bh=1xb2Y9JRUbaMZUaY3tqG39K0NuDLr5boA2oUm4F9Jew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q5gbCfhHkK/IdxcPMCSymBy9fncUPr0CY09o8LVKPy9T5MWtNftba/rDfOcP247ZV
	 aJQW4cOA4cJWPs316qQFv7meC3Y5lUqYO5XC82oNmj+22ZrTs97kBTVkY5Fwwa7F49
	 4RXr3kM9qlIcZmSGOJuEYMLo0tqefNeBRWdmKsGk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Willy Tarreau <w@1wt.eu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0194/1518] tools/nolibc: mark arg1 operand in __nolibc_syscall0() as write-only
Date: Sat, 12 Sep 2026 08:39:23 +0200
Message-ID: <20260912065627.880082135@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index ca420d843e254..a9386a4808a75 100644
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



