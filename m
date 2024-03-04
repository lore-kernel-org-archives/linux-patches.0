Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 166E0200CD;
	Mon,  4 Mar 2024 21:29:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709587793; cv=none; b=u8P3mVy8G14KgMhuETmtdmbQKxGRNxQnB8dLPxSIr+OZdIh6zBK94Q7b40Z792fCJUKENdQpoVQpSQ2jI7Blk7Hrfl//KhvOLzsgPezDiM8Vmm4g7UMuZTPf2/pZ3DKX4PbSK4vICAkUXmE0QalxU4NYOmte3eOCTIaQoCXUbMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709587793; c=relaxed/simple;
	bh=mFMOtTRFToyFPMbw6jHOCk8lz2WJd1G5jRbXM0MnLOg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nrSEaAtu60id4cJs1Qm0LucnphCiHQLKTdN5IHG8MruZhhuafwQnrvY7FcUZ3Xo3yJZVpuGwcjogY50DonsxG3WVlETxOser7c8dGtfPwqcaCxupiysfWrSJEeXbQM7koYYFXrRPUQK0Nz5NkgRzSi0jN5s3nsaiVj0+NwM5P5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QVkBmP9+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QVkBmP9+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C536C433F1;
	Mon,  4 Mar 2024 21:29:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709587793;
	bh=mFMOtTRFToyFPMbw6jHOCk8lz2WJd1G5jRbXM0MnLOg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QVkBmP9+BZiKuBrOdW6PY+t0f9Vsc4hGu0Wnm5oPOPLSAtI9B6IE136DkHrj+2Snj
	 4W/du1O6CS4W1rd1MY3DoJHXJN71t2u2uovcEte6CuYJmRZoe9quIfR4SUYhkT/4oH
	 p1qMGcC8RQbuKHMCueJYYRHDsFeYztNtmodJgfTM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 068/162] riscv: Fix pte_leaf_size() for NAPOT
Date: Mon,  4 Mar 2024 21:22:13 +0000
Message-ID: <20240304211554.027962466@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211551.833500257@linuxfoundation.org>
References: <20240304211551.833500257@linuxfoundation.org>
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
index 74ffb2178f545..ec8468ddad4a0 100644
--- a/arch/riscv/include/asm/pgtable.h
+++ b/arch/riscv/include/asm/pgtable.h
@@ -439,6 +439,10 @@ static inline pte_t pte_mkhuge(pte_t pte)
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



