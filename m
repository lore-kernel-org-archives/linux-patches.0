Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FCC91F759C;
	Tue,  3 Dec 2024 15:35:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240145; cv=none; b=VuiB35YiLVgAu9h6Gw/QoyXPeXFUOB/ipKIxdUIuCGYZvvTFHudrAsaV8qzoERfEPks1d68VUs9dSNIpvKG3CKC4/nK6pTjlgohnmqa5wCw4DQ97uQKWVqhJW7JMkwlxt24Uojtr+HmClgSyidzgAWCn/gIuQfHumPczvclI/ss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240145; c=relaxed/simple;
	bh=5UoqKI7czbvj7eB9J+Sl2DPH8tW1ZBUPnZSdliQTGLg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kk5Uma94OQsuBcC0UEAQJnLD7YVcUauGRMi9kxZpdRh4LF6ms+os41/bQyYOFB4ynfCna1ppdKyK/lNKaCTqO/Y18teDBHP4EbMYkcZxFXTEi9FHkk01HBIBa/UayrxoOL17XH5d6Du8yDDAIwV5ZyXq36beAiqVenSZKOSAagA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v8yAlib9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v8yAlib9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07A95C4CECF;
	Tue,  3 Dec 2024 15:35:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240145;
	bh=5UoqKI7czbvj7eB9J+Sl2DPH8tW1ZBUPnZSdliQTGLg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v8yAlib9vXNIGYm9gSUrMT899lMi4lOPZM1RqII2fdVNnmK3Uke40/FapQeJdCCPE
	 k3XmXOx6rgVYuFiFQZcXLyFH1Zi5fphlyz3wby0CZDBq3gjqfyZ1oxcCLaqIYsRoLo
	 O+U1hbyjwVmxIe4gb8ffprkNskRxUbUYy8XW/IPY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andre Przywara <andre.przywara@arm.com>,
	Mark Brown <broonie@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 009/826] kselftest/arm64: mte: fix printf type warnings about __u64
Date: Tue,  3 Dec 2024 15:35:36 +0100
Message-ID: <20241203144743.809005594@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



