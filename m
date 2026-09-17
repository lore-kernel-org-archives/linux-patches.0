Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50DEF40A93E;
	Thu, 17 Sep 2026 18:41:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789670473; cv=none; b=D1WcxiGWmUrW/NAlvALyNadjOV74VGA5VjGmRF4go8WGDHnHdi+A02GoV/S05HLcFQoSR9AO0zzUyR6SNC5a+jRNeUwOYOyYWchaSkTcBIKMZXpDOxQprSe0AdFqPsS7qx2xEP4uTEW88cUxBU3ZK7ajMu+tJsiXu0o7/4Rzf2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789670473; c=relaxed/simple;
	bh=WBt97Tu5Jl1nx4EaQomopAAl4JgpS1n5FhS42z78A8g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N3BVHnG4iQkhv+0ZMWITgp/JHn39E1zshczgDJpyN+Cbg6ru+ETDR/1yNRUFZkIiGZxasfHmZPrpfcRnCinVemEAudvA3fci1t4bEQKCF6h9tCfw4+MTFFbyYurQVlsFjxtbC6yeVDQePxPPeYwp3DmZxAICQAwJqvbDQVCePdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zTdUdS1Q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zTdUdS1Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8A691F000FF;
	Thu, 17 Sep 2026 18:41:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789670472;
	bh=LjRmgCALP0QA8ShSe8gig6mNDNc8VvzdSccQ0zyLro0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zTdUdS1QxC3jAUFSA/6i9i1S/wX9O1t4zFAZ2w7eBSz/R+W+oRzf0HMdX34CBPEVn
	 GXx708NziSHRlXexxZXbashOJiTa7SEEOf8VnPnwrzvKKYjQhmXlzkyO3ApEvkEVvY
	 f4LoxPKRnsbktpdEzU5LI/SjAUwsC0SbXdxbeEFk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	VEGA <vega@nebusec.ai>,
	Joe Damato <joe@dama.to>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0671/1102] eth: nfp: bound the ntuple rule dump by the callers buffer size
Date: Thu, 17 Sep 2026 16:10:14 +0100
Message-ID: <20260917151557.071337536@linuxfoundation.org>
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



