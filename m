Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFE5B31717E;
	Tue, 31 Mar 2026 17:08:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976911; cv=none; b=Hq5nDmh9ixqOetHJXPrcvatxHS/Qpnyikz8TtQp+NQLx9EpOG/QuVUbAB/0bJolorCVhrNuwyxVkTkhall8QHxKUHtgyLq9+AEBAxEhacOsoJLq0AuzRh56bz5DHFuM+vlC3/rJYwgMyJuE54meoyOvYOpoxpTDUo+064aIvk2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976911; c=relaxed/simple;
	bh=yZGyOriDWqgyzFxCoE8CgL8UhYZ8qOJwkGIoemN4U34=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KjIN9j5B+qM+hGgaE5USPNJ/LhBsP0vidDlxgmTZbIEZ+y7rJqPCcB22Q51VvsU0gCB7KuLIUN1ZeEXhgJVF61FebKevwJFN7YUu7MI/Bgs1soptwYmDTr7nh/OBQeOnxl8189q6XKogKdbXPk5hvbsP6gshzV9ATOlJ3H0z6vM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U31Ezv/W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U31Ezv/W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8368FC19423;
	Tue, 31 Mar 2026 17:08:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976910;
	bh=yZGyOriDWqgyzFxCoE8CgL8UhYZ8qOJwkGIoemN4U34=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U31Ezv/WrPLZsvz1gH5QawKnCZ5c51uUDfS9DL42RbOb55hxrNGbKwCu0dGOga1GB
	 1b8rnhX00xv5mKYoiqHW4pDoJSwl1BsoaLTX+Xvbb9EYhcyQtcl2VqyvWAxkPcu0zT
	 GqrZmrIC6g+2XYMco2IriCNp/XTRmC8Qcq/yKj8o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aurelien Jarno <aurel32@debian.org>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.18 242/309] LoongArch: KVM: Handle the case that EIOINTCs coremap is empty
Date: Tue, 31 Mar 2026 18:22:25 +0200
Message-ID: <20260331161802.480472740@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161753.468533260@linuxfoundation.org>
References: <20260331161753.468533260@linuxfoundation.org>
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

From: Huacai Chen <chenhuacai@loongson.cn>

commit b97bd69eb0f67b5f961b304d28e9ba45e202d841 upstream.

EIOINTC's coremap in eiointc_update_sw_coremap() can be empty, currently
we get a cpuid with -1 in this case, but we actually need 0 because it's
similar as the case that cpuid >= 4.

This fix an out-of-bounds access to kvm_arch::phyid_map::phys_map[].

Cc: <stable@vger.kernel.org>
Fixes: 3956a52bc05bd81 ("LoongArch: KVM: Add EIOINTC read and write functions")
Reported-by: Aurelien Jarno <aurel32@debian.org>
Link: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1131431
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/kvm/intc/eiointc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/loongarch/kvm/intc/eiointc.c
+++ b/arch/loongarch/kvm/intc/eiointc.c
@@ -83,7 +83,7 @@ static inline void eiointc_update_sw_cor
 
 		if (!(s->status & BIT(EIOINTC_ENABLE_CPU_ENCODE))) {
 			cpuid = ffs(cpuid) - 1;
-			cpuid = (cpuid >= 4) ? 0 : cpuid;
+			cpuid = ((cpuid < 0) || (cpuid >= 4)) ? 0 : cpuid;
 		}
 
 		vcpu = kvm_get_vcpu_by_cpuid(s->kvm, cpuid);


