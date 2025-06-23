Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B20D421FF2B;
	Mon, 23 Jun 2025 22:17:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750717067; cv=none; b=TdFtAqSmUWomZSU3jpAT/Z02oMa+rqsZhAL0QG7XYR2TL+Sk2JsryrkBnQjlkbTTCcWb+CwhnCTvpLhPGRKODuMFcH0gp5pypMdlX5QaJPKIdrFo+YlLbYgGsz4wVTWRTXP2sgxUi55q2qbwTkfKXPQfX4u3mxZgEfcfdRGRybA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750717067; c=relaxed/simple;
	bh=2mZqwiOZc1NQ5EgdSaHVQT3kNGxRZ0fjnSI/Rfh8wFU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U/5kcnPAFamoW6eKzLPQqjUUSYMvnNjfwisdaPsxS0HTxyuDGuD+wUjhWmNmWO4dL1KCi/MJ3qRZz5zVDQxgWHq6DitiJLtmN01/K3EqDK1PrQwjCRyZF+REHk37KrfrnwcoVO7eHQNOky1iYpb3pQjign99dCkLOkZswDaeW0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BLFzthqm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BLFzthqm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47963C4CEEA;
	Mon, 23 Jun 2025 22:17:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750717067;
	bh=2mZqwiOZc1NQ5EgdSaHVQT3kNGxRZ0fjnSI/Rfh8wFU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BLFzthqmx7hPcLKPDbBFbHrETQSRpb2zyBELEO6mPq9JhzsJ/k/80WlzaQCJ2+bsg
	 WSQrlNSZEivYeAXnOf8HOfih2FGdWlhj2734Q6WhqITZ/s9CXrtcsR/XNmtI2nMGfz
	 wD5N/XTjNbEKQ2CmhOKcXHoDHOsXEpMiC1W1LW7M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Morse <james.morse@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Pu Lehui <pulehui@huawei.com>
Subject: [PATCH 5.15 392/411] arm64: proton-pack: Expose whether the branchy loop k value
Date: Mon, 23 Jun 2025 15:08:56 +0200
Message-ID: <20250623130643.545537108@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: James Morse <james.morse@arm.com>

[ Upstream commit a1152be30a043d2d4dcb1683415f328bf3c51978 ]

Add a helper to expose the k value of the branchy loop. This is needed
by the BPF JIT to generate the mitigation sequence in BPF programs.

Signed-off-by: James Morse <james.morse@arm.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Pu Lehui <pulehui@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/spectre.h |    1 +
 arch/arm64/kernel/proton-pack.c  |    5 +++++
 2 files changed, 6 insertions(+)

--- a/arch/arm64/include/asm/spectre.h
+++ b/arch/arm64/include/asm/spectre.h
@@ -97,6 +97,7 @@ enum mitigation_state arm64_get_meltdown
 
 enum mitigation_state arm64_get_spectre_bhb_state(void);
 bool is_spectre_bhb_affected(const struct arm64_cpu_capabilities *entry, int scope);
+u8 get_spectre_bhb_loop_value(void);
 bool is_spectre_bhb_fw_mitigated(void);
 void spectre_bhb_enable_mitigation(const struct arm64_cpu_capabilities *__unused);
 bool try_emulate_el1_ssbs(struct pt_regs *regs, u32 instr);
--- a/arch/arm64/kernel/proton-pack.c
+++ b/arch/arm64/kernel/proton-pack.c
@@ -998,6 +998,11 @@ bool is_spectre_bhb_affected(const struc
 	return true;
 }
 
+u8 get_spectre_bhb_loop_value(void)
+{
+	return max_bhb_k;
+}
+
 static void this_cpu_set_vectors(enum arm64_bp_harden_el1_vectors slot)
 {
 	const char *v = arm64_get_bp_hardening_vector(slot);


