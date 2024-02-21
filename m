Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25F7D7BB18;
	Wed, 21 Feb 2024 14:13:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708524833; cv=none; b=dKG+t6mwpISSm3v1hrUOsCHOccxsiJmY5Hapm1e9UdG52nKAaCsMY3SgGqE5ox4wAHrMWzpRp/51sl57AcU0fazPh7PxpaiXgi8juLW9BOZR0TTXfhiSnb8FqW1+04zAr9m8XI8RX7NYZdu+VQo02Xd8zk2Cyqx4Q1TrPZM3yqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708524833; c=relaxed/simple;
	bh=rVMo0GNB4RIjWbB+dxyGKg3K5Uozcnp5MP7QC9OZDcw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WFWNlZeCSSE4nFrezQUM480DD1DHfadqHRoaenOjubBLUFr7blfnuFTtCjIYxMQeno4z32JZNjU9U4n+5hQA+klF4U+2/pzZvND6akj7fYS1wDe3f2fADOxcY6wfEgwo6v/tUhDWJJVQYmF6FCx4yeYjQ0dQMWFzy+bDfDsbsRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QEJIO+Pr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QEJIO+Pr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D417C433C7;
	Wed, 21 Feb 2024 14:13:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708524833;
	bh=rVMo0GNB4RIjWbB+dxyGKg3K5Uozcnp5MP7QC9OZDcw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QEJIO+PrAik6JyIVd3FxKN+4IYaZlX6NnNhJZ02od1bj+9SK3ibrxxzYsiLdN9bYS
	 u/JMW8I8RQOQ6cdHFvpa0oUSKA6dnPJUw068nk93uriXjfXXg864VNvyTUc9Up1hhy
	 gZzviUr3hA0HhMigf3yi8ggcXELV4BDx/Ad2Nj+g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Schspa Shi <schspa@gmail.com>,
	Stephen Boyd <swboyd@chromium.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 362/379] scripts/decode_stacktrace.sh: support old bash version
Date: Wed, 21 Feb 2024 14:09:01 +0100
Message-ID: <20240221130005.774979565@linuxfoundation.org>
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

From: Schspa Shi <schspa@gmail.com>

[ Upstream commit 3af8acf6aff2a98731522b52927429760f0b8006 ]

Old bash version don't support associative array variables.  Avoid to use
associative array variables to avoid error.

Without this, old bash version will report error as fellowing
[   15.954042] Kernel panic - not syncing: sysrq triggered crash
[   15.955252] CPU: 1 PID: 167 Comm: sh Not tainted 5.18.0-rc1-00208-gb7d075db2fd5 #4
[   15.956472] Hardware name: Hobot J5 Virtual development board (DT)
[   15.957856] Call trace:
./scripts/decode_stacktrace.sh: line 128: ,dump_backtrace: syntax error: operand expected (error token is ",dump_backtrace")

Link: https://lkml.kernel.org/r/20220409180331.24047-1-schspa@gmail.com
Signed-off-by: Schspa Shi <schspa@gmail.com>
Cc: Stephen Boyd <swboyd@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: efbd63983533 ("scripts/decode_stacktrace.sh: optionally use LLVM utilities")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/decode_stacktrace.sh | 27 +++++++++++++++++++--------
 1 file changed, 19 insertions(+), 8 deletions(-)

diff --git a/scripts/decode_stacktrace.sh b/scripts/decode_stacktrace.sh
index 5bdf610f33d2..51d48bf65fd7 100755
--- a/scripts/decode_stacktrace.sh
+++ b/scripts/decode_stacktrace.sh
@@ -33,8 +33,13 @@ else
 	release=""
 fi
 
-declare -A cache
-declare -A modcache
+declare aarray_support=true
+declare -A cache 2>/dev/null
+if [[ $? != 0 ]]; then
+	aarray_support=false
+else
+	declare -A modcache
+fi
 
 find_module() {
 	if [[ "$modpath" != "" ]] ; then
@@ -74,7 +79,7 @@ parse_symbol() {
 
 	if [[ $module == "" ]] ; then
 		local objfile=$vmlinux
-	elif [[ "${modcache[$module]+isset}" == "isset" ]]; then
+	elif [[ $aarray_support == true && "${modcache[$module]+isset}" == "isset" ]]; then
 		local objfile=${modcache[$module]}
 	else
 		local objfile=$(find_module)
@@ -82,7 +87,9 @@ parse_symbol() {
 			echo "WARNING! Modules path isn't set, but is needed to parse this symbol" >&2
 			return
 		fi
-		modcache[$module]=$objfile
+		if [[ $aarray_support == true ]]; then
+			modcache[$module]=$objfile
+		fi
 	fi
 
 	# Remove the englobing parenthesis
@@ -102,7 +109,7 @@ parse_symbol() {
 	# Use 'nm vmlinux' to figure out the base address of said symbol.
 	# It's actually faster to call it every time than to load it
 	# all into bash.
-	if [[ "${cache[$module,$name]+isset}" == "isset" ]]; then
+	if [[ $aarray_support == true && "${cache[$module,$name]+isset}" == "isset" ]]; then
 		local base_addr=${cache[$module,$name]}
 	else
 		local base_addr=$(nm "$objfile" 2>/dev/null | awk '$3 == "'$name'" && ($2 == "t" || $2 == "T") {print $1; exit}')
@@ -110,7 +117,9 @@ parse_symbol() {
 			# address not found
 			return
 		fi
-		cache[$module,$name]="$base_addr"
+		if [[ $aarray_support == true ]]; then
+			cache[$module,$name]="$base_addr"
+		fi
 	fi
 	# Let's start doing the math to get the exact address into the
 	# symbol. First, strip out the symbol total length.
@@ -126,11 +135,13 @@ parse_symbol() {
 
 	# Pass it to addr2line to get filename and line number
 	# Could get more than one result
-	if [[ "${cache[$module,$address]+isset}" == "isset" ]]; then
+	if [[ $aarray_support == true && "${cache[$module,$address]+isset}" == "isset" ]]; then
 		local code=${cache[$module,$address]}
 	else
 		local code=$(${CROSS_COMPILE}addr2line -i -e "$objfile" "$address" 2>/dev/null)
-		cache[$module,$address]=$code
+		if [[ $aarray_support == true ]]; then
+			cache[$module,$address]=$code
+		fi
 	fi
 
 	# addr2line doesn't return a proper error code if it fails, so
-- 
2.43.0



