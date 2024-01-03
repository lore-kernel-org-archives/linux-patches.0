Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7AFA1BDF0;
	Wed,  3 Jan 2024 17:03:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iQbPm8tf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0736C433C7;
	Wed,  3 Jan 2024 17:03:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704301415;
	bh=teeFpiwTOdCGSFTv9uRHy1V5DnNfY+FGvuKTgSCgUOo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iQbPm8tfXuGhgxl7SU3Kndt4BfKNvSUPkHqmA94oZvOlaEo2Zod7wnG3kJDqKirAR
	 yb9VI69lomkWlmoOnVbrD4wb7aUbkVlUFup39CWjJNQEXMopjtUoW1gNksE6eorEI3
	 2gf2O4KmW9mvyQsJRjyG0IC7Kq6810YzVVB+kDsI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Carstens <hca@linux.ibm.com>,
	Hendrik Brueckner <brueckner@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 04/95] s390/vx: fix save/restore of fpu kernel context
Date: Wed,  3 Jan 2024 17:54:12 +0100
Message-ID: <20240103164854.519619772@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240103164853.921194838@linuxfoundation.org>
References: <20240103164853.921194838@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiko Carstens <hca@linux.ibm.com>

[ Upstream commit e6b2dab41888332bf83f592131e7ea07756770a4 ]

The KERNEL_FPR mask only contains a flag for the first eight vector
registers. However floating point registers overlay parts of the first
sixteen vector registers.

This could lead to vector register corruption if a kernel fpu context uses
any of the vector registers 8 to 15 and is interrupted or calls a
KERNEL_FPR context. If that context uses also vector registers 8 to 15,
their contents will be corrupted on return.

Luckily this is currently not a real bug, since the kernel has only one
KERNEL_FPR user with s390_adjust_jiffies() and it is only using floating
point registers 0 to 2.

Fix this by using the correct bits for KERNEL_FPR.

Fixes: 7f79695cc1b6 ("s390/fpu: improve kernel_fpu_[begin|end]")
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Reviewed-by: Hendrik Brueckner <brueckner@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/include/asm/fpu/api.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/s390/include/asm/fpu/api.h b/arch/s390/include/asm/fpu/api.h
index a959b815a58b6..b8c7e8538c855 100644
--- a/arch/s390/include/asm/fpu/api.h
+++ b/arch/s390/include/asm/fpu/api.h
@@ -78,7 +78,7 @@ static inline int test_fp_ctl(u32 fpc)
 #define KERNEL_VXR_HIGH		(KERNEL_VXR_V16V23|KERNEL_VXR_V24V31)
 
 #define KERNEL_VXR		(KERNEL_VXR_LOW|KERNEL_VXR_HIGH)
-#define KERNEL_FPR		(KERNEL_FPC|KERNEL_VXR_V0V7)
+#define KERNEL_FPR		(KERNEL_FPC|KERNEL_VXR_LOW)
 
 struct kernel_fpu;
 
-- 
2.43.0



