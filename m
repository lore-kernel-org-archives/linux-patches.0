Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 385B72ECD22;
	Tue, 17 Jun 2025 15:41:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174890; cv=none; b=cdUQ7B9OloQrfyNmxLpAGC3ymxrryNeLW2y/eOMry67BQvgmrpoZJl79hQ+KQbqNbpfdp2TizJm+YR8hfzIk59qeGL2OP6zUjIAJrlTtC+t7rJP3DLyTqjP5mcAH4Cv7J6b8k73vnBESMpYwV/bfMd4pB8N4SEds3N88uXjHFIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174890; c=relaxed/simple;
	bh=I/gEV2DXiX2TueiQD/jQjZwfTfG4t/sxLuhserPHV3g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nqi1jcpqADlM9D40q5fkMAUzPZfujHgUOB9wPzrLapZaNVIrXTeO0DZQuZ3B9hEYrhEZTOrU0fHQ0PeXV7Qq0Ik/FHYOkAfbXadjnt9yUM2rPHNHoPhtaAip5Hfx4/FgomcEdZT0RCY5gx3X1JjxDMZa3+xJ9Rbrar8pJOawXtA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t9696M2s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t9696M2s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49F2FC4CEE3;
	Tue, 17 Jun 2025 15:41:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750174889;
	bh=I/gEV2DXiX2TueiQD/jQjZwfTfG4t/sxLuhserPHV3g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t9696M2su09Z0X4Xp+ZgDDqjBmKX0pbrSofE1iMP2y7tywL4yzRHremFWl6aMRbLR
	 QJcmVdbY9t9QpI52C1k5XTMoJp1X2dCFerJl0d+nEPtox+ikQuq6pUcLMsEfO07xZ/
	 4n2K2SCZ/zs/F3PxzKp2FvwfkOO0DhV2Jg7IZnQw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Rutland <mark.rutland@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 070/512] arm64/fpsimd: Reset FPMR upon exec()
Date: Tue, 17 Jun 2025 17:20:36 +0200
Message-ID: <20250617152422.408821736@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Mark Rutland <mark.rutland@arm.com>

[ Upstream commit a90878f297d3dba906a6261deccb1bd4a791ba52 ]

An exec() is expected to reset all FPSIMD/SVE/SME state, and barring
special handling of the vector lengths, the state is expected to reset
to zero. This reset is handled in fpsimd_flush_thread(), which the core
exec() code calls via flush_thread().

When support was added for FPMR, no logic was added to
fpsimd_flush_thread() to reset the FPMR value, and thus it is
erroneously inherited across an exec().

Add the missing reset of FPMR.

Fixes: 203f2b95a882 ("arm64/fpsimd: Support FEAT_FPMR")
Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Will Deacon <will@kernel.org>
Reviewed-by: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/r/20250409164010.3480271-9-mark.rutland@arm.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/fpsimd.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
index 9f2b83c50f7d9..8b8cd9d238234 100644
--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -1663,6 +1663,9 @@ void fpsimd_flush_thread(void)
 		current->thread.svcr = 0;
 	}
 
+	if (system_supports_fpmr())
+		current->thread.uw.fpmr = 0;
+
 	current->thread.fp_type = FP_STATE_FPSIMD;
 
 	put_cpu_fpsimd_context();
-- 
2.39.5



