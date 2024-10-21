Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A60C1F4FC3;
	Mon, 21 Oct 2024 10:48:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507688; cv=none; b=SpO0hfGNdWw1nlF1A31KRekOd/pP1SaM0sbk5Sk44VBD0dgN4UyjupXdjuk1i5P7Akw/EMuWtmUtGOS1esGB5Uc/H+1PTS8qFpOvfMgmQArbb2S9wiG6DJN93K1RjKCLjUZEx1SylG3/WACifRQ93iB5OKcbCGwNvW7FtQnsduU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507688; c=relaxed/simple;
	bh=sqjPxZeZuClSBCc0c0aqnf29BypjKKw61MTfwcoBlPM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DZC7I5i1ng5WGEgrf5/lSQSHMq+mcluZirmJANAYUmsPiJrEWLSSBCcKpUxDJ7GAa7A4RHYtaeaEe6BAmJ96qHDH1AvFSAQ1dzeFlaQXwDAclm+8P4hE7AWNqHWCLJyhlalHkEsvr7E+emDYG80o5irBAI245BsmZFHL4K789x8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sNV6pYKv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sNV6pYKv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60E50C4CEC3;
	Mon, 21 Oct 2024 10:48:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507687;
	bh=sqjPxZeZuClSBCc0c0aqnf29BypjKKw61MTfwcoBlPM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sNV6pYKvsnifdkJfaF4ofkvnyA2VITUXn7imA+AnMGFQOwySgApfjfoRf9VmVLBd2
	 LLigcY7wPU9AcxlsX1F4watXOqxK5bxv+inwLPiltO0FAPFFlSHJor14Vi+VEC6vpL
	 yDZBHJJRQ3Gfh1qv5H9siq53Gs1RgkIWDrvLkMMY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Reinette Chatre <reinette.chatre@intel.com>,
	stable@kernel.org
Subject: [PATCH 5.15 68/82] x86/resctrl: Annotate get_mem_config() functions as __init
Date: Mon, 21 Oct 2024 12:25:49 +0200
Message-ID: <20241021102249.910760371@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102247.209765070@linuxfoundation.org>
References: <20241021102247.209765070@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Nathan Chancellor <nathan@kernel.org>

commit d5fd042bf4cfb557981d65628e1779a492cd8cfa upstream.

After a recent LLVM change [1] that deduces __cold on functions that only call
cold code (such as __init functions), there is a section mismatch warning from
__get_mem_config_intel(), which got moved to .text.unlikely. as a result of
that optimization:

  WARNING: modpost: vmlinux: section mismatch in reference: \
  __get_mem_config_intel+0x77 (section: .text.unlikely.) -> thread_throttle_mode_init (section: .init.text)

Mark __get_mem_config_intel() as __init as well since it is only called
from __init code, which clears up the warning.

While __rdt_get_mem_config_amd() does not exhibit a warning because it
does not call any __init code, it is a similar function that is only
called from __init code like __get_mem_config_intel(), so mark it __init
as well to keep the code symmetrical.

CONFIG_SECTION_MISMATCH_WARN_ONLY=n would turn this into a fatal error.

Fixes: 05b93417ce5b ("x86/intel_rdt/mba: Add primary support for Memory Bandwidth Allocation (MBA)")
Fixes: 4d05bf71f157 ("x86/resctrl: Introduce AMD QOS feature")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
Cc: <stable@kernel.org>
Link: https://github.com/llvm/llvm-project/commit/6b11573b8c5e3d36beee099dbe7347c2a007bf53 [1]
Link: https://lore.kernel.org/r/20240917-x86-restctrl-get_mem_config_intel-init-v3-1-10d521256284@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/resctrl/core.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -175,7 +175,7 @@ static inline bool rdt_get_mb_table(stru
 	return false;
 }
 
-static bool __get_mem_config_intel(struct rdt_resource *r)
+static __init bool __get_mem_config_intel(struct rdt_resource *r)
 {
 	struct rdt_hw_resource *hw_res = resctrl_to_arch_res(r);
 	union cpuid_0x10_3_eax eax;
@@ -210,7 +210,7 @@ static bool __get_mem_config_intel(struc
 	return true;
 }
 
-static bool __rdt_get_mem_config_amd(struct rdt_resource *r)
+static __init bool __rdt_get_mem_config_amd(struct rdt_resource *r)
 {
 	struct rdt_hw_resource *hw_res = resctrl_to_arch_res(r);
 	union cpuid_0x10_3_eax eax;


