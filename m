Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A65D4255F39;
	Mon, 23 Jun 2025 13:33:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685600; cv=none; b=KEL/1g24OS+S6kLivj5I/txGarOCHTjie3fNOWooYkh1pZDXrXIgP1tkqpg5nz+7no0nN01sCbuab5I/jxJn0MUuzCVlD19v5hZC5YRyXVod0hod4sQD0ZqA3JF27EXh5q1JC4cdImLUyQrtiBuipDMZ6wL3mICQDjn85JRxJfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685600; c=relaxed/simple;
	bh=A2gj8+4sT1hReJ6NCKg5T1BA053jxwxIUQVtPy85K0g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=maoUIk+AmAQMy2Rb8MjTaZSxLx8mKgFHKCkrzjyfV9zthaMplTU5BV9x+NSO/fZ71EQyQKMCTY4lzD03m2lfQfVh1bViz/hi/SC4KVs1+uGiL82odKKpvt1X4y6XBImzrzLIvpEmh9YclMurYBWT7jSDXK3tiSLbWc/TqN66hPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B0UvG5zZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B0UvG5zZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39930C4CEEA;
	Mon, 23 Jun 2025 13:33:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685600;
	bh=A2gj8+4sT1hReJ6NCKg5T1BA053jxwxIUQVtPy85K0g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B0UvG5zZLxE8Y3b+yLOjybedLlV+67fvFbaye/IjDTj9eS+QUxYEhms6U3uoRcqxU
	 aYsijqfb6x2nKAT/BgWYsX3GxP+lcj0fS3LfY8rl+euv1Vfe9n1pWv5xNZnMPO0wwj
	 gUwKlhCe8A1E+4iNji68/OMbFl/6aP6jlRSRIXTk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eddie James <eajames@linux.ibm.com>,
	Hari Bathini <hbathini@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 018/508] powerpc/crash: Fix non-smp kexec preparation
Date: Mon, 23 Jun 2025 15:01:03 +0200
Message-ID: <20250623130645.702988014@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

From: Eddie James <eajames@linux.ibm.com>

[ Upstream commit 882b25af265de8e05c66f72b9a29f6047102958f ]

In non-smp configurations, crash_kexec_prepare is never called in
the crash shutdown path. One result of this is that the crashing_cpu
variable is never set, preventing crash_save_cpu from storing the
NT_PRSTATUS elf note in the core dump.

Fixes: c7255058b543 ("powerpc/crash: save cpu register data in crash_smp_send_stop()")
Signed-off-by: Eddie James <eajames@linux.ibm.com>
Reviewed-by: Hari Bathini <hbathini@linux.ibm.com>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/20250211162054.857762-1-eajames@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kexec/crash.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/kexec/crash.c b/arch/powerpc/kexec/crash.c
index 252724ed666a3..14abe7046cd74 100644
--- a/arch/powerpc/kexec/crash.c
+++ b/arch/powerpc/kexec/crash.c
@@ -356,7 +356,10 @@ void default_machine_crash_shutdown(struct pt_regs *regs)
 	if (TRAP(regs) == INTERRUPT_SYSTEM_RESET)
 		is_via_system_reset = 1;
 
-	crash_smp_send_stop();
+	if (IS_ENABLED(CONFIG_SMP))
+		crash_smp_send_stop();
+	else
+		crash_kexec_prepare();
 
 	crash_save_cpu(regs, crashing_cpu);
 
-- 
2.39.5



