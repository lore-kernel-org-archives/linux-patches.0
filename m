Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21D29216E2A;
	Tue, 17 Jun 2025 16:16:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176981; cv=none; b=tB4AbtjGRNh02ibagg1BQAmCvtLNSJyyS8zkzg9R7B7QQ66tAaUyTBEV8pGHooa2GFDcCuDOS6mgtIUMn+8yY1FVkCyhHkxfMfXRjF/tfC9BuEObYABMzd3EJ+FnfMQlhi/3v2WHexGMcCe56QPNMN8EddwBxH7+hJ00HcAxuYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176981; c=relaxed/simple;
	bh=VBcoML0cLGuOeR+zgCnn+Kv3SgfjK13wjAOVGQhwaLQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E74WJ1AIjaqV0Km4G8FBGqYUEQ3sSjIsCSXNp03az8E40zQjq/KxbKO83V9St1tEPzwZqoXE+nPLO5npyKjG8GQkpgfJWUWjhVEiDzBodz7K1VNad7omIuPs0lyEAa4S1lsLIAUgNciO/iulWrcXFuROmVLcO9QT5mOxIiGo9s8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hyozGz7d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hyozGz7d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DA0DC4CEE3;
	Tue, 17 Jun 2025 16:16:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176981;
	bh=VBcoML0cLGuOeR+zgCnn+Kv3SgfjK13wjAOVGQhwaLQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hyozGz7dQEqqxye3Dp6bRIbfyyTb14PSCoRrFPHzCRyj9GD3HD9RsHAY2akcqqwtp
	 t4UvWpdds45nPFDcAkUBrsYm1/3vF5+YfVG0dC/o6+yvFT2b8HgTWzhs+EZOD01y+7
	 GyyGTxfmN3gEjwJPhrjGwWaqFs/4UZ/NAXZnVNX0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Suleiman Souhlal <suleiman@google.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>
Subject: [PATCH 6.6 336/356] tools/resolve_btfids: Fix build when cross compiling kernel with clang.
Date: Tue, 17 Jun 2025 17:27:31 +0200
Message-ID: <20250617152351.657942786@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
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


