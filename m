Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5FD1350D54;
	Tue, 26 Aug 2025 13:53:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216404; cv=none; b=uZrrsDzvKI28eRzteRSLDfoV9nVS4PkEGFLl6I4NJTSyE3jTRwZkJr2L6rxQS9u2smH6yDTt2cTWuVBusO01Jbzhtf0h+FcTdpwfcr8hbDKOcWlkVX8MRmYjVNfHifTTTWsPHjxgjDiewDXjXUJHtZmD0zGNcdisVzFcYXevBSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216404; c=relaxed/simple;
	bh=6NFMBSEUHzo85Oh6w4PXDR48KZykZz+kGqL2ORi0RY4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i8tJGS6Ua18dl3ThLlx1f8VMXvB1LraOLe7atmxOyCZ89LPoGpT7rJzoKpjlUYaGn550T6npUNo4Y3Elj3YYkB8VOnJIzyDQpJwAxo79rpThRL/lkobi+hfJ7WTsm1NeyLBcjse5KZND/zef/L2/2W1HACKyVkgp0hw7kfnNuec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W7UluNDD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W7UluNDD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67B2BC113D0;
	Tue, 26 Aug 2025 13:53:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756216404;
	bh=6NFMBSEUHzo85Oh6w4PXDR48KZykZz+kGqL2ORi0RY4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W7UluNDDB44tXusiVsyfV3nq6fy0JYVS9boJRHBzGqKkx9dmWoRk8E60Lz+W1oKga
	 zc++r27hhzf73MtCVrJrrmwkRCeDa62Mw2n4iDozPz2BWHUXfUGk+zVKlwIOaFaerV
	 ALcXli6GOhBdiajgbcTzcvVwgQNBHULneIoQb89A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 345/644] arm64: Mark kernel as tainted on SAE and SError panic
Date: Tue, 26 Aug 2025 13:07:16 +0200
Message-ID: <20250826110954.945779802@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Breno Leitao <leitao@debian.org>

[ Upstream commit d7ce7e3a84642aadf7c4787f7ec4f58eb163d129 ]

Set TAINT_MACHINE_CHECK when SError or Synchronous External Abort (SEA)
interrupts trigger a panic to flag potential hardware faults. This
tainting mechanism aids in debugging and enables correlation of
hardware-related crashes in large-scale deployments.

This change aligns with similar patches[1] that mark machine check
events when the system crashes due to hardware errors.

Link: https://lore.kernel.org/all/20250702-add_tain-v1-1-9187b10914b9@debian.org/ [1]
Signed-off-by: Breno Leitao <leitao@debian.org>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Link: https://lore.kernel.org/r/20250716-vmcore_hw_error-v2-1-f187f7d62aba@debian.org
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/traps.c | 1 +
 arch/arm64/mm/fault.c     | 1 +
 2 files changed, 2 insertions(+)

diff --git a/arch/arm64/kernel/traps.c b/arch/arm64/kernel/traps.c
index c71074cb2bef..6debe95f8a62 100644
--- a/arch/arm64/kernel/traps.c
+++ b/arch/arm64/kernel/traps.c
@@ -883,6 +883,7 @@ void panic_bad_stack(struct pt_regs *regs, unsigned long esr, unsigned long far)
 
 void __noreturn arm64_serror_panic(struct pt_regs *regs, unsigned long esr)
 {
+	add_taint(TAINT_MACHINE_CHECK, LOCKDEP_STILL_OK);
 	console_verbose();
 
 	pr_crit("SError Interrupt on CPU%d, code 0x%016lx -- %s\n",
diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
index 632762039714..d293aac8c554 100644
--- a/arch/arm64/mm/fault.c
+++ b/arch/arm64/mm/fault.c
@@ -726,6 +726,7 @@ static int do_sea(unsigned long far, unsigned long esr, struct pt_regs *regs)
 		 */
 		siaddr  = untagged_addr(far);
 	}
+	add_taint(TAINT_MACHINE_CHECK, LOCKDEP_STILL_OK);
 	arm64_notify_die(inf->name, regs, inf->sig, inf->code, siaddr, esr);
 
 	return 0;
-- 
2.39.5



