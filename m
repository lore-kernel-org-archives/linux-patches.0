Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 352C82FF641;
	Fri,  7 Aug 2026 14:47:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114075; cv=none; b=dnMffftmW8IUCGv5d8ER7rhFzNQJq9SQbXqnQWe4SOEoA9DxHwwBiV4IUSJp65mT8t/5x78psDW7p9HzWX23Jh7lsrevzO3iJ9lta7BoCmoBXY6neLIz7G9DPV/gr1HNdMrQk/vrRzzIkUY0Ld8BonHxR1/NwjZ32/owcOCt7qo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114075; c=relaxed/simple;
	bh=fGJ3RqUdQBqr+NzaBEzJz5/g/pg2orgv+xB7l6ALaZA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qKpB2lVpJr9xfXW1nACAZoO6ZlzQPzfWZKykCKze+uUGQGZO3fBYeah/vbY2q3fGPwLF4CEqCPQ94ekXyG8/+XI3Tmv3qcjumOMc4HXOfHUXNDWXB4A3qEffRdWHyuDK4VFbS+gHyLWwVIg2qyWzpO9Ue3I7SV2uObTmaNriue4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L3c1IAiT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L3c1IAiT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72E651F000E9;
	Fri,  7 Aug 2026 14:47:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114074;
	bh=PHSjJ9/xn8QrzONMWf/8qc69soF3IOooATk1zVys2rE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L3c1IAiTirfJLqA4yfYtOsCulEiB4B/eno+rZSk35afyOHtV4f1nM5KXiqvI+ZiAx
	 ulJpziElr0VcJjCrwL2HxHt1+kuo6ODXoitHo+FCQEtmEOdnQjJPZZH3XWGb/TKby3
	 NXwH3rwFa3yeaHjnRhZlcY/bEKe0yKDkcToIWjm4=
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
Subject: [PATCH 6.12 136/337] mm/percpu-km: fix bitmap overflow and accounting in pcpu_create_chunk()
Date: Fri,  7 Aug 2026 16:35:39 +0200
Message-ID: <20260807143421.482381261@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
References: <20260807143418.516897842@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


