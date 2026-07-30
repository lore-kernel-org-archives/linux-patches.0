Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7A9544AB62;
	Thu, 30 Jul 2026 15:25:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425133; cv=none; b=XR67MlQUFhUJ0myuME+KqV7u/eXGh+/298MQ02845u0Mev57IRQQfDCT6iO/3sOIo140I5TJynckc9qq+ym6uvf3W8zvkV2AD0aLh/VDvX3mvFi0K6Q75oNPaKmmpAKmP1jiVtI3t5sEYkz2//9nvazCLiFBk1N/uIBR5hHrZ9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425133; c=relaxed/simple;
	bh=6QY9l3qjPJzLClXeWc0zKUXAce/Ctthg9XRxQhxWutc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h13jiCh8n0sgGWWbPR5RyIveKhENSkOl8zK+V9w2n0sKUwZsrtyyBF4b4fwgssAtZUaoIt+SttuVPl0boQs6oOHp/bVyu1nF93y6yLmrlc5BXwRt0XGEhWh7cdr5xVGYWR2rkMAesjtl1GOzlmDaCm0bNkMJcou779IvDwxBJwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DEdb1ZGe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DEdb1ZGe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 057A71F000E9;
	Thu, 30 Jul 2026 15:25:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425132;
	bh=nbOik6BSze4Ln+NnxnpYZ+8aYaWROyxZ/G6sdYCTT8M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DEdb1ZGeh5aS2AaRyc67TkuCVkKc7f1UIhE51ywiQzcLu3N+nZLKSbrFuWB2sXujl
	 lFBDaRkrY2zeM5jAaHx0l7RnvzfDeB4le7NzOxtYB0a15Wz3+smdM0CDGmZWLu6eOW
	 z5Ga9J4yf3xHWGjJXwI5xqzR+fjLhXu8DgvyLTOA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	"Pratyush Yadav (Google)" <pratyush@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 635/675] kho: make sure scratch size is always aligned by CMA_MIN_ALIGNMENT_BYTES
Date: Thu, 30 Jul 2026 16:16:05 +0200
Message-ID: <20260730141458.626279682@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

From: "Pratyush Yadav (Google)" <pratyush@kernel.org>

[ Upstream commit 0e39380a7316122e1b00012b3f3cd3e318b3e7d3 ]

When using scratch_scale, the scratch sizes are rounded up to
CMA_MIN_ALIGNMENT_BYTES since they will be released as MIGRATE_CMA. This
is not done when using fixed scratch sizes via command line. This can
result in user specifying a size which is not aligned, and thus kernel
releasing a pageblock that is only partially scratch.

Do the rounding up for both cases in scratch_size_update().

Fixes: 3dc92c311498 ("kexec: add Kexec HandOver (KHO) generation helpers")
Cc: stable@kernel.org
Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
Link: https://patch.msgid.link/20260519160554.2713361-1-pratyush@kernel.org
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/kexec_handover.c |   32 +++++++++++++++++++++-----------
 1 file changed, 21 insertions(+), 11 deletions(-)

--- a/kernel/kexec_handover.c
+++ b/kernel/kexec_handover.c
@@ -562,20 +562,30 @@ early_param("kho_scratch", kho_parse_scr
 
 static void __init scratch_size_update(void)
 {
-	phys_addr_t size;
+	/*
+	 * If fixed sizes are not provided via command line, calculate them
+	 * now.
+	 */
+	if (scratch_scale) {
+		phys_addr_t size;
 
-	if (!scratch_scale)
-		return;
+		size = memblock_reserved_kern_size(ARCH_LOW_ADDRESS_LIMIT,
+						   NUMA_NO_NODE);
+		size = size * scratch_scale / 100;
+		scratch_size_lowmem = size;
 
-	size = memblock_reserved_kern_size(ARCH_LOW_ADDRESS_LIMIT,
-					   NUMA_NO_NODE);
-	size = size * scratch_scale / 100;
-	scratch_size_lowmem = round_up(size, CMA_MIN_ALIGNMENT_BYTES);
+		size = memblock_reserved_kern_size(MEMBLOCK_ALLOC_ANYWHERE,
+						   NUMA_NO_NODE);
+		size = size * scratch_scale / 100 - scratch_size_lowmem;
+		scratch_size_global = size;
+	}
 
-	size = memblock_reserved_kern_size(MEMBLOCK_ALLOC_ANYWHERE,
-					   NUMA_NO_NODE);
-	size = size * scratch_scale / 100 - scratch_size_lowmem;
-	scratch_size_global = round_up(size, CMA_MIN_ALIGNMENT_BYTES);
+	/*
+	 * Scratch areas are released as MIGRATE_CMA. Round them up to the right
+	 * size.
+	 */
+	scratch_size_lowmem = round_up(scratch_size_lowmem, CMA_MIN_ALIGNMENT_BYTES);
+	scratch_size_global = round_up(scratch_size_global, CMA_MIN_ALIGNMENT_BYTES);
 }
 
 static phys_addr_t __init scratch_size_node(int nid)


