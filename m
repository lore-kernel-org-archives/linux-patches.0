Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1228355F42;
	Wed, 30 Sep 2026 16:48:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786927; cv=none; b=qwCASq54hGFvzkBvVHX5sWyFRgCrRjsMyjgL9U9tJf03/tv1HBFzA8qzETDyw1Qbvs2j/yxq9mnXsXX6p58J39um6bcwgI0eboyhDiYgnpdcBEXbmZuqh8G2cH+uuInaGzydYtIMeiDB6sY+x1t43g/bXHnfi0D6W4L6Zpel5pI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786927; c=relaxed/simple;
	bh=PAiIwzVmVeSLuirDjfDd4aXbDQz67zM/QcPFimBwnyE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q7v+ZNmvU6HqvdR9sgqvLMDXuPSJWk0dv67TSzOUbPHFW2DlaG3Du1C1gXzxxGK5AMdJfr0xRLA1yTfevxZgVYSBP6PsWltqWRmCIE7VAVg3pGudoxksBv8X40Gkhr7wt4FJLU2QiAu0kBaJ6eKCYquWSjSLn4ByKqoQfunXIOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YOUIaTln; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YOUIaTln"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F25841F000FF;
	Wed, 30 Sep 2026 16:48:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786924;
	bh=Guu9uJQeiNZhAmaZtMPk0AtJhz2fLWoum21pLzTokbw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YOUIaTlnCQxh8DjP0kE9soRmfG7tAoM6rS0O3ARdiD/AV5oifxH/GSI9v2F93Wzps
	 8pv7rEf1AYq+Tk/e4SeKEp1oSxUVKeLZOcTAB13QumXChnzd7EdaawxYv5NFV8fkLA
	 czFOkTVHXJiyrYxn9Mec7jL39+kZ0mHuMMPNDSxg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leonardo Bras <leo.bras@arm.com>,
	Mark Brown <broonie@kernel.org>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 049/457] KVM: arm64: Fix FGT mapping for HFGITR_EL2.nGCSEPP
Date: Wed, 30 Sep 2026 17:22:34 +0200
Message-ID: <20260930152347.092500336@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Brown <broonie@kernel.org>

[ Upstream commit 089e4f3c4862ba3f29dff2361caa8084879194fd ]

The encoding to trap mapping currently maps a FGT on OP_GCSPOPX to
HFGITR_EL2.nGCSEPP but as per DDI0601 2026-06 this FGT controls trapping
of GCSPUSHX and GCSPOPCX, and not the separate GCSPOPX instruction.
Update the mapping to reflect the architecture.

Fixes: 863ac38984a82 ("KVM: arm64: Add missing HFGITR_EL2 FGT entries to nested virt")
Reviewed-by: Leonardo Bras <leo.bras@arm.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Link: https://patch.msgid.link/20260901-arm64-gcs-v20-2-f31750bdfadb@kernel.org
Signed-off-by: Oliver Upton <oupton@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kvm/emulate-nested.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
index 3c82f392845d1..b32742d9dd73e 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -1432,7 +1432,7 @@ static const struct encoding_to_trap_config encoding_to_fgt[] __initconst = {
 	SR_FGT(OP_AT_S1E1A, 		HFGITR, ATS1E1A, 1),
 	SR_FGT(OP_COSP_RCTX, 		HFGITR, COSPRCTX, 1),
 	SR_FGT(OP_GCSPUSHX, 		HFGITR, nGCSEPP, 0),
-	SR_FGT(OP_GCSPOPX, 		HFGITR, nGCSEPP, 0),
+	SR_FGT(OP_GCSPOPCX, 		HFGITR, nGCSEPP, 0),
 	SR_FGT(OP_GCSPUSHM, 		HFGITR, nGCSPUSHM_EL1, 0),
 	SR_FGT(OP_BRB_IALL, 		HFGITR, nBRBIALL, 0),
 	SR_FGT(OP_BRB_INJ, 		HFGITR, nBRBINJ, 0),
-- 
2.53.0



