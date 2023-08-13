Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34BC19443
	for <patches@lists.linux.dev>; Sun, 13 Aug 2023 21:27:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAFE2C433C8;
	Sun, 13 Aug 2023 21:27:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691962074;
	bh=SDZ8x7raN/AlSsbkys9k4iVMnXCk1dURpQpzzmKmKl8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Oh9Fe2HnifC92YUb9U3Q3ea2DWR/vldGIDY3vBvFZnIK93yhVy7/l9nPCpoq9ByCU
	 EshXSUiEy5hlA76AdMMReD9OFzicNWh1YuXZdDYd2Ydmn6W79QICj9mn+udyiS1I7G
	 vq2l61gpnop21c3X5IsEuord59+ooKLTkA98ohas=
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
Subject: [PATCH 6.4 104/206] selftests: forwarding: bridge_mdb: Check iproute2 version
Date: Sun, 13 Aug 2023 23:17:54 +0200
Message-ID: <20230813211728.034021166@linuxfoundation.org>
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

commit ab2eda04e2c2116910b9d77ccc82e727efa71d49 upstream.

The selftest relies on iproute2 changes present in version 6.3, but the
test does not check for it, resulting in error:

 # ./bridge_mdb.sh

 INFO: # Host entries configuration tests
 TEST: Common host entries configuration tests (IPv4)                [FAIL]
         Managed to add IPv4 host entry with a filter mode
 TEST: Common host entries configuration tests (IPv6)                [FAIL]
         Managed to add IPv6 host entry with a filter mode
 TEST: Common host entries configuration tests (L2)                  [FAIL]
         Managed to add L2 host entry with a filter mode

 INFO: # Port group entries configuration tests - (*, G)
 Command "replace" is unknown, try "bridge mdb help".
 [...]

Fix by skipping the test if iproute2 is too old.

Fixes: b6d00da08610 ("selftests: forwarding: Add bridge MDB test")
Reported-by: Mirsad Todorovac <mirsad.todorovac@alu.unizg.hr>
Closes: https://lore.kernel.org/netdev/6b04b2ba-2372-6f6b-3ac8-b7cba1cfae83@alu.unizg.hr/
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Tested-by: Mirsad Todorovac <mirsad.todorovac@alu.unizg.hr>
Reviewed-by: Hangbin Liu <liuhangbin@gmail.com>
Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
Link: https://lore.kernel.org/r/20230808141503.4060661-4-idosch@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/forwarding/bridge_mdb.sh | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/tools/testing/selftests/net/forwarding/bridge_mdb.sh b/tools/testing/selftests/net/forwarding/bridge_mdb.sh
index ae3f9462a2b6..6f830b5f03c9 100755
--- a/tools/testing/selftests/net/forwarding/bridge_mdb.sh
+++ b/tools/testing/selftests/net/forwarding/bridge_mdb.sh
@@ -1206,6 +1206,11 @@ ctrl_test()
 	ctrl_mldv2_is_in_test
 }
 
+if ! bridge mdb help 2>&1 | grep -q "replace"; then
+	echo "SKIP: iproute2 too old, missing bridge mdb replace support"
+	exit $ksft_skip
+fi
+
 trap cleanup EXIT
 
 setup_prepare
-- 
2.41.0



