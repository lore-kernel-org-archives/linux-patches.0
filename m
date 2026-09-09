Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3E40563299;
	Wed,  9 Sep 2026 14:02:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962530; cv=none; b=ZO7oQWHFzK7UdjwYUPoOK681Ohxv4OKkSLYMIMWFULxvpnJBBpPOqGqIgBz/1YN6jqOzu++lIa1W//e+OeBaOzYrZF5XwxqhTVaSMFbT9kepiQWxHjTQEQ9WR3JoST/3yxiWqRuLR3uwIQqH5dCxEJddMaTHCsHM8Jd1zJz+2/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962530; c=relaxed/simple;
	bh=KXSWHMbvXMkaJmK1e9H6OeHIFjE4VCL6u/pOHDYKAJM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WFn5xj47mXlucSKIQD7x4yh+IljsoyLpK7GBpt5kfd4Hwai1qOQ1isAORpNK4dMpX3tZ8Pq0vA1IsSPqTITsx8BJj/QKyV8DEFV9PFRLByzSNM5780N6NMutFhbT2Ds8BTaEd0j8ziR14VBMjBwZZR6JIObptOOMHUJjX09ssyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ca/c2opw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ca/c2opw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E61991F00A3A;
	Wed,  9 Sep 2026 14:02:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962529;
	bh=+p5e791aTnv0Asa8rGQAykZmllzrK+0bkLmjq0yLlzA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ca/c2opwyDrR1eGAcDtGrKFtJ6IAiJGVyUrwrvJnFHdjV76R0OdR0KuMA12gH20Fu
	 ZyE4s3RyMxj0Dk4F8Nb9p7szxazGv6y2Kl1KezGzMVbZ9vPDE90BB7xMpdIDhJ3qfP
	 aIqsBhlxfIZq+gfHDs5rkXgjajHsBFmeZOz5jGRE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kajetan Puchalski <kajetan.puchalski@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>
Subject: [PATCH 7.2 322/556] KVM: arm64: vgic: Fix detection of MI on no pending LR
Date: Wed,  9 Sep 2026 15:40:02 +0200
Message-ID: <20260909134241.989461448@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -152,7 +152,7 @@ static void vgic_compute_mi_state(struct
 			eisr |= BIT(i);
 		if (!(lr & ICH_LR_STATE))
 			elrsr |= BIT(i);
-		pend |= (lr & ICH_LR_PENDING_BIT);
+		pend |= (lr & ICH_LR_STATE) == ICH_LR_PENDING_BIT;
 	}
 
 	mi_state->eisr	= eisr;


