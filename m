Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B709758F08D;
	Wed,  9 Sep 2026 14:26:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963971; cv=none; b=Oi3NnsN0aELTITW547WxWvTqTo7VBG4HSZkqGvZDx55wjQvBrcFTOqadtyVsHn+LKHTyw5PEXeskGXaJFTCgNQy15KiskbRpeOkr3pffRZ5tzAksJTolRat75RbMxziA7/S6RFtVVQhY4fUfhh6r9S2qrZpJFdIOHeryIXKCGlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963971; c=relaxed/simple;
	bh=Uv3osxnfYdJNiNTT8X7ItgEhT5hRFKzuAMBXaP8M4P4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=io0IaMDfpqMYsXpIZrXRHp1VKrdKLgf/EqsWzM2nDaOkQIno/0LrT4W3Pque7oQTEV2yWHYCJ30yOVPomiIEgRaLLL+Kbv+EH8WtDPez5+bFIyRy8bTl1WhOoRPdcq85rIhDGhcKG5nzzoXLiyW362oZtXLTEDvVrn6i0RmnRtg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DZYnDwmR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DZYnDwmR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C61FF1F00A3A;
	Wed,  9 Sep 2026 14:26:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963970;
	bh=6Xcc+qrJdfqvv0GlEM420Q+4W8x8hTnft1wz+M2ASAs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DZYnDwmReno11TTu+38CN0Nqi/hwNYsadcsuI0LQBOsrOemYb05zSjUOYUHu31d1q
	 WdBL0PxJ5volYmKq3whGMVOqwC+dYC/dOTeDjyQAZu9LZ+P31rIQc+jRZfi8gZrCk5
	 biRtcu5pB6yJz0KkHTmF2u2pxjuCHI0DYzApax94=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>
Subject: [PATCH 6.18 261/583] KVM: arm64: Correctly cap TLBI Range to the architural limit
Date: Wed,  9 Sep 2026 15:39:06 +0200
Message-ID: <20260909134247.143763208@linuxfoundation.org>
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

From: Marc Zyngier <maz@kernel.org>

commit 69a598288195947a1662b53de702eb6976af96b7 upstream.

TLB Invalidation by Range has a fairly powerful way of encoding pretty
large ranges in a small number of bits. This range can be based on an
arbitrary VA, which means it is pretty easy for a guest to generate an
overflow should the hypervisor be naive enough to add the range to the
base...

Make sure the range is capped to the limit dictated by the address bit
that determines the VA range. For an IPA invalidation, this is further
corrected down the line to ignore the upper range.

Fixes: 4ffa72ad8f37e ("KVM: arm64: nv: Add S1 TLB invalidation primitive for VNCR_EL2")
Reported-by: Wei-Lin Chang <weilin.chang@arm.com>
Link: https://lore.kernel.org/r/yifz3wn5gk5sr6mapi32trgk5m5kp33bquctsjmkifebnsnndt@fix6u4rthx4g
Signed-off-by: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org
Reviewed-by: Wei-Lin Chang <weilin.chang@arm.com>
Link: https://patch.msgid.link/20260810170616.746100-1-maz@kernel.org
Signed-off-by: Oliver Upton <oupton@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/kvm_nested.h |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/arch/arm64/include/asm/kvm_nested.h
+++ b/arch/arm64/include/asm/kvm_nested.h
@@ -271,6 +271,12 @@ static inline u64 decode_range_tlbi(u64
 	num	= FIELD_GET(GENMASK(43, 39), val);
 	*range	= __TLBI_RANGE_PAGES(num, scale) << shift;
 
+	/* Cap the range to the correct half of the address space */
+	if (!(base & BIT(48)))
+		*range = min(*range, (BIT(48) - base));
+	else
+		*range = min(*range, ~base + 1);
+
 	return base;
 }
 


