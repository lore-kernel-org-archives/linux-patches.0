Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70C5979DAB;
	Wed, 21 Feb 2024 13:53:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708523589; cv=none; b=ccP8gA4jLfIUrnZwoQ7fblMy+madFWomWUSew3srsvpRzQJLov6WOOcpZn71gwv8MfAN7wpj/f8XKMWtubVHZlBMZZIrdzPIfPkUx2TPhjsQF+FbhucQx+OuxqJm/UaJ0DA5fjTW4g5ybKePJWbB210d6JfC2EydgOgo3iH8H5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708523589; c=relaxed/simple;
	bh=XYkhy8QGIBygRigGkARX/MA+scopnlbaJnLkM6K1y04=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VxnlTq/vzilYBdMI7H3UWWLY+v+EqdaxIn7NISYEnBWnf/cZTLIfyEZYlR6igu1P2WtPquCxOMRzjNWzSjBgJHFn9Qms9FstsmE2f/S+y7C9v3A/dATquU1vYQonwV3Yrot/lx9uZTWmyHtanvObyeFT52opzWfz7ZPDYt1THYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g/Qp/iuG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g/Qp/iuG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFA32C433C7;
	Wed, 21 Feb 2024 13:53:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708523589;
	bh=XYkhy8QGIBygRigGkARX/MA+scopnlbaJnLkM6K1y04=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g/Qp/iuGatxxFXYbNCjWRRRu3ccv4W4W+E77JxgKxfL840Xb1dXcvbGlyFsq8aZ8K
	 3T2VBxwvsX5GRx4YGq5K5CXdR+JohDNzQlUAdKGbfetCa0dJWAliwKiVvXdAWKIe4f
	 QqWXqWSTbgkpcrZZ/AXyJSbWpeUc+qRO6uQrQp8Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Schspa Shi <schspa@gmail.com>,
	Stephen Boyd <swboyd@chromium.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 454/476] scripts/decode_stacktrace.sh: support old bash version
Date: Wed, 21 Feb 2024 14:08:25 +0100
Message-ID: <20240221130024.822980212@linuxfoundation.org>
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
index 5fbad61fe490..7075e26ab2c4 100755
--- a/scripts/decode_stacktrace.sh
+++ b/scripts/decode_stacktrace.sh
@@ -45,8 +45,13 @@ else
 	fi
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
 	if [[ -n $debuginfod ]] ; then
@@ -97,7 +102,7 @@ parse_symbol() {
 
 	if [[ $module == "" ]] ; then
 		local objfile=$vmlinux
-	elif [[ "${modcache[$module]+isset}" == "isset" ]]; then
+	elif [[ $aarray_support == true && "${modcache[$module]+isset}" == "isset" ]]; then
 		local objfile=${modcache[$module]}
 	else
 		local objfile=$(find_module)
@@ -105,7 +110,9 @@ parse_symbol() {
 			echo "WARNING! Modules path isn't set, but is needed to parse this symbol" >&2
 			return
 		fi
-		modcache[$module]=$objfile
+		if [[ $aarray_support == true ]]; then
+			modcache[$module]=$objfile
+		fi
 	fi
 
 	# Remove the englobing parenthesis
@@ -125,7 +132,7 @@ parse_symbol() {
 	# Use 'nm vmlinux' to figure out the base address of said symbol.
 	# It's actually faster to call it every time than to load it
 	# all into bash.
-	if [[ "${cache[$module,$name]+isset}" == "isset" ]]; then
+	if [[ $aarray_support == true && "${cache[$module,$name]+isset}" == "isset" ]]; then
 		local base_addr=${cache[$module,$name]}
 	else
 		local base_addr=$(nm "$objfile" 2>/dev/null | awk '$3 == "'$name'" && ($2 == "t" || $2 == "T") {print $1; exit}')
@@ -133,7 +140,9 @@ parse_symbol() {
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
@@ -149,11 +158,13 @@ parse_symbol() {
 
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



