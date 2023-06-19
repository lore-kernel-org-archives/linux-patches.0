Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D631BE4B
	for <patches@lists.linux.dev>; Mon, 19 Jun 2023 10:50:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBD45C433C0;
	Mon, 19 Jun 2023 10:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687171814;
	bh=FpZbeesFbF4D+zyryl0oboypA5TXNyeoaUfoXB0qfhQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IE5EEjbULnUBERGOfXK3pEx4OwHaKPYZ0Q6PY7cbuLVxNVp/pciEA+DmtbZzapqb2
	 uv1gqJh8F9FpBaB+kJ3QgvObzRlVcvqNgYAqaycgiWmc1uDQJUAqu2eYlc6uKBm+XC
	 EOOoNl2/hj9QJec3QEoms4DDp/vIdH7RRbZaUWZw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Danielle Ratson <danieller@nvidia.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Petr Machata <petrm@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 142/166] selftests: forwarding: hw_stats_l3: Set addrgenmode in a separate step
Date: Mon, 19 Jun 2023 12:30:19 +0200
Message-ID: <20230619102201.628348857@linuxfoundation.org>
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

From: Danielle Ratson <danieller@nvidia.com>

[ Upstream commit bef68e201e538eaa3a91f97aae8161eb2d0a8ed7 ]

Setting the IPv6 address generation mode of a net device during its
creation never worked, but after commit b0ad3c179059 ("rtnetlink: call
validate_linkmsg in rtnl_create_link") it explicitly fails [1]. The
failure is caused by the fact that validate_linkmsg() is called before
the net device is registered, when it still does not have an 'inet6_dev'.

Likewise, raising the net device before setting the address generation
mode is meaningless, because by the time the mode is set, the address
has already been generated.

Therefore, fix the test to first create the net device, then set its
IPv6 address generation mode and finally bring it up.

[1]
 # ip link add name mydev addrgenmode eui64 type dummy
 RTNETLINK answers: Address family not supported by protocol

Fixes: ba95e7930957 ("selftests: forwarding: hw_stats_l3: Add a new test")
Signed-off-by: Danielle Ratson <danieller@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
Link: https://lore.kernel.org/r/f3b05d85b2bc0c3d6168fe8f7207c6c8365703db.1686580046.git.petrm@nvidia.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/forwarding/hw_stats_l3.sh | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/net/forwarding/hw_stats_l3.sh b/tools/testing/selftests/net/forwarding/hw_stats_l3.sh
index 9c1f76e108af1..1a936ffbacee7 100755
--- a/tools/testing/selftests/net/forwarding/hw_stats_l3.sh
+++ b/tools/testing/selftests/net/forwarding/hw_stats_l3.sh
@@ -84,8 +84,9 @@ h2_destroy()
 
 router_rp1_200_create()
 {
-	ip link add name $rp1.200 up \
-		link $rp1 addrgenmode eui64 type vlan id 200
+	ip link add name $rp1.200 link $rp1 type vlan id 200
+	ip link set dev $rp1.200 addrgenmode eui64
+	ip link set dev $rp1.200 up
 	ip address add dev $rp1.200 192.0.2.2/28
 	ip address add dev $rp1.200 2001:db8:1::2/64
 	ip stats set dev $rp1.200 l3_stats on
@@ -256,9 +257,11 @@ reapply_config()
 
 	router_rp1_200_destroy
 
-	ip link add name $rp1.200 link $rp1 addrgenmode none type vlan id 200
+	ip link add name $rp1.200 link $rp1 type vlan id 200
+	ip link set dev $rp1.200 addrgenmode none
 	ip stats set dev $rp1.200 l3_stats on
-	ip link set dev $rp1.200 up addrgenmode eui64
+	ip link set dev $rp1.200 addrgenmode eui64
+	ip link set dev $rp1.200 up
 	ip address add dev $rp1.200 192.0.2.2/28
 	ip address add dev $rp1.200 2001:db8:1::2/64
 }
-- 
2.39.2



