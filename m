Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017555;
	b=fzRw7SsQKtEWsBODZ74ixbzLsptHpHfGVjbKOtUaCgPmD/vemUhEwcpgZYSdfFdUpeB7
	 FHaYwlKrPDxPyeEaY5eK5HYPYzxiiWzXnwYRrX61E3VMeUr6FYcWICIXMdedbBqq3QhJJ
	 e0rsQY4y78s+7uYR5xrM8kaCgbITh5j+10DxRfSQF5VuopfLoAOV9bDl/cS2hlKlfnPiR
	 Ie92Cutr3LT5lWgGfn6rA7bzCPT3dibjybZUcXtSdqpvnovwGtuQir+UWfOEDEIjz9bn2
	 ESjcN2m2C3kjx1vcsbBDpxmgaMrbA1oD/bGSKmfceyETCI5MClHSgLiVWWD5pW4p2BQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017555;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3myfqHzfKqdxjZW4LX4SY3TmH5dikYLoFO9By5nsHYs=;
	b=vTtIjYCm9lPfFnEgIXik0b9txD3JreO6GtnWmUljas3PKdNZg+Trg/EhuZlVZP3VWcO9
	 6AtpGy4rLUg7suaw4jGefHV8dBkA2ulFjazSOYijAtonL7aiuxDdUZ1x8WHUoqCD0PdFG
	 1egdE4d/MyMNOtCtRy5bXvcw/q1SOljkQlkv27hz1Oqocsa4RehAKVioyb85QmXOzEW88
	 xM2v2ih6APeQ+aJjjwLNAr48YNn5zNDnraAVwyMYLANOV2Odm0tdCKFmauDdXHCpel44U
	 BgTL5qdgth1S3Ph8yZ1As0ARKIhAC4YTslzWtJQ4kbjIWQHc3Q6mSYn4+FZu0/zMi4w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=i6Oh57W2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35B7E606A31C;
	Wed, 18 Nov 2026 15:59:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=i6Oh57W2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C34F1F000C5;
	Wed, 18 Nov 2026 15:59:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017555;
	bh=3myfqHzfKqdxjZW4LX4SY3TmH5dikYLoFO9By5nsHYs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i6Oh57W2UvsckR/hgPmtLbtl4M4gV0E/aH0nG8vt7HODw3w7Bqj+9oUky2EbvevMs
	 hMnokUCFsYkZaTBaMAETaWCUU270GgDHrpUVYWgM3lF7Ds10OEdVoQiZ2akaDLcZ7X
	 TwdmbTt2trqE44+NdRNwyFCvK5Ga2fidBNYPq+LU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0927/2651] iommu/vt-d: Fix iopf refcount leak in nested attach
Date: Wed, 18 Nov 2026 15:36:07 +0100
Message-ID: <20261118150321.258240973@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lu Baolu <baolu.lu@linux.intel.com>

[ Upstream commit 83871c3ae10e3dce95408175df94ecfa0280e15f ]

intel_nested_attach_dev() takes an iopf reference for the new domain but
does not drop the possible reference from the old domain. This leaks
info->iopf_refcount, can keep the device permanently on the iopf queue,
and later triggers WARN_ON(info->iopf_refcount) when PRI is disabled.

Fix this by dropping the possible reference from the old domain after
the nested translation setup completes.

Fixes: 17fce9d2336d9 ("iommu/vt-d: Put iopf enablement in domain attach path")
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/intel/nested.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/iommu/intel/nested.c b/drivers/iommu/intel/nested.c
index 2b979bec56cef..f84fc8b41fde9 100644
--- a/drivers/iommu/intel/nested.c
+++ b/drivers/iommu/intel/nested.c
@@ -59,6 +59,8 @@ static int intel_nested_attach_dev(struct iommu_domain *domain,
 	if (ret)
 		goto disable_iopf;
 
+	iopf_for_domain_remove(old, dev);
+
 	info->domain = dmar_domain;
 	info->domain_attached = true;
 	spin_lock_irqsave(&dmar_domain->lock, flags);
-- 
2.53.0



