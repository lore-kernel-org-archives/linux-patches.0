Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14C103161AD;
	Thu, 16 Jul 2026 14:18:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211539; cv=none; b=cVOKtFQH0T70sHWtjJY5xB7WUdI0Ogw22MPi8Ae80cpZr2Q7F7pztBYVyP9Oi1VOrr7ABle+wFinvpA93hCW61zg/Ig5iIbJO2Y/h/02EIhh2FtuDva+8jKjGvJEXx1y+cmJO/UAe53M70UwL9dKxiomRJ4DYSxLw5D2NasydO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211539; c=relaxed/simple;
	bh=vvJEB9mqQm4zNnf6tYRInYSmypvmvMWV5EpvsZVpu4w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NhLg7E2dVJsfjttlw510RN8JBlqWml9BChr/O0FX2wdqQL3yntOyRjNDE25u7z44UrM+P3pHTMxTN9jSAhN/LBlyRPiQnOtd2wNhV/aaWF+Hbp9dyB+Dqm+b+YzG0k9DK2BUHvxgSG3Y0utfLjnV1OUl56f26WEHpVpwcCg+e6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M7KAUDPd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M7KAUDPd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A9BA1F000E9;
	Thu, 16 Jul 2026 14:18:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211538;
	bh=qgkBv6S5h0CL/O/ygAJ8pCt7Iuc7AzdoK6Js62taBz0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M7KAUDPdw6DCM7KKhsYSSARRaWGkPXBWJWQPABg7ybvR+FklPDDi+yVZsUgFkRgmG
	 KwekGchFBGPq4nNo4KrhQiMEdqAK5R2dCO9M9zuANQevH0+uZQ3vgLr8vUmgg+032f
	 Aa37ScZBiSmiCZ5U2yZ8LPkeoq9lL9XKtHnfnURU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunwoo Kim <imv4bel@gmail.com>,
	Fuad Tabba <tabba@google.com>,
	Marc Zyngier <maz@kernel.org>
Subject: [PATCH 6.18 422/480] KVM: arm64: Clear __hyp_running_vcpu when flushing the pKVM hyp vCPU
Date: Thu, 16 Jul 2026 15:32:49 +0200
Message-ID: <20260716133053.943230285@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kvm/hyp/nvhe/hyp-main.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -126,6 +126,9 @@ static void flush_hyp_vcpu(struct pkvm_h
 
 	hyp_vcpu->vcpu.arch.ctxt	= host_vcpu->arch.ctxt;
 
+	/* __hyp_running_vcpu must be NULL in a guest context. */
+	hyp_vcpu->vcpu.arch.ctxt.__hyp_running_vcpu = NULL;
+
 	hyp_vcpu->vcpu.arch.mdcr_el2	= host_vcpu->arch.mdcr_el2;
 	hyp_vcpu->vcpu.arch.hcr_el2 &= ~(HCR_TWI | HCR_TWE);
 	hyp_vcpu->vcpu.arch.hcr_el2 |= READ_ONCE(host_vcpu->arch.hcr_el2) &


