Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84AAE1DF72E;
	Tue,  8 Oct 2024 13:12:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728393127; cv=none; b=BwelO6c0WehmdND3OAEDDooR8FbKytJI1bp1BysK8frogTwWgMDiv8Eog8Aj9UptrPnSd1xqe6h3bQd2DejT8A4PHad3yE9BXYUkbHwtJavOhLN0H1wtsmtXai66nk9yvVYiZkthR/BKAOcVCAlTTNVcUoQF/XZaKVStudQEqKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728393127; c=relaxed/simple;
	bh=5F8crIyGLy7jEN3SXjCGziNt2lut2zNA8iopRPYL+Pg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CgG9PLPqU/mbbj2lwMz26OrO0Rq6Kmogh7MavCIIBRISq9RpReoWvM7ObkYKmzZq9f23imb+hrdNbVdYJZBaFvmwuiTFSoi+eFWp0nlF0u4iqZVbt+Dqp5wfcGqzflqGzog6vkRkZHJB4Usfn87SdBrvmouX0hb1W/WirYCTxkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d5IWvp0Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d5IWvp0Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AD45C4CEC7;
	Tue,  8 Oct 2024 13:12:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728393127;
	bh=5F8crIyGLy7jEN3SXjCGziNt2lut2zNA8iopRPYL+Pg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d5IWvp0YAVl8xwPsUOIz5w7Rqsw1L6P7gDkHK/X90Z3bim17eK7m1TnFaSVFOlVyv
	 9KWZ3A8lOXfEasGyv42WhN5MjiJ80YvgFlvCJYt4JGcW6jR5RvDfbYw94uZptgEJ2/
	 KCGO0Rdq8TJUjFN6kdUHPfnDX+QcqKPnY1Ga4v9s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 020/386] selftests: netfilter: Fix nft_audit.sh for newer nft binaries
Date: Tue,  8 Oct 2024 14:04:25 +0200
Message-ID: <20241008115630.271035865@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
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

From: Phil Sutter <phil@nwl.cc>

[ Upstream commit 8a89015644513ef69193a037eb966f2d55fe385a ]

As a side-effect of nftables' commit dbff26bfba833 ("cache: consolidate
reset command"), audit logs changed when more objects were reset than
fit into a single netlink message.

Since the objects' distribution in netlink messages is not relevant,
implement a summarizing function which combines repeated audit logs into
a single one with summed up 'entries=' value.

Fixes: 203bb9d39866 ("selftests: netfilter: Extend nft_audit.sh")
Signed-off-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../testing/selftests/netfilter/nft_audit.sh  | 57 ++++++++++---------
 1 file changed, 29 insertions(+), 28 deletions(-)

diff --git a/tools/testing/selftests/netfilter/nft_audit.sh b/tools/testing/selftests/netfilter/nft_audit.sh
index 99ed5bd6e8402..e4717444d38e7 100755
--- a/tools/testing/selftests/netfilter/nft_audit.sh
+++ b/tools/testing/selftests/netfilter/nft_audit.sh
@@ -25,12 +25,31 @@ logread_pid=$!
 trap 'kill $logread_pid; rm -f $logfile $rulefile' EXIT
 exec 3<"$logfile"
 
