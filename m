Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56AD415A49D;
	Mon, 29 Jan 2024 17:12:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548321; cv=none; b=qdqzGCghUWkA9GYdL3B3lCTOWJdEJCSQT2WotQyZ4orF2fB5G0p9pZZYr5hESTgUtATFf4lD/wta8YXIPlCyB107BE5qVoGQTIBPuVX815XRV8LRGQIqiSrXOy+QUBqZHWRLD2cjm8KaFsn76i9xEVU23fDr22xui1UMIvdjCGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548321; c=relaxed/simple;
	bh=q1qCLBm8DeZg7Nqrk7KLFX4CTAfyYDrD+7gn2P3ks+s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z+DqIBojtMv86xWKvuPQWjUuUMBPrhQMRzZo3tsm7WdJTnyRm2d/oivL7BdDOHx0G2VYMFE0IE2FMSKGKpy98pYJXvfgd+Vn/FJEmZlUbIO3LUmKyBEwZ1+gpbvrXPfZgMPPOKsUuEjAPRhzToosY7GxuzzimAYbacfpD3wnFS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qzgSn2y/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qzgSn2y/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 201F3C433F1;
	Mon, 29 Jan 2024 17:12:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548321;
	bh=q1qCLBm8DeZg7Nqrk7KLFX4CTAfyYDrD+7gn2P3ks+s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qzgSn2y/PO4mmqwacyr7+zMYzOgIr+VR0V1oe7e8GSHE7MxpZlqsqymEfQT1PIPG4
	 wlv52ATJJZ461WqhXBKaDR0eIDWbHP09HfJaxgKs1E/LTsGzuP1VDYep1GaeqjFFro
	 sZLuf/FSnLT3Mwg5EWz7pzMc4n0TuDINbGQykkjw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yajun Deng <yajun.deng@linux.dev>,
	"Mike Rapoport (IBM)" <rppt@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 314/346] memblock: fix crash when reserved memory is not added to memory
Date: Mon, 29 Jan 2024 09:05:45 -0800
Message-ID: <20240129170025.709965392@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yajun Deng <yajun.deng@linux.dev>

[ Upstream commit 6a9531c3a88096a26cf3ac582f7ec44f94a7dcb2 ]

After commit 61167ad5fecd ("mm: pass nid to reserve_bootmem_region()")
nid of a reserved region is used by init_reserved_page() (with
CONFIG_DEFERRED_STRUCT_PAGE_INIT=y) to access node strucure.
In many cases the nid of the reserved memory is not set and this causes
a crash.

When the nid of a reserved region is not set, fall back to
early_pfn_to_nid(), so that nid of the first_online_node will be passed
to init_reserved_page().

Fixes: 61167ad5fecd ("mm: pass nid to reserve_bootmem_region()")
Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
Link: https://lore.kernel.org/r/20240118061853.2652295-1-yajun.deng@linux.dev
[rppt: massaged the commit message]
Signed-off-by: Mike Rapoport (IBM) <rppt@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/memblock.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/memblock.c b/mm/memblock.c
index 5a88d6d24d79..4823ad979b72 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -2141,6 +2141,9 @@ static void __init memmap_init_reserved_pages(void)
 			start = region->base;
 			end = start + region->size;
 
+			if (nid == NUMA_NO_NODE || nid >= MAX_NUMNODES)
+				nid = early_pfn_to_nid(PFN_DOWN(start));
+
 			reserve_bootmem_region(start, end, nid);
 		}
 	}
-- 
2.43.0



