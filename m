Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 435E01E1C33;
	Wed,  6 Nov 2024 13:14:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898863; cv=none; b=QWmsYSrKvmHZG9K/GJ7ZrTE92IKgwdRNwo7lu9ptuTFnnQljUrFijEI1l23jTMljdn+l5LcbGpADJCss1rjTeJvoxEvJVJg25IdQDrDB+bH0F4Oi3qCAYIjVuciIOYFVHCMW4BSNUcz6hHZisipMam1Oyil8Ru7RJ0lvVoKxFEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898863; c=relaxed/simple;
	bh=SyV8CNYtuS/syIXt/4aagq83FCUaQrIsAvoqQ+1IVbQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nDTPP6/BcUQkmU9EsmziK1U2iYYdNnnx+fWzQARrY8/V/mKqW+T2GznBZ0svjSKBmfnfLGKRF240uKvHuNIcfBB9k0cKacOC/JMX9LdCzCRLTkNP/3cn5G6Nngtat/vF9FZ1NFzGbm3zMcZBm8qGKZdTzeCCH89ZPgAOA/mImYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XLmJ5KFq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XLmJ5KFq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE252C4CECD;
	Wed,  6 Nov 2024 13:14:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898863;
	bh=SyV8CNYtuS/syIXt/4aagq83FCUaQrIsAvoqQ+1IVbQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XLmJ5KFqzcWSWth1zNR8cD/A7dJgNTeJF4MvAQV4c5oZmmU0A2y2oeInR+F77Dgl7
	 e8biSJf0YmJqJXtzI/cTkEJTl/8ud0raCi3KY+y/opz6SktGRAjn9xYQQQMnjeo8et
	 mz21DVn1mcUitVPMxW+In/wbHRqgyYAnd9bOQd+o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Reinette Chatre <reinette.chatre@intel.com>,
	stable@kernel.org
Subject: [PATCH 5.4 380/462] x86/resctrl: Annotate get_mem_config() functions as __init
Date: Wed,  6 Nov 2024 13:04:33 +0100
Message-ID: <20241106120340.908860134@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -250,7 +250,7 @@ static inline bool rdt_get_mb_table(stru
 	return false;
 }
 
-static bool __get_mem_config_intel(struct rdt_resource *r)
+static __init bool __get_mem_config_intel(struct rdt_resource *r)
 {
 	union cpuid_0x10_3_eax eax;
 	union cpuid_0x10_x_edx edx;
@@ -277,7 +277,7 @@ static bool __get_mem_config_intel(struc
 	return true;
 }
 
-static bool __rdt_get_mem_config_amd(struct rdt_resource *r)
+static __init bool __rdt_get_mem_config_amd(struct rdt_resource *r)
 {
 	union cpuid_0x10_3_eax eax;
 	union cpuid_0x10_x_edx edx;


