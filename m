Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E4A826A1C8;
	Tue,  8 Apr 2025 12:26:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115193; cv=none; b=bceu/jtnlP1/fTCG1lZFIlhXk/xKYOK3oEs/39WbUH1yM+mKas9zDoLBY/GjDamggXtuk4p9pDnK4gvSjpiRN297wAY7ukKzkeVPsLmSeaur+mOj6BA0u1z7ZDoeX+/jtifcN2ZHreqOtn5SBNo8odlibaVy5xPlmB/v2Zcr1dM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115193; c=relaxed/simple;
	bh=21RHF9vUadITS+CjLvJbHnLUuTWt/cehDAZTH4702Ms=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y8gsYSbd4Ke1+23z67la5egJ9Uj/z1cGHiEykAjZN5IOQfMHBijpPmlk/D8Prs5kj0gjTqqmEU6PDFy5fxbDgP4MUxkW+rM5dbg6Lqx3LcK2kzUZB7qhd1s5HdiVsYSQFri8Z/QixnhBYnl+ltL/tGSKGUfWSUONMr9CM42KvBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jrG2Usn5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jrG2Usn5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0057EC4CEE5;
	Tue,  8 Apr 2025 12:26:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115193;
	bh=21RHF9vUadITS+CjLvJbHnLUuTWt/cehDAZTH4702Ms=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jrG2Usn5TfCQ64fJ+bor18fZ5FfQfr1sEDMVTz4YxvgZK6cfMldXu+B8gcLH3ZNST
	 UIR9Z/TQmUBgKUglCDHX4pSAFfl0MRuJwDfvwDqI8cLYqkyC7Nw4T12cwogmsMP14H
	 5eGJcul5OSGkHKfu0pouWyzGT/m9OH/JVhbEfrcQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 345/499] selftests: netfilter: skip br_netfilter queue tests if kernel is tainted
Date: Tue,  8 Apr 2025 12:49:17 +0200
Message-ID: <20250408104859.828613830@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

[ Upstream commit c21b02fd9cbf15aed6e32c89e0fd70070281e3d1 ]

These scripts fail if the kernel is tainted which leads to wrong test
failure reports in CI environments when an unrelated test triggers some
splat.

Check taint state at start of script and SKIP if its already dodgy.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/netfilter/br_netfilter.sh      | 7 +++++++
 .../testing/selftests/net/netfilter/br_netfilter_queue.sh  | 7 +++++++
 tools/testing/selftests/net/netfilter/nft_queue.sh         | 1 +
 3 files changed, 15 insertions(+)

diff --git a/tools/testing/selftests/net/netfilter/br_netfilter.sh b/tools/testing/selftests/net/netfilter/br_netfilter.sh
index c28379a965d83..1559ba275105e 100755
--- a/tools/testing/selftests/net/netfilter/br_netfilter.sh
+++ b/tools/testing/selftests/net/netfilter/br_netfilter.sh
@@ -13,6 +13,12 @@ source lib.sh
 
 checktool "nft --version" "run test without nft tool"
 
+read t < /proc/sys/kernel/tainted
+if [ "$t" -ne 0 ];then
+	echo SKIP: kernel is tainted
+	exit $ksft_skip
+fi
+
 cleanup() {
 	cleanup_all_ns
 }
@@ -165,6 +171,7 @@ if [ "$t" -eq 0 ];then
 	echo PASS: kernel not tainted
 else
 	echo ERROR: kernel is tainted
+	dmesg
 	ret=1
 fi
 
diff --git a/tools/testing/selftests/net/netfilter/br_netfilter_queue.sh b/tools/testing/selftests/net/netfilter/br_netfilter_queue.sh
index 6a764d70ab06f..4788641717d93 100755
--- a/tools/testing/selftests/net/netfilter/br_netfilter_queue.sh
+++ b/tools/testing/selftests/net/netfilter/br_netfilter_queue.sh
@@ -4,6 +4,12 @@ source lib.sh
 
 checktool "nft --version" "run test without nft tool"
 
+read t < /proc/sys/kernel/tainted
+if [ "$t" -ne 0 ];then
+	echo SKIP: kernel is tainted
+	exit $ksft_skip
+fi
+
 cleanup() {
 	cleanup_all_ns
 }
@@ -72,6 +78,7 @@ if [ "$t" -eq 0 ];then
 	echo PASS: kernel not tainted
 else
 	echo ERROR: kernel is tainted
+	dmesg
 	exit 1
 fi
 
diff --git a/tools/testing/selftests/net/netfilter/nft_queue.sh b/tools/testing/selftests/net/netfilter/nft_queue.sh
index 785e3875a6da4..784d1b46912b0 100755
--- a/tools/testing/selftests/net/netfilter/nft_queue.sh
+++ b/tools/testing/selftests/net/netfilter/nft_queue.sh
@@ -593,6 +593,7 @@ EOF
 		echo "PASS: queue program exiting while packets queued"
 	else
 		echo "TAINT: queue program exiting while packets queued"
+		dmesg
 		ret=1
 	fi
 }
-- 
2.39.5



