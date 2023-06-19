Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8904AD26
	for <patches@lists.linux.dev>; Mon, 19 Jun 2023 10:50:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BAF6C433C0;
	Mon, 19 Jun 2023 10:50:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687171803;
	bh=McbMLBXb1zWa2kv9l4Q/ho1gDz0d6auu5uWwDs9LbZs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wCobeu8LHJl/2Idn6zU2vOeKiCDrBZl8lEysGKuv3DTpNcHMauAqWcyYUbtgTjCwH
	 6eVFmiyfQmKOQ0np+fI/gkHeFD2Rzm6mvFtTAZiknjIvkCLCy3KaESyreQbbalxAjC
	 3Us1zgyZXjBZMouNPPfvyHabHlURh7aQqyc8XUDw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vlad Buslov <vladbu@nvidia.com>,
	Pedro Tammela <pctammela@mojatatu.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 138/166] selftests/tc-testing: Fix SFB db test
Date: Mon, 19 Jun 2023 12:30:15 +0200
Message-ID: <20230619102201.461062214@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230619102154.568541872@linuxfoundation.org>
References: <20230619102154.568541872@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Vlad Buslov <vladbu@nvidia.com>

[ Upstream commit b39d8c41c7a8336ce85c376b5d4906089524a0ae ]

Setting very small value of db like 10ms introduces rounding errors when
converting to/from jiffies on some kernel configs. For example, on 250hz
the actual value will be set to 12ms which causes the test to fail:

 # $ sudo ./tdc.py  -d eth2 -e 3410
 #  -- ns/SubPlugin.__init__
 # Test 3410: Create SFB with db setting
 #
 # All test results:
 #
 # 1..1
 # not ok 1 3410 - Create SFB with db setting
 #         Could not match regex pattern. Verify command output:
 # qdisc sfb 1: root refcnt 2 rehash 600s db 12ms limit 1000p max 25p target 20p increment 0.000503548 decrement 4.57771e-05 penalty_rate 10pps penalty_burst 20p

Set the value to 100ms instead which currently seem to work on 100hz,
250hz, 300hz and 1000hz kernel configs.

Fixes: 6ad92dc56fca ("selftests/tc-testing: add selftests for sfb qdisc")
Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Reviewed-by: Pedro Tammela <pctammela@mojatatu.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/tc-testing/tc-tests/qdiscs/sfb.json | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/tc-testing/tc-tests/qdiscs/sfb.json b/tools/testing/selftests/tc-testing/tc-tests/qdiscs/sfb.json
index ba2f5e79cdbfe..e21c7f22c6d4c 100644
--- a/tools/testing/selftests/tc-testing/tc-tests/qdiscs/sfb.json
+++ b/tools/testing/selftests/tc-testing/tc-tests/qdiscs/sfb.json
@@ -58,10 +58,10 @@
         "setup": [
             "$IP link add dev $DUMMY type dummy || /bin/true"
         ],
-        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root sfb db 10",
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root sfb db 100",
         "expExitCode": "0",
         "verifyCmd": "$TC qdisc show dev $DUMMY",
-        "matchPattern": "qdisc sfb 1: root refcnt [0-9]+ rehash 600s db 10ms",
+        "matchPattern": "qdisc sfb 1: root refcnt [0-9]+ rehash 600s db 100ms",
         "matchCount": "1",
         "teardown": [
             "$TC qdisc del dev $DUMMY handle 1: root",
-- 
2.39.2



