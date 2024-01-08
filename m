Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FBE75101D;
	Mon,  8 Jan 2024 15:38:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AQTvHXzd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50D67C433CC;
	Mon,  8 Jan 2024 15:38:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704728304;
	bh=AcvGbpQEUJI9EFwYf1TtV98YYOjqYcH+2rASszzYVZA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AQTvHXzd1tGM6Tfu9lzsNLdqbM3KAmmOY48RCQtRlpYh7QlnCindpnhDdU2S6KpnS
	 m81s8dXLt1EaFHkCUsOm4hyKSNKPEN7m6g6uNzLMfF+Nl3ct7PvmR24ZqvoiWPZAL3
	 YqVoaKBcy+VDUSVFrAKEw/ScPonNdJEXcSYQmSko=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hangbin Liu <liuhangbin@gmail.com>,
	Benjamin Poirier <benjamin.poirier@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 035/150] selftests: bonding: do not set port down when adding to bond
Date: Mon,  8 Jan 2024 16:34:46 +0100
Message-ID: <20240108153512.901896003@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240108153511.214254205@linuxfoundation.org>
References: <20240108153511.214254205@linuxfoundation.org>
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

From: Hangbin Liu <liuhangbin@gmail.com>

[ Upstream commit 61fa2493ca76fd7bb74e13f0205274f4ab0aa696 ]

Similar to commit be809424659c ("selftests: bonding: do not set port down
before adding to bond"). The bond-arp-interval-causes-panic test failed
after commit a4abfa627c38 ("net: rtnetlink: Enslave device before bringing
it up") as the kernel will set the port down _after_ adding to bond if setting
port down specifically.

Fix it by removing the link down operation when adding to bond.

Fixes: 2ffd57327ff1 ("selftests: bonding: cause oops in bond_rr_gen_slave_id")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Tested-by: Benjamin Poirier <benjamin.poirier@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../drivers/net/bonding/bond-arp-interval-causes-panic.sh   | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/drivers/net/bonding/bond-arp-interval-causes-panic.sh b/tools/testing/selftests/drivers/net/bonding/bond-arp-interval-causes-panic.sh
index 71c00bfafbc99..2ff58fed76e28 100755
--- a/tools/testing/selftests/drivers/net/bonding/bond-arp-interval-causes-panic.sh
+++ b/tools/testing/selftests/drivers/net/bonding/bond-arp-interval-causes-panic.sh
@@ -33,16 +33,16 @@ ip netns add "client"
 ip link set dev link1_1 netns client down name eth0
 ip netns exec client ip link add dev bond0 down type bond mode 1 \
 	miimon 100 all_slaves_active 1
-ip netns exec client ip link set dev eth0 down master bond0
+ip netns exec client ip link set dev eth0 master bond0
 ip netns exec client ip link set dev bond0 up
 ip netns exec client ip addr add ${client_ip4}/24 dev bond0
 ip netns exec client ping -c 5 $server_ip4 >/dev/null
 
-ip netns exec client ip link set dev eth0 down nomaster
+ip netns exec client ip link set dev eth0 nomaster
 ip netns exec client ip link set dev bond0 down
 ip netns exec client ip link set dev bond0 type bond mode 0 \
 	arp_interval 1000 arp_ip_target "+${server_ip4}"
-ip netns exec client ip link set dev eth0 down master bond0
+ip netns exec client ip link set dev eth0 master bond0
 ip netns exec client ip link set dev bond0 up
 ip netns exec client ping -c 5 $server_ip4 >/dev/null
 
-- 
2.43.0



