Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 329951A5A3
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:21:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iBSIF1Qr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A165CC433C8;
	Mon,  9 Oct 2023 13:21:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696857678;
	bh=SIXnW3++cJ1BWCltsnubMWqs8tfZ/rX4Y3DG/g1qejg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iBSIF1QrEqSObYSNDjoFekcHV6iYu/evllqYoXOPaW8qIO3t03eKU49M+YufJWRFn
	 AkqrfKpW0dZIYZgEyVBvFRJsScaIXpa/cM3lMHUPEC1lsjxnROVqscMCGGAkz2uBe0
	 v/21BGGJZahISj5A2sKZEHkZHkjQr6uu+K+8M7/c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Phil Sutter <phil@nwl.cc>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 121/162] selftests: netfilter: Extend nft_audit.sh
Date: Mon,  9 Oct 2023 15:01:42 +0200
Message-ID: <20231009130126.268956720@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130122.946357448@linuxfoundation.org>
References: <20231009130122.946357448@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Phil Sutter <phil@nwl.cc>

[ Upstream commit 203bb9d39866d3c5a8135433ce3742fe4f9d5741 ]

Add tests for sets and elements and deletion of all kinds. Also
reorder rule reset tests: By moving the bulk rule add command up, the
two 'reset rules' tests become identical.

While at it, fix for a failing bulk rule add test's error status getting
lost due to its use in a pipe. Avoid this by using a temporary file.

Headings in diff output for failing tests contain no useful data, strip
them.

Signed-off-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Florian Westphal <fw@strlen.de>
Stable-dep-of: 0d880dc6f032 ("netfilter: nf_tables: Deduplicate nft_register_obj audit logs")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../testing/selftests/netfilter/nft_audit.sh  | 97 ++++++++++++++++---
 1 file changed, 81 insertions(+), 16 deletions(-)

diff --git a/tools/testing/selftests/netfilter/nft_audit.sh b/tools/testing/selftests/netfilter/nft_audit.sh
index 83c271b1c7352..0b3255e7b3538 100755
--- a/tools/testing/selftests/netfilter/nft_audit.sh
+++ b/tools/testing/selftests/netfilter/nft_audit.sh
@@ -12,10 +12,11 @@ nft --version >/dev/null 2>&1 || {
 }
 
 logfile=$(mktemp)
+rulefile=$(mktemp)
 echo "logging into $logfile"
 ./audit_logread >"$logfile" &
 logread_pid=$!
