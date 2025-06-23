Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21E981DF98B;
	Mon, 23 Jun 2025 21:13:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713207; cv=none; b=rKPNXoSRiUqPD7UZad53ukJ6aGil6lheff1Sn5ohGQW7ohcafVc+So8jEZU9gzAyyBmxJkFWUd9RzT/4ga5fadW36a3x1mbUfBECuzZcPpDqb1yNSZtfKa9DEumCVZ0d1odimD77srZe4ZiipOnEB3NJ7psp6Wlw6N6eNIFZ9cg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713207; c=relaxed/simple;
	bh=HoC+8hN6TgMbZUbXW5Gd/xud+W3TaDuoOVshO1ZRF60=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MKyF8iM+NYwZ1x2BSidP9duRjGKnB/eJnhgUaI+4n3csuf+eWHsGC4zenZHdMQoOS2Bw3kx4QYY1JN0iTfA9dTVsKdXeSpUpZeTzX5hXAE+vVp6/yjUGSI4DvGpHeZ9tJNq9i6C2el1WAdOhRC/tFBi5lBGAH0Tf06Fb3ZqPEJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Urrn5ksW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Urrn5ksW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B01D7C4CEEA;
	Mon, 23 Jun 2025 21:13:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713207;
	bh=HoC+8hN6TgMbZUbXW5Gd/xud+W3TaDuoOVshO1ZRF60=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Urrn5ksWUXn7R4Zt99dj+Lyof+9kK2n1Dc9gpM8/R4HSg5iYDM67i5l6ZxBhvmBtU
	 xWki0HsKtNLrPT7m14rqLr9Ct8tL65ikR5FQKXji1JgCsgBS+pkFawe/2D/8YPKmLo
	 HvTe/QN3FIR/9JJ+XiNlImOjYd5zHQpfPuhRopmE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Machata <petrm@nvidia.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 174/222] vxlan: Do not treat dst cache initialization errors as fatal
Date: Mon, 23 Jun 2025 15:08:29 +0200
Message-ID: <20250623130617.301708346@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130611.896514667@linuxfoundation.org>
References: <20250623130611.896514667@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/net/vxlan.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
index 7105ac37f341e..18844bac9375e 100644
--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -681,10 +681,10 @@ static int vxlan_fdb_append(struct vxlan_fdb *f,
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



