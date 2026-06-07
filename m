Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 774D82C1595;
	Sun,  7 Jun 2026 10:30:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780828227; cv=none; b=Au8/S8xBi8x5srJuLTDx0KDhlOI+GpodRSp6WR+ZCIk4KKNf3O6MFi3pTB19J8ESojryGa374uQ/324B7iRGzWfvFbDKMEoq0RrvZuUHAiFuMI7sa+tX2I3/mZ2ldRJJKF4TYq3Hl/mLIcFZQImFQqiunMplH+0jmmhwmZaozwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780828227; c=relaxed/simple;
	bh=IvR6CgNJ2OuEJrLqppbANO0C/xOGDqP5XKizJLfYziM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SM467uMPrBgCQojHa/sMabgC7t5m42asePdM/QEV3PU8j7oEJfp7bd29Fwfd6vJEN1sSrJOp0od7blMjs7iR3Y31bFVdQXxDkw4LZNOoo/pu+zUBR8SH7MwrEiZfeq+BvgYm3F0E+WS8TiQE5qyQy8ChpEV6mVv0wu1YIEE+hhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pZidX1+H; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pZidX1+H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 452CC1F00893;
	Sun,  7 Jun 2026 10:30:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780828225;
	bh=IQZYTiLnVtwbOKJUwbDK0/TN9/BfbNUz3DkIVD2V6rc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pZidX1+H+bVQvpkyxIlCp22y2hA3lfh4At0OhxS2toltDervrULJnCfOFnFv/OFL6
	 +EAvIj27RKS9f7E306KfdG6oxg3Qf4UzA7uboF+yQ9G3JlJRD6EXKM2a92NAvAHH8G
	 KLF5lVVP62hVUo6KNw0sFkmUeRjG1EOw4fCbjyGg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiang Ma <maqianga@uniontech.com>,
	Marc Zyngier <maz@kernel.org>
Subject: [PATCH 6.18 142/315] KVM: arm64: PMU: Preserve AArch32 counter low bits
Date: Sun,  7 Jun 2026 11:58:49 +0200
Message-ID: <20260607095732.816625615@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.528828913@linuxfoundation.org>
References: <20260607095727.528828913@linuxfoundation.org>
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
@@ -174,8 +174,8 @@ static void kvm_pmu_set_pmc_value(struct
 		 * action is to use PMCR.P, which will reset them to
 		 * 0 (the only use of the 'force' parameter).
 		 */
-		val  = __vcpu_sys_reg(vcpu, reg) & GENMASK(63, 32);
-		val |= lower_32_bits(val);
+		val = (__vcpu_sys_reg(vcpu, reg) & GENMASK(63, 32)) |
+		      lower_32_bits(val);
 	}
 
 	__vcpu_assign_sys_reg(vcpu, reg, val);


