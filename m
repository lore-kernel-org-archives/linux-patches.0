Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2283E1E5722;
	Mon, 21 Oct 2024 10:44:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507442; cv=none; b=W21uT1uaC/rS3XZ/7LDS4X9n2lkOV7E/ojtS3WbotBtOSo6rBedPFodhDmO6Qc005HuwPckg5rcZ6jeThuGXh/vwNHioOYNBEqLtXabyQdn4enFbv7KqMauZ9E1rXtPKYVugWhFXmSGETpBFGQI6zQSpsWajGkX8+M68NUG9J2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507442; c=relaxed/simple;
	bh=z1oq3G3Xl3SZ0GHN2I4AK6+OUHQpjECITI+vSfXYjUA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n6yzMH1JxFvO9QM+6TbD+mM8fCB8JZa2aYAHWIow+h2J8kf3DybsHDAXh1v9oD0Hur3CZe4e8w3IwEQEXxFPB8ekpCCzN47iO8wIEJIVjT2nARCSXIOZkp0VZy++meeRWLr6/9XhNnZHfWpvvl4N2VJ6nUeLA08B+IiNygg3XSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bdE7Qnyo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bdE7Qnyo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98DA8C4CEC3;
	Mon, 21 Oct 2024 10:44:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507442;
	bh=z1oq3G3Xl3SZ0GHN2I4AK6+OUHQpjECITI+vSfXYjUA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bdE7Qnyo1h9n2THYWXD/V6McrpqG2yiLfGDfdp3PUA9dB5Ydes47ceWcvcRVsFJkZ
	 3KrA4d9vpVlMay4BXWSyiKojc/T5lholikFCiD+QXt20vEY3OSbk2O92beZ9rjNjrB
	 ERgOqc2PxGhboCxA+GDBsevvRb/k2sfQ+kSI7X8c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Reinette Chatre <reinette.chatre@intel.com>,
	stable@kernel.org
Subject: [PATCH 6.1 78/91] x86/resctrl: Annotate get_mem_config() functions as __init
Date: Mon, 21 Oct 2024 12:25:32 +0200
Message-ID: <20241021102252.861017308@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102249.791942892@linuxfoundation.org>
References: <20241021102249.791942892@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -174,7 +174,7 @@ static inline bool rdt_get_mb_table(stru
 	return false;
 }
 
-static bool __get_mem_config_intel(struct rdt_resource *r)
+static __init bool __get_mem_config_intel(struct rdt_resource *r)
 {
 	struct rdt_hw_resource *hw_res = resctrl_to_arch_res(r);
 	union cpuid_0x10_3_eax eax;
@@ -208,7 +208,7 @@ static bool __get_mem_config_intel(struc
 	return true;
 }
 
-static bool __rdt_get_mem_config_amd(struct rdt_resource *r)
+static __init bool __rdt_get_mem_config_amd(struct rdt_resource *r)
 {
 	struct rdt_hw_resource *hw_res = resctrl_to_arch_res(r);
 	union cpuid_0x10_3_eax eax;


