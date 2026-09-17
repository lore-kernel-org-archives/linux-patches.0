Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60F424ABBCE;
	Thu, 17 Sep 2026 18:41:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789670479; cv=none; b=lJwVHEXuxB32NprlG0mVtsDJ1L/kvtq9eEEsaLF6d7CZfPufOF1dRmAXInSSRp0EHwJVr/S/0ocMWAaFRIXiqCy0fSkW5INXwO9sjLVvkslJeJWsitKX0Xb2YDMR/thyMOk2DdJ8c/hIyfm5ihpVxHPNNUdVItMMzV0IDk5N+ow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789670479; c=relaxed/simple;
	bh=mE0CBtdgdRqV4yuYsQ786ccc/RqAavvWm+kx+dqvTyY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NpgJbnBWLwjk41ndykJdXwKdYrMkRBHlsOSBIoxStD3GNL5ewz7FPOwQQiU/tCrWZ/ipql1lZBYb2D4Nsm64BcoNPMPQfdkjmQad/EzF8EB0MMGXeJd9JtOvlO0mixgin/6UCWSu1EaH0knGgw0nEFRn8eXVwI4ZEOG3pY9jRRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bQdVcaX0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bQdVcaX0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DE681F000FF;
	Thu, 17 Sep 2026 18:41:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789670478;
	bh=gOdzYQmgrKkxOyROT47XLK7zBvgNvBxgFbMPM0yUHXo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bQdVcaX0mWKC8BkHtjynNHpEsvyx02aD2/XYEGDE5duWPYX8Dvp00PbAwMjiXERHG
	 pnmdtIPsGSFfD1F5DZVPcnhhvcnhxV4m67qNjfw/TEkQ5rwESpyDn52s5tzAej10q+
	 GNNDn4BGGD8b7J3UiPAe9Yudsk9NfgoLqEisgINs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Damato <joe@dama.to>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0673/1102] net: dsa: mv88e6xxx: bound the policy rule dump by the callers buffer size
Date: Thu, 17 Sep 2026 16:10:16 +0100
Message-ID: <20260917151557.124120227@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 2c7d462f046ce..63d40a40ad0c1 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -2492,6 +2492,7 @@ static int mv88e6xxx_get_rxnfc(struct dsa_switch *ds, int port,
 	struct ethtool_rx_flow_spec *fs = &rxnfc->fs;
 	struct mv88e6xxx_chip *chip = ds->priv;
 	struct mv88e6xxx_policy *policy;
+	u32 cnt = 0;
 	int err;
 	int id;
 
@@ -2517,11 +2518,18 @@ static int mv88e6xxx_get_rxnfc(struct dsa_switch *ds, int port,
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



