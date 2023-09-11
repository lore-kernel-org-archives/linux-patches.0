Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0277911715
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 15:06:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B64AC433C8;
	Mon, 11 Sep 2023 15:06:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694444799;
	bh=CJY/nidx3RHgG2Rm3IJLEcHNRl6F7dZQo4pBRupqgq8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HcipyLfoj6PaI/TIb5eb7nzB9U1QE7pmPRsIUweSqL+TIEC5PCu5KJiTY3A/iajwM
	 r2prgEL2jvSu/lMXA2SeqDVodt0/fXRSH0bt4QsB/0k2QBI215VyO1jWdM7zrwi/Nx
	 L15VRQrleQ2JKddCakxfolhC+m5i7GlfHAZXOzHk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Brown <broonie@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 119/600] arm64/sme: Dont use streaming mode to probe the maximum SME VL
Date: Mon, 11 Sep 2023 15:42:32 +0200
Message-ID: <20230911134637.125708871@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134633.619970489@linuxfoundation.org>
References: <20230911134633.619970489@linuxfoundation.org>
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

From: Mark Brown <broonie@kernel.org>

[ Upstream commit fcd3d2c082b2a19da2326b2b38ba5a05536dcd32 ]

During development the architecture added the RDSVL instruction which means
we do not need to enter streaming mode to enumerate the SME VLs, use it
when we probe the maximum supported VL. Other users were already updated.

No functional change.

Signed-off-by: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/r/20221223-arm64-sme-probe-max-v1-1-cbde68f67ad0@kernel.org
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Stable-dep-of: 01948b09edc3 ("arm64/fpsimd: Only provide the length to cpufeature for xCR registers")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/fpsimd.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
index 8cd59d387b90b..4aa579ff3125d 100644
--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -1296,7 +1296,6 @@ u64 read_smcr_features(void)
 	unsigned int vq_max;
 
 	sme_kernel_enable(NULL);
-	sme_smstart_sm();
 
 	/*
 	 * Set the maximum possible VL.
@@ -1306,11 +1305,9 @@ u64 read_smcr_features(void)
 
 	smcr = read_sysreg_s(SYS_SMCR_EL1);
 	smcr &= ~(u64)SMCR_ELx_LEN_MASK; /* Only the LEN field */
-	vq_max = sve_vq_from_vl(sve_get_vl());
+	vq_max = sve_vq_from_vl(sme_get_vl());
 	smcr |= vq_max - 1; /* set LEN field to maximum effective value */
 
-	sme_smstop_sm();
-
 	return smcr;
 }
 
-- 
2.40.1



