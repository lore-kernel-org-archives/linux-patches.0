Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4628238757B;
	Tue, 10 Mar 2026 11:20:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141641; cv=none; b=ADTc7PRqJ1UfP2b7ej54kg7F4Pe8ioFM3Co/Rbk2pS1Shtooatnd4JGFFaUt7ZFAssy7bkgHsyqcB3qgxNbVZdjVyh3qVkCSYllImCwttZwNwFGzZpoA4SjHQGEQTsrnkbvGNkieFTfuIrNPpf3i8WJRl307SAvO0sClDlJNDjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141641; c=relaxed/simple;
	bh=Ef0XUYcs3hPauCEzNSc6II6zQVnnJTN18Qfu/ET8wy0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mp7ni1P+S0xBVgaZn+754137/bXm+K8uB2HEZXNGcK0ydRHM5VO84la6XkoDM0uY/iQaYlqkJDTdl00UEmoNEri4Fbdezpzk28xl/fwSsk/gULzmBIW9dGugFa5y5GyMlNM8HJJAoHtBXMGa3Hm3O4qJEpZ8lHJb0+WkjR8YSp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hIGJeyJT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hIGJeyJT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80802C2BC9E;
	Tue, 10 Mar 2026 11:20:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141641;
	bh=Ef0XUYcs3hPauCEzNSc6II6zQVnnJTN18Qfu/ET8wy0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hIGJeyJTQc9qIP9PXyU5Mjzwh1Fd6hGbqZW9AyAZgh8przM9X1NlKroFvb1hGGNgH
	 3BYo+bP54uJbtIZV1Op6xiGncaBxu0NhSbPeMPtNT3gnjlErrhubWBX9TRI5KHuXUr
	 5RMJvvedt8+TRql6SzjG5XnF5bWYkT+chZ4ygbZ4Ps5RnjQz8OzdMMuePy+QZB90AB
	 qouOfvvAdlw6r3czozRTmHJcrZm4xNsU7DQXU1daaUQuJPextC4iLuktO4s1ZlSyzA
	 I0k/ffQpSIuVu+UJxJVLpyzKI0pveMR1QgMm6/R3Y4z3YhuktIDCbQIgpB20w8yDPo
	 bI6S7tPLDhmeQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Fuad Tabba <tabba@google.com>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 006/314] KVM: arm64: Hide S1POE from guests when not supported by the host
Date: Tue, 10 Mar 2026 07:14:25 -0400
Message-ID: <c694fd7e8b71832ba4f7742994ee2e2236ff633e.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Fuad Tabba <tabba@google.com>

[ Upstream commit f66857bafd4f151c5cc6856e47be2e12c1721e43 ]

When CONFIG_ARM64_POE is disabled, KVM does not save/restore POR_EL1.
However, ID_AA64MMFR3_EL1 sanitisation currently exposes the feature to
guests whenever the hardware supports it, ignoring the host kernel
configuration.

If a guest detects this feature and attempts to use it, the host will
fail to context-switch POR_EL1, potentially leading to state corruption.

Fix this by masking ID_AA64MMFR3_EL1.S1POE in the sanitised system
registers, preventing KVM from advertising the feature when the host
does not support it (i.e. system_supports_poe() is false).

Fixes: 70ed7238297f ("KVM: arm64: Sanitise ID_AA64MMFR3_EL1")
Signed-off-by: Fuad Tabba <tabba@google.com>
Link: https://patch.msgid.link/20260213143815.1732675-2-tabba@google.com
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index ec3fbe0b8d525..7b7f3c932dcd5 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1801,6 +1801,9 @@ static u64 __kvm_read_sanitised_id_reg(const struct kvm_vcpu *vcpu,
 		       ID_AA64MMFR3_EL1_SCTLRX |
 		       ID_AA64MMFR3_EL1_S1POE |
 		       ID_AA64MMFR3_EL1_S1PIE;
+
+		if (!system_supports_poe())
+			val &= ~ID_AA64MMFR3_EL1_S1POE;
 		break;
 	case SYS_ID_MMFR4_EL1:
 		val &= ~ID_MMFR4_EL1_CCIDX;
-- 
2.51.0

