Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46C534F85A5;
	Thu, 17 Sep 2026 17:21:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665696; cv=none; b=ft+BHnjFVx2/Da1rNhYAGtD//RmFfkDCp4O8/wvNZQiUbzQQZhDWG2PArsn6PRQEkvLYPu0JhobIG8vHcRj5ypvGjYzG77lyArLL+kIIZ+pEjEgBc/KPzabZtODZHTC/WU9BKMPcLS5iI2dT5TzHZfkUoPM5n1FWDx/ASKH6slY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665696; c=relaxed/simple;
	bh=jCJcqG0B7OtwOJ6+5nsznNP3DhGCen9sqhKr5CP6okI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ef4ME+TWRPRAUyMfOpjgumO9XOjqhujl2m8j8C7o4JlsXJJ+TmQyeihlJ99TOP2XMFQD54/U2PlAmNgTBLToVm8dG71CSFXA2yJJjZ1YiS5WcLR331CqOCvzcTokG/E2UpmRjBmOWvn51UuV9m0bgyA/M6jzZEMIN/i5Kq61+/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UxlpIn+I; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UxlpIn+I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D8651F000FF;
	Thu, 17 Sep 2026 17:21:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665695;
	bh=xTXZM6LiVCFD7kywWDcSdwK+wp17X9UbH9naOEEC20Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UxlpIn+I1TtTUvbHrUu7wy6F7vj7qt2fdIaJsJcMVdmzXNZwh9lJrWarNErQ6X7qY
	 ncmorVRPHX2+RKFQ+GfXv7PkKIHiyHr2YDtaCtj3oKUvX9rOXlhQP1Hbl6P2xIfp/T
	 SLIMEPU2HHPx0R9EJ/MHxcY1lOMUR1Qt/Kwsd1UI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	VEGA <vega@nebusec.ai>,
	Joe Damato <joe@dama.to>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0791/1250] eth: nfp: bound the ntuple rule dump by the callers buffer size
Date: Thu, 17 Sep 2026 16:09:46 +0100
Message-ID: <20260917151613.334502076@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 16c828dd5c1a3..d6e1998e55367 100644
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
@@ -1451,7 +1456,7 @@ static int nfp_net_get_rxnfc(struct net_device *netdev,
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



