Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC098280CCE;
	Wed, 23 Apr 2025 14:57:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420247; cv=none; b=doGQPzJOBlvqpC7Xe2MKeKZYeRQu1mEHFHnQrwR3xW8MwK7MFdRveo27peZ9rDm1xTeMzlirCpx/9sfoyf/kDVWDRQ2TxKUulTc26vwbf8vYs433IQmaEnwLtjpK4rzUObYzzM2FPOSZje36RJQSWX6YIV59IfYJXNcGq78wtCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420247; c=relaxed/simple;
	bh=WHlo2y2BOlBx6FJdIzpix1HmBxePJJxhuoh3k2DUTuI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cY5q2qXxQjS5twFT2i4rV+WGS6pEa/gDIpZCVFj8CoSRtcxba75dn7jsUQOyzB6TIpzd3H0mINxH4HXdTgcGmqc8MuuWXV3NvZEUrgrbA7z0li7G6I4DZno3vsuheOnD0d5FejYMXdY2hnAnWgBhLmwJyh8wLXYOJZPaXwlcQ7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wTLd1E2x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wTLd1E2x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF9BCC4CEE2;
	Wed, 23 Apr 2025 14:57:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420247;
	bh=WHlo2y2BOlBx6FJdIzpix1HmBxePJJxhuoh3k2DUTuI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wTLd1E2x410iU2aXy5QduKN0B5XZIL76lt0x9c3SfQ4bJRYRKxChUl1GQMBbK/Ciz
	 rlwv0LEvHepYe02/d5G3RAORtFdz8Ki9BxYwO9TAKhvLnMUzdYyWlrK8U1/6HR6bUZ
	 kXPMUNLJ159B67XZ+3u/WJeAywCnpq6XH+qPFAkA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 075/241] net: dsa: mv88e6xxx: fix -ENOENT when deleting VLANs and MST is unsupported
Date: Wed, 23 Apr 2025 16:42:19 +0200
Message-ID: <20250423142623.658574249@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142620.525425242@linuxfoundation.org>
References: <20250423142620.525425242@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index 29a89ab4b7894..08db846cda8de 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -1852,6 +1852,8 @@ static int mv88e6xxx_vtu_get(struct mv88e6xxx_chip *chip, u16 vid,
 	if (!chip->info->ops->vtu_getnext)
 		return -EOPNOTSUPP;
 
+	memset(entry, 0, sizeof(*entry));
+
 	entry->vid = vid ? vid - 1 : mv88e6xxx_max_vid(chip);
 	entry->valid = false;
 
@@ -1960,7 +1962,16 @@ static int mv88e6xxx_mst_put(struct mv88e6xxx_chip *chip, u8 sid)
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



