Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C2BB344052;
	Tue, 16 Dec 2025 12:29:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765888177; cv=none; b=HWFVicbu0lVlLkHIrL0NdfxktoWHWIYT8vrWdWax21iYtrm0rMnXtjY3MAUS8iv0QcO7wo28qCDXdFk2J98P1q093vBN0GmJlV0DFpQoRXRzjrBYLsp5SjCm4Nx+sjn0QSX8UJX3n+0Oom9GYncXv30gkzJttL4v38DTKHESIhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765888177; c=relaxed/simple;
	bh=qzXTl6cDAe0pm1AwLLR6kq1x6y1Q7wVO6GnD4KvXD2k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y2tQm5sYS/zl8eKAv81b2kjiCARj8XTrYrXhGvNTAGVmUuS5CzohnUX5EsspH4t8YbwDUjWpID23nDiIjy3r3mX6ZSbO4nPlXa+nznnclfkXX8naks69Mi5Ct7tSQULsQdsSdLFtoOyGwBD9ulrrQupBr0ooS4DPCVW8vUOOE8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ctcvzNr8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ctcvzNr8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBCDCC4CEF1;
	Tue, 16 Dec 2025 12:29:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765888177;
	bh=qzXTl6cDAe0pm1AwLLR6kq1x6y1Q7wVO6GnD4KvXD2k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ctcvzNr8aLYq/bZGxSDXMuWELKqMHvF9JDXc7r2vYafmh0afbw018AS+DaUf75i5C
	 R0GbmrolXVdPtXaNmwiJZVXWWwDxgorUix7fA/uIE8OJ69e5QppQ2YwAS48fdlgffh
	 A3fORvN+XCAZX6WSk3PDPUYdHWsNuj30AVskjNAw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Czurylo <krzysztof.czurylo@intel.com>,
	Tatyana Nikolova <tatyana.e.nikolova@intel.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 422/614] RDMA/irdma: Fix data race in irdma_free_pble
Date: Tue, 16 Dec 2025 12:13:09 +0100
Message-ID: <20251216111416.660109928@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Czurylo <krzysztof.czurylo@intel.com>

[ Upstream commit 81f44409fb4f027d1e6d54edbeba5156ad94b214 ]

Protects pble_rsrc counters with mutex to prevent data race.
Fixes the following data race in irdma_free_pble reported by KCSAN:

BUG: KCSAN: data-race in irdma_free_pble [irdma] / irdma_free_pble [irdma]

write to 0xffff91430baa0078 of 8 bytes by task 16956 on cpu 5:
 irdma_free_pble+0x3b/0xb0 [irdma]
 irdma_dereg_mr+0x108/0x110 [irdma]
 ib_dereg_mr_user+0x74/0x160 [ib_core]
 uverbs_free_mr+0x26/0x30 [ib_uverbs]
 destroy_hw_idr_uobject+0x4a/0x90 [ib_uverbs]
 uverbs_destroy_uobject+0x7b/0x330 [ib_uverbs]
 uobj_destroy+0x61/0xb0 [ib_uverbs]
 ib_uverbs_run_method+0x1f2/0x380 [ib_uverbs]
 ib_uverbs_cmd_verbs+0x365/0x440 [ib_uverbs]
 ib_uverbs_ioctl+0x111/0x190 [ib_uverbs]
 __x64_sys_ioctl+0xc9/0x100
 do_syscall_64+0x44/0xa0
 entry_SYSCALL_64_after_hwframe+0x6e/0xd8

read to 0xffff91430baa0078 of 8 bytes by task 16953 on cpu 2:
 irdma_free_pble+0x23/0xb0 [irdma]
 irdma_dereg_mr+0x108/0x110 [irdma]
 ib_dereg_mr_user+0x74/0x160 [ib_core]
 uverbs_free_mr+0x26/0x30 [ib_uverbs]
 destroy_hw_idr_uobject+0x4a/0x90 [ib_uverbs]
 uverbs_destroy_uobject+0x7b/0x330 [ib_uverbs]
 uobj_destroy+0x61/0xb0 [ib_uverbs]
 ib_uverbs_run_method+0x1f2/0x380 [ib_uverbs]
 ib_uverbs_cmd_verbs+0x365/0x440 [ib_uverbs]
 ib_uverbs_ioctl+0x111/0x190 [ib_uverbs]
 __x64_sys_ioctl+0xc9/0x100
 do_syscall_64+0x44/0xa0
 entry_SYSCALL_64_after_hwframe+0x6e/0xd8

value changed: 0x0000000000005a62 -> 0x0000000000005a68

Fixes: e8c4dbc2fcac ("RDMA/irdma: Add PBLE resource manager")
Signed-off-by: Krzysztof Czurylo <krzysztof.czurylo@intel.com>
Signed-off-by: Tatyana Nikolova <tatyana.e.nikolova@intel.com>
Link: https://patch.msgid.link/20251125025350.180-3-tatyana.e.nikolova@intel.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/irdma/pble.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/irdma/pble.c b/drivers/infiniband/hw/irdma/pble.c
index fa6325adaedec..28dfad7f940c2 100644
--- a/drivers/infiniband/hw/irdma/pble.c
+++ b/drivers/infiniband/hw/irdma/pble.c
@@ -506,12 +506,14 @@ int irdma_get_pble(struct irdma_hmc_pble_rsrc *pble_rsrc,
 void irdma_free_pble(struct irdma_hmc_pble_rsrc *pble_rsrc,
 		     struct irdma_pble_alloc *palloc)
 {
-	pble_rsrc->freedpbles += palloc->total_cnt;
-
 	if (palloc->level == PBLE_LEVEL_2)
 		free_lvl2(pble_rsrc, palloc);
 	else
 		irdma_prm_return_pbles(&pble_rsrc->pinfo,
 				       &palloc->level1.chunkinfo);
+
+	mutex_lock(&pble_rsrc->pble_mutex_lock);
+	pble_rsrc->freedpbles += palloc->total_cnt;
 	pble_rsrc->stats_alloc_freed++;
+	mutex_unlock(&pble_rsrc->pble_mutex_lock);
 }
-- 
2.51.0



