Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D9BB151CF3;
	Tue, 20 Feb 2024 21:20:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464024; cv=none; b=nKCXhQTsi8JuHQYx7n1PaHxSjUqn+kRBk49iYn8h8ZW409ypmUhq4SR4w3tOuf2P2D6LRfEs0Md4Ok+F5Dtbc55Np+oQ6fWUdIcI9UH1hczR8eQTwLzwBs/waqLhQA+WqWQNYRKdRbn+I7facoV6IUQvptIV2eCPSkYIl2wKYeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464024; c=relaxed/simple;
	bh=jFOgIOiXeoZOkk5c55rDOCKq1JSRrt/ofjFjl5hCFnM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VJp7pCnEfIYT1yWtJo9VhLH0kqgtGTYgDFc0Sfa2F4DXDuBWBW6iUwgfYoHzEqH67FUMdA5Ty7sJ5VAkEqwZC31h3cMhI6ohHpruHFcBWgdbgI3BGWOwkJ2VzL2Z737pv3a0MmKE1wwLXmZlxHd/gNmI/8CTPNXFUykMkyGcfzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G9bjpAXB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G9bjpAXB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B67F9C433F1;
	Tue, 20 Feb 2024 21:20:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464023;
	bh=jFOgIOiXeoZOkk5c55rDOCKq1JSRrt/ofjFjl5hCFnM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G9bjpAXBgtLxJJW6gYcKtN2TKJ/atHxTC+cVM42OQokH4WDvgnf7lVVyKER1R3MAk
	 g/Rul30knH4IGEpNAHIK7C9mplVPib8dDoLGS6gHMiVvkv2eBS3bK7/dEM2ygws93y
	 sgvi3nkp2bsPLqeMitSqXYzavt9iQ2DshKxndTn0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>,
	Donald Zickus <dzickus@redhat.com>,
	Daniel Bristot de Oliveira <bristot@kernel.org>
Subject: [PATCH 6.6 228/331] tools/rtla: Fix clang warning about mount_point var size
Date: Tue, 20 Feb 2024 21:55:44 +0100
Message-ID: <20240220205644.928528895@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Bristot de Oliveira <bristot@kernel.org>

commit 30369084ac6e27479a347899e74f523e6ca29b89 upstream.

clang is reporting this warning:

$ make HOSTCC=clang CC=clang LLVM_IAS=1
[...]
clang -O -g -DVERSION=\"6.8.0-rc3\" -flto=auto -fexceptions
	-fstack-protector-strong -fasynchronous-unwind-tables
	-fstack-clash-protection  -Wall -Werror=format-security
	-Wp,-D_FORTIFY_SOURCE=2 -Wp,-D_GLIBCXX_ASSERTIONS
	$(pkg-config --cflags libtracefs)    -c -o src/utils.o src/utils.c

src/utils.c:548:66: warning: 'fscanf' may overflow; destination buffer in argument 3 has size 1024, but the corresponding specifier may require size 1025 [-Wfortify-source]
  548 |         while (fscanf(fp, "%*s %" STR(MAX_PATH) "s %99s %*s %*d %*d\n", mount_point, type) == 2) {
      |                                                                         ^

Increase mount_point variable size to MAX_PATH+1 to avoid the overflow.

Link: https://lkml.kernel.org/r/1b46712e93a2f4153909514a36016959dcc4021c.1707217097.git.bristot@kernel.org

Cc: stable@vger.kernel.org
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Bill Wendling <morbo@google.com>
Cc: Justin Stitt <justinstitt@google.com>
Cc: Donald Zickus <dzickus@redhat.com>
Fixes: a957cbc02531 ("rtla: Add -C cgroup support")
Signed-off-by: Daniel Bristot de Oliveira <bristot@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/tracing/rtla/src/utils.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/tracing/rtla/src/utils.c
+++ b/tools/tracing/rtla/src/utils.c
@@ -530,7 +530,7 @@ int set_cpu_dma_latency(int32_t latency)
  */
 static const int find_mount(const char *fs, char *mp, int sizeof_mp)
 {
-	char mount_point[MAX_PATH];
+	char mount_point[MAX_PATH+1];
 	char type[100];
 	int found = 0;
 	FILE *fp;


