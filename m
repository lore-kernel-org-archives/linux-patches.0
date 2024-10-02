Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F8181D096E;
	Wed,  2 Oct 2024 14:40:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727880009; cv=none; b=SwmH7avj88EnLTHUGkBL965m2jTAJauGAZNAo89Dw2Gw/LPrV6TNOC/HpSRTTUspRj69wWe8ynfISjguWi2DzdCZHq9KTlq3eMHuPHxcEh5o2CYxyMQTUDmDIKepfMWQ5Yf1vLXb7/kIswHARx4YtEpY39aNg49Qys6LuwUHfk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727880009; c=relaxed/simple;
	bh=pGp97DpmRADn31TnHbo6FLB5AZD/MEfRJn3dJiBAsQA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lTwZy0cCzzvLS0sD3Hu+EZP+VN/OYp8vIR5ELjNkmU/VDg7VTmtEfuBbudyMIaJreKwq/wsKRX1aMVL90gApu0BdOPQvgO7DFemTDL/geijFdkYdM5+zFaWFFpYk9Jg9sk2akksYyLS5gLxNlRpR2K09XWXNGT2HiLRW0/gHTi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1SqA8HNO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1SqA8HNO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CB1EC4CEC2;
	Wed,  2 Oct 2024 14:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727880008;
	bh=pGp97DpmRADn31TnHbo6FLB5AZD/MEfRJn3dJiBAsQA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1SqA8HNOxVTPkb0maFbZ1Ej3iBTFhUXvrbfJbpSXbMKoqNVxNF+8C8VmZ5eY9VTdE
	 +ReXy7zirAJLT1t4D5Ses7y05L3mNAw3VJa5cSheIvwdBTvV8TgE4fZENznbtwj8tp
	 mr/JFEu5soeUNHfU9ERGPuQivmfX+6SmAcPd4rF0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Guralnik <michaelgur@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 313/538] RDMA/mlx5: Limit usage of over-sized mkeys from the MR cache
Date: Wed,  2 Oct 2024 14:59:12 +0200
Message-ID: <20241002125804.772544059@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Guralnik <michaelgur@nvidia.com>

[ Upstream commit ee6d57a2e13d11ce9050cfc3e3b69ef707a44a63 ]

When searching the MR cache for suitable cache entries, don't use mkeys
larger than twice the size required for the MR.
This should ensure the usage of mkeys closer to the minimal required size
and reduce memory waste.

On driver init we create entries for mkeys with clear attributes and
powers of 2 sizes from 4 to the max supported size.
This solves the issue for anyone using mkeys that fit these
requirements.

In the use case where an MR is registered with different attributes,
like an access flag we can't UMR, we'll create a new cache entry to store
it upon dereg.
Without this fix, any later registration with same attributes and smaller
size will use the newly created cache entry and it's mkeys, disregarding
the memory waste of using mkeys larger than required.

For example, one worst-case scenario can be when registering and
deregistering a 1GB mkey with ATS enabled which will cause the creation of
a new cache entry to hold those type of mkeys. A user registering a 4k MR
with ATS will end up using the new cache entry and an mkey that can
support a 1GB MR, thus wasting x250k memory than actually needed in the HW.

Additionally, allow all small registration to use the smallest size
cache entry that is initialized on driver load even if size is larger
than twice the required size.

Fixes: 73d09b2fe833 ("RDMA/mlx5: Introduce mlx5r_cache_rb_key")
Signed-off-by: Michael Guralnik <michaelgur@nvidia.com>
Link: https://patch.msgid.link/8ba3a6e3748aace2026de8b83da03aba084f78f4.1725362530.git.leon@kernel.org
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/mr.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index 50a1786231c77..9e465cf99733e 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -48,6 +48,7 @@ enum {
 	MAX_PENDING_REG_MR = 8,
 };
 
+#define MLX5_MR_CACHE_PERSISTENT_ENTRY_MIN_DESCS 4
 #define MLX5_UMR_ALIGN 2048
 
 static void
@@ -715,6 +716,7 @@ mkey_cache_ent_from_rb_key(struct mlx5_ib_dev *dev,
 {
 	struct rb_node *node = dev->cache.rb_root.rb_node;
 	struct mlx5_cache_ent *cur, *smallest = NULL;
+	u64 ndescs_limit;
 	int cmp;
 
 	/*
@@ -733,10 +735,18 @@ mkey_cache_ent_from_rb_key(struct mlx5_ib_dev *dev,
 			return cur;
 	}
 
+	/*
+	 * Limit the usage of mkeys larger than twice the required size while
+	 * also allowing the usage of smallest cache entry for small MRs.
+	 */
+	ndescs_limit = max_t(u64, rb_key.ndescs * 2,
+			     MLX5_MR_CACHE_PERSISTENT_ENTRY_MIN_DESCS);
+
 	return (smallest &&
 		smallest->rb_key.access_mode == rb_key.access_mode &&
 		smallest->rb_key.access_flags == rb_key.access_flags &&
-		smallest->rb_key.ats == rb_key.ats) ?
+		smallest->rb_key.ats == rb_key.ats &&
+		smallest->rb_key.ndescs <= ndescs_limit) ?
 		       smallest :
 		       NULL;
 }
@@ -986,7 +996,7 @@ int mlx5_mkey_cache_init(struct mlx5_ib_dev *dev)
 	mlx5_mkey_cache_debugfs_init(dev);
 	mutex_lock(&cache->rb_lock);
 	for (i = 0; i <= mkey_cache_max_order(dev); i++) {
-		rb_key.ndescs = 1 << (i + 2);
+		rb_key.ndescs = MLX5_MR_CACHE_PERSISTENT_ENTRY_MIN_DESCS << i;
 		ent = mlx5r_cache_create_ent_locked(dev, rb_key, true);
 		if (IS_ERR(ent)) {
 			ret = PTR_ERR(ent);
-- 
2.43.0



