Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA06D220686;
	Mon, 23 Jun 2025 21:52:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715523; cv=none; b=TXazF+UY5bpvLdEJf+4280fXhQbROSINVTDNxRABlAUjOkAyln0lryJ/w82cpE0djPfJZNzz6i6ao+0zLaz3OIAfxKU6gQ35mjg61vwrGLaXaYCefIq/q/ADQXH3hHUJtMn/L2oHxphUqBJ3drXFFQ+713wlIk92QlPZabjlq6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715523; c=relaxed/simple;
	bh=FLJWTn27H8+xrnF2u7IOvHmD4yD8JHF702Z5yXILj/s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=otuTkr9aYyNjHuGAFE6EVpOUw3ItXVztJkL305caQ2YlwZLjTCTtpZlPjsZ/SE/vC22DwHhVyaRkk0Fuvr0IpwqDjR/LjPGaGcU9WTpcnrHb6/spMo1C+hOLTLdfL++dpIi9s69GOfn8trRQHS3vaDttEaigFbCxnMIV7hKqQNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xhvFnIRb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xhvFnIRb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5067EC4CEEA;
	Mon, 23 Jun 2025 21:52:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715523;
	bh=FLJWTn27H8+xrnF2u7IOvHmD4yD8JHF702Z5yXILj/s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xhvFnIRbRBGNTpKRyUosbiQ4Mabk0ypFFZAhKUVZTZThKVuhFVNFb8dt27Lrp9ZQ/
	 S4zRWx8mN4ygCFO+suhEKZ4rAbA+bzZXNJpMWzxiiS8q3fJCvupIS9fBhxzFDiNcWa
	 6pA/UaHd4FSPSq5SMUmepT8zdawAgdKyV26nOef4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Suleiman Souhlal <suleiman@google.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>
Subject: [PATCH 6.1 266/508] tools/resolve_btfids: Fix build when cross compiling kernel with clang.
Date: Mon, 23 Jun 2025 15:05:11 +0200
Message-ID: <20250623130651.789073638@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Suleiman Souhlal <suleiman@google.com>

commit a298bbab903e3fb4cbe16d36d6195e68fad1b776 upstream.

When cross compiling the kernel with clang, we need to override
CLANG_CROSS_FLAGS when preparing the step libraries.

Prior to commit d1d096312176 ("tools: fix annoying "mkdir -p ..." logs
when building tools in parallel"), MAKEFLAGS would have been set to a
value that wouldn't set a value for CLANG_CROSS_FLAGS, hiding the
fact that we weren't properly overriding it.

Fixes: 56a2df7615fa ("tools/resolve_btfids: Compile resolve_btfids as host program")
Signed-off-by: Suleiman Souhlal <suleiman@google.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Jiri Olsa <jolsa@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/bpf/20250606074538.1608546-1-suleiman@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/bpf/resolve_btfids/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/bpf/resolve_btfids/Makefile
+++ b/tools/bpf/resolve_btfids/Makefile
@@ -19,7 +19,7 @@ endif
 
 # Overrides for the prepare step libraries.
 HOST_OVERRIDES := AR="$(HOSTAR)" CC="$(HOSTCC)" LD="$(HOSTLD)" ARCH="$(HOSTARCH)" \
-		  CROSS_COMPILE="" EXTRA_CFLAGS="$(HOSTCFLAGS)"
+		  CROSS_COMPILE="" CLANG_CROSS_FLAGS="" EXTRA_CFLAGS="$(HOSTCFLAGS)"
 
 RM      ?= rm
 HOSTCC  ?= gcc


