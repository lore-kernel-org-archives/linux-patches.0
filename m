Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3194E2F2D;
	Tue, 27 Feb 2024 13:41:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041286; cv=none; b=VwHHU+SrqjH5m2COGDARxSK12PPBT5UdSZCFZTnG5iQBICsQNVe8k8YtlJc/7myVhmSAy30PwZd+Jt/2TRNWAwq9OO38l1ahJGFlGfzTX317TgJxExEkxBGbWOT+JLI+n1Eo+KmsQiZ4hC5GVohw/t5+wyo5ZORYzqvn9LiY6lg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041286; c=relaxed/simple;
	bh=InUYOBRgxThMqum0hFNllBbYgm5KZ4aQZASxAhkgJvQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FNh4RfGEQULDmk1tLZu8AuOTCo3158fPOUgzdnXdxid4hrt37KUM5E8AUU4IVWEEe+7UPeCOnYvo2HYjqumFg3DoAqubu3bD2zG6StpeD1FSVSG6xA3mT9u4g4+utBm7Of/mnirb5mBKcjZH0hvgeKXmS317p+9wrfOFXqkCLYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a0eNuLm8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a0eNuLm8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0C0BC433C7;
	Tue, 27 Feb 2024 13:41:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041286;
	bh=InUYOBRgxThMqum0hFNllBbYgm5KZ4aQZASxAhkgJvQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a0eNuLm8Ni6JvorFyVv6XBrC47Qhvd+stYxfn3TflClsGqdmmYSlTh8vyHlkZbPp+
	 OW09a2tx83RbSETmFjoUz/OBNU1C1bnDjOlZJ6+jUgTGHsVrKrekbqFRWI7JPkDE3N
	 38KMkOAeQ3B/ZtpFWlTwAx4Q5nWpFYJkcjvFdK6I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jackson Cooper-Driver <Jackson.Cooper-Driver@arm.com>,
	Mark Brown <broonie@kernel.org>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 286/334] arm64/sme: Restore SMCR_EL1.EZT0 on exit from suspend
Date: Tue, 27 Feb 2024 14:22:24 +0100
Message-ID: <20240227131640.219652875@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
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
index db1eba8d5f66d..0898ac9979045 100644
--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -1348,6 +1348,8 @@ void sme_suspend_exit(void)
 
 	if (system_supports_fa64())
 		smcr |= SMCR_ELx_FA64;
+	if (system_supports_sme2())
+		smcr |= SMCR_ELx_EZT0;
 
 	write_sysreg_s(smcr, SYS_SMCR_EL1);
 	write_sysreg_s(0, SYS_SMPRI_EL1);
-- 
2.43.0



