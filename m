Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DE861CF297;
	Tue,  8 Oct 2024 12:14:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728389653; cv=none; b=aYW4FzYEyvA26SAxIcR5yarQtCBn0Ev32tnDBGX+BRdDOlRrZylq0xCbiGobiv6vfS38AzTyAn8kcy9nMaMzl4ZbzvOOVxwv5sNUoocqx2MgtcKZ4EZnHUPvm66fgU4O3bkWM7wLqqv3/njq9/tfk4M/BMM9YulRA2RMF2GFg5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728389653; c=relaxed/simple;
	bh=kuXUmA4UEBsAu+5cQhOuXoLDVEGD231HOlYe4F/fNS4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ImBVKoWUkLPheOITuYVDoTua2xJOcNAlolQygPn3x4246cCLz+hZh7xnQ5aHB/X9zdUzf/Jpa+DETTD/nl+Q08Gi1wvUqeWAKePXEx6q6+86Rlm82YaXdGiHcBtmagHy0Xni2Y6jgNfbxJYlwrdRAugXJPrbOZUcPMSQ5ZN1wks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u8tYQ1ku; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u8tYQ1ku"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F02EC4CECC;
	Tue,  8 Oct 2024 12:14:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728389653;
	bh=kuXUmA4UEBsAu+5cQhOuXoLDVEGD231HOlYe4F/fNS4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u8tYQ1kupDX41ybnjvhPJ7i/6vh6KJcmPI4IT6rVV8RP6T635TcaOa+Up4izt4Pso
	 gBbtlYgCq3IApyB5BhZFz5MN3INFDkSxpTa3xSsaXpe3lNXTlmjFjfPJeit524V/ef
	 geD3uSbrb8I0NAyQuc+lYiu6I3aKFWW1mOPwOZiM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 025/482] selftests: netfilter: Fix nft_audit.sh for newer nft binaries
Date: Tue,  8 Oct 2024 14:01:28 +0200
Message-ID: <20241008115649.289981154@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
 .../selftests/net/netfilter/nft_audit.sh      | 57 ++++++++++---------
 1 file changed, 29 insertions(+), 28 deletions(-)

diff --git a/tools/testing/selftests/net/netfilter/nft_audit.sh b/tools/testing/selftests/net/netfilter/nft_audit.sh
index 902f8114bc80f..87f2b4c725aa0 100755
--- a/tools/testing/selftests/net/netfilter/nft_audit.sh
+++ b/tools/testing/selftests/net/netfilter/nft_audit.sh
@@ -48,12 +48,31 @@ logread_pid=$!
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
@@ -152,31 +171,17 @@ do_test 'nft reset rules t1 c2' \
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
 
@@ -200,13 +205,11 @@ do_test 'nft reset counters t1' \
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
 
@@ -217,13 +220,11 @@ do_test 'nft reset quotas t1' \
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



