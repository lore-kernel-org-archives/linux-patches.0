Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E32F4DEC26;
	Wed, 30 Sep 2026 18:21:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792481; cv=none; b=fLRWp0sOAj76uJmp+04zKUtgk8tQ6KXuK5Jb387j1C4ow4j9CGlGH+S4Q28DLFCaHzg5GdSVujUCoD1Aoubdx+ajx9V9MSInhjzQflY2mmZIXTwF+hJh3c7ftomiaMhnX7FS02XjWtz9zs1NEhkmV3ruoW7lHkXDTCyI0405f6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792481; c=relaxed/simple;
	bh=tgq57Qj9qBa/69AhPpdknis7afTe05oaGw5s3QRflZc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MTI08SH4YHb3BF76TtvJEVPnoKLFWB+9MBi37sCTX+0riPTNJjEEdkcIY6vIGfPvBsm32uoLgh1ccL/TnJwX5E8aqQ63ndFTRa/K+hbwUYbGj/ImY0e9bqcJVuTnbNF216PKex2ICXR8GA5+z/vbAGoCsdwRhi7bcZqfs8eM2uc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rbHQeSbo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rbHQeSbo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A945A1F00898;
	Wed, 30 Sep 2026 18:21:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792480;
	bh=K7ZRFwGne1UGfX6YInir5NJT44N/gsfzCFt33wNHFVs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rbHQeSboS7rvTES1uCwauH144m9qx1SjyxFoEUS8Ypp7E2s8X2KtCWnHbKZOVw3TM
	 x3LAFp8fpT3hFpmbZNEIlVzoXJPPyVf+gPZ2Ujul3zXeuxFUT0e+wDiz9UVVCkgI0T
	 +B9b09nkYx2Fx4kTjuHuFMiW71gl6sl9OtWZZRFM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karsten Graul <kgraul@linux.ibm.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 671/752] net/smc: stop links when their GID is removed
Date: Wed, 30 Sep 2026 17:29:01 +0200
Message-ID: <20260930152412.771078207@linuxfoundation.org>
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

From: Karsten Graul <kgraul@linux.ibm.com>

[ Upstream commit 29397e34c76b57ce596493008176cf374f1cb867 ]

With SMC-Rv2 the GID is an IP address that can be deleted from the
device. When an IB_EVENT_GID_CHANGE event is provided then iterate over
all active links and check if their GID is still defined. Otherwise
stop the affected link.

Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 61cb282fe97b ("net/smc: fix UAF on lgr list traversal in smcr_port_err()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/smc/smc_ib.c | 53 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 53 insertions(+)

diff --git a/net/smc/smc_ib.c b/net/smc/smc_ib.c
index f0ec1f1d50fac..04a8612529b36 100644
--- a/net/smc/smc_ib.c
+++ b/net/smc/smc_ib.c
@@ -217,6 +217,58 @@ int smc_ib_determine_gid(struct smc_ib_device *smcibdev, u8 ibport,
 	return -ENODEV;
 }
 
+/* check if gid is still defined on smcibdev */
+static bool smc_ib_check_link_gid(u8 gid[SMC_GID_SIZE], bool smcrv2,
+				  struct smc_ib_device *smcibdev, u8 ibport)
+{
+	const struct ib_gid_attr *attr;
+	bool rc = false;
+	int i;
+
+	for (i = 0; !rc && i < smcibdev->pattr[ibport - 1].gid_tbl_len; i++) {
+		attr = rdma_get_gid_attr(smcibdev->ibdev, ibport, i);
+		if (IS_ERR(attr))
+			continue;
+
+		rcu_read_lock();
+		if ((!smcrv2 && attr->gid_type == IB_GID_TYPE_ROCE) ||
+		    (smcrv2 && attr->gid_type == IB_GID_TYPE_ROCE_UDP_ENCAP &&
+		     !(ipv6_addr_type((const struct in6_addr *)&attr->gid)
+				     & IPV6_ADDR_LINKLOCAL)))
+			if (!memcmp(gid, &attr->gid, SMC_GID_SIZE))
+				rc = true;
+		rcu_read_unlock();
+		rdma_put_gid_attr(attr);
+	}
+	return rc;
+}
+
+/* check all links if the gid is still defined on smcibdev */
+static void smc_ib_gid_check(struct smc_ib_device *smcibdev, u8 ibport)
+{
+	struct smc_link_group *lgr;
+	int i;
+
+	spin_lock_bh(&smc_lgr_list.lock);
+	list_for_each_entry(lgr, &smc_lgr_list.list, list) {
+		if (strncmp(smcibdev->pnetid[ibport - 1], lgr->pnet_id,
+			    SMC_MAX_PNETID_LEN))
+			continue; /* lgr is not affected */
+		if (list_empty(&lgr->list))
+			continue;
+		for (i = 0; i < SMC_LINKS_PER_LGR_MAX; i++) {
+			if (lgr->lnk[i].state == SMC_LNK_UNUSED ||
+			    lgr->lnk[i].smcibdev != smcibdev)
+				continue;
+			if (!smc_ib_check_link_gid(lgr->lnk[i].gid,
+						   lgr->smc_version == SMC_V2,
+						   smcibdev, ibport))
+				smcr_port_err(smcibdev, ibport);
+		}
+	}
+	spin_unlock_bh(&smc_lgr_list.lock);
+}
+
 static int smc_ib_remember_port_attr(struct smc_ib_device *smcibdev, u8 ibport)
 {
 	int rc;
@@ -255,6 +307,7 @@ static void smc_ib_port_event_work(struct work_struct *work)
 		} else {
 			clear_bit(port_idx, smcibdev->ports_going_away);
 			smcr_port_add(smcibdev, port_idx + 1);
+			smc_ib_gid_check(smcibdev, port_idx + 1);
 		}
 	}
 }
-- 
2.53.0



