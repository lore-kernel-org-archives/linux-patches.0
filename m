Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BA831D86DC;
	Mon, 23 Jun 2025 22:03:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716226; cv=none; b=WgL8aLVa8TJWzFIuPnyA/dYkxMovaIr//+T490ij39QI1RhKNyyH27t887gxbkuDBs9ergyuDoecEci48lOD6VV/HCtba8Qqw4tEs46EvN7kB2a8011U6+kRpDWZ13EW2tgceIMq1yexdyxcr6Jyw/t6QlQwkaF8BNcWhQkyRvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716226; c=relaxed/simple;
	bh=JIRuRj+BIDM7LwpV1ebU4+TiBDsH/n+/SOekI2dtqiI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C2jsdHlUYkCmTMTvhx/9SeF7IC+s25Smdhgovy1nUbAA7ehynNXdKUAym14JoAlKxMyYw0RLtjKEg3qgFVy7E7AsCWiTu4wOnyxYQsuXiOKGfWlrZiRK51CmakK6G/Np6LfkozKw9DY/g19ufh1L7RDdxGDOxLY+IR9mjdiWyxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AoOf0wGo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AoOf0wGo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97034C4CEEA;
	Mon, 23 Jun 2025 22:03:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716225;
	bh=JIRuRj+BIDM7LwpV1ebU4+TiBDsH/n+/SOekI2dtqiI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AoOf0wGoNtyE7X8CWnu034/VidKPeTZ1ZBvIcRzpJE/KZza60jlGVZol66Bd45NUQ
	 qcBhs8ZzO1sG4ewAsSqOBdOcqPAyp5EH3C2a4KhauSRfld1bXkk++91DdG1GZLL2Jw
	 Htfm8XyIhOl8unKy1J51PK2YnBx9QBx04jb6h8UE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Machata <petrm@nvidia.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 258/414] vxlan: Do not treat dst cache initialization errors as fatal
Date: Mon, 23 Jun 2025 15:06:35 +0200
Message-ID: <20250623130648.490119476@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 474faccf75fd9..1a70770938001 100644
--- a/drivers/net/vxlan/vxlan_core.c
+++ b/drivers/net/vxlan/vxlan_core.c
@@ -605,10 +605,10 @@ static int vxlan_fdb_append(struct vxlan_fdb *f,
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



