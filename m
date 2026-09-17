Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1D2A4E3233;
	Thu, 17 Sep 2026 15:48:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660129; cv=none; b=DZVTiHzDVxO29CuIeyS3m2HwvRtDVpl6+u/89fe/tuntVGfio3FRUHd7me9d2jlyKvM321R70XBb+5RcQSlp/hIXPHiWhtcxRebZ1EMg5dAZS2tMw06yPXy0GF4ZKai051MCEIdXkxeJWZFGk4FrYaFl4xmm9ZTo0lgkoBOYiZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660129; c=relaxed/simple;
	bh=whgSLW2W2U6aWbqx5zNQYkrp1KrWbOFEpG4krmdyxjQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xo9jFwKHWZOdzIyCX9uKW4PLnICudKuNPd7S4mnltPQnOUXolHMsIf9Cz1cSEFLRw8rchBlIY3lkK+xZWCX1wDQzVWUoOlhZVF8veOguyQ+mBZrTXR9WOBqQajRxkPHo6H+zV0T0y5MGmqXNInTK/2dBAj1/Sog7HEhh/F5bhJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jeodnQP9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jeodnQP9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C57801F000FF;
	Thu, 17 Sep 2026 15:48:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660121;
	bh=dTrZq3zzkWWc5X33kVNL4ulD+XICivgiTEXy7fw3F38=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jeodnQP9nZZVXC1TLLThS8Um12pMRgwK7ygTNPS/VAQ7ZeGP1L5J6SpMBCLnIwM/L
	 KQJwXIVKir89NNOHb1vwbmbK3u8IGA5/zKy0kIEnVP3sYgjLy5iVGXPA/m/WHSTDmN
	 vzrOkj3hKLFyCMuRcEH4rA4FN1+FKO1iivc37TC8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Chiu <tchiu@tenstorrent.com>,
	Jesse Taube <jtaubepe@redhat.com>,
	Paul Walmsley <pjw@kernel.org>
Subject: [PATCH 7.2 485/733] riscv: hwprobe: initialize pair->value in hwprobe_one_pair()
Date: Thu, 17 Sep 2026 16:13:13 +0100
Message-ID: <20260917151404.120817390@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Chiu <tchiu@tenstorrent.com>

commit d0fc6fab20460add1f27402cd8b945d094a56b21 upstream.

The vendor-extension handlers reached from hwprobe_one_pair()
(hwprobe_isa_vendor_ext_thead_0() and friends) only OR the present bits
into pair->value via VENDOR_EXTENSION_SUPPORTED() and clear their own
missing bits; they assume the caller has already zeroed pair->value.

That holds for hwprobe_get_values() (it zeroes each pair) and
hwprobe_get_cpus() (it re-initializes its scratch pair per key), but not
for complete_hwprobe_vdso_data(), which reuses a single pair across all
keys without re-zeroing. A vendor key therefore inherits stale bits from
the previously probed key, and the wrong value is cached in the vDSO
all_cpu_hwprobe_values[] and handed to userspace on the fast patih.

Zero pair->value once at the top of hwprobe_one_pair() so every handler
starts from a clean value regardless of the caller, and drop the now
redundant zeroing in the *_BLOCK_SIZE cases. hwprobe_isa_ext0() keeps its
own zeroing because hwprobe_ext0_has() calls it directly, bypassing
hwprobe_one_pair().

Fixes: a5ea53da65c5 ("riscv: hwprobe: Add thead vendor extension probing")
Signed-off-by: Andy Chiu <tchiu@tenstorrent.com>
Reviewed-by: Jesse Taube <jtaubepe@redhat.com>
Link: https://patch.msgid.link/20260725001614.2578617-2-tchiu@tenstorrent.com
Cc: stable@vger.kernel.org
Signed-off-by: Paul Walmsley <pjw@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/kernel/sys_hwprobe.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/arch/riscv/kernel/sys_hwprobe.c
+++ b/arch/riscv/kernel/sys_hwprobe.c
@@ -295,6 +295,8 @@ static u64 hwprobe_vec_misaligned(const
 static void hwprobe_one_pair(struct riscv_hwprobe *pair,
 			     const struct cpumask *cpus)
 {
+	pair->value = 0;
+
 	switch (pair->key) {
 	case RISCV_HWPROBE_KEY_MVENDORID:
 	case RISCV_HWPROBE_KEY_MARCHID:
@@ -329,17 +331,14 @@ static void hwprobe_one_pair(struct risc
 		break;
 
 	case RISCV_HWPROBE_KEY_ZICBOZ_BLOCK_SIZE:
-		pair->value = 0;
 		if (hwprobe_ext0_has(cpus, RISCV_HWPROBE_EXT_ZICBOZ))
 			pair->value = riscv_cboz_block_size;
 		break;
 	case RISCV_HWPROBE_KEY_ZICBOM_BLOCK_SIZE:
-		pair->value = 0;
 		if (hwprobe_ext0_has(cpus, RISCV_HWPROBE_EXT_ZICBOM))
 			pair->value = riscv_cbom_block_size;
 		break;
 	case RISCV_HWPROBE_KEY_ZICBOP_BLOCK_SIZE:
-		pair->value = 0;
 		if (hwprobe_ext0_has(cpus, RISCV_HWPROBE_EXT_ZICBOP))
 			pair->value = riscv_cbop_block_size;
 		break;


