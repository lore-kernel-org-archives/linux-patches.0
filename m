Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16CC222A813;
	Sat, 25 Oct 2025 16:26:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409589; cv=none; b=MzOwmiW27YvICyHU8w5/7PLBv61/d+TfZwlNvgSLB9mrWqJeK25+rJEodj7TAoxQKkqwR4L5+yF0zoKYInuupOU187k4UJrgCUDvlSW/AcruRSSU2qQ4+VvalC/oYPTd+c/uoT/ztic3E3+XVYaNSTLl0YgX0AXewI6YZzmdaKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409589; c=relaxed/simple;
	bh=/IhRMrnVGIhxtU6N+34X448FuGb7y/8d+aNopWtQiBA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CsdsD0VQQBfJzPGiinOkxnW59KgLjnf5k7+BNQOtyn7hwvyHnTDP1lsnF3xBcjl1sKEoZL6sFFaCtp1fwCIrzr3rPkg77M6pHBxYX8HVtCgD3d7rGgIgBGDV0nNpmwyTxSA2FqilX5QKzBuLeUQ5lu7tntlmbprEp6MoYVIm8uA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C6BiGn+k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C6BiGn+k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C555C4CEF5;
	Sat, 25 Oct 2025 16:26:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409589;
	bh=/IhRMrnVGIhxtU6N+34X448FuGb7y/8d+aNopWtQiBA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C6BiGn+klD6kM1bZtsjemwKg9MjZRucAAW+JIO2v44ffdqj+GWmBTVaF2bobW7nv6
	 CzpG6C5MMadnj1A+olauOqdhGRjNweEO7kslkuOhGd5Czx5EYjls19FFVVu1+aHLpc
	 OEpedE50C4cuQe/NDxVVS2bNza5ovDUfP2ygLuX7CbljpINTh2jkwOq95DeTvMjr9f
	 hiKkOQfwi1jLinbpv1TkFSX+F4EpLFVFs9ysk9FYuL4Fy4HPoanovHnNzxj/Sy7Ghl
	 XQXT/HkdahSAwdicyctWwAEhg4MxOrzI7d3vcalkWO2HxnaxnqXzE3TZ2kQz2burs7
	 g+3X0ZhFrQeoQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Bhargava Marreddy <bhargava.marreddy@broadcom.com>,
	Vikas Gupta <vikas.gupta@broadcom.com>,
	Rajashekar Hudumula <rajashekar.hudumula@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.17] bng_en: make bnge_alloc_ring() self-unwind on failure
Date: Sat, 25 Oct 2025 12:00:10 -0400
Message-ID: <20251025160905.3857885-379-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Bhargava Marreddy <bhargava.marreddy@broadcom.com>

[ Upstream commit 9ee5994418bb527788e77361d338af40a126aa21 ]

Ensure bnge_alloc_ring() frees any intermediate allocations
when it fails. This enables later patches to rely on this
self-unwinding behavior.

Signed-off-by: Bhargava Marreddy <bhargava.marreddy@broadcom.com>
Reviewed-by: Vikas Gupta <vikas.gupta@broadcom.com>
Reviewed-by: Rajashekar Hudumula <rajashekar.hudumula@broadcom.com>
Link: https://patch.msgid.link/20250919174742.24969-2-bhargava.marreddy@broadcom.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES
- Change makes `bnge_alloc_ring()` jump to `err_free_ring` and call
  `bnge_free_ring()` whenever a DMA page or the optional `vzalloc()`
  fails (`drivers/net/ethernet/broadcom/bnge/bnge_rmem.c:93-125`). That
  guarantees every partially allocated page, page-table entry, and vmem
  buffer is released before the function returns `-ENOMEM`.
- Without this patch, callers such as `alloc_one_cp_ring()` leak DMA
  buffers on allocation failure: its error path only invokes
  `bnge_free_cp_desc_arr()` which frees the host-side arrays but not the
  coherent allocations
  (`drivers/net/ethernet/broadcom/bnge/bnge_netdev.c:239-246` together
  with `drivers/net/ethernet/broadcom/bnge/bnge_netdev.c:112-121`).
  Similar allocation sites rely on `bnge_alloc_ring()` to clean up for
  them, so the leak is user-visible under memory pressure.
- `bnge_free_ring()` already tolerates partially initialized state,
  skipping NULL slots and resetting pointers
  (`drivers/net/ethernet/broadcom/bnge/bnge_rmem.c:36-66`), so even
  callers that still run their normal unwind paths (e.g.
  `bnge_free_nq_tree()` and `bnge_free_tx_rings()`) remain safe—double
  frees are avoided because the pointers are nulled.
- Scope is limited to the new `bng_en` driver; no interfaces or success
  paths change. The fix eliminates a real leak and carries very low
  regression risk, making it a good candidate for stable backporting.

 drivers/net/ethernet/broadcom/bnge/bnge_rmem.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnge/bnge_rmem.c b/drivers/net/ethernet/broadcom/bnge/bnge_rmem.c
index 52ada65943a02..98b4e9f55bcbb 100644
--- a/drivers/net/ethernet/broadcom/bnge/bnge_rmem.c
+++ b/drivers/net/ethernet/broadcom/bnge/bnge_rmem.c
@@ -95,7 +95,7 @@ int bnge_alloc_ring(struct bnge_dev *bd, struct bnge_ring_mem_info *rmem)
 						     &rmem->dma_arr[i],
 						     GFP_KERNEL);
 		if (!rmem->pg_arr[i])
-			return -ENOMEM;
+			goto err_free_ring;
 
 		if (rmem->ctx_mem)
 			bnge_init_ctx_mem(rmem->ctx_mem, rmem->pg_arr[i],
@@ -116,10 +116,13 @@ int bnge_alloc_ring(struct bnge_dev *bd, struct bnge_ring_mem_info *rmem)
 	if (rmem->vmem_size) {
 		*rmem->vmem = vzalloc(rmem->vmem_size);
 		if (!(*rmem->vmem))
-			return -ENOMEM;
+			goto err_free_ring;
 	}
-
 	return 0;
+
+err_free_ring:
+	bnge_free_ring(bd, rmem);
+	return -ENOMEM;
 }
 
 static int bnge_alloc_ctx_one_lvl(struct bnge_dev *bd,
-- 
2.51.0

