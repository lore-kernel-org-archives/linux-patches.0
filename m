Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80A8E398911;
	Thu, 17 Sep 2026 15:33:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659217; cv=none; b=R6as+P52Yiv1QVb27YTRDlz/3tSQBM7Vdqn7fp+sZ4tCe1nv/tPPMTacw8xVp4JZzschgSiVdkGnqQs81NA9Lk9xNWHcF/FAKKVOQpmKX/hEp/NSqmhznRao23YFOHQm+8nq/6HVwTKOdnAkzOs1srLn6anJB7JKIT2rAVGdZ+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659217; c=relaxed/simple;
	bh=aQREflve+Vz882UoZFDTAwcfhmZqm09noD/NYR2VVsI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=S7UqLbFA/0RHQj+Tv8t/edMQIOBrngeec+uX80tjqLBj3dVhraKanAZB98EPVlwxbeWTH4tl/TRblHF+xKyZ0v2JP4bCWF8j/uCV7DcWrmZ2c5t2qP4k+AN+IGkdap1k1WWNGQbq36fLKRwFxx3mMA8Uu1UDSefBYJw2v6Sqp2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zzhhhC/8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zzhhhC/8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 893EB1F00898;
	Thu, 17 Sep 2026 15:33:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659209;
	bh=gRiQxntk4SLvR+vBHi68iRqk23v4lTVUh19eE2ecevU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zzhhhC/8K/fSUnFCt3t2+q8Ii3QbnCFbgwG2AVZacb21Bd1EZ03gLsnOHXLuzbcgO
	 l2tVfeY6cEhmrl2rnt6MR9ja/Z2UQKB6aK7w0lY0dwhEyWUQIp7ouPAsyJaVRkFRWX
	 1Ox1ViXwTXleoxHsSiJZa0JGpnVmi/A2uberJUDo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Lizhi Hou <lizhi.hou@amd.com>,
	Taimuraz Kaitmazov <taimuraz@kaitmazov.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 163/733] accel/amdxdna: refuse to flush an imported BO
Date: Thu, 17 Sep 2026 16:07:51 +0100
Message-ID: <20260917151355.139478432@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Taimuraz Kaitmazov <taimuraz@kaitmazov.com>

[ Upstream commit 0ba8e0f90039da68342febf613019f4a68d86620 ]

SYNC_BO clflushes an imported BO's scatterlist. An importer may not do
that: the memory belongs to the exporter, and dma-buf gives the importer
no interface to ask for maintenance on it. Refuse the request instead.

is_import_bo() is (obj)->attach, which covers more than foreign buffers.
A userptr BO arrives through a ubuf, and on a carveout device every share
BO and the device heap arrive through a cbuf, so SYNC_BO answers
-EOPNOTSUPP for those too, including the AMDXDNA_BO_DEV path that flushes
through its heap.

Only the ubuf case gives up maintenance it was getting: on a 64 MiB
userptr BO a 4 KiB sync and a full sync both cost 659 us, this arm having
ignored the range. amdxdna_cbuf_map() fills in only the DMA address and
length, so drm_clflush_sg() already walks zero pages on carveout memory.
Userspace maintains these through the mapping it already holds, as XRT's
buffer::sync() does unless it is told to sync through the driver.

Fixes: dbc8fd7a03cb ("accel/amdxdna: Add expandable device heap support")
Reported-by: Christian König <christian.koenig@amd.com>
Link: https://lore.kernel.org/dri-devel/a505f9e5-b416-43e9-934d-c5c29b8a70e9@amd.com/
Suggested-by: Lizhi Hou <lizhi.hou@amd.com>
Signed-off-by: Taimuraz Kaitmazov <taimuraz@kaitmazov.com>
Reviewed-by: Lizhi Hou <lizhi.hou@amd.com>
Signed-off-by: Lizhi Hou <lizhi.hou@amd.com>
Link: https://patch.msgid.link/20260819224458.257346-5-taimuraz@kaitmazov.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/amdxdna/amdxdna_gem.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/accel/amdxdna/amdxdna_gem.c b/drivers/accel/amdxdna/amdxdna_gem.c
index 2a16de96e6a4e..219dacdfa527c 100644
--- a/drivers/accel/amdxdna/amdxdna_gem.c
+++ b/drivers/accel/amdxdna/amdxdna_gem.c
@@ -1240,6 +1240,9 @@ static int amdxdna_flush_bo(struct amdxdna_gem_obj *abo, u64 offset, u64 size)
 {
 	u64 end;
 
+	if (is_import_bo(abo))
+		return -EOPNOTSUPP;
+
 	if (offset >= abo->mem.size)
 		return -EINVAL;
 
@@ -1250,9 +1253,7 @@ static int amdxdna_flush_bo(struct amdxdna_gem_obj *abo, u64 offset, u64 size)
 	if (!size)
 		return 0;
 
-	if (is_import_bo(abo))
-		drm_clflush_sg(abo->base.sgt);
-	else if (amdxdna_gem_vmap(abo))
+	if (amdxdna_gem_vmap(abo))
 		drm_clflush_virt_range(amdxdna_gem_vmap(abo) + offset, size);
 	else if (abo->base.pages)
 		drm_clflush_pages(abo->base.pages, abo->mem.size >> PAGE_SHIFT);
-- 
2.53.0



