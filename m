Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FCA613D635;
	Thu, 13 Jun 2024 12:07:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280468; cv=none; b=gSmHRqyPsyrJftHDjdmUbNqEAbcQ1Tb4+QgCrnrpQRnmdTAeOpwR0eZYgJCEHDUevAlNH7sTmt9msOv4Pf52hAy0LUWzpbb9DPx+FyPDWbcKY76jaqJKqcrCYDd77Kehf3+NSboZOwFigi+saQpqprpEiF+uGVTpE7uFCIgazNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280468; c=relaxed/simple;
	bh=mFau7EG/3sz3VKvDbAwNGA0vpGcbwNR0P9/jPYyiVF4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cwsbQsrAN1frIEH8w3mGZSCyIXRceiRLtmu6FmWhl5rw8VG2LfQK6Itc/pjQp3+Yv0AYZMHbKoFpmNgKVJEeI5uT2+B26oxTtLULE6mKJQlZRavTietw36pneWEPjym1AUnd6bkgbHbRxZWwozLtEmpG/ReVjMcy5NRYQyX05sc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AnuoHBKQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AnuoHBKQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94B57C2BBFC;
	Thu, 13 Jun 2024 12:07:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280468;
	bh=mFau7EG/3sz3VKvDbAwNGA0vpGcbwNR0P9/jPYyiVF4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AnuoHBKQ4TT8OJwQAQT1iYWrhePejriihTxQHiM05qm4frcUiIdvwaxflRUFT/LW2
	 XhG759wBs3Znv5gZhIUZK14NRPFgGDqq1xt+LrUX5tbC+3WtdzUwd+a1WHX6Yh+WQJ
	 qkW2DEq/Xck6+zOieFeRmBC9EtShY9RhSWFLMlTw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Upton <oliver.upton@linux.dev>,
	Marc Zyngier <maz@kernel.org>
Subject: [PATCH 6.6 063/137] KVM: arm64: AArch32: Fix spurious trapping of conditional instructions
Date: Thu, 13 Jun 2024 13:34:03 +0200
Message-ID: <20240613113225.746596749@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113223.281378087@linuxfoundation.org>
References: <20240613113223.281378087@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Zyngier <maz@kernel.org>

commit c92e8b9eacebb4060634ebd9395bba1b29aadc68 upstream.

We recently upgraded the view of ESR_EL2 to 64bit, in keeping with
the requirements of the architecture.

However, the AArch32 emulation code was left unaudited, and the
(already dodgy) code that triages whether a trap is spurious or not
(because the condition code failed) broke in a subtle way:

If ESR_EL2.ISS2 is ever non-zero (unlikely, but hey, this is the ARM
architecture we're talking about), the hack that tests the top bits
of ESR_EL2.EC will break in an interesting way.

Instead, use kvm_vcpu_trap_get_class() to obtain the EC, and list
all the possible ECs that can fail a condition code check.

While we're at it, add SMC32 to the list, as it is explicitly listed
as being allowed to trap despite failing a condition code check (as
described in the HCR_EL2.TSC documentation).

Fixes: 0b12620fddb8 ("KVM: arm64: Treat ESR_EL2 as a 64-bit register")
Cc: stable@vger.kernel.org
Acked-by: Oliver Upton <oliver.upton@linux.dev>
Link: https://lore.kernel.org/r/20240524141956.1450304-4-maz@kernel.org
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kvm/hyp/aarch32.c |   18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

--- a/arch/arm64/kvm/hyp/aarch32.c
+++ b/arch/arm64/kvm/hyp/aarch32.c
@@ -50,9 +50,23 @@ bool kvm_condition_valid32(const struct
 	u32 cpsr_cond;
 	int cond;
 
-	/* Top two bits non-zero?  Unconditional. */
-	if (kvm_vcpu_get_esr(vcpu) >> 30)
+	/*
+	 * These are the exception classes that could fire with a
+	 * conditional instruction.
+	 */
+	switch (kvm_vcpu_trap_get_class(vcpu)) {
+	case ESR_ELx_EC_CP15_32:
+	case ESR_ELx_EC_CP15_64:
+	case ESR_ELx_EC_CP14_MR:
+	case ESR_ELx_EC_CP14_LS:
+	case ESR_ELx_EC_FP_ASIMD:
+	case ESR_ELx_EC_CP10_ID:
+	case ESR_ELx_EC_CP14_64:
+	case ESR_ELx_EC_SVC32:
+		break;
+	default:
 		return true;
+	}
 
 	/* Is condition field valid? */
 	cond = kvm_vcpu_get_condition(vcpu);


