Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 380E11E22E6;
	Mon, 23 Jun 2025 22:07:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716444; cv=none; b=P0T+/NJtv/iyICMEJknJZ5voLk09MyRXroEt70RvBDEz7DBHRxiPrybczCPod4BTb+t5Vahy0y66MFXlNfAbBBEJuvFL1Cabhtm0g1XOzlyTMkwHo6uMniKD6xoAWVXio/wQNy6GsbVNMP/pPaaVtVMaPvzEjq67FEoP6xbaA/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716444; c=relaxed/simple;
	bh=zE+RgxG3S9ceMKf22dOL5w4XZSKkb5opHQfmRMxU4fg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CscC3y5zpy8z5BFuv4tFd98aR1fOmMOPq0++HCRRYpDtGo6f6+e+resEmA3V4Q/2KPTVlYlR0ryC6uT7iwd6NmrUDGn9KtneHc+ZmJcrXtKSUXTv52c72RvU7Jg0cuwfWzNmPwnN+eu4UJRP4sQr/aFylHS5hTLQA8Avfo3iv6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AJ05SmRo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AJ05SmRo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3BDFC4CEEA;
	Mon, 23 Jun 2025 22:07:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716444;
	bh=zE+RgxG3S9ceMKf22dOL5w4XZSKkb5opHQfmRMxU4fg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AJ05SmRobzcuTQzz9ybJS3El6tv3daKP4+uN6LgP0X5OalaOqA8G5qaoYFCVyL0TT
	 C7zPzbVaFe6W1ZgfpWl8yQBXHrzTS6Bbqt3NLtd/KVs/LzIpTI3TNcpHMwX2xxPaYj
	 5DHvgEWX785rZ5TAKMSfILTRxHdjVPXOUk2DF6+0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Machata <petrm@nvidia.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 329/411] vxlan: Do not treat dst cache initialization errors as fatal
Date: Mon, 23 Jun 2025 15:07:53 +0200
Message-ID: <20250623130641.928102364@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ido Schimmel <idosch@nvidia.com>

[ Upstream commit 20c76dadc783759fd3819d289c72be590660cc8b ]

FDB entries are allocated in an atomic context as they can be added from
the data path when learning is enabled.

After converting the FDB hash table to rhashtable, the insertion rate
will be much higher (*) which will entail a much higher rate of per-CPU
allocations via dst_cache_init().

When adding a large number of entries (e.g., 256k) in a batch, a small
percentage (< 0.02%) of these per-CPU allocations will fail [1]. This
does not happen with the current code since the insertion rate is low
enough to give the per-CPU allocator a chance to asynchronously create
new chunks of per-CPU memory.

Given that:

a. Only a small percentage of these per-CPU allocations fail.

b. The scenario where this happens might not be the most realistic one.

c. The driver can work correctly without dst caches. The dst_cache_*()
APIs first check that the dst cache was properly initialized.

d. The dst caches are not always used (e.g., 'tos inherit').

It seems reasonable to not treat these allocation failures as fatal.

Therefore, do not bail when dst_cache_init() fails and suppress warnings
by specifying '__GFP_NOWARN'.

[1] percpu: allocation failed, size=40 align=8 atomic=1, atomic alloc failed, no space left

(*) 97% reduction in average latency of vxlan_fdb_update() when adding
256k entries in a batch.

Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20250415121143.345227-14-idosch@nvidia.com
Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/vxlan/vxlan_core.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/vxlan/vxlan_core.c b/drivers/net/vxlan/vxlan_core.c
index 9c4d7bedc7641..91122d4d404b7 100644
--- a/drivers/net/vxlan/vxlan_core.c
+++ b/drivers/net/vxlan/vxlan_core.c
@@ -713,10 +713,10 @@ static int vxlan_fdb_append(struct vxlan_fdb *f,
 	if (rd == NULL)
 		return -ENOMEM;
 
-	if (dst_cache_init(&rd->dst_cache, GFP_ATOMIC)) {
-		kfree(rd);
-		return -ENOMEM;
-	}
+	/* The driver can work correctly without a dst cache, so do not treat
+	 * dst cache initialization errors as fatal.
+	 */
+	dst_cache_init(&rd->dst_cache, GFP_ATOMIC | __GFP_NOWARN);
 
 	rd->remote_ip = *ip;
 	rd->remote_port = port;
-- 
2.39.5



