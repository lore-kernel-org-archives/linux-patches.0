Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A15EC51DB19;
	Wed, 30 Sep 2026 18:27:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792830; cv=none; b=l3iAvrrDJCBB/d8IK9lTyVaiNAq0R6fpp0LsVrD0FSvM9REC/JYJX9hoNySIjY/fUdu1t5KyWC83fD8Aq40v1FHVoa8ilo29rAhPlBxnzXCdOM7ofqPYKag7reHrMDYGua4KF09jRHvk/wn6jZ7bHokwNwVJC8fPsJaX4Zj/8HQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792830; c=relaxed/simple;
	bh=RwlOM7ygHeE4MoOhX4cuJ++P3EWh2AXs9jIfuegVDqM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c0wMxdVxBmRYxHtMoGAr3J+5/VD1OX0qCpprvg39kgxUufdoVzeisk5MvUgTUmsR8hTlgXmXeNMJTSeYGllKg4n9SIi3/oqwiHORdg9nUATSsZxwdZsn1MnsN91U9TF2v9LD0yP8gR6ey+pj7WrNH7godUseLsC5bvfvNkMV1r8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dD0gXJnH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dD0gXJnH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA3F61F000FF;
	Wed, 30 Sep 2026 18:27:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792829;
	bh=RSNPTJ3Ay+gwqzfwIq01KUtrC8zDVQ1Mk7O6B/71CmM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dD0gXJnH0d4lPytAlSm5C6NkRbBf32yQuEi1gx/1u445raaoYJcpLlf9A/A8m+C/V
	 PyWprOvHJqVQbHAttBZkZWtWSnNxOGi3fvZnTNqyU/bewEu8Chl0ZWMzRw0qMAhxix
	 vhM6WCKcztwTOAJvzVS+b3H3JZ2aCfbyDh3kzKJQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leonardo Bras <leo.bras@arm.com>,
	Mark Brown <broonie@kernel.org>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 041/395] KVM: arm64: Fix FGT mapping for HFGITR_EL2.nGCSEPP
Date: Wed, 30 Sep 2026 17:25:03 +0200
Message-ID: <20260930152341.520410855@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 8778188407047..fbb37edfbabae 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -1423,7 +1423,7 @@ static const struct encoding_to_trap_config encoding_to_fgt[] __initconst = {
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



