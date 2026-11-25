Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622527;
	b=pEusTjIMuzTFn3CvUL7NiDitdkevlCa0SDwlJDJuZ51hIg7WV3cWpebSDHDJsEMtzdU/
	 gYTpmYPkhiz5FX87RfccqDk73VSIWPxd4Je6Flgc9pb9ImaquhHOeU2yAmDVJGG88IMHb
	 90VrEPbAA8h//fxwgoeo9p82EDch9ChSi2UxEzsGgJuPIJ8MnfpIMY9cXyvnblyrg9epy
	 ViOqXUTbaOsbJMHomRQDFQ73z4TuA40rxDwnQ95EY/JChM2oraPwpNxh+h89rI4UANfdT
	 a/w6NbuO+Ah58sJafFIU9Txpuz5wnLjQ0iTeTibZEx4wNJvKEngflVhXEnNeCT1bHaw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622527;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=s9eAb4ckYMl/ZsLopewTuNgi7v1nyczQK4LaP+W7Mi4=;
	b=3NB6k1rkKI4/5yVSWE/EckJV1rQnGGyEMF0qEMjuvJiX053vmeCoLIia+IREOV3ghsMi
	 IWeOHN07ePkpB1C8CV/Dkc9xK4V7KXPwoSE2tFv48OC4CkqvTgKCgsQk/Mdulw9WRxbuf
	 TSU1tUch6fMLlL+ktd8JdJTcrPWmfjOyWKGDXmBqwEwfAYyZobehlLQ8Op6WizW8HA/Jq
	 pRgtc4f3b1NwTiXxVd8ySjXs5LQU2DsH6wmLERiw6beGjntY0jaSjQ0TJWvsZUHQIfuNh
	 u9u+LuOSR/EWrQiZQ6xjoHBexpSuIL9nTSxczOzFa09IJa49X7j5PL5F3Tt/AHR0lPA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bdCxaBOB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8DA6606A31E;
	Wed, 25 Nov 2026 16:02:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bdCxaBOB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7F6A1F000C4;
	Wed, 25 Nov 2026 16:02:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622527;
	bh=s9eAb4ckYMl/ZsLopewTuNgi7v1nyczQK4LaP+W7Mi4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bdCxaBOB2a+k8ZqadOjtWxNpeB5DRTEFJr7SJ58zu9mjYisqxno/htHFcnSM5SVF2
	 OAGRW7e4AvI6vywqQSmqVEH6x31ykYJ25faBStqxz8T9u2KhqtcmKY1nykEngpQ4Gu
	 iNGOSLvePkIgFpMpRnKq9qUewqkJquF0AmWRwfFs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolin Chen <nicolinc@nvidia.com>,
	Mostafa Saleh <smostafa@google.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 566/990] iommu/arm-smmu-v3: Dont rb_erase() a never-inserted stream node
Date: Wed, 25 Nov 2026 15:32:13 +0100
Message-ID: <20261125143835.356142203@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Placed the RB_CLEAR_NODE() loop right after master->num_streams is set, since this tree has no sort() or build_invs context, and dropped the upstream sort comment. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 84dff2f06bcd1..8a678910a18cd 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -3535,6 +3535,9 @@ static int arm_smmu_insert_master(struct arm_smmu_device *smmu,
 		return -ENOMEM;
 	master->num_streams = fwspec->num_ids;
 
+	for (i = 0; i < fwspec->num_ids; i++)
+		RB_CLEAR_NODE(&master->streams[i].node);
+
 	mutex_lock(&smmu->streams_mutex);
 	for (i = 0; i < fwspec->num_ids; i++) {
 		struct arm_smmu_stream *new_stream = &master->streams[i];
@@ -3570,7 +3573,9 @@ static int arm_smmu_insert_master(struct arm_smmu_device *smmu,
 
 	if (ret) {
 		for (i--; i >= 0; i--)
-			rb_erase(&master->streams[i].node, &smmu->streams);
+			if (!RB_EMPTY_NODE(&master->streams[i].node))
+				rb_erase(&master->streams[i].node,
+					 &smmu->streams);
 		kfree(master->streams);
 	}
 	mutex_unlock(&smmu->streams_mutex);
@@ -3589,7 +3594,8 @@ static void arm_smmu_remove_master(struct arm_smmu_master *master)
 
 	mutex_lock(&smmu->streams_mutex);
 	for (i = 0; i < fwspec->num_ids; i++)
-		rb_erase(&master->streams[i].node, &smmu->streams);
+		if (!RB_EMPTY_NODE(&master->streams[i].node))
+			rb_erase(&master->streams[i].node, &smmu->streams);
 	mutex_unlock(&smmu->streams_mutex);
 
 	kfree(master->streams);
-- 
2.53.0



