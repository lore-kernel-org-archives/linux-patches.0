Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E635F151CE9;
	Tue, 20 Feb 2024 21:28:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464497; cv=none; b=tjuEOP0sG2CtbEyaIhn1+WUpywg+Dh4Fd/vbqsjFiWpvwe01LMGSWNEUcuqpzb9jbLG11lMbXbMiYye2cf+MPakScP0RzRteWiXi3mRmsMf73glTFzpwyv3quZTSzbUVzQ2RyK4a0G/XyZZ/GEbRs17QlTHf3WPlh19wVqzka+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464497; c=relaxed/simple;
	bh=XRJL2hMnxPkhHjb9ChkLNc+Z1aq+oeBKqb+I00lWzG8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uInxWjoe4wdUyfUJUWmEdRuibvM26ZzCgJ6GkdwEhG5Sack4qvJTAmxQzGGpOKQaj75iYXGe20eN6HEIg5BcZACk0FobfnqvzPt2Z7cjG8gPlt2BRYBhH39rpLd/tHI5NpzPwHsvtAy7Nj+O6PPf1LqreejJpDMp8r5KMiUvVxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cm4Mw2we; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cm4Mw2we"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56334C433C7;
	Tue, 20 Feb 2024 21:28:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464496;
	bh=XRJL2hMnxPkhHjb9ChkLNc+Z1aq+oeBKqb+I00lWzG8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cm4Mw2weLnupWnFiFC3eH2pS12Xz4Vnb7xdU0sig05h3VlwF01T9zbcH4Yhsw6UJ2
	 4oLkCdBLoJYMWe2RvKgOgV4KM9VCcVRff+dkV3yG5ateU5AqCxPWCSjqg4gVBZuq9S
	 NwIwKYW0LcY/p72P4mjQivAp0pXgTe2rYh2nCUPI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ido Schimmel <idosch@nvidia.com>,
	Hangbin Liu <liuhangbin@gmail.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 044/309] selftests: forwarding: Fix bridge locked port test flakiness
Date: Tue, 20 Feb 2024 21:53:23 +0100
Message-ID: <20240220205634.562784631@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ido Schimmel <idosch@nvidia.com>

[ Upstream commit f97f1fcc96908c97a240ff6cb4474e155abfa0d7 ]

The redirection test case fails in the netdev CI on debug kernels
because an FDB entry is learned despite the presence of a tc filter that
redirects incoming traffic [1].

I am unable to reproduce the failure locally, but I can see how it can
happen given that learning is first enabled and only then the ingress tc
filter is configured. On debug kernels the time window between these two
operations is longer compared to regular kernels, allowing random
packets to be transmitted and trigger learning.

Fix by reversing the order and configure the ingress tc filter before
enabling learning.

[1]
[...]
 # TEST: Locked port MAB redirect                                      [FAIL]
 # Locked entry created for redirected traffic

Fixes: 38c43a1ce758 ("selftests: forwarding: Add test case for traffic redirection from a locked port")
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Hangbin Liu <liuhangbin@gmail.com>
Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
Link: https://lore.kernel.org/r/20240208155529.1199729-5-idosch@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/forwarding/bridge_locked_port.sh | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/net/forwarding/bridge_locked_port.sh b/tools/testing/selftests/net/forwarding/bridge_locked_port.sh
index 9af9f6964808..c62331b2e006 100755
--- a/tools/testing/selftests/net/forwarding/bridge_locked_port.sh
+++ b/tools/testing/selftests/net/forwarding/bridge_locked_port.sh
@@ -327,10 +327,10 @@ locked_port_mab_redirect()
 	RET=0
 	check_port_mab_support || return 0
 
-	bridge link set dev $swp1 learning on locked on mab on
 	tc qdisc add dev $swp1 clsact
 	tc filter add dev $swp1 ingress protocol all pref 1 handle 101 flower \
 		action mirred egress redirect dev $swp2
+	bridge link set dev $swp1 learning on locked on mab on
 
 	ping_do $h1 192.0.2.2
 	check_err $? "Ping did not work with redirection"
@@ -349,8 +349,8 @@ locked_port_mab_redirect()
 	check_err $? "Locked entry not created after deleting filter"
 
 	bridge fdb del `mac_get $h1` vlan 1 dev $swp1 master
-	tc qdisc del dev $swp1 clsact
 	bridge link set dev $swp1 learning off locked off mab off
+	tc qdisc del dev $swp1 clsact
 
 	log_test "Locked port MAB redirect"
 }
-- 
2.43.0



