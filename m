Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8429D9443
	for <patches@lists.linux.dev>; Sun, 13 Aug 2023 21:27:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DCC3C433C7;
	Sun, 13 Aug 2023 21:27:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691962071;
	bh=IXazafFHrKIZ56Cc5iqDPulswwyXb2g5Q7ayV5vJOQQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eP8YCkspWmoRM0ngn4B69J/5MUixzbU3gbR2RFj9jH/a6sqOfL205FlUBROMTbGXA
	 CzP3g8ZZ7dCfe9g2SpkSmKYYJa9hnhjNCIzuq/s9WVc1nZTM+4WLbOQaif96c+43B+
	 4q8WTtRBTxdi6nBmUTLLkcSs58kCkvlGaSWXVFCM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mirsad Todorovac <mirsad.todorovac@alu.unizg.hr>,
	Ido Schimmel <idosch@nvidia.com>,
	Petr Machata <petrm@nvidia.com>,
	Hangbin Liu <liuhangbin@gmail.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.4 103/206] selftests: forwarding: bridge_mdb_max: Check iproute2 version
Date: Sun, 13 Aug 2023 23:17:53 +0200
Message-ID: <20230813211728.006160147@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230813211724.969019629@linuxfoundation.org>
References: <20230813211724.969019629@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ido Schimmel <idosch@nvidia.com>

commit 6bdf3d9765f4e0eebfd919e70acc65bce5daa9b9 upstream.

The selftest relies on iproute2 changes present in version 6.3, but the
test does not check for it, resulting in errors:

 # ./bridge_mdb_max.sh
  INFO: 802.1d tests
  TEST: cfg4: port: ngroups reporting                                 [FAIL]
          Number of groups was null, now is null, but 5 expected
  TEST: ctl4: port: ngroups reporting                                 [FAIL]
          Number of groups was null, now is null, but 5 expected
  TEST: cfg6: port: ngroups reporting                                 [FAIL]
          Number of groups was null, now is null, but 5 expected
  [...]

Fix by skipping the test if iproute2 is too old.

Fixes: 3446dcd7df05 ("selftests: forwarding: bridge_mdb_max: Add a new selftest")
Reported-by: Mirsad Todorovac <mirsad.todorovac@alu.unizg.hr>
Closes: https://lore.kernel.org/netdev/6b04b2ba-2372-6f6b-3ac8-b7cba1cfae83@alu.unizg.hr/
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Tested-by: Mirsad Todorovac <mirsad.todorovac@alu.unizg.hr>
Reviewed-by: Hangbin Liu <liuhangbin@gmail.com>
Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
Link: https://lore.kernel.org/r/20230808141503.4060661-5-idosch@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/forwarding/bridge_mdb_max.sh | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/tools/testing/selftests/net/forwarding/bridge_mdb_max.sh b/tools/testing/selftests/net/forwarding/bridge_mdb_max.sh
index ae255b662ba3..fa762b716288 100755
--- a/tools/testing/selftests/net/forwarding/bridge_mdb_max.sh
+++ b/tools/testing/selftests/net/forwarding/bridge_mdb_max.sh
@@ -1328,6 +1328,11 @@ test_8021qvs()
 	switch_destroy
 }
 
+if ! bridge link help 2>&1 | grep -q "mcast_max_groups"; then
+	echo "SKIP: iproute2 too old, missing bridge \"mcast_max_groups\" support"
+	exit $ksft_skip
+fi
+
 trap cleanup EXIT
 
 setup_prepare
-- 
2.41.0



