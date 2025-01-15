Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ABE3248BBD;
	Wed, 15 Jan 2025 10:47:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938034; cv=none; b=TbXdyAbxlg4Un8Vc72blEwt2uTKbilVB0s6oDc4PX3TX/Xa/rlYEkCKnu9Bclp+rHuFcMfAU5xHWfnjH4/9UAUCxDU/4Vyih8F31S5QLy0/4ZzzfT7q39tpyVoVFOp2gBz4pF0n+Xxxq9wOvmH00kcKMNVJT+sz0w7dwu+MtlwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938034; c=relaxed/simple;
	bh=UHKE67PtfYTmLiH13SV84tb9qg6FG8qmsLmnmq3IdoA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kkc0OPfEJAm+96Sa4gtSkAG6rru3/m9jf7zhj33y5kRwcnROHHLBFYoB9dyEcpnfGVaIWmoIg2Lv/ctuGSWOXbU/5f7rJ9NIRVemfr7v1kZpIF8EkJkm8fJn0vNrWjebzjxqPq0Uk2Vw+njXF0ypsrgG7rnYlkF3ewSAuDv6egA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n9YXWatq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n9YXWatq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80ED4C4CEDF;
	Wed, 15 Jan 2025 10:47:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938034;
	bh=UHKE67PtfYTmLiH13SV84tb9qg6FG8qmsLmnmq3IdoA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n9YXWatqexiV5kR65wySeqxNobHVBp+y9ky6cnMcyXRJ+W+TGAa/HbloOaaR4wLks
	 MiqtlFG2PCiwX8zfWF/c2E2NV5f9ngXle/0+ZoJbk8mt+iuSBHLoTXAfsKiSrgG207
	 Dvv4Dye4oeRtKUJoeyGV8JW9tHBY4dGrSi8LLNvU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 034/189] net: dont dump Tx and uninitialized NAPIs
Date: Wed, 15 Jan 2025 11:35:30 +0100
Message-ID: <20250115103607.719510078@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103606.357764746@linuxfoundation.org>
References: <20250115103606.357764746@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit fd48f071a3d6d51e737e953bb43fe69785cf59a9 ]

We use NAPI ID as the key for continuing dumps. We also depend
on the NAPIs being sorted by ID within the driver list. Tx NAPIs
(which don't have an ID assigned) break this expectation, it's
not currently possible to dump them reliably. Since Tx NAPIs
are relatively rare, and can't be used in doit (GET or SET)
hide them from the dump API as well.

Fixes: 27f91aaf49b3 ("netdev-genl: Add netlink framework functions for napi")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20250103183207.1216004-1-kuba@kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/netdev-genl.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/core/netdev-genl.c b/net/core/netdev-genl.c
index d58270b48cb2..c639acb5abfd 100644
--- a/net/core/netdev-genl.c
+++ b/net/core/netdev-genl.c
@@ -173,8 +173,7 @@ netdev_nl_napi_fill_one(struct sk_buff *rsp, struct napi_struct *napi,
 	if (!hdr)
 		return -EMSGSIZE;
 
-	if (napi->napi_id >= MIN_NAPI_ID &&
-	    nla_put_u32(rsp, NETDEV_A_NAPI_ID, napi->napi_id))
+	if (nla_put_u32(rsp, NETDEV_A_NAPI_ID, napi->napi_id))
 		goto nla_put_failure;
 
 	if (nla_put_u32(rsp, NETDEV_A_NAPI_IFINDEX, napi->dev->ifindex))
@@ -254,6 +253,8 @@ netdev_nl_napi_dump_one(struct net_device *netdev, struct sk_buff *rsp,
 		return err;
 
 	list_for_each_entry(napi, &netdev->napi_list, dev_list) {
+		if (napi->napi_id < MIN_NAPI_ID)
+			continue;
 		if (ctx->napi_id && napi->napi_id >= ctx->napi_id)
 			continue;
 
-- 
2.39.5



