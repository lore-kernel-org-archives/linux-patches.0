Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BF4E47604A;
	Tue, 21 Jul 2026 20:14:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664868; cv=none; b=AZyhGKxIw/w8gWXyMjUM2GcErlR0xxBWJw5jS8apHzFM2+wlBsBTPZEirSH7IJuaBPbmhst4OUYwPZ3foy9KhuY3I8WE54wye+QPBAA8k8sTnniXuRlbZZ2laCVSs/OO+zpQVFgHdDl1vXQbqcnRcn0b0RAnMb8/jQdY5SiEt0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664868; c=relaxed/simple;
	bh=mzmdaWk6UBc1Cz+vQ6jUF68cls9zoqvCNQM+oORsWZU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IjDmuN6crhfW5mwJE7uN7fE66TKP1waEeVy2/KqnhB0Be2aRDPFcxf1QEXX0TTq3Wd4vto2tL328n1YPuYxukasY3USemvag+Z8Sva+3e6S65bPyLfIMyLHamjB2iJsZ9CvfJr0jOxCEmbu01k6fBQbii6l2bwVxQTLo0+Si1WM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jTJpEJS4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jTJpEJS4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8B811F000E9;
	Tue, 21 Jul 2026 20:14:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664867;
	bh=IBA8CuvbZRiinfe54qmig7ZCF/Zdd4xkll+lYw0BY4g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jTJpEJS4c77xt+qqpBxGMKNTLFJ6xRhDiMLcAy0dWZB24dDN+fCY3H96Mq1nSLlRK
	 jRBY1hHDmPZmR3Ez5MoR9cLGssz+yexWdHwCvFqMfToWJDjYogEagMykf2nTfym75G
	 F5WCGwe5O0cDcKZ1990qQhYY+LgMnyofhsANhypA=
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
	Wentao Guan <guanwentao@uniontech.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0045/1266] bonding: Fix initial {vlan,mpls}_feature set in bond_compute_features
Date: Tue, 21 Jul 2026 17:08:02 +0200
Message-ID: <20260721152442.810684395@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Borkmann <daniel@iogearbox.net>

[ Upstream commit d064ea7fe2a24938997b5e88e6b61cbb0a4bb906 ]

If a bonding device has slave devices, then the current logic to derive
the feature set for the master bond device is limited in that flags which
are fully supported by the underlying slave devices cannot be propagated
up to vlan devices which sit on top of bond devices. Instead, these get
blindly masked out via current NETIF_F_ALL_FOR_ALL logic.

vlan_features and mpls_features should reuse netdev_base_features() in
order derive the set in the same way as ndo_fix_features before iterating
through the slave devices to refine the feature set.

Fixes: a9b3ace44c7d ("bonding: fix vlan_features computing")
Fixes: 2e770b507ccd ("net: bonding: Inherit MPLS features from slave devices")
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Cc: Nikolay Aleksandrov <razor@blackwall.org>
Cc: Ido Schimmel <idosch@idosch.org>
Cc: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>
Reviewed-by: Hangbin Liu <liuhangbin@gmail.com>
Link: https://patch.msgid.link/20241210141245.327886-2-daniel@iogearbox.net
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Wentao Guan <guanwentao@uniontech.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/bonding/bond_main.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 36277bcefe2908..d200909a75cfe9 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -1499,8 +1499,9 @@ static void bond_compute_features(struct bonding *bond)
 
 	if (!bond_has_slaves(bond))
 		goto done;
-	vlan_features &= NETIF_F_ALL_FOR_ALL;
-	mpls_features &= NETIF_F_ALL_FOR_ALL;
+
+	vlan_features = netdev_base_features(vlan_features);
+	mpls_features = netdev_base_features(mpls_features);
 
 	bond_for_each_slave(bond, slave, iter) {
 		vlan_features = netdev_increment_features(vlan_features,
-- 
2.53.0



