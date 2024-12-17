Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 463F21F4735;
	Tue, 17 Dec 2024 17:11:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734455488; cv=none; b=fc2HlhrFOPySSOhAXdg9z0zes0AyHZorInRJhuu+fy3rhCr+2e6wQkiocVT+vRTjf5EIuBuS1+c/IybeLoUUDPSqWEfhBS6aBINuXfqdUgVHiRgOj9BtYKtcqcOl4ye1ybiH3GJ4br5jUpH0wg4K79Uf/oDImYoi9DeLD3a7lFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734455488; c=relaxed/simple;
	bh=29w2WZ8WEtxdugirbYO82G9H1rJ9VsWz1OZdO385PAc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ln4OrB0/Vl8s/VryhIQrB0W9S9u6AGFVXTmHL4z7psXSv74limqaazs1CHF/2OElEBlCSsfcUiY1s3zRUrqfMyaJSpp95kYR6KqO6hLJ/xxpgHCXWm8Jz2o1f0MApMnmTLR1BebcSYbEPU3larwtDOixA8WHVF/o8E2e8dP6alY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1LUgGY63; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1LUgGY63"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9C80C4CED3;
	Tue, 17 Dec 2024 17:11:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734455488;
	bh=29w2WZ8WEtxdugirbYO82G9H1rJ9VsWz1OZdO385PAc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1LUgGY63oQ7Y87NfLRuDVsytNQpxHTVaeG87sD9jU2T6km1AnIvBFuQprUsUUYHSj
	 PqEkpokQgJAl0049siawXaPl6mzeUybwaC1kUgdRBXqY4zQbxVB8MGbjKIjgcyEhSu
	 545ySNjb8DnjjfZVUVcOg3WAnUhm+wKN+8XZZ0eg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Borkmann <daniel@iogearbox.net>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Ido Schimmel <idosch@idosch.org>,
	Jiri Pirko <jiri@nvidia.com>,
	Hangbin Liu <liuhangbin@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 27/43] team: Fix feature propagation of NETIF_F_GSO_ENCAP_ALL
Date: Tue, 17 Dec 2024 18:07:18 +0100
Message-ID: <20241217170521.548601329@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170520.459491270@linuxfoundation.org>
References: <20241217170520.459491270@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Borkmann <daniel@iogearbox.net>

[ Upstream commit 98712844589e06d9aa305b5077169942139fd75c ]

Similar to bonding driver, add NETIF_F_GSO_ENCAP_ALL to TEAM_VLAN_FEATURES
in order to support slave devices which propagate NETIF_F_GSO_UDP_TUNNEL &
NETIF_F_GSO_UDP_TUNNEL_CSUM as vlan_features.

Fixes: 3625920b62c3 ("teaming: fix vlan_features computing")
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Cc: Nikolay Aleksandrov <razor@blackwall.org>
Cc: Ido Schimmel <idosch@idosch.org>
Cc: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>
Reviewed-by: Hangbin Liu <liuhangbin@gmail.com>
Link: https://patch.msgid.link/20241210141245.327886-5-daniel@iogearbox.net
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/team/team.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/team/team.c b/drivers/net/team/team.c
index e455e526b774..bc52f9e24ff3 100644
--- a/drivers/net/team/team.c
+++ b/drivers/net/team/team.c
@@ -978,7 +978,8 @@ static void team_port_disable(struct team *team,
 
 #define TEAM_VLAN_FEATURES (NETIF_F_HW_CSUM | NETIF_F_SG | \
 			    NETIF_F_FRAGLIST | NETIF_F_GSO_SOFTWARE | \
-			    NETIF_F_HIGHDMA | NETIF_F_LRO)
+			    NETIF_F_HIGHDMA | NETIF_F_LRO | \
+			    NETIF_F_GSO_ENCAP_ALL)
 
 #define TEAM_ENC_FEATURES	(NETIF_F_HW_CSUM | NETIF_F_SG | \
 				 NETIF_F_RXCSUM | NETIF_F_GSO_SOFTWARE)
-- 
2.39.5



