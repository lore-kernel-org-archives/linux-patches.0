Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40141338F26;
	Tue, 16 Dec 2025 12:33:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765888410; cv=none; b=J8YA345lODTg3csYPmBdFSCXPdcYx1MsssLo8Ap4nDlrBwuScut09VNxHavjiCHBKb/3Mex0YSOsC4vxV0p14oBjtRYmGYnz4ZKXu+D4+4hnujpBDCIS56P9y++T/ChSMSkuMOQ69L5KVoML3Hmbhr749HXJXawRaPvaDO/0H4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765888410; c=relaxed/simple;
	bh=P6kx2nXwd8IfT6gQcNM778E9XiGlJkiE5WMVG6d/RUI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zcb011Y6XJnRTS6wMeoDWGltGHARqzx27pxzLbqW/7OIoRBqN27cDHpZExlTglFaJN7UGDvBnMk/sj45MP2X7Eqw0Tjs/sk5WJ1Aht5iE7cCiPz4+F/+sb5KJ+qBlImP1ed1YAcV0wJ06vgfQ/W8i0Lafuvt62xd7B9ofHr8Tms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H5UEXUyo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H5UEXUyo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92C04C4CEF1;
	Tue, 16 Dec 2025 12:33:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765888410;
	bh=P6kx2nXwd8IfT6gQcNM778E9XiGlJkiE5WMVG6d/RUI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H5UEXUyo64WSWM2Ulj0U0B9lKTxQebBQ/jGywrznz5nWw7xiv+iRFKwayW1zLwgfe
	 MfOoZtErDCmm221JccxAZUrPsP+apz8v83K7yONRNDNO7WA1C7qkHw8o3j6UfhUVCn
	 e5+CbA3yINPY10NJzDQYrmgafc63eEzXz3+pdFZ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Hangbin Liu <liuhangbin@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 493/614] selftests: bonding: add delay before each xvlan_over_bond connectivity check
Date: Tue, 16 Dec 2025 12:14:20 +0100
Message-ID: <20251216111419.233352274@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hangbin Liu <liuhangbin@gmail.com>

[ Upstream commit 2c28ee720ad14f58eb88a97ec3efe7c5c315ea5d ]

Jakub reported increased flakiness in bond_macvlan_ipvlan.sh on regular
kernel, while the tests consistently pass on a debug kernel. This suggests
a timing-sensitive issue.

To mitigate this, introduce a short sleep before each xvlan_over_bond
connectivity check. The delay helps ensure neighbor and route cache
have fully converged before verifying connectivity.

The sleep interval is kept minimal since check_connection() is invoked
nearly 100 times during the test.

Fixes: 246af950b940 ("selftests: bonding: add macvlan over bond testing")
Reported-by: Jakub Kicinski <kuba@kernel.org>
Closes: https://lore.kernel.org/netdev/20251114082014.750edfad@kernel.org
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Link: https://patch.msgid.link/20251127143310.47740-1-liuhangbin@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../testing/selftests/drivers/net/bonding/bond_macvlan_ipvlan.sh | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/drivers/net/bonding/bond_macvlan_ipvlan.sh b/tools/testing/selftests/drivers/net/bonding/bond_macvlan_ipvlan.sh
index c4711272fe45d..559f300f965aa 100755
--- a/tools/testing/selftests/drivers/net/bonding/bond_macvlan_ipvlan.sh
+++ b/tools/testing/selftests/drivers/net/bonding/bond_macvlan_ipvlan.sh
@@ -30,6 +30,7 @@ check_connection()
 	local message=${3}
 	RET=0
 
+	sleep 0.25
 	ip netns exec ${ns} ping ${target} -c 4 -i 0.1 &>/dev/null
 	check_err $? "ping failed"
 	log_test "${bond_mode}/${xvlan_type}_${xvlan_mode}: ${message}"
-- 
2.51.0



