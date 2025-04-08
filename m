Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD107277811;
	Tue,  8 Apr 2025 12:54:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116863; cv=none; b=s2IdIYjBh9Enlt4ED5xkjYVJNsxnInEzXbBI4F51BoBp/FmMuu90pm6UHwKR5HAjWxpzPW+D6nMeYY4qlY/FCWz7LoWZfOwrcuEoCHCNgfmGJfpWBnrbpE7qv7mfk6R7/BbYBW2JiRTXAV3toDlXEb/lg9MZgov4wldVkc89URM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116863; c=relaxed/simple;
	bh=KgDoIgwA20ge0xDo+3MHfDKLdCarOCGcCUZQTeP/GWY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QLmPPZ07CRMmzNSbQf6rQLSGlKnhNi/9SVc5D3l1r5ICLhBl51LUjV/3uKs6UUY6YJYg2PLVOzmhRpnWvdA9BAuQeGGN19Gu1kL9w6trvB8meJ4CFD7fvSQ9ks808naHU9X8R+GYAE9zZtJp7P2FpwhmK/jacZOAgKOsE7E7WvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ATTQ3EBJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ATTQ3EBJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5C0DC4CEE5;
	Tue,  8 Apr 2025 12:54:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116862;
	bh=KgDoIgwA20ge0xDo+3MHfDKLdCarOCGcCUZQTeP/GWY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ATTQ3EBJnRJsv4Sh7beOC3mU5bYGiCVx9uYidbYfLs8K2hOhXmGZx+B2vlzUieA85
	 5RD8vIthuETIdNIllcvAep+OL0mfJj3lnRj8LpTNs86ScBGoTTAgNlOYx/5rNeQ3p3
	 8DGZyYQCwDUFs8SF4zhBFAwRv54m5RFouJgEzD/g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 295/423] selftests: netfilter: skip br_netfilter queue tests if kernel is tainted
Date: Tue,  8 Apr 2025 12:50:21 +0200
Message-ID: <20250408104852.659725137@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index a9d109fcc15c2..00fe1a6c1f30c 100755
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



