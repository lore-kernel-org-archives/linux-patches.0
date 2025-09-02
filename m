Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2942D2DC33B;
	Tue,  2 Sep 2025 13:35:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756820120; cv=none; b=tmnsCVMgMGf8apxTEI98UDn6x09deSCUyU8a2eL1ljucuXg0hCuE2KatHN8MvPDiv57pzzepbxI2bxcruN7MnDPDfXeYIBp7r9TlYB4ND0y3T/T5hx+fWj9n9SSWLWz+uVgxEOdvLkzRUVrIndjngv17r4JGZkIx3iEA4PGE2Lc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756820120; c=relaxed/simple;
	bh=gla+jhBCe5RXnSyeZcu2bKrJzAafMAFU6tXw8kIVZjM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IVqll8Aj64yklOpCMW78zowG58q7w4gwu5ztm4GHRiIhGRIvhGUnBgmLPyRt8cKGOajjGAV7vmNzc/eWoJ+mpz3tZMjOzpPSYnYGpbrN160SoNeulBoWSwZOWWBI+gd98jMSWFmHlZIkt0iHuZaoD/OvQQKsUb+4wuC/4Yl8M+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YLk+iQyg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YLk+iQyg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E213C4CEED;
	Tue,  2 Sep 2025 13:35:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756820120;
	bh=gla+jhBCe5RXnSyeZcu2bKrJzAafMAFU6tXw8kIVZjM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YLk+iQyg3zHr9GqVpUoeFL9rF+cf2Fx4VlOhEKTnULFoAa8Ntasf2FBnobuyQoFMo
	 Yep7Op/xG9mpQTsVgI+FJ7kU//uaU1zZc3QoKOwNvVbPtOnctVd5WLwEnjj+PiBbfM
	 GHDk8lnbOm3ebmdTzij0Bz63D45fOReQg46ZbinI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@ventanamicro.com>,
	Nutty Liu <liujingqi@lanxincomputing.com>,
	Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
	Anup Patel <anup@brainfault.org>
Subject: [PATCH 6.12 68/95] RISC-V: KVM: fix stack overrun when loading vlenb
Date: Tue,  2 Sep 2025 15:20:44 +0200
Message-ID: <20250902131942.213540312@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131939.601201881@linuxfoundation.org>
References: <20250902131939.601201881@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Radim Krčmář <rkrcmar@ventanamicro.com>

commit 799766208f09f95677a9ab111b93872d414fbad7 upstream.

The userspace load can put up to 2048 bits into an xlen bit stack
buffer.  We want only xlen bits, so check the size beforehand.

Fixes: 2fa290372dfe ("RISC-V: KVM: add 'vlenb' Vector CSR")
Cc: stable@vger.kernel.org
Signed-off-by: Radim Krčmář <rkrcmar@ventanamicro.com>
Reviewed-by: Nutty Liu <liujingqi@lanxincomputing.com>
Reviewed-by: Daniel Henrique Barboza <dbarboza@ventanamicro.com>
Link: https://lore.kernel.org/r/20250805104418.196023-4-rkrcmar@ventanamicro.com
Signed-off-by: Anup Patel <anup@brainfault.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/kvm/vcpu_vector.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/riscv/kvm/vcpu_vector.c
+++ b/arch/riscv/kvm/vcpu_vector.c
@@ -181,6 +181,8 @@ int kvm_riscv_vcpu_set_reg_vector(struct
 		struct kvm_cpu_context *cntx = &vcpu->arch.guest_context;
 		unsigned long reg_val;
 
+		if (reg_size != sizeof(reg_val))
+			return -EINVAL;
 		if (copy_from_user(&reg_val, uaddr, reg_size))
 			return -EFAULT;
 		if (reg_val != cntx->vector.vlenb)


