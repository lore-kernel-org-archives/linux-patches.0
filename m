Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B901525DB0A;
	Tue, 11 Mar 2025 15:17:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706231; cv=none; b=c9UiF2lwex4KhIFxWmilRdgRixACKpEt185JcBULKIANxN2JczVaYJUjtzXaT/tUZSs9a+YCyKQC9VT64FQJBMTmkF2NatvTPIvwXT3IBnaOFk8R7E7unMvWdbQ4ds3FuOnOjNjnx9BydtTojnBUUoXi6eXQfFOo3O7/14zt5QM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706231; c=relaxed/simple;
	bh=v8rr5nAqV+bswViHWuL2m7j2drlOXpv78lPl38M1ILo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LkDIkWZh5ONhay2JFsh7PKO79lCLeaehdqR2QzAtG3mh4bkv0iVq3YSQ3QolgmXfkBwuY3HIJdcyj8pkXX3nAhYDuAMs++KxlsttnF5RZnFkKI30vnVn1qOhwfuB99DLjMhfSX+B2WN0gbQKoqOFFchqWRJwUsGrmbzSyzYMDRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oXCikSKq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oXCikSKq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 175F3C4CEEA;
	Tue, 11 Mar 2025 15:17:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706231;
	bh=v8rr5nAqV+bswViHWuL2m7j2drlOXpv78lPl38M1ILo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oXCikSKqZ2T5QePzWODpBrW7pr5yrP3wn/0Jao4hfA9i5fdQRrAfIL3jsiiy3rBTX
	 1t+XJAf/olitlWYw1Q/mWryaL9ppLoNMMPmN/QcKxPvFfxXL9eI8MdhdRscmMzxaZ3
	 bk7h4XRCrA/AbLxypG2a2gs9auQ5wdlTBnTAO9so=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+91161fe81857b396c8a0@syzkaller.appspotmail.com,
	Oscar Maes <oscmaes92@gmail.com>,
	Jiri Pirko <jiri@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 306/328] vlan: enforce underlying device type
Date: Tue, 11 Mar 2025 16:01:16 +0100
Message-ID: <20250311145727.070993010@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145714.865727435@linuxfoundation.org>
References: <20250311145714.865727435@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Oscar Maes <oscmaes92@gmail.com>

[ Upstream commit b33a534610067ade2bdaf2052900aaad99701353 ]

Currently, VLAN devices can be created on top of non-ethernet devices.

Besides the fact that it doesn't make much sense, this also causes a
bug which leaks the address of a kernel function to usermode.

When creating a VLAN device, we initialize GARP (garp_init_applicant)
and MRP (mrp_init_applicant) for the underlying device.

As part of the initialization process, we add the multicast address of
each applicant to the underlying device, by calling dev_mc_add.

__dev_mc_add uses dev->addr_len to determine the length of the new
multicast address.

This causes an out-of-bounds read if dev->addr_len is greater than 6,
since the multicast addresses provided by GARP and MRP are only 6
bytes long.

This behaviour can be reproduced using the following commands:

ip tunnel add gretest mode ip6gre local ::1 remote ::2 dev lo
ip l set up dev gretest
ip link add link gretest name vlantest type vlan id 100

Then, the following command will display the address of garp_pdu_rcv:

ip maddr show | grep 01:80:c2:00:00:21

Fix the bug by enforcing the type of the underlying device during VLAN
device initialization.

Fixes: 22bedad3ce11 ("net: convert multicast list to list_head")
Reported-by: syzbot+91161fe81857b396c8a0@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/netdev/000000000000ca9a81061a01ec20@google.com/
Signed-off-by: Oscar Maes <oscmaes92@gmail.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Link: https://patch.msgid.link/20250303155619.8918-1-oscmaes92@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/8021q/vlan.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/8021q/vlan.c b/net/8021q/vlan.c
index 796d95797ab40..c75fca3eed49e 100644
--- a/net/8021q/vlan.c
+++ b/net/8021q/vlan.c
@@ -124,7 +124,8 @@ int vlan_check_real_dev(struct net_device *real_dev,
 {
 	const char *name = real_dev->name;
 
-	if (real_dev->features & NETIF_F_VLAN_CHALLENGED) {
+	if (real_dev->features & NETIF_F_VLAN_CHALLENGED ||
+	    real_dev->type != ARPHRD_ETHER) {
 		pr_info("VLANs not supported on %s\n", name);
 		NL_SET_ERR_MSG_MOD(extack, "VLANs not supported on device");
 		return -EOPNOTSUPP;
-- 
2.39.5



