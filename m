Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04CF313DB92;
	Tue, 27 Feb 2024 13:58:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042336; cv=none; b=aZ/uCq6JCx0e/yW75I6MFNa5S5S+903lYS+ww2dzOKXXCSnCmakBkJNGVBgjbcFypqQTCKcxrLRCpgBoMa3mxAaFDFTJ5JP4ZuyYnhNIaKcsEd2PLKRvSMTTlW3XJFXwRjWzoURHr3Gkku8tkhEt4A0D49NOFjSy5EcaXP81tIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042336; c=relaxed/simple;
	bh=bPLgFaS6abbxedH27HK5P59vOywuFj40Zs73YRZaQOs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UFA8ZP4NQSQkH/Dux+NaeaJaRNdeMYx5B6wP0RavfNSs79MC6Bjrqo2lywEVXfbcmMojJceaIGrSq0qCj4bT9RN5ceZJvp4cwRO0XNzTb/UvNGjAxsMHujOLFvVHhoUGwObSYr0ZpSbJPEObTJNSbcUdh2tm+OWG27jT7ADaKmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iG0SMdU8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iG0SMdU8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85F1DC433C7;
	Tue, 27 Feb 2024 13:58:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042335;
	bh=bPLgFaS6abbxedH27HK5P59vOywuFj40Zs73YRZaQOs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iG0SMdU8eq70dJYOwqbaAOqqAo5AbEj3XbRVBykLOjy3sDinOFV9O5XTGkZY/ObIW
	 tesBXPMv5RKEtrSrltQxarm7SUZns5nZPEBXn39cv9gHbxCdQPrpSG/38NY3GgIzUI
	 MhTESXjnGuqzv4Yks4Bjd7X3LjlVCN4SnL0HTrFo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jackson Cooper-Driver <Jackson.Cooper-Driver@arm.com>,
	Mark Brown <broonie@kernel.org>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 259/299] arm64/sme: Restore SMCR_EL1.EZT0 on exit from suspend
Date: Tue, 27 Feb 2024 14:26:10 +0100
Message-ID: <20240227131634.041201409@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
References: <20240227131625.847743063@linuxfoundation.org>
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

From: Mark Brown <broonie@kernel.org>

[ Upstream commit d7b77a0d565b048cb0808fa8a4fb031352b22a01 ]

The fields in SMCR_EL1 reset to an architecturally UNKNOWN value. Since we
do not otherwise manage the traps configured in this register at runtime we
need to reconfigure them after a suspend in case nothing else was kind
enough to preserve them for us. Do so for SMCR_EL1.EZT0.

Fixes: d4913eee152d ("arm64/sme: Add basic enumeration for SME2")
Reported-by: Jackson Cooper-Driver <Jackson.Cooper-Driver@arm.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/r/20240213-arm64-sme-resume-v3-2-17e05e493471@kernel.org
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/fpsimd.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
index ce0bc01b4208d..5cdfcc9e3e54b 100644
--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -1415,6 +1415,8 @@ void sme_suspend_exit(void)
 
 	if (system_supports_fa64())
 		smcr |= SMCR_ELx_FA64;
+	if (system_supports_sme2())
+		smcr |= SMCR_ELx_EZT0;
 
 	write_sysreg_s(smcr, SYS_SMCR_EL1);
 	write_sysreg_s(0, SYS_SMPRI_EL1);
-- 
2.43.0



