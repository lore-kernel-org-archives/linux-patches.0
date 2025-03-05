Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C101250C0E;
	Wed,  5 Mar 2025 17:56:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197407; cv=none; b=WZ6PHVu6GrBysaMIvr70gkmS3ZmstS4c1d+8nTutSMAUwVrZIC76FKly6+2O2wUzZmwAr1jm908oOs3l0N55c72/XPu3UZo1iZgyql7dLdHh5hkPX1wn93pq8sB2fqeN1E7fmrzm5fTJxJGPhOEr/Dsh4EdB3xD2jkNRSswv1d8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197407; c=relaxed/simple;
	bh=4mfgfTfoaVor642YPKq1tm20SA/rzZPm7IurPUiY3xc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m2bABubLRzipqGW6LD6iZplPeUor5DgKnCZot+d3upLUE321A3WcQ9CCwxobxHJzkU/GnFXr7TK6iP7+/sLbNMNZ7bep0Ag/nIEG3qqf+lS2Hid+xCa9AmWfF65n4mN2Xk/oSQibSusoMuJv6+tP497rLYFfMFgEEsOohC8X7Hw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ykkUbsnf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ykkUbsnf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04F39C4CED1;
	Wed,  5 Mar 2025 17:56:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197407;
	bh=4mfgfTfoaVor642YPKq1tm20SA/rzZPm7IurPUiY3xc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ykkUbsnfy9xe9jHcUcqf/mO6nDoDEfsQ/YDRy2kEoIHMt3rlWa/hWULBAL174N3XP
	 mls/SGjg+YG5VJWYmABtviIBoHjMKMtpUsgBYDBOURoENCGkqEzbAGlnGKWWI4YW34
	 sQcQtoUQtDHnOTaGY2w4MllZH+78FT6MxyOrPWE0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Russell Senior <russell@personaltelco.net>,
	Ingo Molnar <mingo@kernel.org>,
	Matthew Whitehead <tedheadster@gmail.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>,
	Jonas Gorski <jonas.gorski@gmail.com>
Subject: [PATCH 6.1 146/176] x86/CPU: Fix warm boot hang regression on AMD SC1100 SoC systems
Date: Wed,  5 Mar 2025 18:48:35 +0100
Message-ID: <20250305174511.304920713@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.437358097@linuxfoundation.org>
References: <20250305174505.437358097@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Russell Senior <russell@personaltelco.net>

[ Upstream commit bebe35bb738b573c32a5033499cd59f20293f2a3 ]

I still have some Soekris net4826 in a Community Wireless Network I
volunteer with. These devices use an AMD SC1100 SoC. I am running
OpenWrt on them, which uses a patched kernel, that naturally has
evolved over time.  I haven't updated the ones in the field in a
number of years (circa 2017), but have one in a test bed, where I have
intermittently tried out test builds.

A few years ago, I noticed some trouble, particularly when "warm
booting", that is, doing a reboot without removing power, and noticed
the device was hanging after the kernel message:

  [    0.081615] Working around Cyrix MediaGX virtual DMA bugs.

If I removed power and then restarted, it would boot fine, continuing
through the message above, thusly:

  [    0.081615] Working around Cyrix MediaGX virtual DMA bugs.
  [    0.090076] Enable Memory-Write-back mode on Cyrix/NSC processor.
  [    0.100000] Enable Memory access reorder on Cyrix/NSC processor.
  [    0.100070] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
  [    0.110058] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
  [    0.120037] CPU: NSC Geode(TM) Integrated Processor by National Semi (family: 0x5, model: 0x9, stepping: 0x1)
  [...]

In order to continue using modern tools, like ssh, to interact with
the software on these old devices, I need modern builds of the OpenWrt
firmware on the devices. I confirmed that the warm boot hang was still
an issue in modern OpenWrt builds (currently using a patched linux
v6.6.65).

Last night, I decided it was time to get to the bottom of the warm
boot hang, and began bisecting. From preserved builds, I narrowed down
the bisection window from late February to late May 2019. During this
period, the OpenWrt builds were using 4.14.x. I was able to build
using period-correct Ubuntu 18.04.6. After a number of bisection
iterations, I identified a kernel bump from 4.14.112 to 4.14.113 as
the commit that introduced the warm boot hang.

  https://github.com/openwrt/openwrt/commit/07aaa7e3d62ad32767d7067107db64b6ade81537

Looking at the upstream changes in the stable kernel between 4.14.112
and 4.14.113 (tig v4.14.112..v4.14.113), I spotted a likely suspect:

  https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?id=20afb90f730982882e65b01fb8bdfe83914339c5

So, I tried reverting just that kernel change on top of the breaking
OpenWrt commit, and my warm boot hang went away.

Presumably, the warm boot hang is due to some register not getting
cleared in the same way that a loss of power does. That is
approximately as much as I understand about the problem.

More poking/prodding and coaching from Jonas Gorski, it looks
like this test patch fixes the problem on my board: Tested against
v6.6.67 and v4.14.113.

Fixes: 18fb053f9b82 ("x86/cpu/cyrix: Use correct macros for Cyrix calls on Geode processors")
Debugged-by: Jonas Gorski <jonas.gorski@gmail.com>
Signed-off-by: Russell Senior <russell@personaltelco.net>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://lore.kernel.org/r/CAHP3WfOgs3Ms4Z+L9i0-iBOE21sdMk5erAiJurPjnrL9LSsgRA@mail.gmail.com
Cc: Matthew Whitehead <tedheadster@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/cyrix.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/cyrix.c b/arch/x86/kernel/cpu/cyrix.c
index 9651275aecd1b..dfec2c61e3547 100644
--- a/arch/x86/kernel/cpu/cyrix.c
+++ b/arch/x86/kernel/cpu/cyrix.c
@@ -153,8 +153,8 @@ static void geode_configure(void)
 	u8 ccr3;
 	local_irq_save(flags);
 
-	/* Suspend on halt power saving and enable #SUSP pin */
-	setCx86(CX86_CCR2, getCx86(CX86_CCR2) | 0x88);
+	/* Suspend on halt power saving */
+	setCx86(CX86_CCR2, getCx86(CX86_CCR2) | 0x08);
 
 	ccr3 = getCx86(CX86_CCR3);
 	setCx86(CX86_CCR3, (ccr3 & 0x0f) | 0x10);	/* enable MAPEN */
-- 
2.39.5



