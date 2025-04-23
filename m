Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECA5817B421;
	Wed, 23 Apr 2025 15:24:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421877; cv=none; b=meyXqGj0Hm25jXLrsoCpP+kM4GjH9YPP+KiyrtQMRV+abPkRqk9RQR8h5UXLq4BabJOqk6tuk3hs7hhZUU06DMV0YHBygJ2Z3ouDSGaYA8C++c1PEs51GCYjk4ixfmiP07lBh5/0J8eWwFcg4FQoGZgIpIzjuuMyUWyKCw8fzoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421877; c=relaxed/simple;
	bh=TB5k+hKtaBiX++ScL635bbQTcgDj5ZrPjll8y6+iY2U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G2moeoV4feHvEtVE1xztYmCcbtjf7JKr68kFPRi1BV5XuxhT0IKTLZUm53JbF738d4tcZGZL7kcEn+aD1539PyZI5CMWVt7ZckaabSZriNqxKPiPIaUjDPx3VGKg4ONtIXu47m+RuSv/3XX/KtOxbOQ5Pj7M1p9LXlSrSf4Ypo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XkdrccR1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XkdrccR1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7AB5C4CEE2;
	Wed, 23 Apr 2025 15:24:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421876;
	bh=TB5k+hKtaBiX++ScL635bbQTcgDj5ZrPjll8y6+iY2U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XkdrccR1RehGl3TmvEJclFmnXIHALCgCnfwbO2I9r71DO14jnFPcrYkJMSQW4rQbM
	 qtJkXvj0gctNAYXrH16Nc3C1mdRFiyTqLVS/cwEZfv932s+xe+uDA3I5fkK+RYIgcx
	 xVWSFvnAqepDApMTX6uQafyZirvtGeCdwUiXX2SI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 191/291] net: dsa: mv88e6xxx: fix -ENOENT when deleting VLANs and MST is unsupported
Date: Wed, 23 Apr 2025 16:43:00 +0200
Message-ID: <20250423142632.188641500@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142624.409452181@linuxfoundation.org>
References: <20250423142624.409452181@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit ea08dfc35f83cfc73493c52f63ae4f2e29edfe8d ]

Russell King reports that on the ZII dev rev B, deleting a bridge VLAN
from a user port fails with -ENOENT:
https://lore.kernel.org/netdev/Z_lQXNP0s5-IiJzd@shell.armlinux.org.uk/

This comes from mv88e6xxx_port_vlan_leave() -> mv88e6xxx_mst_put(),
which tries to find an MST entry in &chip->msts associated with the SID,
but fails and returns -ENOENT as such.

But we know that this chip does not support MST at all, so that is not
surprising. The question is why does the guard in mv88e6xxx_mst_put()
not exit early:

	if (!sid)
		return 0;

And the answer seems to be simple: the sid comes from vlan.sid which
supposedly was previously populated by mv88e6xxx_vtu_get().
But some chip->info->ops->vtu_getnext() implementations do not populate
vlan.sid, for example see mv88e6185_g1_vtu_getnext(). In that case,
later in mv88e6xxx_port_vlan_leave() we are using a garbage sid which is
just residual stack memory.

Testing for sid == 0 covers all cases of a non-bridge VLAN or a bridge
VLAN mapped to the default MSTI. For some chips, SID 0 is valid and
installed by mv88e6xxx_stu_setup(). A chip which does not support the
STU would implicitly only support mapping all VLANs to the default MSTI,
so although SID 0 is not valid, it would be sufficient, if we were to
zero-initialize the vlan structure, to fix the bug, due to the
coincidence that a test for vlan.sid == 0 already exists and leads to
the same (correct) behavior.

Another option which would be sufficient would be to add a test for
mv88e6xxx_has_stu() inside mv88e6xxx_mst_put(), symmetric to the one
which already exists in mv88e6xxx_mst_get(). But that placement means
the caller will have to dereference vlan.sid, which means it will access
uninitialized memory, which is not nice even if it ignores it later.

So we end up making both modifications, in order to not rely just on the
sid == 0 coincidence, but also to avoid having uninitialized structure
fields which might get temporarily accessed.

Fixes: acaf4d2e36b3 ("net: dsa: mv88e6xxx: MST Offloading")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Link: https://patch.msgid.link/20250414212913.2955253-1-vladimir.oltean@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index d348078ec033c..4c60f79ce2697 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -1724,6 +1724,8 @@ static int mv88e6xxx_vtu_get(struct mv88e6xxx_chip *chip, u16 vid,
 	if (!chip->info->ops->vtu_getnext)
 		return -EOPNOTSUPP;
 
+	memset(entry, 0, sizeof(*entry));
+
 	entry->vid = vid ? vid - 1 : mv88e6xxx_max_vid(chip);
 	entry->valid = false;
 
@@ -1859,7 +1861,16 @@ static int mv88e6xxx_mst_put(struct mv88e6xxx_chip *chip, u8 sid)
 	struct mv88e6xxx_mst *mst, *tmp;
 	int err;
 
-	if (!sid)
+	/* If the SID is zero, it is for a VLAN mapped to the default MSTI,
+	 * and mv88e6xxx_stu_setup() made sure it is always present, and thus,
+	 * should not be removed here.
+	 *
+	 * If the chip lacks STU support, numerically the "sid" variable will
+	 * happen to also be zero, but we don't want to rely on that fact, so
+	 * we explicitly test that first. In that case, there is also nothing
+	 * to do here.
+	 */
+	if (!mv88e6xxx_has_stu(chip) || !sid)
 		return 0;
 
 	list_for_each_entry_safe(mst, tmp, &chip->msts, node) {
-- 
2.39.5



