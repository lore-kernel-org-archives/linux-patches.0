Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 713FF15957E;
	Tue, 18 Jun 2024 13:17:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716634; cv=none; b=UVXQD4ynwCwIRZIB3t8RLdRaP4ma/irtojucLElkm4Du8XCPYD84dJxBv/hUOVrWkOXhqo5iQXOFzWZartFkEPyMZnX+HYHbWbf03OqYgzcg/u2GLshEA2Qk/sdy+JGZTtbr5pi7Aj7Q+xD35+uqOeISq8e5bVqSScwlofvKCK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716634; c=relaxed/simple;
	bh=iDLinDzcwHjTCVUuGp0qJeF8wbySA6P8IXQdmkyRnLs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aI/pr6prL2r++5v65Iivt5qokzglLcgHbMsCy2S24KnQRdfs9LnfZhseS0xJYtcH4f1OOXoFCLiFkSmkAYy26HxXaEBL0VKWxGU8wWU/e5rkID6L5FeFrGdZQBE7SAu9K1P8roG/VJCbu/kkN9Iju6FblLCSWb5K7smD8b+/1Sk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rn8Hvz4K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rn8Hvz4K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBE4DC3277B;
	Tue, 18 Jun 2024 13:17:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716634;
	bh=iDLinDzcwHjTCVUuGp0qJeF8wbySA6P8IXQdmkyRnLs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rn8Hvz4Kr3vxk28bwxd+dXp3R43j0ElVKVSBIO1nxEVDQo0URz+ho/cdvAbjUNpxU
	 fKcdGoSI67qOOdQlUC4TeQaieyGWljH37iyhiyYQlqrsEEPc5nAcpB60vI8mAePV8G
	 bq6a8kav7A5+dXSn9OH2/nvhmaVedjPSQ+Gw5wBI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiu Jianfeng <xiujianfeng@huawei.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 711/770] NFSD: Use struct_size() helper in alloc_session()
Date: Tue, 18 Jun 2024 14:39:24 +0200
Message-ID: <20240618123434.716344789@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiu Jianfeng <xiujianfeng@huawei.com>

[ Upstream commit 85a0d0c9a58002ef7d1bf5e3ea630f4fbd42a4f0 ]

Use struct_size() helper to simplify the code, no functional changes.

Signed-off-by: Xiu Jianfeng <xiujianfeng@huawei.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4state.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index d490b19d95ddf..9a8038bfaa0d5 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -1833,13 +1833,12 @@ static struct nfsd4_session *alloc_session(struct nfsd4_channel_attrs *fattrs,
 	int numslots = fattrs->maxreqs;
 	int slotsize = slot_bytes(fattrs);
 	struct nfsd4_session *new;
-	int mem, i;
+	int i;
 
-	BUILD_BUG_ON(NFSD_MAX_SLOTS_PER_SESSION * sizeof(struct nfsd4_slot *)
-			+ sizeof(struct nfsd4_session) > PAGE_SIZE);
-	mem = numslots * sizeof(struct nfsd4_slot *);
+	BUILD_BUG_ON(struct_size(new, se_slots, NFSD_MAX_SLOTS_PER_SESSION)
+		     > PAGE_SIZE);
 
-	new = kzalloc(sizeof(*new) + mem, GFP_KERNEL);
+	new = kzalloc(struct_size(new, se_slots, numslots), GFP_KERNEL);
 	if (!new)
 		return NULL;
 	/* allocate each struct nfsd4_slot and data cache in one piece */
-- 
2.43.0



