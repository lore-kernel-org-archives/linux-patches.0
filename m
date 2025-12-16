Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FA1D338F25;
	Tue, 16 Dec 2025 11:31:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884710; cv=none; b=SkAvypQEYnpiuVhMFUPnnHfjGo1tfeUXKDcoJOfl4yqDuRpXK4KKFGBH39Av87JzGKGMwJkuY0Aj8x9fNEPkCjyTFbIwnRI0w6mHj+mnzTM5N5ZgzXbmt1F76AeYc5kFhGGa1xexqdkg5+4JkBwgix4wqYGcGZaTCRT40kWbv58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884710; c=relaxed/simple;
	bh=dGnYxn3cedpRzfOXW6BCSee+I+LcvXP/Cm/BY2+QbwY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kj4sMYtD/xttM9Kt/RE/yfrmcHAWvXdkDeiiPvWojBtbhyUDPr2Te9hjZKyxsrPi59pKhGrzweSNNDX3+yPtw+aHPmXHOKroBZBwtjnXeMXLSruHue2OdWoiESKBTzYbMQcUZigo535mN0bXoYQS60yWq2O/GEyz165wibOrKq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jm1v+DhT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jm1v+DhT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA44DC4CEF1;
	Tue, 16 Dec 2025 11:31:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884710;
	bh=dGnYxn3cedpRzfOXW6BCSee+I+LcvXP/Cm/BY2+QbwY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jm1v+DhTmI2Y1aoQxKSnV+L6MYHzR37/wzkOY4qzi+oqd7wa5nDzx/aIrytbSv9to
	 NC34D2SQhIeAx/c7bNJWNUS38wLnNcpqTcD9XdaAHxp47MuT5XDMXS0Ux54OI09SEn
	 dGkoHM4Wyn+n0Bc02tOW7ZoeBE3YtO0MUU7sD1DE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Hangbin Liu <liuhangbin@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 274/354] selftests: bonding: add delay before each xvlan_over_bond connectivity check
Date: Tue, 16 Dec 2025 12:14:01 +0100
Message-ID: <20251216111330.842154226@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



