Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5A279443
	for <patches@lists.linux.dev>; Sun, 13 Aug 2023 21:27:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 613FEC433C8;
	Sun, 13 Aug 2023 21:27:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691962068;
	bh=rUjMNLyauspD1fsMyJIM0dhznTVXeLRmDEHGHbdeLEU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U11SAU6FL2SS3RwdqoesW9b9M+7vj0s5mPypP+p2pQLysnGSY3zLmrENeEAqH57N6
	 kMfVQwOeJR29iUXeKuhC7cb9mub5KAPP6NNT4zCPE2Ou5EgoMLVknl9Pc7MvEsYNNi
	 oaHjlh/XI2CzTLZaUOZHKrFh/utOwhsNk3PdhJjw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mirsad Todorovac <mirsad.todorovac@alu.unizg.hr>,
	Ido Schimmel <idosch@nvidia.com>,
	Hangbin Liu <liuhangbin@gmail.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.4 102/206] selftests: forwarding: ethtool_mm: Skip when MAC Merge is not supported
Date: Sun, 13 Aug 2023 23:17:52 +0200
Message-ID: <20230813211727.977662507@linuxfoundation.org>
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

commit 23fb886a1ced6f885ddd541cc86d45c415ce705c upstream.

MAC Merge cannot be tested with veth pairs, resulting in failures:

 # ./ethtool_mm.sh
 [...]
 TEST: Manual configuration with verification: swp1 to swp2          [FAIL]
         Verification did not succeed

Fix by skipping the test when the interfaces do not support MAC Merge.

Fixes: e6991384ace5 ("selftests: forwarding: add a test for MAC Merge layer")
Reported-by: Mirsad Todorovac <mirsad.todorovac@alu.unizg.hr>
Closes: https://lore.kernel.org/netdev/adc5e40d-d040-a65e-eb26-edf47dac5b02@alu.unizg.hr/
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Hangbin Liu <liuhangbin@gmail.com>
Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
Link: https://lore.kernel.org/r/20230808141503.4060661-11-idosch@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 .../selftests/net/forwarding/ethtool_mm.sh     | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/net/forwarding/ethtool_mm.sh b/tools/testing/selftests/net/forwarding/ethtool_mm.sh
index c580ad623848..39e736f30322 100755
--- a/tools/testing/selftests/net/forwarding/ethtool_mm.sh
+++ b/tools/testing/selftests/net/forwarding/ethtool_mm.sh
@@ -258,11 +258,6 @@ h2_destroy()
 
 setup_prepare()
 {
-	check_ethtool_mm_support
-	check_tc_fp_support
-	require_command lldptool
-	bail_on_lldpad "autoconfigure the MAC Merge layer" "configure it manually"
-
 	h1=${NETIFS[p1]}
 	h2=${NETIFS[p2]}
 
@@ -278,6 +273,19 @@ cleanup()
 	h1_destroy
 }
 
+check_ethtool_mm_support
+check_tc_fp_support
+require_command lldptool
+bail_on_lldpad "autoconfigure the MAC Merge layer" "configure it manually"
+
+for netif in ${NETIFS[@]}; do
+	ethtool --show-mm $netif 2>&1 &> /dev/null
+	if [[ $? -ne 0 ]]; then
+		echo "SKIP: $netif does not support MAC Merge"
+		exit $ksft_skip
+	fi
+done
+
 trap cleanup EXIT
 
 setup_prepare
-- 
2.41.0



