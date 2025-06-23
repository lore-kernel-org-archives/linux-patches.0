Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E9171EFFA6;
	Mon, 23 Jun 2025 21:29:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714167; cv=none; b=K9LETmTna/c2dJN8K8wxlYMdG30RxgXTS35F2V3hPeH0XK+PI+PMV6vT/CStu337PwBqrUe1odK3D8av4L1+OW2hIY0sn5+h/8ZN1nEzLeBk/1Jhg5flHuNl1DhOe6iavVBw3ZN0iyNzScrngPFijUzvpDQJpIOpobgTD8Vutms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714167; c=relaxed/simple;
	bh=5A9gLUUI6oT34TIW/a7InOgx1uNzHwBdEtF2Rt2i+AU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cPxXg6y6zDzKjtecUk1OtAHq05CS84Rfn76VHq9DF+G9StCTrW5ubm6ks9erlHVg0Kr86YfFztif36gUsP7R98mKMi/ztGdxiPVFpTVPy88G02Ds6r7jBJNQsay+0M/HjWTor4NzRDc1qL694i0e9RW+9VZKfXSuhzgKkaT+RiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o+edq7Tk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o+edq7Tk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA487C4CEEA;
	Mon, 23 Jun 2025 21:29:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714167;
	bh=5A9gLUUI6oT34TIW/a7InOgx1uNzHwBdEtF2Rt2i+AU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o+edq7TkooZUxY15MvDRfE93q0oOigS7jf7hMXHtIuRsLt2jn7G7PrQmWwYd4WXYZ
	 yD/lUQWrji22xrosz42V6WWpalHdg7gUowwlBKwuYI0XRddWxCfgZAhssWLrAK72rW
	 PetZDcVKnQD3BjbEfGzLJOX5QBQ4a6ltRSeZRYwA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Machata <petrm@nvidia.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 394/592] vxlan: Do not treat dst cache initialization errors as fatal
Date: Mon, 23 Jun 2025 15:05:52 +0200
Message-ID: <20250623130709.816401277@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index 9ccc3f09f71b8..e83197fac1e0f 100644
--- a/drivers/net/vxlan/vxlan_core.c
+++ b/drivers/net/vxlan/vxlan_core.c
@@ -610,10 +610,10 @@ static int vxlan_fdb_append(struct vxlan_fdb *f,
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



