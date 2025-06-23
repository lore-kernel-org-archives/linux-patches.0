Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85A302222B2;
	Mon, 23 Jun 2025 22:23:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750717416; cv=none; b=aTGbrMDEYZvSJ3/z8VuTcL8q1RmZK3jbqrawvAOoZFSFcOS1eh+AUdm1Q+weeG9mPKkd4t8OXu2p9Guf91UHMzb/D42K53R0v6veHFG12JOQS0PtTzLDbDAA+6X5dTeez5fwsK403B2+OtK4mC80qvnNWZLgRH8X+oSOJKS4NKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750717416; c=relaxed/simple;
	bh=Fi4zxsdL2Us8qdLQrcnwMB2Y9oLAQ59eZBp5Tb5kfGk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q9udM4pdS/2Iuq6/YOMsYZYdHqjxiJGspiLXkVFRLdknievHBz6eDwBPmALvq4g6iu1oR0Q5xv7AXpuJfFgKS1zEo2JiJp6CRD8nIohvMnQ8BRwwsqXiYxTLnGlEl4K6bn58pOOZgA2CbVDdRhciM3iIA6BuzYhpL2bPiNfz30o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sN0+pd4s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sN0+pd4s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D05CC4CEEA;
	Mon, 23 Jun 2025 22:23:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750717416;
	bh=Fi4zxsdL2Us8qdLQrcnwMB2Y9oLAQ59eZBp5Tb5kfGk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sN0+pd4skdTndUBdUAgFY22oJK9uNZ5y4LsupHQWDRuMbPsbqnE2iHfMq85uwUjSb
	 tC28ms5cjyfDiEnVGtt1BvQqD5G2SnsE9Rk97atebiZ21MT+8olcHdthPDMA5uqSBF
	 NBwiq2GK60e48tQvAsCXW/diOMIfqbOTUmBrjIIE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Machata <petrm@nvidia.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 422/508] vxlan: Do not treat dst cache initialization errors as fatal
Date: Mon, 23 Jun 2025 15:07:47 +0200
Message-ID: <20250623130655.574733172@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index ef61eab81707c..747ce00dd321d 100644
--- a/drivers/net/vxlan/vxlan_core.c
+++ b/drivers/net/vxlan/vxlan_core.c
@@ -653,10 +653,10 @@ static int vxlan_fdb_append(struct vxlan_fdb *f,
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



