Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 271FB346FB3;
	Thu, 12 Mar 2026 20:12:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773346321; cv=none; b=rW6o0tGGDicYpkSFjyPLSWSpAprI93NTZFGkFzKBiOP32m+eXjjh+RFcrrTvMQhhcYu1YXk8xpbgoAgMmrXDq3pY9Q7NK/ZVOXkjIFFgMkpcoVm30P4h6VubARQCjjKTIn+eAFzHFGwOJ2HYU7JDq38cTWTxR/X4gg2I/Pd3dO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773346321; c=relaxed/simple;
	bh=z5fQU46b1cAS1XMR6BdTy06YSzc7kongcjw+5ZqobI0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C18vNi9sDnNos5EEPhqe6yaHEGxqvJqTuE3WYL0e3Z2LAJXCjQqMp7YkuX1m4D6bjh80dMi00F7fzC408vWzVCXybk3Su92jAVmm2hnZMhcZjbOhkfzoBBoXiFj8NJ+F1Tho67sTVezlK2xVobxyfPwJaOzvNMORJUiqSSm5RuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lWxMSXVP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lWxMSXVP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02062C4CEF7;
	Thu, 12 Mar 2026 20:11:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773346320;
	bh=z5fQU46b1cAS1XMR6BdTy06YSzc7kongcjw+5ZqobI0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lWxMSXVPMu2b5LP4WxmoCtfsLBmKqQk6KKAMjGZThtzeMnBa+JOtLFLc3xCyaZZj3
	 iVl26P6Xrd9WAm7Kb3FBAsAOTHasxgAptR4Yy0pXe5SGMwxO5paXNJHDGBMoZJQr9K
	 poCuIt+ecbvPGU7oP7J2gEWYN55N3TOKVBMiV580=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fuad Tabba <tabba@google.com>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 005/265] KVM: arm64: Hide S1POE from guests when not supported by the host
Date: Thu, 12 Mar 2026 21:06:32 +0100
Message-ID: <20260312201018.343179132@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260312201018.128816016@linuxfoundation.org>
References: <20260312201018.128816016@linuxfoundation.org>
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
index 784603a355487..a76b3182e0917 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1563,6 +1563,9 @@ static u64 __kvm_read_sanitised_id_reg(const struct kvm_vcpu *vcpu,
 		       ID_AA64MMFR3_EL1_SCTLRX |
 		       ID_AA64MMFR3_EL1_S1POE |
 		       ID_AA64MMFR3_EL1_S1PIE;
+
+		if (!system_supports_poe())
+			val &= ~ID_AA64MMFR3_EL1_S1POE;
 		break;
 	case SYS_ID_MMFR4_EL1:
 		val &= ~ARM64_FEATURE_MASK(ID_MMFR4_EL1_CCIDX);
-- 
2.51.0



