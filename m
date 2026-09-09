Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA405576ED4;
	Wed,  9 Sep 2026 14:26:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963962; cv=none; b=gncDr5f6iHDDAie5pHiu+caLGg7arJThujAsuJc3y6QsnQfKOwxYVqyOGKiGkbpIllb2Fc2IJM72nRU3RxoFprBvwwYlskUY5dDtpfJR0t6wOOLfelCtWa5re+y/bkVKNgoSTXWegjW7CmWfxjk34/xqax2f/8aflWy4le93dx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963962; c=relaxed/simple;
	bh=AQTPPqyQEL71+A56oWMfIpSLl0Wib0QMT4T3HG1cGDw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fcq24qhEG8hkgzxr48bdUhN7fcd/twT/nTKm3ZYjZq0ZMzhbXG6SESTmsQ6srh0PgEhh8S6PfaALaCDLOuY8lPoU9dApIfWQ+NOoknD8tw+pMdumkyBGBAufrOqY39DGZ/zgG3HEC7a51xF79dHaFQIwnMSQS/qeyDE8FgrERTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2IAxo6SS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2IAxo6SS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D64A1F00A3A;
	Wed,  9 Sep 2026 14:26:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963961;
	bh=lU/QrPv9kNxgG14vo60ck/n4LDyKaVE/qQznW+DruLg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2IAxo6SS/DsTCvz/ro7sPHbnVoVgx1lsC3DIzXmPQ1vtGCCtku92Ta4RhWyayNP03
	 2GPteNNDEB4FufQBQ0VjzsQVq2ZjlMopN+MT//fqXPG6uBpAxQeuBmrssMIt/FBMfM
	 8HZZGglJ6XKj446eVGzfk0bBWPNSY+9FRbxgaV7E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kajetan Puchalski <kajetan.puchalski@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>
Subject: [PATCH 6.18 258/583] KVM: arm64: vgic: Fix detection of MI on no pending LR
Date: Wed,  9 Sep 2026 15:39:03 +0200
Message-ID: <20260909134247.050466215@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

From: Kajetan Puchalski <kajetan.puchalski@arm.com>

commit a342faadc5acbd5d9fd894fd4499d4fd614dfcf6 upstream.

As per the ARM GICv3 spec, the maintenance interrupt identified by
ICH_MISR_EL2.NP is asserted when it is enabled and no List register is
in pending state. This is further described in the document as "no List
registers with the State field set to 0b01 (pending)". By checking only
the pending bit of the LR (bit 62), KVM currently asserts the MI when
there are no LRs in "pending" or "pending and active" states.
Fix the detection logic to consider only the "pending" state.

Cc: stable@vger.kernel.org
Fixes: 96c2f03311de ("KVM: arm64: nv: Plumb handling of GICv3 EL2 accesses")
Signed-off-by: Kajetan Puchalski <kajetan.puchalski@arm.com>
Reviewed-by: Marc Zyngier <maz@kernel.org>
Link: https://patch.msgid.link/20260810102923.2426475-2-kajetan.puchalski@arm.com
Signed-off-by: Oliver Upton <oupton@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kvm/vgic/vgic-v3-nested.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/kvm/vgic/vgic-v3-nested.c
+++ b/arch/arm64/kvm/vgic/vgic-v3-nested.c
@@ -149,7 +149,7 @@ static void vgic_compute_mi_state(struct
 			eisr |= BIT(i);
 		if (!(lr & ICH_LR_STATE))
 			elrsr |= BIT(i);
-		pend |= (lr & ICH_LR_PENDING_BIT);
+		pend |= (lr & ICH_LR_STATE) == ICH_LR_PENDING_BIT;
 	}
 
 	mi_state->eisr	= eisr;


