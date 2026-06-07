Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F74F2D3A69;
	Sun,  7 Jun 2026 10:36:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780828618; cv=none; b=bTP8PfK7MDYCWHjQCOToghZcyXh4JiJ19JJole86zcMNz8ouOeToY2sLNJE66oJwZwrxvgRiQM8n/VVQARCClIR1J4NiJP/gTAHk2dGOG4uwqze9watj2DJ74LlaoXy/m5uPX+KWuJ/NpQESSt27P4w+dwX2y5391UD6qg/CJ5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780828618; c=relaxed/simple;
	bh=vN9TdOjMyH5+hxVNWQ91SubFHQyXe31YKMDjF4IS7rA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VkK556+RArDGlTta0R4WO+OjG/NIvWxr5ahJuq/72UJDJcQFRkCB1eQX2jxX1tQSSK5nxHNCn3DAsSfLqzinxG8kdbGGHIisdTXoglL5OHtGLCRXBBR6JFzWP/j0V78Hv8ptcyazEjerRSiklI97FihOM0nJC7L1NjzgkHinZ4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Cwq3er/n; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Cwq3er/n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7346E1F00893;
	Sun,  7 Jun 2026 10:36:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780828617;
	bh=PIEV3E+Rmt+4fc2utCzB5NBGbP76TeyqeCO4Y6C5hj0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Cwq3er/nErcyWKHfPOzudQxFosCjjl5yano4DxMs8XevyX6XUXWEWVCKG9WvIpkQ9
	 7/gJCLRLA+JF9pNqnXN+NZWuwtaSqAmYejC99USbA0IwoAJoQT23f5xK35Uric/M00
	 DgAtGO0wHxGkjCMBHI4VDyl6vRih2gexuyP0iFpI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiang Ma <maqianga@uniontech.com>,
	Marc Zyngier <maz@kernel.org>
Subject: [PATCH 6.12 152/307] KVM: arm64: PMU: Preserve AArch32 counter low bits
Date: Sun,  7 Jun 2026 11:59:09 +0200
Message-ID: <20260607095733.304972318@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.647295505@linuxfoundation.org>
References: <20260607095727.647295505@linuxfoundation.org>
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

From: Qiang Ma <maqianga@uniontech.com>

commit 1750ad1388e03fb27068cd1f22c9c8b4590fe936 upstream.

AArch32 writes to PMU event counters cannot update the top 32 bits,
even when PMUv3p5 makes the counters 64-bit. KVM therefore needs to
preserve the existing high half and only update the low half written by
the guest, unless the caller explicitly forces a full reset through
PMCR.P.

The current code masks @val down to the old high half before taking
lower_32_bits(val), which means the low half is always zero. As a
result, AArch32 writes to event counters discard the guest-provided low
32 bits instead of storing them.

Build the new value from the old high 32 bits and the low 32 bits of
the value supplied by the guest.

Fixes: 26d2d0594d70 ("KVM: arm64: PMU: Do not let AArch32 change the counters' top 32 bits")
Signed-off-by: Qiang Ma <maqianga@uniontech.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://patch.msgid.link/20260526074640.791991-1-maqianga@uniontech.com
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kvm/pmu-emul.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -163,8 +163,8 @@ static void kvm_pmu_set_pmc_value(struct
 		 * action is to use PMCR.P, which will reset them to
 		 * 0 (the only use of the 'force' parameter).
 		 */
-		val  = __vcpu_sys_reg(vcpu, reg) & GENMASK(63, 32);
-		val |= lower_32_bits(val);
+		val = (__vcpu_sys_reg(vcpu, reg) & GENMASK(63, 32)) |
+		      lower_32_bits(val);
 	}
 
 	__vcpu_sys_reg(vcpu, reg) = val;


