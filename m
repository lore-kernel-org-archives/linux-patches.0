Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A43026B094;
	Thu, 13 Feb 2025 15:10:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459431; cv=none; b=fgTByt2MPdt+kUg5evTmdvRrG8rjqBOw3xnWrNfyuV+bwCNVeB+8W31K5MfuI0tN2SMaI0bHpmQWymjot0rFdrpwW5+n0qqZ8ioUneg+nlHX6dZ34u4dF8E6wvKiytKqesDu+ljmD7VGTuc2Wt1x25eoxhOiKSSVk2aPxDPYdBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459431; c=relaxed/simple;
	bh=o/xFjOAxIrkOHIy1vFf0FzX+spJjp8FWVD0xHbvbcqs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IabdXGRKPXigWMlXJwR1MNl9hf9xb9Onrn16UkK04o7RhyyZwETJuGQwYZAfjHYcjjhcAcLm4FzxpcftMG9/wUhp366TimLdkq64cGkDPl52xbJZKnT2rqNqZYAxTI6eHyMwTYbqlbrzw4YGclPHQqkfeXlIu2oUd+fC/UbF9aU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IKMNEoAD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IKMNEoAD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 864B4C4CED1;
	Thu, 13 Feb 2025 15:10:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459431;
	bh=o/xFjOAxIrkOHIy1vFf0FzX+spJjp8FWVD0xHbvbcqs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IKMNEoADGREVh5KukhnVk25mKUVp39y0FYPT1/u0WC+T5L/Ovb13Oo8cD2jzDz90t
	 d7GTK2kF7dxe4r5ZpxL8SuduLDDG0GxdX7ik8NjACQPctLN3jH4NR1093/RXSInbj1
	 kQbAHOwqDxisd3J4azRCJAe36G64O16LIiL02hVg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Icenowy Zheng <icenowy@aosc.io>,
	Xi Ruoyao <xry111@xry111.site>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 6.13 262/443] Revert "MIPS: csrc-r4k: Select HAVE_UNSTABLE_SCHED_CLOCK if SMP && 64BIT"
Date: Thu, 13 Feb 2025 15:27:07 +0100
Message-ID: <20250213142450.726417243@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xi Ruoyao <xry111@xry111.site>

commit 078b831638e1aa06dd7ffa9f244c8ac6b2995561 upstream.

This reverts commit 426fa8e4fe7bb914b5977cbce453a9926bf5b2e6.

The commit has caused two issues on Loongson 3A4000:

1. The timestamp in dmesg become erratic, like:

    [3.736957] amdgpu 0000:04:00.0: ... ...
    [3.748895] [drm] Initialized amdgpu ... ...
    [18446744073.381141] amdgpu 0000:04:00:0: ... ...
    [1.613326] igb 0000:03:00.0 enp3s0: ... ...

2. More seriously, some workloads (for example, the test
   stdlib/test-cxa_atexit2 in the Glibc test suite) triggers an RCU
   stall and hang the system with a high probably (4 hangs out of 5
   tests).

Revert this commit to use jiffie on Loongson MIPS systems and fix these
issues for now.  The root cause may need more investigation.

Cc: stable@vger.kernel.org # 6.11+
Cc: Jiaxun Yang <jiaxun.yang@flygoat.com>
Cc: Icenowy Zheng <icenowy@aosc.io>
Signed-off-by: Xi Ruoyao <xry111@xry111.site>
Reviewed-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/mips/Kconfig |    1 -
 1 file changed, 1 deletion(-)

--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -1084,7 +1084,6 @@ config CSRC_IOASIC
 
 config CSRC_R4K
 	select CLOCKSOURCE_WATCHDOG if CPU_FREQ
-	select HAVE_UNSTABLE_SCHED_CLOCK if SMP && 64BIT
 	bool
 
 config CSRC_SB1250


