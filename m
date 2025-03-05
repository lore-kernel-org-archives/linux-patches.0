Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 815DB1C5D4E;
	Wed,  5 Mar 2025 18:01:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197673; cv=none; b=GN8q6PCqkKCZynzdtcHhOYiNa1qMXZRxw4CiI4WfvDf1y8386EBKqYpGD4+CxQFSmLiSxgMnE+Bq0vAUVYfjfpdohkVZmf0+JGMsLIkOYDxAZj3c2aUx1f/7mvIiqq4sID7+fHJFIkHbdHxjkEcxtOUX/HV2HOy+EJFTTeTVtlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197673; c=relaxed/simple;
	bh=42w1slLA1/O8RfjJ3DxR4VEWthXqCOCFsea78CqoNz8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kfnGjvJbKO9B0VhdIncJbY5msXMV7xTSESN5vU5yCW9YZOsYjo/Ob/bbRcOuoc53X0/oNlEK+G8SI3ShLHoux1Iolgc/0HKleckteGSx+c59wviT7TiwvNhqe4zYJl/YPXPk2zm5wsPuSWwvq0Be9LBysqPimWtmIfFwIzCJSZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CkZi4XdX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CkZi4XdX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03463C4CED1;
	Wed,  5 Mar 2025 18:01:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197673;
	bh=42w1slLA1/O8RfjJ3DxR4VEWthXqCOCFsea78CqoNz8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CkZi4XdXu/6K8LpgnPtOovENks9uAZ4DL+Y1OH+Az3kqYhWK0qRhHDb6GfmGG9qpG
	 We+AZ3u4N/rHmjUgr2Bg38Da6GioCYhK8R/tujzCiJvrqMJ+8aItY+dXcqG9nY7Eli
	 jTEc+RHeEv+kkO2QPAkwVJ6N2ZLibFsCxi3X947g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <anup@brainfault.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 060/142] riscv: KVM: Fix SBI TIME error generation
Date: Wed,  5 Mar 2025 18:47:59 +0100
Message-ID: <20250305174502.749718239@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174500.327985489@linuxfoundation.org>
References: <20250305174500.327985489@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrew Jones <ajones@ventanamicro.com>

[ Upstream commit b901484852992cf3d162a5eab72251cc813ca624 ]

When an invalid function ID of an SBI extension is used we should
return not-supported, not invalid-param.

Fixes: 5f862df5585c ("RISC-V: KVM: Add v0.1 replacement SBI extensions defined in v0.2")
Signed-off-by: Andrew Jones <ajones@ventanamicro.com>
Reviewed-by: Anup Patel <anup@brainfault.org>
Link: https://lore.kernel.org/r/20250217084506.18763-11-ajones@ventanamicro.com
Signed-off-by: Anup Patel <anup@brainfault.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kvm/vcpu_sbi_replace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/kvm/vcpu_sbi_replace.c b/arch/riscv/kvm/vcpu_sbi_replace.c
index 26e2619ab887b..87ec68ed52d76 100644
--- a/arch/riscv/kvm/vcpu_sbi_replace.c
+++ b/arch/riscv/kvm/vcpu_sbi_replace.c
@@ -21,7 +21,7 @@ static int kvm_sbi_ext_time_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
 	u64 next_cycle;
 
 	if (cp->a6 != SBI_EXT_TIME_SET_TIMER) {
-		retdata->err_val = SBI_ERR_INVALID_PARAM;
+		retdata->err_val = SBI_ERR_NOT_SUPPORTED;
 		return 0;
 	}
 
-- 
2.39.5



