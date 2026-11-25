Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624199;
	b=XXSE8wAgkI2A6QtHiJah3USUnZ3Xn4zybW8GvaAV204gN+rq6k5fxZcyP967RC0ROp+N
	 +P2UyQC3eC2nXQLnD9/n9UkMDmfLZChq9xzeDhf9QX4Jno9uCHahsnMYZvbGqiTtefmlD
	 DgttjGl9OCS14+4AZF6ndqa3LI9DmlvpKXunpRbK+hcbf6GlglPq1LmJubzZlZrSs9/0b
	 uXa6n+y+0omDZowkV0lMmp75liJ+RQ/ML0YpOTaZZT1QMsllnCp6d00l/sefEo2A2VQwl
	 AvsuQuLXXgQNhXs/4XjN46Am59bP0SkF+3kJwo+Sq0BpVCajRv2/MZ6jmNNbJf/TIYQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624199;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Rz5wGvD2DX4Hj+52hovqtQgdA8wZNkTWKH6vOpGlpJs=;
	b=d5mFtxbjcvR9X9ZHNLXkaFZ8wbMZTOwXVWCmHgjXfLhc4XfxGUsdxt/DpmBTXbca43X9
	 9ag9gw2ogPzGQIQ97FiCEitV1m7TEHp78XptkgaE0Dy9LhInGBdm4q8GAcuAXtrBspXUd
	 f/Eh6t/e/kightkqprEOWhIA7mg+lGMj5AwmbfQYly9ikBAc3TTySeVGnAifQFyVQY9T0
	 ySBF703b/D+rVAxOPh7JyCWxm//3E7AxZxBZozdxhXfAvZ5t6xldgJXPnExt4JP15So8r
	 4kJbnW5B5R9spFhvRILit264cavc4RVg0PV1/iqSwN/GP64D7oV3gB0+ojqB/vYbMpw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ilsMtAGO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61B85606A329;
	Wed, 25 Nov 2026 16:29:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ilsMtAGO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 042B21F000E6;
	Wed, 25 Nov 2026 16:29:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624198;
	bh=Rz5wGvD2DX4Hj+52hovqtQgdA8wZNkTWKH6vOpGlpJs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ilsMtAGOvT+HxJtVlb3h1o7Oq5oxr4BGlAcmRg+z+oyoPsAI34K56lt5ZK7kpbv1k
	 htTOmxvmw/HXuWkjQxscvq3EM8T2si8t3G47Xhrnma+WD68+9B5ba+r4aRNbQurO4k
	 3fCzRnAANvHHgsz4P1GzI8PQ3KVU2NCRzI8Jrc3M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joas Antonio dos Santos <joasantonio108@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Dave Miller <davem@davem-thinkpadp1gen8.ibmlond.csb>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 115/816] net/mlx5: macsec: free struct mlx5_fs_id after an RCU grace period
Date: Wed, 25 Nov 2026 15:27:43 +0100
Message-ID: <20261125143851.874172286@linuxfoundation.org>
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

From: Joas Antonio dos Santos <joasantonio108@gmail.com>

[ Upstream commit 902407bc588575af0ceae5de4f635fe1e024f258 ]

macsec_fs_id_del() removes a struct mlx5_fs_id from its rhashtable with
rhashtable_remove_fast() and then frees it with kfree() right away.

The TX (SCI) table is read locklessly from the transmit path:
mlx5e_macsec_handle_tx_skb() and mlx5e_macsec_tx_build_eseg() call
mlx5_macsec_fs_get_fs_id_from_hashtable(), which does
rhashtable_lookup() under rcu_read_lock() and then reads
mlx5_fs_id->id. A transmit that looked the entry up just before it was
removed reads freed memory.

Before commit d4ece08f4b1d ("net/mlx5: Maintain fs_id xarray per MACsec
device inside macsec steering") the SCI table held struct
mlx5e_macsec_sa directly, and mlx5e_macsec_del_txsa() freed it with
kfree_rcu_mightsleep(). That commit moved the table into macsec_fs.c
with the new struct mlx5_fs_id, but frees it with a plain kfree().

Add an rcu_head to struct mlx5_fs_id and free it with kfree_rcu().

The same issue was flagged by the Sashiko AI review as a pre-existing
problem while reviewing the HW-GRO for PSP series.

Fixes: d4ece08f4b1d ("net/mlx5: Maintain fs_id xarray per MACsec device inside macsec steering")
Link: https://lore.kernel.org/all/20260909065542.4B80D1F00ACA@smtp.kernel.org/
Signed-off-by: Joas Antonio dos Santos <joasantonio108@gmail.com>
Assisted-by: Yaga Agent HackerSec Claude:claude-opus-5-5
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Dave Miller <davem@davem-thinkpadp1gen8.ibmlond.csb>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/lib/macsec_fs.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/macsec_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/macsec_fs.c
index 4a078113e292d..3d2473d9f3eac 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/macsec_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/macsec_fs.c
@@ -98,6 +98,7 @@ struct mlx5_fs_id {
 	refcount_t refcnt;
 	sci_t sci;
 	struct rhash_head hash;
+	struct rcu_head rcu;
 };
 
 struct mlx5_macsec_device {
@@ -688,7 +689,7 @@ static void macsec_fs_id_del(struct list_head *macsec_devices_list, u32 fs_id,
 
 	xa_erase(fs_id_xa, fs_id);
 
-	kfree(fs_id_found);
+	kfree_rcu(fs_id_found, rcu);
 
 	if (macsec_fs_is_macsec_device_empty(macsec_device)) {
 		list_del(&macsec_device->macsec_devices_list_entry);
-- 
2.53.0



