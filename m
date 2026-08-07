Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5F043264D6;
	Fri,  7 Aug 2026 15:20:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116044; cv=none; b=KYDfT5owsAgFxxl2CCEAZO5suG4HLZIyChBKqKpn7b4pRE/bgaMrPxNKrDIsq24Eh/6RHZr2JJmBLanPKPIiRfDeRQap9AqvhBr6nPv9o1cAjsa2k8tsdaJROx4YlW/0wQMV6eHr7fKraZ9XZqNshsZF9ljgMJ4wUGUPZSI8ab8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116044; c=relaxed/simple;
	bh=xpzJZFqoBGrj5Mk6fkNr+CGms841Y+HdlhXmCTlj55A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tldVlq0e1FqblecLVkJoxkVMnxxed4Ss8Po2gxzIzm0rJEXTJezt9XbUmhpdH9k2c/F8Sa2i8LSUk+M4teEDr50d0UN//FpOAv0JxF0USjzTzTbJsro3iY9whWww5CpytU2HVVXRVjKjDxHl8dxEWtCi1n+zo06t7O3p5ljqqgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M/SHkMlX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M/SHkMlX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03E351F000E9;
	Fri,  7 Aug 2026 15:20:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116042;
	bh=DQ4BKG7fGt2QL38gxu1x3e2t1BkU3uePRr+olN8bBhk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M/SHkMlXibilJB8T3pmwuJ5Cks1q3G5eCQWrbk/3D/UziJGxHSeDuR8EPpI/GI0Ko
	 d+aYfVxsAeABmQlFNUTsC4SlrjnrJUVb31BmT+gAg41AubmE8ueX5+vsblk5OBNNP0
	 icDQJmJn4wyx0GNOcEVUmIHe6fmPr0/Bt4zMal5k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Dennis Zhou <dennis@kernel.org>,
	Christoph Lameter <cl@linux.com>,
	Tejun Heo <tj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 092/261] mm/percpu-km: fix bitmap overflow and accounting in pcpu_create_chunk()
Date: Fri,  7 Aug 2026 16:37:29 +0200
Message-ID: <20260807143417.371252994@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143415.358597922@linuxfoundation.org>
References: <20260807143415.358597922@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zi Yan <ziy@nvidia.com>

commit 89b1b79c308818a715e75f28744b70d8940a07c9 upstream.

In pcpu_create_chunk(), nr_pages is the total contiguous backing
allocation, i.e., nr_units * pcpu_unit_pages, but pcpu_chunk_populated()
uses it to set chunk->populated, whose size is pcpu_unit_pages, bitmap.
Since bit N in chunk->populated means page offset N inside every unit is
backed.  When nr_units > 1, the function writes beyond chunk->populated.
Fix it by using chunk->nr_pages.

It also fixes the global pcpu_nr_empty_pop_pages accounting, since
pcpu_balance_free() only iterates up to chunk->nr_pages.

Commit a63d4ac4ab609 ("percpu: make percpu-km set chunk->populated bitmap
properly") introduced the bitmap overflow issue.  Later, commit
b539b87fed37f ("percpu: implmeent pcpu_nr_empty_pop_pages and
chunk->nr_populated") added pcpu_nr_empty_pop_pages and caused the
accounting issue.

Link: https://lore.kernel.org/20260709-fix-pcpu_create_chunk-in-percpu-km-v1-1-1f64745a84cc@nvidia.com
Fixes: a63d4ac4ab609 ("percpu: make percpu-km set chunk->populated bitmap properly")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260703-keep-subpage-private-zero-at-free-v2-0-2970fe777dd6%40nvidia.com?part=1
Assisted-by: Codex:GPT-5
Signed-off-by: Zi Yan <ziy@nvidia.com>
Acked-by: Dennis Zhou <dennis@kernel.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/percpu-km.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/percpu-km.c
+++ b/mm/percpu-km.c
@@ -75,7 +75,7 @@ static struct pcpu_chunk *pcpu_create_ch
 	chunk->base_addr = page_address(pages);
 
 	spin_lock_irqsave(&pcpu_lock, flags);
-	pcpu_chunk_populated(chunk, 0, nr_pages);
+	pcpu_chunk_populated(chunk, 0, chunk->nr_pages);
 	spin_unlock_irqrestore(&pcpu_lock, flags);
 
 	pcpu_stats_chunk_alloc();


