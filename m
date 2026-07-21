Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64FE9403AE9;
	Tue, 21 Jul 2026 17:22:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654537; cv=none; b=KJboMT/audZDoS9NeTQ5Qz+E/LPp+dEwFFAO8JI+mMTyNUfdBueHfYRHgTye6YfCYL7GQIFPAPPJUjA51twRuuCuzc2zVZNZvryhd7YnOKqvDYB1YZmwhN8h0UftXKLF299QHkQTQBFbnWW/F6o80C/4OLDGecA3RlJ2gX4sdvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654537; c=relaxed/simple;
	bh=ps9KGngJOUydx2W9+NskqK8cu82U0+SOPrr7cVAxWEs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bLTDu7B1989HnLdA3ipHcvuPS0LbjEiADKlqpFP2nfcEaSVk5CHzjUTZunDT6k+PiRYVdpf74ZG/TnPqO+4Y4IWwMinQTnzy9QVZW2IYFYh9proquWflpbtRGdYvazh6Wox3WICtWzG6p8zUfCAPU1M7fK8cO92/JdaAXWRyk4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AjUndhjM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AjUndhjM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB69C1F000E9;
	Tue, 21 Jul 2026 17:22:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654536;
	bh=41vn9lp4oeDbzbQ2O3N/3vR1sTKUi5TJt0gPOQarqqg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AjUndhjMct0G5B4OXbckvkC/Ad71RFf5ZYFOWgKu9NLU+i0m2I5t3Gb68K7h1NqyY
	 u1VMDvwiV+RJ5yI43a07i5SNwFfx++S9pPU2nQ7YZcTYCdswnm4UWtbD8LLYvbgHH8
	 vj0Tl43FrD9r039aFrFk4m5rNPWiMX6acByK2qQ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	"Pratyush Yadav (Google)" <pratyush@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: [PATCH 7.1 1741/2077] kho: make sure scratch size is always aligned by CMA_MIN_ALIGNMENT_BYTES
Date: Tue, 21 Jul 2026 17:23:34 +0200
Message-ID: <20260721152633.810857071@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pratyush Yadav (Google) <pratyush@kernel.org>

commit 0e39380a7316122e1b00012b3f3cd3e318b3e7d3 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/liveupdate/kexec_handover.c |   32 +++++++++++++++++++++-----------
 1 file changed, 21 insertions(+), 11 deletions(-)

--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -593,20 +593,30 @@ early_param("kho_scratch", kho_parse_scr
 
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