+lsplit='s/^\(.*\) entries=\([^ ]*\) \(.*\)$/pfx="\1"\nval="\2"\nsfx="\3"/'
+summarize_logs() {
+	sum=0
+	while read line; do
+		eval $(sed "$lsplit" <<< "$line")
+		[[ $sum -gt 0 ]] && {
+			[[ "$pfx $sfx" == "$tpfx $tsfx" ]] && {
+				let "sum += val"
+				continue
+			}
+			echo "$tpfx entries=$sum $tsfx"
+		}
+		tpfx="$pfx"
+		tsfx="$sfx"
+		sum=$val
+	done
+	echo "$tpfx entries=$sum $tsfx"
+}
+
 do_test() { # (cmd, log)
 	echo -n "testing for cmd: $1 ... "
 	cat <&3 >/dev/null
 	$1 >/dev/null || exit 1
 	sleep 0.1
-	res=$(diff -a -u <(echo "$2") - <&3)
+	res=$(diff -a -u <(echo "$2") <(summarize_logs <&3))
 	[ $? -eq 0 ] && { echo "OK"; return; }
 	echo "FAIL"
 	grep -v '^\(---\|+++\|@@\)' <<< "$res"
@@ -129,31 +148,17 @@ do_test 'nft reset rules t1 c2' \
 'table=t1 family=2 entries=3 op=nft_reset_rule'
 
 do_test 'nft reset rules table t1' \
-'table=t1 family=2 entries=3 op=nft_reset_rule
-table=t1 family=2 entries=3 op=nft_reset_rule
-table=t1 family=2 entries=3 op=nft_reset_rule'
+'table=t1 family=2 entries=9 op=nft_reset_rule'
 
 do_test 'nft reset rules t2 c3' \
-'table=t2 family=2 entries=189 op=nft_reset_rule
-table=t2 family=2 entries=188 op=nft_reset_rule
-table=t2 family=2 entries=126 op=nft_reset_rule'
+'table=t2 family=2 entries=503 op=nft_reset_rule'
 
 do_test 'nft reset rules t2' \
-'table=t2 family=2 entries=3 op=nft_reset_rule
-table=t2 family=2 entries=3 op=nft_reset_rule
-table=t2 family=2 entries=186 op=nft_reset_rule
-table=t2 family=2 entries=188 op=nft_reset_rule
-table=t2 family=2 entries=129 op=nft_reset_rule'
+'table=t2 family=2 entries=509 op=nft_reset_rule'
 
 do_test 'nft reset rules' \
-'table=t1 family=2 entries=3 op=nft_reset_rule
-table=t1 family=2 entries=3 op=nft_reset_rule
-table=t1 family=2 entries=3 op=nft_reset_rule
-table=t2 family=2 entries=3 op=nft_reset_rule
-table=t2 family=2 entries=3 op=nft_reset_rule
-table=t2 family=2 entries=180 op=nft_reset_rule
-table=t2 family=2 entries=188 op=nft_reset_rule
-table=t2 family=2 entries=135 op=nft_reset_rule'
+'table=t1 family=2 entries=9 op=nft_reset_rule
+table=t2 family=2 entries=509 op=nft_reset_rule'
 
 # resetting sets and elements
 
@@ -177,13 +182,11 @@ do_test 'nft reset counters t1' \
 'table=t1 family=2 entries=1 op=nft_reset_obj'
 
 do_test 'nft reset counters t2' \
-'table=t2 family=2 entries=342 op=nft_reset_obj
-table=t2 family=2 entries=158 op=nft_reset_obj'
+'table=t2 family=2 entries=500 op=nft_reset_obj'
 
 do_test 'nft reset counters' \
 'table=t1 family=2 entries=1 op=nft_reset_obj
-table=t2 family=2 entries=341 op=nft_reset_obj
-table=t2 family=2 entries=159 op=nft_reset_obj'
+table=t2 family=2 entries=500 op=nft_reset_obj'
 
 # resetting quotas
 
@@ -194,13 +197,11 @@ do_test 'nft reset quotas t1' \
 'table=t1 family=2 entries=1 op=nft_reset_obj'
 
 do_test 'nft reset quotas t2' \
-'table=t2 family=2 entries=315 op=nft_reset_obj
-table=t2 family=2 entries=185 op=nft_reset_obj'
+'table=t2 family=2 entries=500 op=nft_reset_obj'
 
 do_test 'nft reset quotas' \
 'table=t1 family=2 entries=1 op=nft_reset_obj
-table=t2 family=2 entries=314 op=nft_reset_obj
-table=t2 family=2 entries=186 op=nft_reset_obj'
+table=t2 family=2 entries=500 op=nft_reset_obj'
 
 # deleting rules
 
-- 
2.43.0



