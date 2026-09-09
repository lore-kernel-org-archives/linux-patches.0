Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF576563299;
	Wed,  9 Sep 2026 14:02:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962539; cv=none; b=l9W8nJQrpj1SzC0c9LHn9esZ74FCHZza9rvK3W8xZOufqvyLvmuJJFuE9Tx3RCKrxyQ+LXBHSkwhreOQriOyYNnpbhBjjHjZr5w5HKFglpTjiFeJT29vXFWzfea+s1bvWbuLhdiB8rMqmLGjwPmEr13fBmCUAPfROGFbomTsBfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962539; c=relaxed/simple;
	bh=63QKgVhEww6CZItcHgELrrxsnIwhtMPn7R290Be75MY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ck70mNeC+JqaXJ7RtebCMFNSV5285CIQ9EOAbCs4IhHpmNJJ8Y813zTggM01GWNs4aVCk12jn8NHLn/gBOiT/JCvMOdoh89SwW2pAL30EprTD8VYkECmaTY+IAotQuQ8Kv213VHAMZDSmrXa1fft3yFWAJcaE26Oq1NVpplsxX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hIYpE+zg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hIYpE+zg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13ECC1F00A3A;
	Wed,  9 Sep 2026 14:02:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962538;
	bh=fDnppIaRadioCsppsok5NJa0zT5mIjTCm94HFr16zaE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hIYpE+zgpa1+c4LkFF4mJz3T1lzqVnoDwisQL6MAnins+Fgr0QXR2GwmsiWcDbDql
	 tC+c+l0yuv1FK6nSGVSMGv303olTJjSqRPtdRsP5ucu8qHv2C6+wRaPLsXEF5/zg9o
	 Jj4CR5tE+cx0bg6YHVrmqMUkUowdRX0vl/g9Ah9A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>
Subject: [PATCH 7.2 325/556] KVM: arm64: Correctly cap TLBI Range to the architural limit
Date: Wed,  9 Sep 2026 15:40:05 +0200
Message-ID: <20260909134242.091850798@linuxfoundation.org>
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
@@ -305,6 +305,12 @@ static inline u64 decode_range_tlbi(u64
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
 


