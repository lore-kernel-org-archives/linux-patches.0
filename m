Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F75B8F58;
	Mon,  4 Mar 2024 21:38:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588323; cv=none; b=YiUde3w7fSPvPVpqAD2ClSBIsWWVNrP7TFpvdr8Uuytd3vpAn48b4i/+abl6xkIYte/bj46m4vEoHWGCgoUEqu/Hqil5n6c7mtD0mDQqj5TmkR8nJHkoF4iu6qOGXxPORyOm82HQWlDgHev7h3Tz/D0tZ7//tv5O7s6dftGLmig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588323; c=relaxed/simple;
	bh=PEExZG/kGN8hjv6g/VjgPiVkwnKrkiO46Sw1BmaRsJA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=enRm/ldJTVgeGLFQSCgc2v6L8ylp+cJ2QzbYFvrENQr6FFaShvaUZITFmNR/c0cg2DtHbtB11rsSyXPGsQBfaJ00dftXLlDBx/z1Rb2gkaVjCyIIZi7Lb8mP7DMhoQ6WYWy/6O43kgS8BSwYNQaiOpLnpnVFU4G0NtJBKC4sbn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wNp6tFqr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wNp6tFqr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C52E7C433C7;
	Mon,  4 Mar 2024 21:38:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588323;
	bh=PEExZG/kGN8hjv6g/VjgPiVkwnKrkiO46Sw1BmaRsJA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wNp6tFqrzsA9S3IOVXcR7ggt2UYb7MAw1Q7MwzF7yfOs1DcOWDGnO9VVq68kNPCvK
	 pmz/2TyUlQKdH/u9bsftlOC9p0PxNZWy7onCERscUP74QsHatHcoHSCRrBMw+ZPg52
	 J2/wWpL9U1YYb80oms0TrBJGNwjrY2e0eIRQgwUw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 064/143] riscv: Fix pte_leaf_size() for NAPOT
Date: Mon,  4 Mar 2024 21:23:04 +0000
Message-ID: <20240304211551.976338121@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211549.876981797@linuxfoundation.org>
References: <20240304211549.876981797@linuxfoundation.org>
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

From: Alexandre Ghiti <alexghiti@rivosinc.com>

[ Upstream commit e0fe5ab4192c171c111976dbe90bbd37d3976be0 ]

pte_leaf_size() must be reimplemented to add support for NAPOT mappings.

Fixes: 82a1a1f3bfb6 ("riscv: mm: support Svnapot in hugetlb page")
Signed-off-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Link: https://lore.kernel.org/r/20240227205016.121901-3-alexghiti@rivosinc.com
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/include/asm/pgtable.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pgtable.h
index 511cb385be96b..93c1664361143 100644
--- a/arch/riscv/include/asm/pgtable.h
+++ b/arch/riscv/include/asm/pgtable.h
@@ -438,6 +438,10 @@ static inline pte_t pte_mkhuge(pte_t pte)
 	return pte;
 }
 
+#define pte_leaf_size(pte)	(pte_napot(pte) ?				\
+					napot_cont_size(napot_cont_order(pte)) :\
+					PAGE_SIZE)
+
 #ifdef CONFIG_NUMA_BALANCING
 /*
  * See the comment in include/asm-generic/pgtable.h
-- 
2.43.0



