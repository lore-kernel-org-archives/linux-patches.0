Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4D5320ED;
	Thu, 13 Jun 2024 12:45:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282734; cv=none; b=XyzcMj+aCU8Bt1T0q74jn7Cj56fuLwTcy4An/uqUWW+wUq7sw8hu667LWnKQl5lVuS4HzoCTLRMKn11qPdF+0iHHDxb5Gln14fTLLQz5BSFcomiGtlcfapKoueEuOegGNJy8f3Vv81kTqPk34YDSSR1ZCOidY2oL5C9IotYWjyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282734; c=relaxed/simple;
	bh=VORSan15wy2jj3jvFw3hs5685dtaO1bvD1SAIazcAdk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BYw/MUiCHYMGIpC1YHsrjJ7mEFRPZihyNaafUaq+sMsp2+DnlEzMGEkEZOkxdpC+/nX4qGJOVTPOAOOtHQDUn/fE/V95u/R5d7iyVljBua5rhy3wIaFPbMHk4i5CtcYe1axI+fhgEcET5/6Mxlbqi08RLl8liTyonh7SazTdPrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BeKOUHYS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BeKOUHYS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 309C7C4AF1A;
	Thu, 13 Jun 2024 12:45:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282734;
	bh=VORSan15wy2jj3jvFw3hs5685dtaO1bvD1SAIazcAdk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BeKOUHYSgT2XO0bBfWq9puULTf1Q9EM+pYFh0Yy5M0rgeRzjHduiZlCtBzPuMGp3r
	 B3b9iebljpvX5tpc3mNFdHWH/qC/FHxnkhVyEjs/4pxdwpHTjHWtBp6WEi1p8edsSz
	 r8UIVNBC4zOwL/DHR88Yfh79U7GNjHvS4Vm0/8yM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Upton <oliver.upton@linux.dev>,
	Marc Zyngier <maz@kernel.org>
Subject: [PATCH 5.15 377/402] KVM: arm64: Allow AArch32 PSTATE.M to be restored as System mode
Date: Thu, 13 Jun 2024 13:35:34 +0200
Message-ID: <20240613113316.850404241@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Zyngier <maz@kernel.org>

commit dfe6d190f38fc5df5ff2614b463a5195a399c885 upstream.

It appears that we don't allow a vcpu to be restored in AArch32
System mode, as we *never* included it in the list of valid modes.

Just add it to the list of allowed modes.

Fixes: 0d854a60b1d7 ("arm64: KVM: enable initialization of a 32bit vcpu")
Cc: stable@vger.kernel.org
Acked-by: Oliver Upton <oliver.upton@linux.dev>
Link: https://lore.kernel.org/r/20240524141956.1450304-3-maz@kernel.org
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kvm/guest.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -250,6 +250,7 @@ static int set_core_reg(struct kvm_vcpu
 		case PSR_AA32_MODE_SVC:
 		case PSR_AA32_MODE_ABT:
 		case PSR_AA32_MODE_UND:
+		case PSR_AA32_MODE_SYS:
 			if (!vcpu_el1_is_32bit(vcpu))
 				return -EINVAL;
 			break;


