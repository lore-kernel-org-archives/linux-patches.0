Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4C4A218580;
	Mon, 23 Jun 2025 22:06:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716372; cv=none; b=WLqnPHOysAUQ65OOeKIb3end3fXcMI+h04alIZsWGijscZBRbkwYd6dGdYUplAnEN4O+OrxFRUV2AX6YAz7yCYP5cGrRLrgy55JAxAwmKwiMo2O0gfUEjp7973r4MRHUfhhAhWySkmsEBuKMCbWG+a4+8gpTD8l3Vln2ceiUnNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716372; c=relaxed/simple;
	bh=JbJjTL+kjGmY42PNGrHg+UjNWH2PvkBZHGyfrmwcfDg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BU0t59y6QUnsav107fIEl0M8nPbT0V4iGGLleEoDXxt+tyXV/4lgn2JI3Zv28kHtuBZA9eLF2qiJxpGNv3/jusqBLKW0Rw8i1beN/Sqo34GE7RZhmPfS4IA58SKAxYZrWEGBd748stXR9LYnKwgmA7fumaZD62GioR8/s3Dk5i0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vgBqh93Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vgBqh93Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DB05C4CEED;
	Mon, 23 Jun 2025 22:06:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716372;
	bh=JbJjTL+kjGmY42PNGrHg+UjNWH2PvkBZHGyfrmwcfDg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vgBqh93ZacEXo/ZqpOVoH7vWKg7H+Wl/PxD9vCVsgSwvR4nzzytKXTb8HKypx0Mix
	 5L4T7Y8pOq9m05xe2bpCKSY3gox8i3CmpfnTbcR0rKrfIobeqHB5SdYNenhs8T5of5
	 3U85f6sROeOjLognJNlRr054laiHUYFebOu36mkw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Morse <james.morse@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Pu Lehui <pulehui@huawei.com>
Subject: [PATCH 5.10 334/355] arm64: bpf: Only mitigate cBPF programs loaded by unprivileged users
Date: Mon, 23 Jun 2025 15:08:55 +0200
Message-ID: <20250623130636.779662404@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: James Morse <james.morse@arm.com>

[ Upstream commit f300769ead032513a68e4a02e806393402e626f8 ]

Support for eBPF programs loaded by unprivileged users is typically
disabled. This means only cBPF programs need to be mitigated for BHB.

In addition, only mitigate cBPF programs that were loaded by an
unprivileged user. Privileged users can also load the same program
via eBPF, making the mitigation pointless.

Signed-off-by: James Morse <james.morse@arm.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Pu Lehui <pulehui@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/net/bpf_jit_comp.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/arm64/net/bpf_jit_comp.c
+++ b/arch/arm64/net/bpf_jit_comp.c
@@ -342,6 +342,9 @@ static void __maybe_unused build_bhb_mit
 	    arm64_get_spectre_v2_state() == SPECTRE_VULNERABLE)
 		return;
 
+	if (capable(CAP_SYS_ADMIN))
+		return;
+
 	if (supports_clearbhb(SCOPE_SYSTEM)) {
 		emit(aarch64_insn_gen_hint(AARCH64_INSN_HINT_CLEARBHB), ctx);
 		return;


