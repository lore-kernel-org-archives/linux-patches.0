Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 735EC4B7A3D;
	Thu, 17 Sep 2026 15:38:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659501; cv=none; b=DzpXxqjBotVWmBsKAZf2GGL0pBjI2FcZsnSsV1poCEU4SM8cFoLUL5yvYQDp2rXv4PgXcKO8NqZ9rUpNc6lTcyfrhRcnS0VMBaRuR1Bnwi/sV3/BtoZhIA47/8Nz+vGAPiUnZK3yRRt90e9/mPPkBi5vny0yPFvQIcgSuRy7fys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659501; c=relaxed/simple;
	bh=qIS937yL1/Mi10sJS1m0ew0IZfpgYvq3deIK3QIlTu8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lp1QtNIz/YCz2QMqYYRchC21SpS67Trtop6/HClLR3dPpEp60tDPq0JQJmTs2BAvS3TH8bCYRCpjDdbnntO9MGpc36bvYNjQPPq8Ltv0z4PQvcQiJVYWtw95cYlpFrLCIC2UXPa8ciqVpeRVJThKPC9fHibiYOId3EawoXSjdpM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OuhW+z4m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OuhW+z4m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EB371F000FF;
	Thu, 17 Sep 2026 15:38:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659496;
	bh=ttDPKjVv/3uWD1VwNYLqgWUE3Cv2kWNOpWD+h2L6hQ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OuhW+z4mIqNH3q0tiln7hIHKQ2KbKnFzHHKLajhF6UdxiGhHwEoSUtRJYIbL0bHBb
	 9Ow3GbEFnGDnGuI+YIa5ntbNGWHow2FTHBrKHhSnMzAzOTcQjiPzQqh7WY0FoSV3Hp
	 ZK5DgR45AK1NkSw38fICWYQIAEFKDirDS0honwbE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	VEGA <vega@nebusec.ai>,
	Joe Damato <joe@dama.to>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 275/733] eth: nfp: bound the ntuple rule dump by the callers buffer size
Date: Thu, 17 Sep 2026 16:09:43 +0100
Message-ID: <20260917151358.210200785@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit f1986bf87b0709c95126fe196cf39e5b8c8453a1 ]

nfp_net_get_fs_loc() dumps every entry of nn->fs.list into rule_locs[]
without consulting cmd->rule_cnt, which is how many entries the caller
had room for.  ETHTOOL_GRXCLSRLALL requires no CAP_NET_ADMIN and the
ioctl sizes the buffer from the rule_cnt userspace passes in, so once an
admin has installed flow steering rules any user can ask for fewer slots
than there are rules and run off the end of the allocation.  A rule_cnt
of 0 leaves the buffer pointer NULL and the walk dereferences it.

Bail out with -EMSGSIZE when the buffer fills up, the way the other
ntuple capable drivers do, and report how many locations were filled so
a shrinking rule list does not leave the caller reading stale slots.

Reported-by: VEGA <vega@nebusec.ai>
Fixes: 9eb03bb1c035 ("nfp: add ethtool flow steering callbacks")
Reviewed-by: Joe Damato <joe@dama.to>
Link: https://patch.msgid.link/20260903032611.3000029-3-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
index a2a89d48e3cac..9419e1ed84661 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
@@ -1421,7 +1421,8 @@ static int nfp_net_get_fs_rule(struct nfp_net *nn, struct ethtool_rxnfc *cmd)
 	return -ENOENT;
 }
 
-static int nfp_net_get_fs_loc(struct nfp_net *nn, u32 *rule_locs)
+static int nfp_net_get_fs_loc(struct nfp_net *nn, struct ethtool_rxnfc *cmd,
+			      u32 *rule_locs)
 {
 	struct nfp_fs_entry *entry;
 	u32 count = 0;
@@ -1429,8 +1430,12 @@ static int nfp_net_get_fs_loc(struct nfp_net *nn, u32 *rule_locs)
 	if (!(nn->cap_w1 & NFP_NET_CFG_CTRL_FLOW_STEER))
 		return -EOPNOTSUPP;
 
-	list_for_each_entry(entry, &nn->fs.list, node)
+	list_for_each_entry(entry, &nn->fs.list, node) {
+		if (count == cmd->rule_cnt)
+			return -EMSGSIZE;
 		rule_locs[count++] = entry->loc;
+	}
+	cmd->rule_cnt = count;
 
 	return 0;
 }
@@ -1455,7 +1460,7 @@ static int nfp_net_get_rxnfc(struct net_device *netdev,
 		return nfp_net_get_fs_rule(nn, cmd);
 	case ETHTOOL_GRXCLSRLALL:
 		cmd->data = NFP_FS_MAX_ENTRY;
-		return nfp_net_get_fs_loc(nn, rule_locs);
+		return nfp_net_get_fs_loc(nn, cmd, rule_locs);
 	default:
 		return -EOPNOTSUPP;
 	}
-- 
2.53.0



