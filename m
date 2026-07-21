Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF15F4028E9;
	Tue, 21 Jul 2026 17:16:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654201; cv=none; b=mKaKQBn+lykzii1sVybgWM9XZmQoSmc5psJXsmyYdKCdl0GfQpq7iMvEFoCOpdp2V8LykJ6sM4df7eZDBPbxPFvBZLJZh9X0GpZudwCpzxT40TxhPz3bJ9pFRCqXuizNhzYcFRgudnsokyHbXCpzL5Pqz83QoKdY/Rmq/V5YfEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654201; c=relaxed/simple;
	bh=chA4d20eKVR/aaNc94h/CY/5Ceqh/l77ir0ce5KxQ6Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K5xmXMYp00K/1KenpzUaTj5x4GzeITXaqGOrC6OjJKgm1xvwJDsc2T3zcwExq67VY4ENVGIH0GgpzThQyM2ky6NJkmlCJjO6b0wsFvH4ak0cTzQTLVF3Y7E59URXHkA4vot0cDYo+Ik+zqkcArV0X9y1VP244Sa8CR/TNHDr46k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YYwae2jC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YYwae2jC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 509141F000E9;
	Tue, 21 Jul 2026 17:16:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654200;
	bh=S4aV9ZXvs9OX1D6kSaacZuYCsCYJoaiGE1mC3nqjaGc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YYwae2jCFkXd3qEO1hr4mFOAhwfluHLASi5P9vjP8fhejFEE3a/3Mc9vbbt4pOGQi
	 izlEA3+Lt+fHnUpJzdgWxLhUbbGC7UF4+jRpALg3Kv/gfST/B7h79h+Dc5WedBN7Nw
	 HhUjdD4Nfj9nT/6K1B0P5GYVpI+uSbXIJnHlpWjI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Upton <oupton@kernel.org>,
	Marc Zyngier <maz@kernel.org>
Subject: [PATCH 7.1 1572/2077] KVM: arm64: nv: Drop bogus WARN for write to ZCR_EL2
Date: Tue, 21 Jul 2026 17:20:45 +0200
Message-ID: <20260721152629.857425174@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -601,8 +601,6 @@ static inline bool kvm_hyp_handle_fpsimd
 			return false;
 		break;
 	case ESR_ELx_EC_SYS64:
-		if (WARN_ON_ONCE(!is_hyp_ctxt(vcpu)))
-			return false;
 		fallthrough;
 	case ESR_ELx_EC_SVE:
 		if (!sve_guest)


