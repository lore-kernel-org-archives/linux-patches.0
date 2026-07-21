Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F6E3417D67;
	Tue, 21 Jul 2026 19:14:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661294; cv=none; b=CtnRbBDCdwWoPTd5x/w7NAFWVYcqweI17P4gKkxGWefvnggfZt06qaYkXZ/jukkkzsXER0Bl7lJqSSSkqlvc9abxyYxySPELwOkDvNzeDY2cKsH1dhKwcfxxfcknD39sW6JBhtksyHd+sUA6iwUmj2edLgGZehgQLcf3WhnHKWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661294; c=relaxed/simple;
	bh=is3J2aoTaZcb7xE6wZYrcSJujeRbVIa8QrsuK1497F4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JgYadhhEVoVlfjhcPWLz5Ez9ZvCIpdXsFjmzJKQvs+M/DYJrlKMq1Mvlz9dxE2ICZWmrZ7B+TzNJGrF/MlN852N3NX04XQtMbdECCLiUk4CEjyGaXMSGnsc9IdjrwmUpK0+/h20V4B0ZfxfKopu/Era9Os7XgpQggHE1W4bwlXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JhoEQGsx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JhoEQGsx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF61D1F000E9;
	Tue, 21 Jul 2026 19:14:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661293;
	bh=/QlgxQtD6XP3nujTHX/aTy7mpdk4vKoJW8GpRhiZjBg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JhoEQGsxa71bPrU+UbZMkXFCHVKyl26BraZZXoZHqV85pLl8DN4oV9PdlOS07Dr9C
	 8knCNsqPPcr6xcasdTuSAvHxRu49GKhAdNBr+cjNPuzFXXHAgYNwJ/zWkL0pMkmlDw
	 8Y5UzNvL65IGvSUzATM3JYXsCAAblKwdBVe0Whzs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunwoo Kim <imv4bel@gmail.com>,
	Fuad Tabba <tabba@google.com>,
	Marc Zyngier <maz@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0013/1276] KVM: arm64: Clear __hyp_running_vcpu when flushing the pKVM hyp vCPU
Date: Tue, 21 Jul 2026 17:07:36 +0200
Message-ID: <20260721152446.376438315@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hyunwoo Kim <imv4bel@gmail.com>

commit e8042f6e1d7befb2fb6b10a75918642bcd0acf9a upstream.

flush_hyp_vcpu() copies the host vCPU context into the hyp's private
vCPU on every run. ctxt_to_vcpu() expects a guest context to have a
NULL __hyp_running_vcpu, which is only ever set on the host context, so
that it resolves the vCPU via container_of(). While this is generally
the case, flush_hyp_vcpu() copies the context verbatim and does not
enforce this, so a value provided by the host is dereferenced at EL2
(host -> EL2).

Fix by clearing __hyp_running_vcpu after the copy.

Cc: stable@vger.kernel.org
Fixes: be66e67f1750 ("KVM: arm64: Use the pKVM hyp vCPU structure in handle___kvm_vcpu_run()")
Signed-off-by: Hyunwoo Kim <imv4bel@gmail.com>
Reviewed-by: Fuad Tabba <tabba@google.com>
Tested-by: Fuad Tabba <tabba@google.com>
Link: https://patch.msgid.link/20260606175614.83273-2-imv4bel@gmail.com
Signed-off-by: Marc Zyngier <maz@kernel.org>
[ tabba: adjust flush_hyp_vcpu() context ]
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kvm/hyp/nvhe/hyp-main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 5dbc1878428cc2..72384712377d16 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -103,6 +103,9 @@ static void flush_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)
 
 	hyp_vcpu->vcpu.arch.ctxt	= host_vcpu->arch.ctxt;
 
+	/* __hyp_running_vcpu must be NULL in a guest context. */
+	hyp_vcpu->vcpu.arch.ctxt.__hyp_running_vcpu = NULL;
+
 	hyp_vcpu->vcpu.arch.sve_state	= kern_hyp_va(host_vcpu->arch.sve_state);
 	/* Limit guest vector length to the maximum supported by the host.  */
 	hyp_vcpu->vcpu.arch.sve_max_vl	= min(host_vcpu->arch.sve_max_vl, kvm_host_sve_max_vl);
-- 
2.53.0



