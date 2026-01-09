Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD6FE335097;
	Fri,  9 Jan 2026 12:52:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767963124; cv=none; b=S3vTLykmcOaOGzw3AH8WKaq4behsB7pPvWQshqjevEHUAACKTrsACzccEQsCZX9tMYgqov9jvGo+qibWPE1dENEYBm9MGRIcr8IkOjWcJEW4MGVivskklnuWb7y4cw7uZnQ2uWw0U4kfLMHSEMLfRynKTO9UOAzhWHdi+5X/KCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767963124; c=relaxed/simple;
	bh=uanK5ni0ijL9kaMI4Sr0UdBuwi4vlH/DfXMaQKx8Dew=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ffSY1kufhjLFrO0Nk1fiLIzQdW5TjLasCWGkcRZy9JTzfTqBEtH5V7b5xjkzd2QnAPMyFs8AsfwtYHUC0ra53nX9JM1mC6gxDALzkrZf1kEkmGDVUuPEe0k2q35gvcrh728Thug/a8TE8/1y66SJ7tknx0sy444gb1OERTKXfUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JDmK1dig; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JDmK1dig"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66AFCC4CEF1;
	Fri,  9 Jan 2026 12:52:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767963124;
	bh=uanK5ni0ijL9kaMI4Sr0UdBuwi4vlH/DfXMaQKx8Dew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JDmK1diglCD/KfTRmGOQP/rJ2BIdTqCxZRGphH6AFTuq75KanqwLar5RFX4h0OQSH
	 X6nI7CiTH2Pc2RuO6tAfcx5vkKNyc6ROYWcw4RP4GTbia52TbDxxjYL9tWPeD06Kco
	 /P3sq8t3Xsg8hkdLKgcBl0QVasmRFbVjRDxc+V/I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,  linux-kernel@vger.kernel.org, llvm@lists.linux.dev, stable@vger.kernel.org,  Justin Stitt" <justinstitt@google.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Tiffany Yang <ynaffit@google.com>,
	Justin Stitt <justinstitt@google.com>
Subject: [PATCH 6.1 606/634] KVM: arm64: sys_regs: disable -Wuninitialized-const-pointer warning
Date: Fri,  9 Jan 2026 12:44:44 +0100
Message-ID: <20260109112140.431368819@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Justin Stitt <justinstitt@google.com>

A new warning in Clang 22 [1] complains that @clidr passed to
get_clidr_el1() is an uninitialized const pointer. get_clidr_el1()
doesn't really care since it casts away the const-ness anyways -- it is
a false positive.

This patch isn't needed for anything past 6.1 as this code section was
reworked in Commit 7af0c2534f4c ("KVM: arm64: Normalize cache
configuration") which incidentally removed the aforementioned warning.
Since there is no upstream equivalent, this patch just needs to be
applied to 6.1.

Disable this warning for sys_regs.o instead of backporting the patches
from 6.2+ that modified this code area.

Cc: stable@vger.kernel.org
Fixes: 7c8c5e6a9101e ("arm64: KVM: system register handling")
Link: https://github.com/llvm/llvm-project/commit/00dacf8c22f065cb52efb14cd091d441f19b319e [1]
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Justin Stitt <justinstitt@google.com>
Reviewed-by: Tiffany Yang <ynaffit@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kvm/Makefile |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/arm64/kvm/Makefile
+++ b/arch/arm64/kvm/Makefile
@@ -24,6 +24,9 @@ kvm-y += arm.o mmu.o mmio.o psci.o hyper
 
 kvm-$(CONFIG_HW_PERF_EVENTS)  += pmu-emul.o pmu.o
 
+# Work around a false positive Clang 22 -Wuninitialized-const-pointer warning
+CFLAGS_sys_regs.o := $(call cc-disable-warning, uninitialized-const-pointer)
+
 always-y := hyp_constants.h hyp-constants.s
 
 define rule_gen_hyp_constants


