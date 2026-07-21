Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C386147045A;
	Tue, 21 Jul 2026 19:53:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663588; cv=none; b=XLtr9QV/RZp7lY4riAT1xgnZRnzm5bEVfo6I1RoNNbvhXXel34YOjNK3Yc8xQCmCBnori+HOZp8X3qsvUZvWIBdpFObJQL0bknzvub5xTujLWsC/c/mZGjK1W/Q5MAOS7QHkHDv4lN+bydhpWB0nxrNSe9G824NQoQ/G7HW1/RA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663588; c=relaxed/simple;
	bh=Mu7DbmvaDTg/H5BMFiu0P2yj2CVUlaie9wajoHG9AtI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g2bfGDKz0/RVt7PaMf76OcTVdH8WJJQBMA+BIpIUHhIiC0GKSOo/1ZoM4uM9jjkbTCMtNMesxlDtx0CDS2G7ysa9tC4VW+wIKcxn4LZz+k7PKmjbDZhrcIRvRTCN0b1p7FpU7f1OrYP4DR7JHMnhKFeiAJbgfKakEIhJv66TgMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0kbR9TO/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0kbR9TO/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34A841F000E9;
	Tue, 21 Jul 2026 19:53:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663586;
	bh=ssgoQp0Iu7Ifv7kpw9YYqYz9emisQ/+osy69WkZTvGA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0kbR9TO/+c2mGBoDNdtKV1UZnsVIrNdIe9dK3CV6xbN2urbS+2Rlt/vzLmqj2nTIV
	 pCGu3oikGOYFMncdBlyb1qaY1NtpR8xIYK6UFfuUFDIVGT++SmKt2PYA/lpIvaH9DR
	 nwumOWHgbXzba4097Ew0p4irznV2pR5S75piELsU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Upton <oupton@kernel.org>,
	Marc Zyngier <maz@kernel.org>
Subject: [PATCH 6.12 0836/1276] KVM: arm64: nv: Drop bogus WARN for write to ZCR_EL2
Date: Tue, 21 Jul 2026 17:21:19 +0200
Message-ID: <20260721152504.766368711@linuxfoundation.org>
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

From: Oliver Upton <oupton@kernel.org>

commit 9f1667098c6ae7ec81a9a56859cfdacb822aa0d0 upstream.

It is entirely possible for a guest to write to the ZCR_EL2 sysreg alias
while in a nested context, as it is expected if FEAT_NV2 is advertised
to the L1 hypervisor.

Get rid of the bogus WARN which, since the hyp vectors were installed at
this point, has the effect of a hyp_panic...

Cc: stable@vger.kernel.org
Fixes: 0cfc85b8f5cf ("KVM: arm64: nv: Load guest FP state for ZCR_EL2 trap")
Signed-off-by: Oliver Upton <oupton@kernel.org>
Link: https://patch.msgid.link/20260615051324.830045-1-oupton@kernel.org
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kvm/hyp/include/hyp/switch.h |    2 --
 1 file changed, 2 deletions(-)

--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -451,8 +451,6 @@ static inline bool kvm_hyp_handle_fpsimd
 			return false;
 		break;
 	case ESR_ELx_EC_SYS64:
-		if (WARN_ON_ONCE(!is_hyp_ctxt(vcpu)))
-			return false;
 		fallthrough;
 	case ESR_ELx_EC_SVE:
 		if (!sve_guest)


