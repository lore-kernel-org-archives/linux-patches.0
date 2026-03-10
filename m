Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D69834B197;
	Tue, 10 Mar 2026 11:06:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773140773; cv=none; b=qV0WmmHGyX0Cv+sPooty8IJkDCqZbqsQPj2ABQkuzTkuB2L39jOqKHrpwhqnAEqO4Bu33InJoqAENEbN9iBUd6ihuzmEGXhD7teLO1IbVptw5HOt3/X/2B1+vkqJKIxzqVEX02BzgkWaMZtv7llICPWF7GElcw4WJcO/Fn12YFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773140773; c=relaxed/simple;
	bh=+EQrl4p3b3A11s8feV0xynSQcvWA2nUNMegaPbmCVl0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nIH4Ykjn2sAObOATThJjKDsZvKHM7x5lOwQ0GOA+UCnFuA6d6OTawn4yc7Vtn8k1JoCL5lyUVlSgtV04mvWPbQJ6olBoOWGND+GN9R/QZ+9v6/Kv6bsClNlqWTskLklPUpVtqbRGmt1qtPYttDDVtr05Cf+Vpmx7kwUjPURlEdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pLzMIDIO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pLzMIDIO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94EE9C19423;
	Tue, 10 Mar 2026 11:06:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773140773;
	bh=+EQrl4p3b3A11s8feV0xynSQcvWA2nUNMegaPbmCVl0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pLzMIDIO1cLCJbdmeNidZcw7lV42/aYbjqFXyAe/RlZaYv75MIlrO/3cZiRuaTfDx
	 z+O/D1MLAPGyQMvaq+okg+MgEZi777f59BuNSg/ISA7WY3Y+q2ZQ71OPxc9ULt13QV
	 Nt11ttJLXMsq9aG/AGiA2OfXkCMbgoHxck3HGO2N2PO0TVcEPVqP+1YrU0VILw2xhd
	 NoKZeQs6HlW5fi9IkTP9qotMyKQfQWtEYv8KGl9HqGarr5oiiIhZAPe9axhqYw7z2S
	 LElJLUrPF8Na+uiHYSNUr1t3rIlFSfhVvqZhjYw/yrsuW8vGhmXkNqysjRk0SxTsge
	 Dc3vKn5tiangQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Fuad Tabba <tabba@google.com>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 006/311] KVM: arm64: Hide S1POE from guests when not supported by the host
Date: Tue, 10 Mar 2026 07:00:53 -0400
Message-ID: <3a5b42123562564fc92f9c3c4f982f18b38f7469.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
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
index 88a57ca36d96c..237e8bd1cf29c 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1816,6 +1816,9 @@ static u64 __kvm_read_sanitised_id_reg(const struct kvm_vcpu *vcpu,
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

