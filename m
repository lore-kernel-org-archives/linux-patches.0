Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AED631C861A;
	Tue, 31 Mar 2026 16:44:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975472; cv=none; b=CKKHe77kcs4U/kPF+klr1PXihtwr+QtzFJ1JwQmSTZp3eonvH65/si83s4hzLMpoQfzqE9S74/MosifSdy+TCE5CQmRklyGaoNjuxjSsY2P1iaDEYpl8vdeTFeCJ160TKTpIqv20bMYyRTTHEraXJEN8cKr1V+eRL+xLxLz13jM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975472; c=relaxed/simple;
	bh=MJQr4686QyzpIiU03xHb9bKcLOynI+yjGVI+cSuKkIw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Abc9qzSfdaj17RrZZg07R1xK6eYNJxqhZsTnmErANYpheye9xYx4uot5vs+JdY+bf5v2X6UY6Mjna3yYrlowobgaYA8vQLL3JijgnWrGDcdv4qQw5vedHud87XcToRax8aNOMWNPpNR4d8+Xr5bbNEQr4zpWYrA9Akqvt/97/zg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XDYfg36R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XDYfg36R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46008C19423;
	Tue, 31 Mar 2026 16:44:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975472;
	bh=MJQr4686QyzpIiU03xHb9bKcLOynI+yjGVI+cSuKkIw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XDYfg36RipLvyK1r6a9dMOKMSpTKciOPMw7PlSezkLVE/jtlBOR9WIkzIozlas+jw
	 0nKW/TfNbxTVQ8S73aFEQBLo9L5aFCB4KXtcBtEbT9XbBSuuCKLYs6sphjk6XE6Czp
	 d2fLwgCer5ZT7ZoRIR82KmyQDbDba1O0pe/mDzEY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aurelien Jarno <aurel32@debian.org>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.19 275/342] LoongArch: KVM: Handle the case that EIOINTCs coremap is empty
Date: Tue, 31 Mar 2026 18:21:48 +0200
Message-ID: <20260331161809.059690507@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>
References: <20260331161758.909578033@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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


