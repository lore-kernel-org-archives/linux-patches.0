Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D23D94ABBA5;
	Wed, 30 Sep 2026 18:04:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791450; cv=none; b=gt4tabxdC5zi9vO0c6odKRDVZbzhegowZsJQmDHB/SIe3hhUssz3L4FzuvjptTvQK0Up1r0t2xMM0C68issTw/z2p32r+sVRHusBRnpKwnd0C+CP1nB18wf8Ig84XFAV1qEGGdmTuvvSgdaKH/bfeJ86ckmy2xdXhqMHSMUDhjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791450; c=relaxed/simple;
	bh=ZH8+eecroK3nS/nDRAN/8Fdvvq8uQMCz4n3i1vHAkAw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ifw5DvrxfwqF1vs93+XvSaDH0Xx4PxRG9mRopjbv4vkprvGQrAilG93Lo6KiFOiIDSk4oYt8de7ejLGQVrXpRVncRKmAkZdwu+cnPkVARpOoMXYa/+F+7AUUuVS4AlwpQdHW/iENirYznBwqD+IGVP569mGEg+roMFeBfB0NpYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GFUYW/8P; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GFUYW/8P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3911A1F000FF;
	Wed, 30 Sep 2026 18:04:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791448;
	bh=JRL+SK2kZivzXFzLWrQxx5RX0Lq4lIZRSiupwd62P6I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GFUYW/8PigOrgTttRQzQRExmhI3BBTCUv2SRCdRHUhmmUksiQP7xdV/+iIydhAXe5
	 tAAD09mJEJypudwT4eUQZUyaQPvNPgXqiG1EtrcWN0TwRUV7ht0ktkdIqtUPdR2DfK
	 cZslQN21zsR+5MWwSCa6M86v52YzAFGg6NQsUm1g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Damato <joe@dama.to>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 305/752] net: dsa: mv88e6xxx: bound the policy rule dump by the callers buffer size
Date: Wed, 30 Sep 2026 17:22:55 +0200
Message-ID: <20260930152404.892419836@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit b1fffc273112e7284c5b705e186b43b5770cd3d5 ]

mv88e6xxx_get_rxnfc() uses rxnfc->rule_cnt as the write index while
dumping the policy IDR, clobbering the input value before it has been
looked at.  That input is the number of entries the caller had room for.
ETHTOOL_GRXCLSRLALL requires no CAP_NET_ADMIN and the ioctl sizes the
buffer from the rule_cnt userspace passes in, so once an admin has
installed policy rules any user can ask for fewer slots than there are
rules and run off the end of the allocation.  A rule_cnt of 0 leaves the
buffer pointer NULL and the walk dereferences it.

Count into a local so the caller's limit survives the walk, and stop with
-EMSGSIZE once it is reached.

Fixes: da7dc8755304 ("net: dsa: mv88e6xxx: add RXNFC support")
Reviewed-by: Joe Damato <joe@dama.to>
Link: https://patch.msgid.link/20260903032611.3000029-5-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index bcf5696804504..273d5e930362a 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -1995,6 +1995,7 @@ static int mv88e6xxx_get_rxnfc(struct dsa_switch *ds, int port,
 	struct ethtool_rx_flow_spec *fs = &rxnfc->fs;
 	struct mv88e6xxx_chip *chip = ds->priv;
 	struct mv88e6xxx_policy *policy;
+	u32 cnt = 0;
 	int err;
 	int id;
 
@@ -2020,11 +2021,18 @@ static int mv88e6xxx_get_rxnfc(struct dsa_switch *ds, int port,
 		break;
 	case ETHTOOL_GRXCLSRLALL:
 		rxnfc->data = 0;
-		rxnfc->rule_cnt = 0;
-		idr_for_each_entry(&chip->policies, policy, id)
-			if (policy->port == port)
-				rule_locs[rxnfc->rule_cnt++] = id;
 		err = 0;
+		idr_for_each_entry(&chip->policies, policy, id) {
+			if (policy->port != port)
+				continue;
+			if (cnt == rxnfc->rule_cnt) {
+				err = -EMSGSIZE;
+				break;
+			}
+			rule_locs[cnt++] = id;
+		}
+		if (!err)
+			rxnfc->rule_cnt = cnt;
 		break;
 	default:
 		err = -EOPNOTSUPP;
-- 
2.53.0



