Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 266E314A4F9;
	Tue, 25 Jun 2024 09:56:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719309389; cv=none; b=HyofwJuZ9p5DW5aNIwnSGfmJ80hxV64cRAOoe8/PmOFXbbBQinh9P3N1tHVSbqWgRfW2Hd6a+n572XrgoRanX7WArevE4Opx939QlG4aPNjfobpuwv9Q+gY9mpzB/2Ot/tKGBYfVTpOnOfP4U+Z1nTdTY8k9C02oRbdWtKCh99w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719309389; c=relaxed/simple;
	bh=e8YUhccHa6Pj5IH6HZkW3U8oo7BG+y9DOOhHlBHv3lQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dflyr78PZIPYuu3R7/FV3QwZjJ6RYKT4nF4ZczKhqYKrNxMIim07SORet8AFYhX5dE5h9HWGF8cDq5ZPlP0/JsmMhMvHnKGfbmcYE+JcSDfZgAr6s6Lgzv1mTLsXFIaDsHyLAah6wHoZlBxeBFfIGpNkrw4I0R7Z/vSEquOEfXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u3rmyi4l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u3rmyi4l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0322C32781;
	Tue, 25 Jun 2024 09:56:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719309389;
	bh=e8YUhccHa6Pj5IH6HZkW3U8oo7BG+y9DOOhHlBHv3lQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u3rmyi4lfYgkBqAnLXbNP9aVZ+R+rxOBinkZ0THAwbQis0kDNr5Wprza78Stn0dNk
	 PTiNcwVECVKIQNl+qAmaascrrOi0mcFxrdSRgtLzaT84pAteFA/xMvSuwOjzU5ioF8
	 vlZW9/c5wHvRetktIFX+h77bHXPULyEtfiEL9q00=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nam Cao <namcao@linutronix.de>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 182/192] riscv: force PAGE_SIZE linear mapping if debug_pagealloc is enabled
Date: Tue, 25 Jun 2024 11:34:14 +0200
Message-ID: <20240625085544.147179390@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085537.150087723@linuxfoundation.org>
References: <20240625085537.150087723@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nam Cao <namcao@linutronix.de>

[ Upstream commit c67ddf59ac44adc60649730bf8347e37c516b001 ]

debug_pagealloc is a debug feature which clears the valid bit in page table
entry for freed pages to detect illegal accesses to freed memory.

For this feature to work, virtual mapping must have PAGE_SIZE resolution.
(No, we cannot map with huge pages and split them only when needed; because
pages can be allocated/freed in atomic context and page splitting cannot be
done in atomic context)

Force linear mapping to use small pages if debug_pagealloc is enabled.

Note that it is not necessary to force the entire linear mapping, but only
those that are given to memory allocator. Some parts of memory can keep
using huge page mapping (for example, kernel's executable code). But these
parts are minority, so keep it simple. This is just a debug feature, some
extra overhead should be acceptable.

Fixes: 5fde3db5eb02 ("riscv: add ARCH_SUPPORTS_DEBUG_PAGEALLOC support")
Signed-off-by: Nam Cao <namcao@linutronix.de>
Cc: stable@vger.kernel.org
Reviewed-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Link: https://lore.kernel.org/r/2e391fa6c6f9b3fcf1b41cefbace02ee4ab4bf59.1715750938.git.namcao@linutronix.de
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/mm/init.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/riscv/mm/init.c b/arch/riscv/mm/init.c
index 4d62f54698b99..8adcb9419ad50 100644
--- a/arch/riscv/mm/init.c
+++ b/arch/riscv/mm/init.c
@@ -668,6 +668,9 @@ void __init create_pgd_mapping(pgd_t *pgdp,
 static uintptr_t __init best_map_size(phys_addr_t pa, uintptr_t va,
 				      phys_addr_t size)
 {
+	if (debug_pagealloc_enabled())
+		return PAGE_SIZE;
+
 	if (pgtable_l5_enabled &&
 	    !(pa & (P4D_SIZE - 1)) && !(va & (P4D_SIZE - 1)) && size >= P4D_SIZE)
 		return P4D_SIZE;
-- 
2.43.0



