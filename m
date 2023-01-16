Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AA8833EC
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 15:57:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90FF0C433EF;
	Mon, 16 Jan 2023 15:57:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673884659;
	bh=gwXibOn/UarruZHKukZW+4kIqqw6P6zzm9aBHYHxeDY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WXQIh9e9w5FRiB5Dvhpw9FCgZ6f9V1UWreyH+5CojUBGxuXZ1ykciXYX3ZiH+OwTT
	 drj9/mw4P7zHPwvNuotqdEk05EAFFvzvmcHpVtm9t7vcCNVSu3jupFtgQuSrhG5gYa
	 f/97BhC3E5CDLM3wORWlwjLuk7u0m3rDfXmMY2PU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 6.1 090/183] selftests: netfilter: fix transaction test script timeout handling
Date: Mon, 16 Jan 2023 16:50:13 +0100
Message-Id: <20230116154807.225847175@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154803.321528435@linuxfoundation.org>
References: <20230116154803.321528435@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

commit c273289fac370b6488757236cd62cc2cf04830b7 upstream.

The kselftest framework uses a default timeout of 45 seconds for
all test scripts.

Increase the timeout to two minutes for the netfilter tests, this
should hopefully be enough,

Make sure that, should the script be canceled, the net namespace and
the spawned ping instances are removed.

Fixes: 25d8bcedbf43 ("selftests: add script to stress-test nft packet path vs. control plane")
Reported-by: Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
Signed-off-by: Florian Westphal <fw@strlen.de>
Tested-by: Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/netfilter/nft_trans_stress.sh |   16 +++++++++-------
 tools/testing/selftests/netfilter/settings            |    1 +
 2 files changed, 10 insertions(+), 7 deletions(-)
 create mode 100644 tools/testing/selftests/netfilter/settings

--- a/tools/testing/selftests/netfilter/nft_trans_stress.sh
+++ b/tools/testing/selftests/netfilter/nft_trans_stress.sh
@@ -10,12 +10,20 @@
 ksft_skip=4
 
 testns=testns-$(mktemp -u "XXXXXXXX")
+tmp=""
 
 tables="foo bar baz quux"
 global_ret=0
 eret=0
 lret=0
 
+cleanup() {
+	ip netns pids "$testns" | xargs kill 2>/dev/null
+	ip netns del "$testns"
+
+	rm -f "$tmp"
+}
+
 check_result()
 {
 	local r=$1
@@ -43,6 +51,7 @@ if [ $? -ne 0 ];then
 	exit $ksft_skip
 fi
 
+trap cleanup EXIT
 tmp=$(mktemp)
 
 for table in $tables; do
@@ -139,11 +148,4 @@ done
 
 check_result $lret "add/delete with nftrace enabled"
 
-pkill -9 ping
-
-wait
-
-rm -f "$tmp"
-ip netns del "$testns"
-
 exit $global_ret
--- /dev/null
+++ b/tools/testing/selftests/netfilter/settings
@@ -0,0 +1 @@
+timeout=120


