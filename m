Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 884FA264612;
	Fri, 21 Nov 2025 13:25:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731526; cv=none; b=ETaXhe03RGr0Uwa4V6AtUloRXC0439POoqvBykMn5eWNT8ISAItgUig5+pVGFQcqYwnYaDuYL5jxH2JM6S6NYVrxtXNknD1sXkhiU/Ihn5qWOK2GUpP2jm/PjUZGCpzAnAKhL+OZR+NhmUTn4R4IgKz/wke9d1EOuXaMJmIk4TE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731526; c=relaxed/simple;
	bh=fJVBFeAYkKRkibgCx13CeKTzfZnlBCqYo0ZkwsUX8kU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tTVB40z2N8PVmzQipPMZc1QbcHrOsXGgAQFgGhJ8QgCbHeTACVQS/9k3XIwWPc2XvtcvGEsxEJsT81au3M9CUNWHyeVn2/QJmXgzZjD33+1WgpqhrHipFW6YRoCLAqISL8C19SgsluuzuwqTzSYZ+qnrPRR6/rQKPgp3z/itGZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1FB9esIp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1FB9esIp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00D78C4CEF1;
	Fri, 21 Nov 2025 13:25:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731526;
	bh=fJVBFeAYkKRkibgCx13CeKTzfZnlBCqYo0ZkwsUX8kU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1FB9esIpqOPnK157yGeQapTMoYYM/i/4RfTV+BsHx7PL27RxrNph8liA2t6ea1VhM
	 /FY6gJYHXuRqr9IsPQWrHyzCh55X9mC1coWHXAhhvsWX5bWVXaCWQZW/VBZO7wNRS7
	 JYpr5swt4hK0HZXag/qXYkWMCOLm6Gh0yii4Bg+Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Carlos Llamas <cmllamas@google.com>,
	Breno Leitao <leitao@debian.org>,
	Elliot Berman <quic_eberman@quicinc.com>,
	Luca Ceresoli <luca.ceresoli@bootlin.com>,
	Stephen Boyd <swboyd@chromium.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.17 239/247] scripts/decode_stacktrace.sh: symbol: preserve alignment
Date: Fri, 21 Nov 2025 14:13:06 +0100
Message-ID: <20251121130203.314915757@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

commit 4a2fc4897b5e0ca1e7a3cb4e32f44c7db3367dee upstream.

With lines having a symbol to decode, the script was only trying to
preserve the alignment for the timestamps, but not the rest, nor when the
caller was set (CONFIG_PRINTK_CALLER=y).

With this sample ...

  [   52.080924] Call Trace:
  [   52.080926]  <TASK>
  [   52.080931]  dump_stack_lvl+0x6f/0xb0

... the script was producing the following output:

  [   52.080924] Call Trace:
  [   52.080926]  <TASK>
  [   52.080931] dump_stack_lvl (arch/x86/include/asm/irqflags.h:19)

  (dump_stack_lvl is no longer aligned with <TASK>: one missing space)

With this other sample ...

  [   52.080924][   T48] Call Trace:
  [   52.080926][   T48]  <TASK>
  [   52.080931][   T48]  dump_stack_lvl+0x6f/0xb0

... the script was producing the following output:

  [   52.080924][   T48] Call Trace:
  [   52.080926][   T48]  <TASK>
  [ 52.080931][ T48] dump_stack_lvl (arch/x86/include/asm/irqflags.h:19)

  (the misalignment is clearer here)

That's because the script had a workaround for CONFIG_PRINTK_TIME=y only,
see the previous comment called "Format timestamps with tabs".

To always preserve spaces, they need to be recorded along the words.  That
is what is now done with the new 'spaces' array.

Some notes:

- 'extglob' is needed only for this operation, and that's why it is set
  in a dedicated subshell.

- 'read' is used with '-r' not to treat a <backslash> character in any
  special way, e.g. when followed by a space.

- When a word is removed from the 'words' array, the corresponding space
  needs to be removed from the 'spaces' array as well.

With the last sample, we now have:

  [   52.080924][   T48] Call Trace:
  [   52.080926][   T48]  <TASK>
  [   52.080931][   T48]  dump_stack_lvl (arch/x86/include/asm/irqflags.h:19)

  (the alignment is preserved)

Link: https://lkml.kernel.org/r/20250908-decode_strace_indent-v1-2-28e5e4758080@kernel.org
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Tested-by: Carlos Llamas <cmllamas@google.com>
Cc: Breno Leitao <leitao@debian.org>
Cc: Elliot Berman <quic_eberman@quicinc.com>
Cc: Luca Ceresoli <luca.ceresoli@bootlin.com>
Cc: Stephen Boyd <swboyd@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 scripts/decode_stacktrace.sh |   26 ++++++++++++--------------
 1 file changed, 12 insertions(+), 14 deletions(-)

--- a/scripts/decode_stacktrace.sh
+++ b/scripts/decode_stacktrace.sh
@@ -255,10 +255,11 @@ handle_line() {
 		basepath=${basepath%/init/main.c:*)}
 	fi
 
-	local words
+	local words spaces
 
-	# Tokenize
-	read -a words <<<"$1"
+	# Tokenize: words and spaces to preserve the alignment
+	read -ra words <<<"$1"
+	IFS='#' read -ra spaces <<<"$(shopt -s extglob; echo "${1//+([^[:space:]])/#}")"
 
 	# Remove hex numbers. Do it ourselves until it happens in the
 	# kernel
@@ -270,19 +271,13 @@ handle_line() {
 	for i in "${!words[@]}"; do
 		# Remove the address
 		if [[ ${words[$i]} =~ \[\<([^]]+)\>\] ]]; then
-			unset words[$i]
-		fi
-
-		# Format timestamps with tabs
-		if [[ ${words[$i]} == \[ && ${words[$i+1]} == *\] ]]; then
-			unset words[$i]
-			words[$i+1]=$(printf "[%13s\n" "${words[$i+1]}")
+			unset words[$i] spaces[$i]
 		fi
 	done
 
 	if [[ ${words[$last]} =~ ^[0-9a-f]+\] ]]; then
 		words[$last-1]="${words[$last-1]} ${words[$last]}"
-		unset words[$last]
+		unset words[$last] spaces[$last]
 		last=$(( $last - 1 ))
 	fi
 
@@ -294,7 +289,7 @@ handle_line() {
 	local info_str=""
 	if [[ ${words[$last]} =~ \([A-Z]*\) ]]; then
 		info_str=${words[$last]}
-		unset words[$last]
+		unset words[$last] spaces[$last]
 		last=$(( $last - 1 ))
 	fi
 
@@ -311,7 +306,7 @@ handle_line() {
 			modbuildid=
 		fi
 		symbol=${words[$last-1]}
-		unset words[$last-1]
+		unset words[$last-1] spaces[$last-1]
 	else
 		# The symbol is the last element, process it
 		symbol=${words[$last]}
@@ -323,7 +318,10 @@ handle_line() {
 	parse_symbol # modifies $symbol
 
 	# Add up the line number to the symbol
-	echo "${words[@]}" "${symbol}${module:+ ${module}}${info_str:+ ${info_str}}"
+	for i in "${!words[@]}"; do
+		echo -n "${spaces[i]}${words[i]}"
+	done
+	echo "${spaces[$last]}${symbol}${module:+ ${module}}${info_str:+ ${info_str}}"
 }
 
 while read line; do


