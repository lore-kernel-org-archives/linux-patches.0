Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C907440A2E;
	Mon, 17 Aug 2026 14:16:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976171; cv=none; b=NKq3JJN4R1JbcTeT0JT+GKrcHwQi5yhu1elOAk3nsJCpCKkoXALKGt7apt25X1jHDxkvm5iFxp3/oNuWcOaT3eLU3tHExp4jtXSZdZtYxXUjLVtBoo0IrGPPaAoPTXksGfPveyPu+4VmkzQffOUIqvooNKuVJs6rC3J9Vg2OvtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976171; c=relaxed/simple;
	bh=4vgA2iIBzSuh2qyPfQ4Mjp9zcZUEmAXPLt5zUg4f1fU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MkJnlrQsF1kjs/4b7JZaUHDlDCux+iu//6wuzwdqLM+6r8Ua+gRdodbpy8qkAZiUVdULXmZp7NykT08OsM1dtcMrFLJtfza0+PS9OkEDpVaJj0K/aiRPQYtqCXGUa4U79aDy3DNMzJXUTGySvb1a1LngonJlfvrvsGpkjLETZNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L+cO7erX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L+cO7erX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5ECD1F000E9;
	Mon, 17 Aug 2026 14:16:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976170;
	bh=CocxqtwHmaqnMY9I7H9cGfxalfmpvgW5Zs4lKO56EK8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L+cO7erX9UCG5bI8t0o4OUHrRTFJaPV5ZcvsCmgW10VImYZ1jJX2KiPWjkmAI0QXg
	 tITtTm1f/3/SYfMDd7T7bC/XpST++zSEUgsDv81Kpe0qDS73JKoNPaIt9iTjQ9lU2j
	 V2KIG5Mf1rQMC1/fJvIzdQs0tg+KGqi1A4ESsT0M=
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
Subject: [PATCH 5.10 242/389] mm/percpu-km: fix bitmap overflow and accounting in pcpu_create_chunk()
Date: Mon, 17 Aug 2026 15:31:21 +0200
Message-ID: <20260817132548.732973633@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -70,7 +70,7 @@ static struct pcpu_chunk *pcpu_create_ch
 	chunk->base_addr = page_address(pages);
 
 	spin_lock_irqsave(&pcpu_lock, flags);
-	pcpu_chunk_populated(chunk, 0, nr_pages);
+	pcpu_chunk_populated(chunk, 0, chunk->nr_pages);
 	spin_unlock_irqrestore(&pcpu_lock, flags);
 
 	pcpu_stats_chunk_alloc();


