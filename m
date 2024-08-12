Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0878929CA;
	Mon, 12 Aug 2024 16:21:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479669; cv=none; b=Za9789vrwvRuNpunKyOJFy46zo7VE5ubL01NCc76E+shT1Ly34C0PWN57H0CEcHRBhQsWg4OO+6Ma/RUlD8WR+D51wfDSBxHP/Ytu/m5fVxUPTaRvIUWgZEwTThOy82tybQangozEZqxm8FwT8Z6GfbCpaAo2++pmvvWA6lpxHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479669; c=relaxed/simple;
	bh=FfwE4tzvZOcQZXF/ohmkArhBu5/vsHgQM4l6fO3LK34=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QqIroszInFdg+UoHBMcllEljBKfFSvrPedXnAYclahXdK7Tv5BP9hFyO/TXIWiT8i3GQjnqxYemf4v29jXhSKQzhDPVeOuPeO4JbgzthDjRhJLfjtOlMjyDcH/mn5Ut8lQd9Ksw0sVB7a5Md8nZuWVmqmcwEE2J7VqURphjzn8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X5VQ0oX3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X5VQ0oX3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 141D7C32782;
	Mon, 12 Aug 2024 16:21:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479668;
	bh=FfwE4tzvZOcQZXF/ohmkArhBu5/vsHgQM4l6fO3LK34=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X5VQ0oX3ScOHfXXucE53KJxpkuvTMXAORjStKwA9WBWhyUnexkOQW+DwxiKZ+I5Mt
	 Pw+MS5IOYeZipHbUQ6dnQ3E4aWK7ouBGMlYAvLUev1sLEBABLU9lOMJ2c7acqg0Wdq
	 TCVguNEuEjswSnCteXtkVncbM2hk26SrKVxNUVbw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andi Kleen <ak@linux.intel.com>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 6.6 156/189] x86/mtrr: Check if fixed MTRRs exist before saving them
Date: Mon, 12 Aug 2024 18:03:32 +0200
Message-ID: <20240812160138.147024108@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160132.135168257@linuxfoundation.org>
References: <20240812160132.135168257@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andi Kleen <ak@linux.intel.com>

commit 919f18f961c03d6694aa726c514184f2311a4614 upstream.

MTRRs have an obsolete fixed variant for fine grained caching control
of the 640K-1MB region that uses separate MSRs. This fixed variant has
a separate capability bit in the MTRR capability MSR.

So far all x86 CPUs which support MTRR have this separate bit set, so it
went unnoticed that mtrr_save_state() does not check the capability bit
before accessing the fixed MTRR MSRs.

Though on a CPU that does not support the fixed MTRR capability this
results in a #GP.  The #GP itself is harmless because the RDMSR fault is
handled gracefully, but results in a WARN_ON().

Add the missing capability check to prevent this.

Fixes: 2b1f6278d77c ("[PATCH] x86: Save the MTRRs of the BSP before booting an AP")
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/all/20240808000244.946864-1-ak@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/mtrr/mtrr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kernel/cpu/mtrr/mtrr.c
+++ b/arch/x86/kernel/cpu/mtrr/mtrr.c
@@ -609,7 +609,7 @@ void mtrr_save_state(void)
 {
 	int first_cpu;
 
-	if (!mtrr_enabled())
+	if (!mtrr_enabled() || !mtrr_state.have_fixed)
 		return;
 
 	first_cpu = cpumask_first(cpu_online_mask);


