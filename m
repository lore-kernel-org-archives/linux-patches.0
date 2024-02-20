Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38114612D7;
	Tue, 20 Feb 2024 21:40:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708465221; cv=none; b=uMk3RGc+iDpT718u2pJT/SGhC0HtAGn5P5iEVk9Xs2vskIKiuHYosBcZZXaz7ncVZuQRYUEV/zYFMWQjMbq5/nSEwmGFNyzXr0/IkHoSXf1iA6yl15eRTdpi5BXoPZk+97s3D5hi5N9g5LQM76629Zj/gBJUGdRdrky+nuYSgJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708465221; c=relaxed/simple;
	bh=Q+OTxl8H+JKUKLtDspoY1r5h7fO/h73LXxd6yQ5aHmI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=unZlUrQCD90MwqaFWrf4xZQL2QlD/9HxqdfSq5xmgWI5NadQHWveTyaPCXdEMZATwiSDVzF8Kdu2Tw6NU2E3treGpD21vfOjOsHddKmA+NtywXl91DmxW2JUG5nxgo9EbyYlnhnDr8LMFANF/GqWm65lq7J6hfJkpR9WOkU+s6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1S3Wn5Ek; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1S3Wn5Ek"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B8AEC433C7;
	Tue, 20 Feb 2024 21:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708465221;
	bh=Q+OTxl8H+JKUKLtDspoY1r5h7fO/h73LXxd6yQ5aHmI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1S3Wn5EkTUvgAQpc3+wr7DtdgwjxUryB9X5YIz/4Q7kSyscLNEpi1L5rzpPTkoCeI
	 r4zU2TTmmmOyIG+ivZdPPlAcIYv7Vtrani8h9QllXWXIBos+MADekl+HUyw/z2FPfA
	 mCUMT12ghjsL28l/rE0/V2z2KzNux8kmOG7bvJEo=
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
Subject: [PATCH 6.7 274/309] tools/rtla: Fix clang warning about mount_point var size
Date: Tue, 20 Feb 2024 21:57:13 +0100
Message-ID: <20240220205641.702255671@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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


