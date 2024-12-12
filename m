Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CED64221D88;
	Thu, 12 Dec 2024 15:53:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734018830; cv=none; b=cx8i8WF5Ggo0EX/7eLjliODqCqBUSG/tonaMSJXWoFt7wS/amTxWhhCDfxOJ9SOZGNHLxCQfUJfci5RpnxI8QZCTNkm6pBB/CWdSFlgIpefN64ROnVgIOFPHyMK2o+NpSAxpuAO8m8vv58B7OCrT3eUo12+JEEqCOkyGPmu0LFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734018830; c=relaxed/simple;
	bh=YjpcADOJoDjB2KOtDK1b6yO0QiCzV13XXnSLa6Xpz+I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NUzr5BIMXsvqwwdz1SN+0P6WiI4W7984V4chRezjxV475BK9/rrbnyhiNowytS+t+r0WpZfNHvFB68vbr+B45iMnEe0LNCwnVwQZP4aHriNRw3FADqDXIkt248oLyeb5rhRdXrtA/6Ka6U8ZSVq6aU8ULIUGGTe1tAYLfIP18jg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y3ovQCNj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y3ovQCNj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB9B1C4CECE;
	Thu, 12 Dec 2024 15:53:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734018830;
	bh=YjpcADOJoDjB2KOtDK1b6yO0QiCzV13XXnSLa6Xpz+I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y3ovQCNjNQumU0xWPZ4XyCICg3xpULz9nK+lmZ4lh3Q5ePkkHFxW5d4PrPmXWdUnf
	 zrwb8tILQj2L7R4trzetihrK+s0a440Zc6Cbf1POc/J4niSy77y8mB9SbDH581Sf7o
	 mKhBHDQLGZvq6tBVSoq8IF8NhL8/HX6unM+9i3PE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andre Przywara <andre.przywara@arm.com>,
	Mark Brown <broonie@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 046/772] kselftest/arm64: mte: fix printf type warnings about __u64
Date: Thu, 12 Dec 2024 15:49:51 +0100
Message-ID: <20241212144351.839194219@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andre Przywara <andre.przywara@arm.com>

[ Upstream commit 7e893dc81de3e342156389ea0b83ec7d07f25281 ]

When printing the signal context's PC, we use a "%lx" format specifier,
which matches the common userland (glibc's) definition of uint64_t as an
"unsigned long". However the structure in question is defined in a
kernel uapi header, which uses a self defined __u64 type, and the arm64
kernel headers define this using "int-ll64.h", so it becomes an
"unsigned long long". This mismatch leads to the usual compiler warning.

The common fix would be to use "PRIx64", but because this is defined by
the userland's toolchain libc headers, it wouldn't match as well. Since
we know the exact type of __u64, just use "%llx" here instead, to silence
this warning.

This also fixes a more severe typo: "$lx" is not a valid format
specifier.

Fixes: 191e678bdc9b ("kselftest/arm64: Log unexpected asynchronous MTE faults")
Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/r/20240816153251.2833702-7-andre.przywara@arm.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/arm64/mte/mte_common_util.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/arm64/mte/mte_common_util.c b/tools/testing/selftests/arm64/mte/mte_common_util.c
index 00ffd34c66d30..1120f5aa76550 100644
--- a/tools/testing/selftests/arm64/mte/mte_common_util.c
+++ b/tools/testing/selftests/arm64/mte/mte_common_util.c
@@ -38,7 +38,7 @@ void mte_default_handler(int signum, siginfo_t *si, void *uc)
 			if (cur_mte_cxt.trig_si_code == si->si_code)
 				cur_mte_cxt.fault_valid = true;
 			else
-				ksft_print_msg("Got unexpected SEGV_MTEAERR at pc=$lx, fault addr=%lx\n",
+				ksft_print_msg("Got unexpected SEGV_MTEAERR at pc=%llx, fault addr=%lx\n",
 					       ((ucontext_t *)uc)->uc_mcontext.pc,
 					       addr);
 			return;
@@ -64,7 +64,7 @@ void mte_default_handler(int signum, siginfo_t *si, void *uc)
 			exit(1);
 		}
 	} else if (signum == SIGBUS) {
-		ksft_print_msg("INFO: SIGBUS signal at pc=%lx, fault addr=%lx, si_code=%lx\n",
+		ksft_print_msg("INFO: SIGBUS signal at pc=%llx, fault addr=%lx, si_code=%x\n",
 				((ucontext_t *)uc)->uc_mcontext.pc, addr, si->si_code);
 		if ((cur_mte_cxt.trig_range >= 0 &&
 		     addr >= MT_CLEAR_TAG(cur_mte_cxt.trig_addr) &&
-- 
2.43.0



