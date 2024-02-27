Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EF9413AA50;
	Tue, 27 Feb 2024 13:59:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042388; cv=none; b=RBI/wSn6BYUpBQr5gAyxOV/VKliOj5eIWLqE+17XXM7XGdEr4m47/D5/6D7x82bb7G3BKpgSX/FvETaotN9VeZT/9okU1fHjyTkpm9AgRSBjoQmEjyt7YIn2/zUjKTwdzzK2R680Zbg+5W2/HZ4F4Dng0GqK4AU7IALDtpp9jBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042388; c=relaxed/simple;
	bh=L9F7dL7L9nKaRh8rQvZfkvh9grS71Xssgj1NTWReZdU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PHBssQR4k6APNdFJjZk1EeeT+znGXjmR3Ar1+Dq5Trr5Qw2ytgIJVH9JeFUUO3S7rm/vWdwRbP7Smg6Bs/o39NLUoGTPU+Kodbq7MQn6ITL7mSafKLwQTRx+zVcSsMJDrQdox/tIK1CHnJgqqKk9l8tS+u+QUxw9tlr9XcpWWmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ulSkMbPG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ulSkMbPG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABC86C433C7;
	Tue, 27 Feb 2024 13:59:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042388;
	bh=L9F7dL7L9nKaRh8rQvZfkvh9grS71Xssgj1NTWReZdU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ulSkMbPG9hZn7UUnHcO+5yEkjaA15Xp+6rKTGDzQv3IkAum6qM/uIgdQ31oUhHffi
	 D2PrN5vL2H8HmKFWNTAHesCES6yUh3j9Cl3+VQNv1A6mJI9YY5SUFJTnszgPPUYkFs
	 ACH2OsuIy4awtVbv2pXKjqLjCjNMsoAfVXtxIDb4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hangbin Liu <liuhangbin@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 250/299] selftests: bonding: set active slave to primary eth1 specifically
Date: Tue, 27 Feb 2024 14:26:01 +0100
Message-ID: <20240227131633.770362352@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
References: <20240227131625.847743063@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hangbin Liu <liuhangbin@gmail.com>

[ Upstream commit cd65c48d66920457129584553f217005d09b1edb ]

In bond priority testing, we set the primary interface to eth1 and add
eth0,1,2 to bond in serial. This is OK in normal times. But when in
debug kernel, the bridge port that eth0,1,2 connected would start
slowly (enter blocking, forwarding state), which caused the primary
interface down for a while after enslaving and active slave changed.
Here is a test log from Jakub's debug test[1].

 [  400.399070][   T50] br0: port 1(s0) entered disabled state
 [  400.400168][   T50] br0: port 4(s2) entered disabled state
 [  400.941504][ T2791] bond0: (slave eth0): making interface the new active one
 [  400.942603][ T2791] bond0: (slave eth0): Enslaving as an active interface with an up link
 [  400.943633][ T2766] br0: port 1(s0) entered blocking state
 [  400.944119][ T2766] br0: port 1(s0) entered forwarding state
 [  401.128792][ T2792] bond0: (slave eth1): making interface the new active one
 [  401.130771][ T2792] bond0: (slave eth1): Enslaving as an active interface with an up link
 [  401.131643][   T69] br0: port 2(s1) entered blocking state
 [  401.132067][   T69] br0: port 2(s1) entered forwarding state
 [  401.346201][ T2793] bond0: (slave eth2): Enslaving as a backup interface with an up link
 [  401.348414][   T50] br0: port 4(s2) entered blocking state
 [  401.348857][   T50] br0: port 4(s2) entered forwarding state
 [  401.519669][  T250] bond0: (slave eth0): link status definitely down, disabling slave
 [  401.526522][  T250] bond0: (slave eth1): link status definitely down, disabling slave
 [  401.526986][  T250] bond0: (slave eth2): making interface the new active one
 [  401.629470][  T250] bond0: (slave eth0): link status definitely up
 [  401.630089][  T250] bond0: (slave eth1): link status definitely up
 [...]
 # TEST: prio (active-backup ns_ip6_target primary_reselect 1)         [FAIL]
 # Current active slave is eth2 but not eth1

Fix it by setting active slave to primary slave specifically before
testing.

[1] https://netdev-3.bots.linux.dev/vmksft-bonding-dbg/results/464301/1-bond-options-sh/stdout

Fixes: 481b56e0391e ("selftests: bonding: re-format bond option tests")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/drivers/net/bonding/bond_options.sh | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/selftests/drivers/net/bonding/bond_options.sh b/tools/testing/selftests/drivers/net/bonding/bond_options.sh
index d508486cc0bdc..9a3d3c389dadd 100755
--- a/tools/testing/selftests/drivers/net/bonding/bond_options.sh
+++ b/tools/testing/selftests/drivers/net/bonding/bond_options.sh
@@ -62,6 +62,8 @@ prio_test()
 
 	# create bond
 	bond_reset "${param}"
+	# set active_slave to primary eth1 specifically
+	ip -n ${s_ns} link set bond0 type bond active_slave eth1
 
 	# check bonding member prio value
 	ip -n ${s_ns} link set eth0 type bond_slave prio 0
-- 
2.43.0



