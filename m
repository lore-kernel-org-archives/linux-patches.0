Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B98C26E165;
	Tue,  8 Apr 2025 12:54:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116852; cv=none; b=oyRAD9kE3+XUO8+eVB3BDSLfbcIm+oljDyggSKESYdBhfjUVb+K4v0pBlZy0rosATvhAkQerjlnr94mXsDd4OD0gYBqGJqweIOGx2mKutO4sPf377DbloKjXTPQddAHI1an3T/KUfOwQluQZW+BbDQqmo0BiiyzCZTUowwwoe2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116852; c=relaxed/simple;
	bh=4iUdjLqb0xTmghWfqSb4qm7nq/BHldIq+D8mVyYCV2k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c9L+5HnXvBkEv7fjmAu5wztHe98/2foBnriHg3Jj0yw4E+1dWg/jGBTMsPHRS/gEgV3JIpbYFmY34Bjn9lK0ZGZg/9eavXWb1WIgJvyJBgYDNJJZUy+wvtDchmnqaF9xt+kuoSYek6WhSeAj0GPK0rfzc1Xjs7At58EgXy2dZWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PnNxSqwR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PnNxSqwR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A70BC4CEE5;
	Tue,  8 Apr 2025 12:54:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116851;
	bh=4iUdjLqb0xTmghWfqSb4qm7nq/BHldIq+D8mVyYCV2k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PnNxSqwRhZ63jLj9jzvH44De7L/leNJeIJK1Jep+I40ZRkIODWsY4BYU8t6pF5CV+
	 QiZ/RrFNSN830WRSwUVmzEeybwdRPlLJ/w37NpJZDPs6lDWZIfwURrhmugBiLvc1bj
	 rnK7rygwn01oPcUeLU3xYTOVEA2C1vDgNeSf+G50=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladis Dronov <vdronov@redhat.com>,
	Ingo Molnar <mingo@kernel.org>,
	Kai Huang <kai.huang@intel.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Andy Lutomirski <luto@kernel.org>,
	Sean Christopherson <sean.j.christopherson@intel.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 291/423] x86/sgx: Warn explicitly if X86_FEATURE_SGX_LC is not enabled
Date: Tue,  8 Apr 2025 12:50:17 +0200
Message-ID: <20250408104852.560820561@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vladis Dronov <vdronov@redhat.com>

[ Upstream commit 65be5c95d08eedda570a6c888a12384c77fe7614 ]

The kernel requires X86_FEATURE_SGX_LC to be able to create SGX enclaves,
not just X86_FEATURE_SGX.

There is quite a number of hardware which has X86_FEATURE_SGX but not
X86_FEATURE_SGX_LC. A kernel running on such hardware does not create
the /dev/sgx_enclave file and does so silently.

Explicitly warn if X86_FEATURE_SGX_LC is not enabled to properly notify
users that the kernel disabled the SGX driver.

The X86_FEATURE_SGX_LC, a.k.a. SGX Launch Control, is a CPU feature
that enables LE (Launch Enclave) hash MSRs to be writable (with
additional opt-in required in the 'feature control' MSR) when running
enclaves, i.e. using a custom root key rather than the Intel proprietary
key for enclave signing.

I've hit this issue myself and have spent some time researching where
my /dev/sgx_enclave file went on SGX-enabled hardware.

Related links:

  https://github.com/intel/linux-sgx/issues/837
  https://patchwork.kernel.org/project/platform-driver-x86/patch/20180827185507.17087-3-jarkko.sakkinen@linux.intel.com/

[ mingo: Made the error message a bit more verbose, and added other cases
         where the kernel fails to create the /dev/sgx_enclave device node. ]

Signed-off-by: Vladis Dronov <vdronov@redhat.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Acked-by: Kai Huang <kai.huang@intel.com>
Cc: Jarkko Sakkinen <jarkko@kernel.org>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Sean Christopherson <sean.j.christopherson@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: https://lore.kernel.org/r/20250309172215.21777-2-vdronov@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/sgx/driver.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/driver.c b/arch/x86/kernel/cpu/sgx/driver.c
index 22b65a5f5ec6c..7f8d1e11dbee2 100644
--- a/arch/x86/kernel/cpu/sgx/driver.c
+++ b/arch/x86/kernel/cpu/sgx/driver.c
@@ -150,13 +150,15 @@ int __init sgx_drv_init(void)
 	u64 xfrm_mask;
 	int ret;
 
-	if (!cpu_feature_enabled(X86_FEATURE_SGX_LC))
+	if (!cpu_feature_enabled(X86_FEATURE_SGX_LC)) {
+		pr_info("SGX disabled: SGX launch control CPU feature is not available, /dev/sgx_enclave disabled.\n");
 		return -ENODEV;
+	}
 
 	cpuid_count(SGX_CPUID, 0, &eax, &ebx, &ecx, &edx);
 
 	if (!(eax & 1))  {
-		pr_err("SGX disabled: SGX1 instruction support not available.\n");
+		pr_info("SGX disabled: SGX1 instruction support not available, /dev/sgx_enclave disabled.\n");
 		return -ENODEV;
 	}
 
@@ -173,8 +175,10 @@ int __init sgx_drv_init(void)
 	}
 
 	ret = misc_register(&sgx_dev_enclave);
-	if (ret)
+	if (ret) {
+		pr_info("SGX disabled: Unable to register the /dev/sgx_enclave driver (%d).\n", ret);
 		return ret;
+	}
 
 	return 0;
 }
-- 
2.39.5



