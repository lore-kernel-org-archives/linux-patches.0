Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625259;
	b=kKE5D/8sf9CwTqje01PELlcKLFi7MWDKoJiqKf5nzziDFjlFuTpptp2lpQLX5tYJYewY
	 kelbDKEgxFBQRbv9MawMLMYEfh3Ux6P94DJQRE2OS7Mg9zK5YvqblrJRAoPVFCq2AdPnb
	 jki5MeD1KKE6yNPVY3qGmP4s3dZwcJrwVE1IF23X8YrPX8gNOV005tB0bKn8eY8x14z61
	 cMDAGNKHC0Avk5DMTxguihgLT0RAM5HD8Mw6dR/0/CUmgTGT0mCSoWj+mxMMXU0bUbZNU
	 WVJle2QAYRn+fR/QIwqxewboWp75KSuWegkCbmlMJASA9T/nCDW2Nb11MQEeV9pXlZg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625259;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pWSasSQx6mNqQsjp0BqdPJCtKJw+tssrCwAAAql2Xmk=;
	b=gZlviZiBCTRLuE+0+S4uaSyeQ+JPweJAKlAdbezBzCL/Tc3xHZ9yXQX9cGr5wiQVF0Kt
	 JbvymaU1qh044A4/d0mNKuSjh8QYS6BRpH35hOQuU17logZBq5RdUW8ElFHxsClq4crJF
	 3MBHeU9yOqrSKmBkVQuMsw/KxsTtAVCRODwLZBzziaxvlihcWb1lUvY6deFjCcBUIozNs
	 uqEhbULcyi5DeFmycxY2PYrSGQXDLQMAHjXQZpBf7kzhIbR9qM16/YN6U8G09U1conWqn
	 tl39izH91S02a35/dIBShO0Hp1FSB0GhxSOXNQbOi2P7GAhB95dFtF078Lo+vfukdfw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zabXI6fA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF324606A323;
	Wed, 25 Nov 2026 16:47:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zabXI6fA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC1371F000E6;
	Wed, 25 Nov 2026 16:47:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625259;
	bh=pWSasSQx6mNqQsjp0BqdPJCtKJw+tssrCwAAAql2Xmk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zabXI6fAn9I5KAi+9bUw2Su7vXyzi1H7M9o4yx8BAGNn50n6cUc0SGIGPOplSgLRx
	 Ve3QWZgT+OkGf8x5PydhA9k7HW5dTr0RyYBf7riQ7fzoU4amehxEl05Y6mwomogiay
	 48CBtsczu+oWdm4tDv9a//KSVQ/uqIfknEPlsMv8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolin Chen <nicolinc@nvidia.com>,
	Mostafa Saleh <smostafa@google.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 456/816] iommu/arm-smmu-v3: Dont rb_erase() a never-inserted stream node
Date: Wed, 25 Nov 2026 15:33:24 +0100
Message-ID: <20261125143859.745989321@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolin Chen <nicolinc@nvidia.com>

[ Upstream commit 2888520bdcbe0599cfc77b2fad8dc6c95505a3cb ]

arm_smmu_insert_master() skips inserting a stream whose StreamID duplicates
one the same master already owns (bridged PCI devices can present duplicate
IDs), leaving that master->streams[i].node zeroed and unlinked from the
smmu->streams rb-tree.

Both the insert error-rollback loop and arm_smmu_remove_master() then call
rb_erase() on every master->streams[i].node unconditionally. rb_erase() on
a zeroed node sees a NULL parent, treats the node as the tree root and sets
root->rb_node = NULL, silently emptying the whole SID tree and breaking SID
lookups (and DMA) for every other master on the SMMU.

Mark each node with RB_CLEAR_NODE() after sort_nonatomic() reorders the
array, since sorting relocates the entries and would leave the earlier
self-referential RB_CLEAR_NODE() pointer stale. An un-inserted node then
stays RB_EMPTY_NODE() and is skipped in both erase loops; inserted nodes
are linked by rb_find_add() and erased as before.

Fixes: b00d24997a11 ("iommu/arm-smmu-v3: Fix iommu_device_probe bug due to duplicated stream ids")
Assisted-by: LLM
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
Reviewed-by: Mostafa Saleh <smostafa@google.com>
Signed-off-by: Will Deacon <will@kernel.org>
[ sashal: Dropped the upstream ordering comment and placed the RB_CLEAR_NODE() loop before mutex_lock(), since this tree has no build_invs allocation or sort step. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index af3070db47460..5e19fce65e2ba 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -3242,6 +3242,9 @@ static int arm_smmu_insert_master(struct arm_smmu_device *smmu,
 		return -ENOMEM;
 	master->num_streams = fwspec->num_ids;
 
+	for (i = 0; i < fwspec->num_ids; i++)
+		RB_CLEAR_NODE(&master->streams[i].node);
+
 	mutex_lock(&smmu->streams_mutex);
 	for (i = 0; i < fwspec->num_ids; i++) {
 		struct arm_smmu_stream *new_stream = &master->streams[i];
@@ -3277,7 +3280,9 @@ static int arm_smmu_insert_master(struct arm_smmu_device *smmu,
 
 	if (ret) {
 		for (i--; i >= 0; i--)
-			rb_erase(&master->streams[i].node, &smmu->streams);
+			if (!RB_EMPTY_NODE(&master->streams[i].node))
+				rb_erase(&master->streams[i].node,
+					 &smmu->streams);
 		kfree(master->streams);
 	}
 	mutex_unlock(&smmu->streams_mutex);
@@ -3296,7 +3301,8 @@ static void arm_smmu_remove_master(struct arm_smmu_master *master)
 
 	mutex_lock(&smmu->streams_mutex);
 	for (i = 0; i < fwspec->num_ids; i++)
-		rb_erase(&master->streams[i].node, &smmu->streams);
+		if (!RB_EMPTY_NODE(&master->streams[i].node))
+			rb_erase(&master->streams[i].node, &smmu->streams);
 	mutex_unlock(&smmu->streams_mutex);
 
 	kfree(master->streams);
-- 
2.53.0



