Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36ECB16DECF;
	Wed,  3 Jul 2024 10:50:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720003804; cv=none; b=V1zje5e799rKAHn9JJqOtjxvYATBG3+sgUUWL47AORBZ+3TMtsEy/wq/ir3MVqr8smYlHC/+lvhRXrBDVFRXR3jRAp6OZpkUe3JA+8T2pYc9GC6vCqe1qCf3TNa1FTKQ7Qwdy/eL9A2KcbfmEzF/hFNzlEOWXsqzxFW0cZe2S4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720003804; c=relaxed/simple;
	bh=7z85FPJMX9V8l3BTGj0/3uChZUZCUVtDkUtdgrMDriQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kuOFE4wE3nZejzVFOc2PGKU0b/rvQ1M4Opgc6UjNAUT4AelJFW3X19SOfRkcqWI7ORSMl8c/n/Cs1EzcAPPzEfBM0pHGQOvIt+5/OhQE8uGXvWZ8mBQgrmbISIJa9vV9u73VFCVoUAvQJeMswlbJU7HkOZhD2iUE/Zc5klLCvwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oJDdgdOz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oJDdgdOz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC121C32781;
	Wed,  3 Jul 2024 10:50:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720003804;
	bh=7z85FPJMX9V8l3BTGj0/3uChZUZCUVtDkUtdgrMDriQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oJDdgdOziVSLQarOtisMxtYB9OARX9phN1xzgSeAcORW96UNVDjvGFHn8D0NWyKOW
	 HPj+f2HSg/zhzbDKEhEmYHQmnD4c6g/8aGWv6lSXJ4hoU/PeL8tkWOzJEG6I4lME06
	 nScqNnC9AW7hjQzEznl2ch0RsVW7urh/YyrC9wp8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Borkmann <daniel@iogearbox.net>,
	David Bauer <mail@david-bauer.net>,
	Ido Schimmel <idosch@nvidia.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 009/189] vxlan: Fix regression when dropping packets due to invalid src addresses
Date: Wed,  3 Jul 2024 12:37:50 +0200
Message-ID: <20240703102841.854249439@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102841.492044697@linuxfoundation.org>
References: <20240703102841.492044697@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Borkmann <daniel@iogearbox.net>

[ Upstream commit 1cd4bc987abb2823836cbb8f887026011ccddc8a ]

Commit f58f45c1e5b9 ("vxlan: drop packets from invalid src-address")
has recently been added to vxlan mainly in the context of source
address snooping/learning so that when it is enabled, an entry in the
FDB is not being created for an invalid address for the corresponding
tunnel endpoint.

Before commit f58f45c1e5b9 vxlan was similarly behaving as geneve in
that it passed through whichever macs were set in the L2 header. It
turns out that this change in behavior breaks setups, for example,
Cilium with netkit in L3 mode for Pods as well as tunnel mode has been
passing before the change in f58f45c1e5b9 for both vxlan and geneve.
After mentioned change it is only passing for geneve as in case of
vxlan packets are dropped due to vxlan_set_mac() returning false as
source and destination macs are zero which for E/W traffic via tunnel
is totally fine.

Fix it by only opting into the is_valid_ether_addr() check in
vxlan_set_mac() when in fact source address snooping/learning is
actually enabled in vxlan. This is done by moving the check into
vxlan_snoop(). With this change, the Cilium connectivity test suite
passes again for both tunnel flavors.

Fixes: f58f45c1e5b9 ("vxlan: drop packets from invalid src-address")
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Cc: David Bauer <mail@david-bauer.net>
Cc: Ido Schimmel <idosch@nvidia.com>
Cc: Nikolay Aleksandrov <razor@blackwall.org>
Cc: Martin KaFai Lau <martin.lau@kernel.org>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>
Reviewed-by: David Bauer <mail@david-bauer.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/vxlan.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
index 8808a6540b190..ce11fb2b05561 100644
--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -1323,6 +1323,10 @@ static bool vxlan_snoop(struct net_device *dev,
 	struct vxlan_fdb *f;
 	u32 ifindex = 0;
 
+	/* Ignore packets from invalid src-address */
+	if (!is_valid_ether_addr(src_mac))
+		return true;
+
 #if IS_ENABLED(CONFIG_IPV6)
 	if (src_ip->sa.sa_family == AF_INET6 &&
 	    (ipv6_addr_type(&src_ip->sin6.sin6_addr) & IPV6_ADDR_LINKLOCAL))
-- 
2.43.0



