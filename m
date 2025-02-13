Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C35A323A9A3;
	Thu, 13 Feb 2025 14:46:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739457990; cv=none; b=PgjBOHb7MX/m54vmLzTXnlsdlhJ3ICnkPPbKRJIweanW4Oa19pwIOIQbB0yj+buWbiKGaHOjrlMf4AFvGAqJBIkass/3SSqnD7W3F6OiNGZYV4HihSwKbnVToIGsGBm3ehjstO6l0xaoSkVgqopz9pnXyGg2BKG5b7SZyQjfSkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739457990; c=relaxed/simple;
	bh=K5b2rxhribNtDDhI5W2gVQ+4UKHQVdNxTYjawL1zDDI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JmaWjYI5s0N2zwImWXqavjuI9zNQbInchSdOHd3Ga1WgyAgPToukcoISovpVd+81zIULYo/8N2ILFODE+JmHmiBYgzp0KUaKZKjMwuwebuy6754lfITp7+FMksZoI/C/hIE8xTEWIRr3xF4Ius+20ZKDGEC63XVrdS6atA09Zuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Onieczi6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Onieczi6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CED3C4CED1;
	Thu, 13 Feb 2025 14:46:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739457990;
	bh=K5b2rxhribNtDDhI5W2gVQ+4UKHQVdNxTYjawL1zDDI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Onieczi6S4rjPkcHsMoRqYSg5MIdnmYrs0o9/lpR3gHpj1UuM1mMFp0eMM7MyvCJK
	 OT6d/eGxgfPZIy1zBd0eIYjQXg/6+i0E1ufZrHKo07zI0HrljNJZLzzdP5W4W89gOB
	 QEzGkPcHdj0kMqn2hvwXyWy+KBTyw8qeiMHeRLKo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Icenowy Zheng <icenowy@aosc.io>,
	Xi Ruoyao <xry111@xry111.site>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 6.12 237/422] Revert "MIPS: csrc-r4k: Select HAVE_UNSTABLE_SCHED_CLOCK if SMP && 64BIT"
Date: Thu, 13 Feb 2025 15:26:26 +0100
Message-ID: <20250213142445.680864156@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
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
 arch/mips/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index 467b10f4361a..5078ebf071ec 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -1084,7 +1084,6 @@ config CSRC_IOASIC
 
 config CSRC_R4K
 	select CLOCKSOURCE_WATCHDOG if CPU_FREQ
-	select HAVE_UNSTABLE_SCHED_CLOCK if SMP && 64BIT
 	bool
 
 config CSRC_SB1250
-- 
2.48.1



