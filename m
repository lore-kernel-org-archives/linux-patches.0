Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BDCF3A1E92;
	Sat, 17 Oct 2026 17:38:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258683; cv=none; b=QWFDxBGbxRXRMx9KkfK6qFC8siSCMaRCVJOQujymzyCx43U8X6jtsIl0OJlHGiVAv4eagLItlCyVPAQ/YQHbT5qOTiooa4+TpW4p21FW1C2Ht7gujs4I6A0VtZ0hQqkQoXfL+97iocUfvYMcQyo1UpMl/zSPRoCue/gqRkG/B94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258683; c=relaxed/simple;
	bh=AuJ6Ql4ZWwfO2rwKyYkFYRQWyFT8uyfZSR5jzvJAysA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=evS9kTmdY7OOjncCbkZ6uN1pA6NPt0olhQ+YDhdM21KHQ6qgr4PxaWfGud2puZ+ZQwLLhMj49+px4pOL1jmuYtf0l5KsuS3YKArkyIcwrs+fi1VTjc1TVBGO+QPkvnYApBdI75TQ9hy/8vOgKhO5moP37WBk/0fG37XnUflUCkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ccbjbe54; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ccbjbe54"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF4581F000C4;
	Sat, 17 Oct 2026 17:38:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258682;
	bh=TFCmPuEZECodz0Ntyu5zbEG3S9h3imK9Xqvpi/Vfuyc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ccbjbe54jh5wO8cLmAScFzMnZnIDXSL3Zu2/bUGRUbxOLc9pf+ST4ghcaOxMnrrHD
	 /YEKPon/+iv1DbOcPoCasuPbST3NgTDnE2BBfTlOm3D9LPVwxcjVZ8aeh9I/afPi7m
	 qOB6VBHwozdi65y2ziGiPJW21PHFk3zbi7NJgtoY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Osama Abdelkader <osama.abdelkader@gmail.com>,
	Andy Chiu <andybnac@gmail.com>,
	Anup Patel <anup@brainfault.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0964/1674] riscv: kvm: fix vector context allocation leak
Date: Sat, 17 Oct 2026 17:53:56 +0200
Message-ID: <20261017160455.868602213@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Osama Abdelkader <osama.abdelkader@gmail.com>

[ Upstream commit b7c958d7c1eb1cb9b2be7b5ee4129fcd66cec978 ]

When the second kzalloc (host_context.vector.datap) fails in
kvm_riscv_vcpu_alloc_vector_context, the first allocation
(guest_context.vector.datap) is leaked. Free it before returning.

Fixes: 0f4b82579716 ("riscv: KVM: Add vector lazy save/restore support")
Cc: stable@vger.kernel.org
Signed-off-by: Osama Abdelkader <osama.abdelkader@gmail.com>
Reviewed-by: Andy Chiu <andybnac@gmail.com>
Link: https://lore.kernel.org/r/20260316151612.13305-1-osama.abdelkader@gmail.com
Signed-off-by: Anup Patel <anup@brainfault.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kvm/vcpu_vector.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/riscv/kvm/vcpu_vector.c b/arch/riscv/kvm/vcpu_vector.c
index b430cbb695214..3c99400c024b1 100644
--- a/arch/riscv/kvm/vcpu_vector.c
+++ b/arch/riscv/kvm/vcpu_vector.c
@@ -78,8 +78,11 @@ int kvm_riscv_vcpu_alloc_vector_context(struct kvm_vcpu *vcpu,
 		return -ENOMEM;
 
 	vcpu->arch.host_context.vector.datap = kzalloc(riscv_v_vsize, GFP_KERNEL);
-	if (!vcpu->arch.host_context.vector.datap)
+	if (!vcpu->arch.host_context.vector.datap) {
+		kfree(vcpu->arch.guest_context.vector.datap);
+		vcpu->arch.guest_context.vector.datap = NULL;
 		return -ENOMEM;
+	}
 
 	return 0;
 }
-- 
2.53.0