-trap 'kill $logread_pid; rm -f $logfile' EXIT
+trap 'kill $logread_pid; rm -f $logfile $rulefile' EXIT
 exec 3<"$logfile"
 
 do_test() { # (cmd, log)
@@ -26,12 +27,14 @@ do_test() { # (cmd, log)
 	res=$(diff -a -u <(echo "$2") - <&3)
 	[ $? -eq 0 ] && { echo "OK"; return; }
 	echo "FAIL"
-	echo "$res"
-	((RC++))
+	grep -v '^\(---\|+++\|@@\)' <<< "$res"
+	((RC--))
 }
 
 nft flush ruleset
 
+# adding tables, chains and rules
+
 for table in t1 t2; do
 	do_test "nft add table $table" \
 	"table=$table family=2 entries=1 op=nft_register_table"
@@ -62,6 +65,28 @@ for table in t1 t2; do
 	"table=$table family=2 entries=6 op=nft_register_rule"
 done
 
+for ((i = 0; i < 500; i++)); do
+	echo "add rule t2 c3 counter accept comment \"rule $i\""
+done >$rulefile
+do_test "nft -f $rulefile" \
+'table=t2 family=2 entries=500 op=nft_register_rule'
+
+# adding sets and elements
+
+settype='type inet_service; counter'
+setelem='{ 22, 80, 443 }'
+setblock="{ $settype; elements = $setelem; }"
+do_test "nft add set t1 s $setblock" \
+"table=t1 family=2 entries=4 op=nft_register_set"
+
+do_test "nft add set t1 s2 $setblock; add set t1 s3 { $settype; }" \
+"table=t1 family=2 entries=5 op=nft_register_set"
+
+do_test "nft add element t1 s3 $setelem" \
+"table=t1 family=2 entries=3 op=nft_register_setelem"
+
+# resetting rules
+
 do_test 'nft reset rules t1 c2' \
 'table=t1 family=2 entries=3 op=nft_reset_rule'
 
@@ -70,19 +95,6 @@ do_test 'nft reset rules table t1' \
 table=t1 family=2 entries=3 op=nft_reset_rule
 table=t1 family=2 entries=3 op=nft_reset_rule'
 
-do_test 'nft reset rules' \
-'table=t1 family=2 entries=3 op=nft_reset_rule
-table=t1 family=2 entries=3 op=nft_reset_rule
-table=t1 family=2 entries=3 op=nft_reset_rule
-table=t2 family=2 entries=3 op=nft_reset_rule
-table=t2 family=2 entries=3 op=nft_reset_rule
-table=t2 family=2 entries=3 op=nft_reset_rule'
-
-for ((i = 0; i < 500; i++)); do
-	echo "add rule t2 c3 counter accept comment \"rule $i\""
-done | do_test 'nft -f -' \
-'table=t2 family=2 entries=500 op=nft_register_rule'
-
 do_test 'nft reset rules t2 c3' \
 'table=t2 family=2 entries=189 op=nft_reset_rule
 table=t2 family=2 entries=188 op=nft_reset_rule
@@ -105,4 +117,57 @@ table=t2 family=2 entries=180 op=nft_reset_rule
 table=t2 family=2 entries=188 op=nft_reset_rule
 table=t2 family=2 entries=135 op=nft_reset_rule'
 
+# resetting sets and elements
+
+elem=(22 ,80 ,443)
+relem=""
+for i in {1..3}; do
+	relem+="${elem[((i - 1))]}"
+	do_test "nft reset element t1 s { $relem }" \
+	"table=t1 family=2 entries=$i op=nft_reset_setelem"
+done
+
+do_test 'nft reset set t1 s' \
+'table=t1 family=2 entries=3 op=nft_reset_setelem'
+
+# deleting rules
+
+readarray -t handles < <(nft -a list chain t1 c1 | \
+			 sed -n 's/.*counter.* handle \(.*\)$/\1/p')
+
+do_test "nft delete rule t1 c1 handle ${handles[0]}" \
+'table=t1 family=2 entries=1 op=nft_unregister_rule'
+
+cmd='delete rule t1 c1 handle'
+do_test "nft $cmd ${handles[1]}; $cmd ${handles[2]}" \
+'table=t1 family=2 entries=2 op=nft_unregister_rule'
+
+do_test 'nft flush chain t1 c2' \
+'table=t1 family=2 entries=3 op=nft_unregister_rule'
+
+do_test 'nft flush table t2' \
+'table=t2 family=2 entries=509 op=nft_unregister_rule'
+
+# deleting chains
+
+do_test 'nft delete chain t2 c2' \
+'table=t2 family=2 entries=1 op=nft_unregister_chain'
+
+# deleting sets and elements
+
+do_test 'nft delete element t1 s { 22 }' \
+'table=t1 family=2 entries=1 op=nft_unregister_setelem'
+
+do_test 'nft delete element t1 s { 80, 443 }' \
+'table=t1 family=2 entries=2 op=nft_unregister_setelem'
+
+do_test 'nft flush set t1 s2' \
+'table=t1 family=2 entries=3 op=nft_unregister_setelem'
+
+do_test 'nft delete set t1 s2' \
+'table=t1 family=2 entries=1 op=nft_unregister_set'
+
+do_test 'nft delete set t1 s3' \
+'table=t1 family=2 entries=1 op=nft_unregister_set'
+
 exit $RC
-- 
2.40.1



