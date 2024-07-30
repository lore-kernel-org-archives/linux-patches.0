Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75AAA161901;
	Tue, 30 Jul 2024 17:00:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358841; cv=none; b=U+yBvld+btjfUyzPtJwuGmztcQAIjUxsw2o8wYoU9btK0jSi1XN4dReSnQkaFvHaFoC0mOSvsZ9w5NTfaWq/jKVSRUTAGQjKyyv7SzDwitMWx5v4e3sMkRqn1wIpUJVWdW4c25pUXm8BzkkwDEpBtOe4UwT53AdJu8uvcix8tlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358841; c=relaxed/simple;
	bh=QX6LD+veOcn5y8tWrgG6rAyhqcIyHycG2FcuGLXR6pA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AkKPgwaxMEhQVqAfyI40fN9pibcuxdikFBaGEfg88jktYJqDu18QPE2pVWx88TeInsfWcNQYVK26zZ5Rkpe2CsiCKMUU+Km9UI9cExnTCWvVC6t9hoEZgQVc7nSx0Dwv9GuoF7Jtd6tUlX2vmSknShh7TP0tuX42Ud2PXf1flXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RRTMLRkj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RRTMLRkj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3F27C32782;
	Tue, 30 Jul 2024 17:00:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358841;
	bh=QX6LD+veOcn5y8tWrgG6rAyhqcIyHycG2FcuGLXR6pA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RRTMLRkj67nLMGRGsJaxZB+eHQG1OisOcdNexCWnejFarFUjzk2j1bU9A8S7l/DN2
	 hDJ7Acs/S/e1TqhHENnwGv+sRH6fLlxM1SEGiYRemjn1CvDOKO64WRahDdYeroJ1un
	 Z2Ha5JQH23qhwO2FznxVXFJot9lV33wXoen8QLME=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shivaprasad G Bhat <sbhat@linux.ibm.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 401/809] KVM: PPC: Book3S HV: Fix the get_one_reg of SDAR
Date: Tue, 30 Jul 2024 17:44:37 +0200
Message-ID: <20240730151740.524602422@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shivaprasad G Bhat <sbhat@linux.ibm.com>

[ Upstream commit 009f6f42c67e9de737d6d3d199f92b21a8cb9622 ]

The kvmppc_get_one_reg_hv() for SDAR is wrongly getting the SIAR
instead of SDAR, possibly a paste error emanating from the previous
refactoring.

Patch fixes the wrong get_one_reg() for the same.

Fixes: ebc88ea7a6ad ("KVM: PPC: Book3S HV: Use accessors for VCPU registers")
Signed-off-by: Shivaprasad G Bhat <sbhat@linux.ibm.com>
Reviewed-by: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/171759278410.1480.16404209606556979576.stgit@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kvm/book3s_hv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index a4f34f94c86f7..b576781d58d54 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -2305,7 +2305,7 @@ static int kvmppc_get_one_reg_hv(struct kvm_vcpu *vcpu, u64 id,
 		*val = get_reg_val(id, kvmppc_get_siar_hv(vcpu));
 		break;
 	case KVM_REG_PPC_SDAR:
-		*val = get_reg_val(id, kvmppc_get_siar_hv(vcpu));
+		*val = get_reg_val(id, kvmppc_get_sdar_hv(vcpu));
 		break;
 	case KVM_REG_PPC_SIER:
 		*val = get_reg_val(id, kvmppc_get_sier_hv(vcpu, 0));
-- 
2.43.0



