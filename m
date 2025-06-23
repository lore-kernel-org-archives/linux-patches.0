Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6466D222576;
	Mon, 23 Jun 2025 22:16:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750717011; cv=none; b=BHvd2TFl97OsmV05ACT8ntynOqhpiL0EzUgRPkjJbBGEr8LxYxP5YRg6M+LOlAZwqvTJGWt/r1cQXXThqYvUS+k+k9yNi+uPuaZYjYipHR72ACMgcqND42yEwGnqSWtv2PbtzU9zi6+5BLEIRA/SKn6qKkrs5d9Z/2BEv4NE1bY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750717011; c=relaxed/simple;
	bh=1Cm/6bzGx5im1e78jdvgMVfGmcdRGzr949NI3vdUTGs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mmdhm7MSynmHBrklQrj5yv1W9jwzZDUVB1HC/oIt0itQMD8LE2VG+Sn/VDvsHPtwgTmc61gVpqBrnN5LQBppAj7dC+akN3f0mI+qkeu26+4hPHbjqLy28YkpErtfF5XA4B44mHiN/2JbsSyT16eX79WwIOMGvUxDQHUznAhbvh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lugxxowI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lugxxowI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2D2BC4CEED;
	Mon, 23 Jun 2025 22:16:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750717011;
	bh=1Cm/6bzGx5im1e78jdvgMVfGmcdRGzr949NI3vdUTGs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lugxxowIwczqHC+g1z6eq18/rRPt2JOS7i0sUUXA/J2pJRsYeX924Fm5NBlQYEj5G
	 Guec8UbFasJH0hvMALDyvrYOY0auJVPSUI8iwM9jxlkuRCU6jKrV6L4Tv1iGTYZcjl
	 jVwyxjJ1ChYOnOfh9ig/7h0Z933QzNprW0f58fi0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Atish Patra <atishp@rivosinc.com>,
	Anup Patel <apatel@ventanamicro.com>,
	Anup Patel <anup@brainfault.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 577/592] RISC-V: KVM: Dont treat SBI HFENCE calls as NOPs
Date: Mon, 23 Jun 2025 15:08:55 +0200
Message-ID: <20250623130714.162236624@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anup Patel <apatel@ventanamicro.com>

[ Upstream commit 2e7be162996640bbe3b6da694cc064c511b8a5d9 ]

The SBI specification clearly states that SBI HFENCE calls should
return SBI_ERR_NOT_SUPPORTED when one of the target hart doesn’t
support hypervisor extension (aka nested virtualization in-case
of KVM RISC-V).

Fixes: c7fa3c48de86 ("RISC-V: KVM: Treat SBI HFENCE calls as NOPs")
Reviewed-by: Atish Patra <atishp@rivosinc.com>
Signed-off-by: Anup Patel <apatel@ventanamicro.com>
Link: https://lore.kernel.org/r/20250605061458.196003-3-apatel@ventanamicro.com
Signed-off-by: Anup Patel <anup@brainfault.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kvm/vcpu_sbi_replace.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/kvm/vcpu_sbi_replace.c b/arch/riscv/kvm/vcpu_sbi_replace.c
index 9752d2ffff683..b17fad091babd 100644
--- a/arch/riscv/kvm/vcpu_sbi_replace.c
+++ b/arch/riscv/kvm/vcpu_sbi_replace.c
@@ -127,9 +127,9 @@ static int kvm_sbi_ext_rfence_handler(struct kvm_vcpu *vcpu, struct kvm_run *run
 	case SBI_EXT_RFENCE_REMOTE_HFENCE_VVMA_ASID:
 		/*
 		 * Until nested virtualization is implemented, the
-		 * SBI HFENCE calls should be treated as NOPs
+		 * SBI HFENCE calls should return not supported
+		 * hence fallthrough.
 		 */
-		break;
 	default:
 		retdata->err_val = SBI_ERR_NOT_SUPPORTED;
 	}
-- 
2.39.5



