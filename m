Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D80AEB65C;
	Thu, 18 Jan 2024 10:50:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575059; cv=none; b=GwTWFGQ8BbmgYX0ViY8nO+jmFeU5osSXVePAlUtAOYkhfB089Orj7JjwDOiHnaCbD4yBgyHjpNRoziCSvq5OdHNSGLdGpaWTJjJ307Sj48CciFl0Cp6RB9UQcL9eMESel3j8lTqYcQ1vQHQnZ7/phXiCPVeEuxl0clsDUjVm3xo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575059; c=relaxed/simple;
	bh=GDAuswjR/OYJya90u3mMJdOirAqKRL3cZh3jHSaiL3M=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Transfer-Encoding; b=IgLNCMeuM9DtCQeiCBpeiuGjHIb4qFEz8fBZvjkPKFIYvgnXmN55Lc0HQB4Oqgn3MGZsrO/6W3uliPRQr3WwaOqvymFjljswzbFksFCslSl615jQyv90F5esGyP8OalLpcC0L45ghHTpWFJcv4/qtkVnQrKJFhvyK8FEl/I6xCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nZCRoKg+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nZCRoKg+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25738C433C7;
	Thu, 18 Jan 2024 10:50:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575059;
	bh=GDAuswjR/OYJya90u3mMJdOirAqKRL3cZh3jHSaiL3M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nZCRoKg+ZlFXnZgIfDiWf4ERSMWXQNvzu+30yvdYaS7D+DR1HMYq6IOedOxpQvsZ8
	 4C0Jh7DKQn2BfppmA/ajYOj+fFpnluhfG+oYZoRH6kk+SNLDeFz5fBFoQJfFGeZyDk
	 fIrhGWW6ZQNJsD891qB0SsexW0X1YvyLHrIIOtIM=
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
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.7 26/28] scripts/decode_stacktrace.sh: optionally use LLVM utilities
Date: Thu, 18 Jan 2024 11:49:16 +0100
Message-ID: <20240118104302.116482720@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240118104301.249503558@linuxfoundation.org>
References: <20240118104301.249503558@linuxfoundation.org>
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

From: Carlos Llamas <cmllamas@google.com>

commit efbd6398353315b7018e6943e41fee9ec35e875f upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 scripts/decode_stacktrace.sh |   19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

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


