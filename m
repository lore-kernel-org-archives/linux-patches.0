Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C340279DAB;
	Wed, 21 Feb 2024 13:53:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708523595; cv=none; b=Aa5IYWQarJJQNXsRoRQBzpCLcN1/XM3De6mXrYEj57AaPM5vgQa1cImSdK1vnXWvcoCpVEyMQNPTG5kIeA8M6TIbZwJTwfrx2N5TdAlauyzEh0EUIEfo+d8zpOjlFUyEnwcyznHashEU9S3+URq7clr+/M/w5XQghER405nLDLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708523595; c=relaxed/simple;
	bh=apG4KkGyj49eZ7mUUIZafXeLt3jasV9jJxNWrIR91FI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aIYGmhOr0llOu/KzKjp1tS9pjw1iaT3w+AERXOgk1rvjPq0pMOBxXURysFA/3/BEGw9JHz1B5lB+M/lAq1HekOlhHx2cpOT9Ek/TydWpV4XghA0UCCAImu+Nez5psG9aCtTJCnRxkVFVXi0RW/OB2Dbw1HaP8PZT4v+KED3NUNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lxjsyHT8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lxjsyHT8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB78AC433C7;
	Wed, 21 Feb 2024 13:53:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708523595;
	bh=apG4KkGyj49eZ7mUUIZafXeLt3jasV9jJxNWrIR91FI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lxjsyHT8d7UE5xH9fDrQNVej9miwcgHGyz6SzdLuZqsgZJJvWgKpAkvRvhP21n++9
	 k+/VUHKZbPn7sqwUyOBPsi9Lr1q/5P/nrM8UcHOCjqOnH0t3BkUEyIX3nE78E8hpzp
	 w06YeAFKeBd/5JwaFY8cRpgWYOYUYDGQMDE+7DZQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Carlos Llamas <cmllamas@google.com>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Elliot Berman <quic_eberman@quicinc.com>,
	Justin Stitt <justinstitt@google.com>,
	Will Deacon <will@kernel.org>,
	John Stultz <jstultz@google.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Tom Rix <trix@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 456/476] scripts/decode_stacktrace.sh: optionally use LLVM utilities
Date: Wed, 21 Feb 2024 14:08:27 +0100
Message-ID: <20240221130024.898419459@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Carlos Llamas <cmllamas@google.com>

[ Upstream commit efbd6398353315b7018e6943e41fee9ec35e875f ]

GNU's addr2line can have problems parsing a vmlinux built with LLVM,
particularly when LTO was used.  In order to decode the traces correctly
this patch adds the ability to switch to LLVM's utilities readelf and
addr2line.  The same approach is followed by Will in [1].

Before:
  $ scripts/decode_stacktrace.sh vmlinux < kernel.log
  [17716.240635] Call trace:
  [17716.240646] skb_cow_data (??:?)
  [17716.240654] esp6_input (ld-temp.o:?)
  [17716.240666] xfrm_input (ld-temp.o:?)
  [17716.240674] xfrm6_rcv (??:?)
  [...]

After:
  $ LLVM=1 scripts/decode_stacktrace.sh vmlinux < kernel.log
  [17716.240635] Call trace:
  [17716.240646] skb_cow_data (include/linux/skbuff.h:2172 net/core/skbuff.c:4503)
  [17716.240654] esp6_input (net/ipv6/esp6.c:977)
  [17716.240666] xfrm_input (net/xfrm/xfrm_input.c:659)
  [17716.240674] xfrm6_rcv (net/ipv6/xfrm6_input.c:172)
  [...]

Note that one could set CROSS_COMPILE=llvm- instead to hack around this
issue.  However, doing so can break the decodecode routine as it will
force the selection of other LLVM utilities down the line e.g.  llvm-as.

[1] https://lore.kernel.org/all/20230914131225.13415-3-will@kernel.org/

Link: https://lkml.kernel.org/r/20230929034836.403735-1-cmllamas@google.com
Signed-off-by: Carlos Llamas <cmllamas@google.com>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Reviewed-by: Elliot Berman <quic_eberman@quicinc.com>
Tested-by: Justin Stitt <justinstitt@google.com>
Cc: Will Deacon <will@kernel.org>
Cc: John Stultz <jstultz@google.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Tom Rix <trix@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/decode_stacktrace.sh | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/scripts/decode_stacktrace.sh b/scripts/decode_stacktrace.sh
index 564c5632e1a2..bfe5a4082d8e 100755
--- a/scripts/decode_stacktrace.sh
+++ b/scripts/decode_stacktrace.sh
@@ -16,6 +16,21 @@ elif type c++filt >/dev/null 2>&1 ; then
 	cppfilt_opts=-i
 fi
 
+UTIL_SUFFIX=
+if [[ -z ${LLVM:-} ]]; then
+	UTIL_PREFIX=${CROSS_COMPILE:-}
+else
+	UTIL_PREFIX=llvm-
+	if [[ ${LLVM} == */ ]]; then
+		UTIL_PREFIX=${LLVM}${UTIL_PREFIX}
+	elif [[ ${LLVM} == -* ]]; then
+		UTIL_SUFFIX=${LLVM}
+	fi
+fi
+
+READELF=${UTIL_PREFIX}readelf${UTIL_SUFFIX}
+ADDR2LINE=${UTIL_PREFIX}addr2line${UTIL_SUFFIX}
+
 if [[ $1 == "-r" ]] ; then
 	vmlinux=""
 	basepath="auto"
@@ -75,7 +90,7 @@ find_module() {
 
 	if [[ "$modpath" != "" ]] ; then
 		for fn in $(find "$modpath" -name "${module//_/[-_]}.ko*") ; do
-			if readelf -WS "$fn" | grep -qwF .debug_line ; then
+			if ${READELF} -WS "$fn" | grep -qwF .debug_line ; then
 				echo $fn
 				return
 			fi
@@ -169,7 +184,7 @@ parse_symbol() {
 	if [[ $aarray_support == true && "${cache[$module,$address]+isset}" == "isset" ]]; then
 		local code=${cache[$module,$address]}
 	else
-		local code=$(${CROSS_COMPILE}addr2line -i -e "$objfile" "$address" 2>/dev/null)
+		local code=$(${ADDR2LINE} -i -e "$objfile" "$address" 2>/dev/null)
 		if [[ $aarray_support == true ]]; then
 			cache[$module,$address]=$code
 		fi
-- 
2.43.0



