Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33A8019E98B;
	Mon, 14 Oct 2024 15:33:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919991; cv=none; b=tMRi6W3ZalOKttoQUq73t7x0aG6t3pqsbboNKP8fe0btPZjJHbWH+IizPIUzk9qP1nCh1qnXGQG5tfXpYI0LoE+6EmoTNMzk5haSXrCIkfBWjB3hv3aYPg2Zp6SoH8tm3HcF3NHhCuvzadRL7u/jzNVK6Le3tfheRZJ1PlBzgDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919991; c=relaxed/simple;
	bh=guSAlA79CELeZobNAK1Uv95XAdyaUFnfEIA3TKVAcdc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c9Ze7cR5DYTMYelfpXk165sOGOBu3CxW/NGSWEMK7mqAn1BU9F3o5wBgnguDzDbYeJ1QpzAkXljn+WTuwwz+30DuSNPliar0wV3cFX4Kvk20y4KJHRs3xoRN7KnWYWaXRQuzp/7jVP7CkvnqcK3cQoH1vwzBlopI5CcdCayPrAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O6MZL3Wm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O6MZL3Wm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4ADA7C4CEC3;
	Mon, 14 Oct 2024 15:33:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919990;
	bh=guSAlA79CELeZobNAK1Uv95XAdyaUFnfEIA3TKVAcdc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O6MZL3WmGEKoUb3P2z0gdoHx8mZdc8jOhlTJ+2hKkeyEC17wY2/pg02KMepCN9A+2
	 2u/qQR4ZVIW9lQ+El4CFHHtdfty88bCuoJyswfUuP//7xVIC93O4j61BCDUgoWMtUj
	 br0V6QW+MwxUqtRYSHogeIGrLMSiw6ngd5eEVlwY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hangbin Liu <liuhangbin@gmail.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Kacper Ludwinski <kac.ludwinski@icloud.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 735/798] selftests: net: no_forwarding: fix VID for $swp2 in one_bridge_two_pvids() test
Date: Mon, 14 Oct 2024 16:21:29 +0200
Message-ID: <20241014141246.947410014@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kacper Ludwinski <kac.ludwinski@icloud.com>

[ Upstream commit 9f49d14ec41ce7be647028d7d34dea727af55272 ]

Currently, the second bridge command overwrites the first one.
Fix this by adding this VID to the interface behind $swp2.

The one_bridge_two_pvids() test intends to check that there is no
leakage of traffic between bridge ports which have a single VLAN - the
PVID VLAN.

Because of a typo, port $swp1 is configured with a PVID twice (second
command overwrites first), and $swp2 isn't configured at all (and since
the bridge vlan_default_pvid property is set to 0, this port will not
have a PVID at all, so it will drop all untagged and priority-tagged
traffic).

So, instead of testing the configuration that was intended, we are
testing a different one, where one port has PVID 2 and the other has
no PVID. This incorrect version of the test should also pass, but is
ineffective for its purpose, so fix the typo.

This typo has an impact on results of the test,
potentially leading to wrong conclusions regarding
the functionality of a network device.

The tests results:

TEST: Switch ports in VLAN-aware bridge with different PVIDs:
	Unicast non-IP untagged   [ OK ]
	Multicast non-IP untagged   [ OK ]
	Broadcast non-IP untagged   [ OK ]
	Unicast IPv4 untagged   [ OK ]
	Multicast IPv4 untagged   [ OK ]
	Unicast IPv6 untagged   [ OK ]
	Multicast IPv6 untagged   [ OK ]
	Unicast non-IP VID 1   [ OK ]
	Multicast non-IP VID 1   [ OK ]
	Broadcast non-IP VID 1   [ OK ]
	Unicast IPv4 VID 1   [ OK ]
	Multicast IPv4 VID 1   [ OK ]
	Unicast IPv6 VID 1   [ OK ]
	Multicast IPv6 VID 1   [ OK ]
	Unicast non-IP VID 4094   [ OK ]
	Multicast non-IP VID 4094   [ OK ]
	Broadcast non-IP VID 4094   [ OK ]
	Unicast IPv4 VID 4094   [ OK ]
	Multicast IPv4 VID 4094   [ OK ]
	Unicast IPv6 VID 4094   [ OK ]
	Multicast IPv6 VID 4094   [ OK ]

Fixes: 476a4f05d9b8 ("selftests: forwarding: add a no_forwarding.sh test")
Reviewed-by: Hangbin Liu <liuhangbin@gmail.com>
Reviewed-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Kacper Ludwinski <kac.ludwinski@icloud.com>
Link: https://patch.msgid.link/20241002051016.849-1-kac.ludwinski@icloud.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/forwarding/no_forwarding.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/forwarding/no_forwarding.sh b/tools/testing/selftests/net/forwarding/no_forwarding.sh
index 9e677aa64a06a..694ece9ba3a74 100755
--- a/tools/testing/selftests/net/forwarding/no_forwarding.sh
+++ b/tools/testing/selftests/net/forwarding/no_forwarding.sh
@@ -202,7 +202,7 @@ one_bridge_two_pvids()
 	ip link set $swp2 master br0
 
 	bridge vlan add dev $swp1 vid 1 pvid untagged
-	bridge vlan add dev $swp1 vid 2 pvid untagged
+	bridge vlan add dev $swp2 vid 2 pvid untagged
 
 	run_test "Switch ports in VLAN-aware bridge with different PVIDs"
 
-- 
2.43.0



