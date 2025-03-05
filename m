Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA61E1A5BB7;
	Wed,  5 Mar 2025 18:10:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741198251; cv=none; b=LiXxvKAuEyEOE7ztFPZC4R+m9iyFhOvbVxA17DznYtpcHgizsCfp+AP384yavHfKxqWqAeUZqsXsYCcAQbHC9U7vp6rBUxxof9z6IWOSJia9wpmYI/3kCP3zpF6aBsDpX4LX5eWeG07wrA1W44WFhPqdDFVAGtdVIz0Sv/ndg9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741198251; c=relaxed/simple;
	bh=PfOF+8Picv/BEVlhwWzZxQznl/ec7Z06h/3BzVOSrNM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qj2SubOB6RZXVqSso4pcEFsEjmThW8+oBrIpmcc+tc/HhStjpAD5MStq1Pla9OmDYWDvDQpamXW9OnFznzoXQHJB06ZUaTGuot1mryJjPboG4mVVA8VoKwrtZulI4gdtC3yDnZAA5kbODTpYA4b62iOAb1yeYSJ19euwHgbjOGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rPPAcVDo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rPPAcVDo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 596EAC4CEE0;
	Wed,  5 Mar 2025 18:10:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741198251;
	bh=PfOF+8Picv/BEVlhwWzZxQznl/ec7Z06h/3BzVOSrNM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rPPAcVDoT+NKkf+OjIthsO0tna1rSfEgq0cJ9RmI+rT/Dq+nZFk7LSK4kjRGdiNMU
	 frsTgsb3I3DCCZRzRqjUq0FWkdFgiTxJUw9EADcgtY0tlAQHKIULgiSSNIKKoMRCq9
	 2oowK27VGtDCB9FYHcS7xnKE/NqYvdI1gssk+CW0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <anup@brainfault.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 084/150] riscv: KVM: Fix SBI TIME error generation
Date: Wed,  5 Mar 2025 18:48:33 +0100
Message-ID: <20250305174507.190731130@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174503.801402104@linuxfoundation.org>
References: <20250305174503.801402104@linuxfoundation.org>
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
index 74e3a38c6a29e..5fbf3f94f1e85 100644
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



