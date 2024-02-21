Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D6757F460;
	Wed, 21 Feb 2024 14:13:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708524830; cv=none; b=d9nSpp4p1+iWCqrs+2tEmFMin6zpVLBd4QNuMo4E8KSE1/YdtA6GHcLWcJEdt7A1KhaJYI5ppPsBnpUajauZyIbjizqfs7JucBY/tJtP6QwikLUCUd7CjbHkJ8kU99bbHsZLaNCrK6QHKIuNaTVir4L5EbT8kC6+v+KuZMxL2w0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708524830; c=relaxed/simple;
	bh=pFuiCuHBlZrIU1+IY7+ki2acwX+Y07C4NApi0miX7PY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rraBu75d3VyGynd61c6rL2C2ehDsODbLTFCj4TEkHbtB+AFLe7Fk19fm6Pn4hhkYzs+vfV+kb20dfe/Nkdc2ZB7989q8Lvz148tixSF1tqlpXLKaY38ryuD9qMsaMHj8rnQ99syJh7Eikk7XkuucdW3LK5LAWb+09B+aiu2k74o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wFFd0cDK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wFFd0cDK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2101CC433C7;
	Wed, 21 Feb 2024 14:13:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708524829;
	bh=pFuiCuHBlZrIU1+IY7+ki2acwX+Y07C4NApi0miX7PY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wFFd0cDKvCrFQvgPIFANbnKZbsL0z1THNfT+YHqORYtS9v/CRIzWaSNo9hiuhRQ7y
	 Vm3C0Vjf6Z48SCqJvsjaq9u+51RIfQDo/aHjBMmWXsi4aoNiCrLAcQCFNrf4kLsJMC
	 efacyg5NeU5vmxSgfaHqRg63uyw4CselBQn2X4wg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephen Boyd <swboyd@chromium.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Jessica Yu <jeyu@kernel.org>,
	Evan Green <evgreen@chromium.org>,
	Hsin-Yi Wang <hsinyi@chromium.org>,
	Konstantin Khlebnikov <khlebnikov@yandex-team.ru>,
	Sasha Levin <sashal@kernel.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Baoquan He <bhe@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Dave Young <dyoung@redhat.com>,
	Ingo Molnar <mingo@redhat.com>,
	Matthew Wilcox <willy@infradead.org>,
	Petr Mladek <pmladek@suse.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Vivek Goyal <vgoyal@redhat.com>,
	Will Deacon <will@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.10 361/379] scripts/decode_stacktrace.sh: silence stderr messages from addr2line/nm
Date: Wed, 21 Feb 2024 14:09:00 +0100
Message-ID: <20240221130005.745356091@linuxfoundation.org>
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

From: Stephen Boyd <swboyd@chromium.org>

[ Upstream commit 5bf0f3bc377e5f87bfd61ccc9c1efb3c6261f2c3 ]

Sometimes if you're using tools that have linked things improperly or have
new features/sections that older tools don't expect you'll see warnings
printed to stderr.  We don't really care about these warnings, so let's
just silence these messages to cleanup output of this script.

Link: https://lkml.kernel.org/r/20210511003845.2429846-10-swboyd@chromium.org
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Jessica Yu <jeyu@kernel.org>
Cc: Evan Green <evgreen@chromium.org>
Cc: Hsin-Yi Wang <hsinyi@chromium.org>
Cc: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc: Sasha Levin <sashal@kernel.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Stable-dep-of: efbd63983533 ("scripts/decode_stacktrace.sh: optionally use LLVM utilities")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/decode_stacktrace.sh | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/scripts/decode_stacktrace.sh b/scripts/decode_stacktrace.sh
index 90398347e366..5bdf610f33d2 100755
--- a/scripts/decode_stacktrace.sh
+++ b/scripts/decode_stacktrace.sh
@@ -51,7 +51,7 @@ find_module() {
 	find_module && return
 
 	if [[ $release == "" ]] ; then
-		release=$(gdb -ex 'print init_uts_ns.name.release' -ex 'quit' -quiet -batch "$vmlinux" | sed -n 's/\$1 = "\(.*\)".*/\1/p')
+		release=$(gdb -ex 'print init_uts_ns.name.release' -ex 'quit' -quiet -batch "$vmlinux" 2>/dev/null | sed -n 's/\$1 = "\(.*\)".*/\1/p')
 	fi
 
 	for dn in {/usr/lib/debug,}/lib/modules/$release ; do
@@ -105,7 +105,7 @@ parse_symbol() {
 	if [[ "${cache[$module,$name]+isset}" == "isset" ]]; then
 		local base_addr=${cache[$module,$name]}
 	else
-		local base_addr=$(nm "$objfile" | awk '$3 == "'$name'" && ($2 == "t" || $2 == "T") {print $1; exit}')
+		local base_addr=$(nm "$objfile" 2>/dev/null | awk '$3 == "'$name'" && ($2 == "t" || $2 == "T") {print $1; exit}')
 		if [[ $base_addr == "" ]] ; then
 			# address not found
 			return
@@ -129,7 +129,7 @@ parse_symbol() {
 	if [[ "${cache[$module,$address]+isset}" == "isset" ]]; then
 		local code=${cache[$module,$address]}
 	else
-		local code=$(${CROSS_COMPILE}addr2line -i -e "$objfile" "$address")
+		local code=$(${CROSS_COMPILE}addr2line -i -e "$objfile" "$address" 2>/dev/null)
 		cache[$module,$address]=$code
 	fi
 
-- 
2.43.0



