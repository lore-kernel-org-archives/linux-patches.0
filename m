Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A584262A6;
	Tue, 31 Mar 2026 16:44:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975467; cv=none; b=MY7ARML7aoJFuPWgneCoUqW9A5MSx7ahVZ/I2RYbPB74SrpN0Uq45eYZKBD4aMY5hanMUbrAbibJrYzJhdaDnENRy+rrW0moe4Ofw5FG4p8fvEpXan9r6NVGNJa56CBFupVtXFS8F4lClsPaWDflGzxnfIBGynW8EUNwBjkKlrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975467; c=relaxed/simple;
	bh=o/BLT4YVzWQvszgDET7VWzb53qYtxHSbOfwNOs+zEqs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XqM6LSlDMCA0a3pVTa7QsFX+E8IkzNudKu/WmKKwzVzAHQKPb1BNoZrhQFppz7ZsVCT9Nu+ScxUx45bxQKkhL/XPAr5skr71BM+2yBq/MS8EHUjqwnamaeWxRxW6py9d0iz4J1ngsYtDzAbah0aY0UnEzwTFCHsTSP8TzmkOBhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LTTuyaDZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LTTuyaDZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2133CC19423;
	Tue, 31 Mar 2026 16:44:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975467;
	bh=o/BLT4YVzWQvszgDET7VWzb53qYtxHSbOfwNOs+zEqs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LTTuyaDZwpvWLVbia/fkSOEIt6qhrJplOWCPtMPVyGeuENzL4sSBHDMggK6UZ3Som
	 DHqnYaMbkOMYRK8rfc28RBHZmsbA36amKcIRPbegX5oz7Mof5odj6uXBLBxq9BGBEL
	 Su2g5LJbwSXxGFwS6Nn8EBaLd0W854ZEaRMq+gAw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aurelien Jarno <aurel32@debian.org>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.19 273/342] LoongArch: KVM: Make kvm_get_vcpu_by_cpuid() more robust
Date: Tue, 31 Mar 2026 18:21:46 +0200
Message-ID: <20260331161808.989234631@linuxfoundation.org>
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

commit 2db06c15d8c7a0ccb6108524e16cd9163753f354 upstream.

kvm_get_vcpu_by_cpuid() takes a cpuid parameter whose type is int, so
cpuid can be negative. Let kvm_get_vcpu_by_cpuid() return NULL for this
case so as to make it more robust.

This fix an out-of-bounds access to kvm_arch::phyid_map::phys_map[].

Cc: <stable@vger.kernel.org>
Fixes: 73516e9da512adc ("LoongArch: KVM: Add vcpu mapping from physical cpuid")
Reported-by: Aurelien Jarno <aurel32@debian.org>
Link: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1131431
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/kvm/vcpu.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/loongarch/kvm/vcpu.c
+++ b/arch/loongarch/kvm/vcpu.c
@@ -562,6 +562,9 @@ struct kvm_vcpu *kvm_get_vcpu_by_cpuid(s
 {
 	struct kvm_phyid_map *map;
 
+	if (cpuid < 0)
+		return NULL;
+
 	if (cpuid >= KVM_MAX_PHYID)
 		return NULL;
 


