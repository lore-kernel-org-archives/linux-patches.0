Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 298842DFF1B;
	Tue, 17 Jun 2025 16:39:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178354; cv=none; b=oMlXux6Wxll55j++whQstqel7HMwg0NR8f31AXtsq6HBucsxcrG3QLILZ8W+Lcdck59woykCnS6NZUSiB4qbcZnJBCFL63qlC2PoCKrmZacflBT8NQhI/Agq0ejxIX/KEZMzTBMb4bDhOJWaz7rqBSyaoHYXdLMDFnmzCf6teg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178354; c=relaxed/simple;
	bh=Dgq50nzt/x3boONEJ36VvSkBijAXIUjhSoLWavbHH2I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J85HvWXCuBq1zcIoPukcZwE7f7TQqFHn/WIxOCeXREZvDUNNJb/huH0uxQ/rDeRYVSD+ZdXenGgIZzkvBHxspGiXiDujSIubQdvb/u2mQLrmkoPdnAQwWXyMaBDcMfJv/6wMrtLxrJ8FYZWaK2Wlxq71mA7Usx2B3g+N+VftiE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MnoL8jmd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MnoL8jmd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84BAEC4CEE3;
	Tue, 17 Jun 2025 16:39:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178354;
	bh=Dgq50nzt/x3boONEJ36VvSkBijAXIUjhSoLWavbHH2I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MnoL8jmdq51kybyBYs6Z/OknpRCAVR/gWNUdojcH+e3652HGEWfG1tlbnU5RbVMZc
	 LskULCCkkxWEIWEU//uguBfkeJEaYnIsOx1sZT4Z5V8KplxKKkM7rPgVyw5jB/DT2f
	 ReeF7uKCN3v9MCxqm+3Mkx2SsD7eAijw52sfzkig=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Suleiman Souhlal <suleiman@google.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>
Subject: [PATCH 6.12 483/512] tools/resolve_btfids: Fix build when cross compiling kernel with clang.
Date: Tue, 17 Jun 2025 17:27:29 +0200
Message-ID: <20250617152439.185791071@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


