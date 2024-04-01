Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EADEA5677C;
	Mon,  1 Apr 2024 15:51:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711986698; cv=none; b=gEQqmmx3BMCCl4SDJz4KhxiR0+I2wEMskRDE0Aj26OgjfRI/VEhN58QO6Dw8yxR72Jxaf2YYy1WjHITpGtdynDJ5mb1ncvCkhKCTpvaaCAs0QvQMROZ2Gf9n3jiFbbErVuLTxzARarWM3IHNgS7W6or/Ni7DxOfxZhdgBi1xB7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711986698; c=relaxed/simple;
	bh=OsOVTX558ryEndPDrlbVX/1IcXZH7GhiOlPLZ1AvQd4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WeGMRtakt5nVyYae3BQb7oZDs++83Bk/Oqspg4EZcwmvTcrNu6n0D9xwI+SusHmrp7k+D267BCbQx97PRUaPwqowAvOOj5NvOkqt+Mk2iQpTIAACl5GFxP0U6ghIiNdS+cvdUz955Q4tgdbo+nqJbUu1T90CbuN6MEfCWvhGkP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iwiiMCmO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iwiiMCmO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70F92C433C7;
	Mon,  1 Apr 2024 15:51:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711986697;
	bh=OsOVTX558ryEndPDrlbVX/1IcXZH7GhiOlPLZ1AvQd4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iwiiMCmOWCQjLLtjta3o0YlJ3WEXQ0ON2n7zW9boj7rm0Q3RQ0Y667oJKS8OLsRN8
	 hYZ93dW1nSXXnWqWAlopIJ95Uh9qKauXkf9B7vI31QoV0n+OKYHGEuC0fMLH0W/UiC
	 leLTvkPc02qdvkwAI6xOcFiYC0Mj1R6/Xcz/OCmA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 056/399] x86/nmi: Fix the inverse "in NMI handler" check
Date: Mon,  1 Apr 2024 17:40:22 +0200
Message-ID: <20240401152550.856961504@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Breno Leitao <leitao@debian.org>

[ Upstream commit d54e56f31a34fa38fcb5e91df609f9633419a79a ]

Commit 344da544f177 ("x86/nmi: Print reasons why backtrace NMIs are
ignored") creates a super nice framework to diagnose NMIs.

Every time nmi_exc() is called, it increments a per_cpu counter
(nsp->idt_nmi_seq). At its exit, it also increments the same counter.  By
reading this counter it can be seen how many times that function was called
(dividing by 2), and, if the function is still being executed, by checking
the idt_nmi_seq's least significant bit.

On the check side (nmi_backtrace_stall_check()), that variable is queried
to check if the NMI is still being executed, but, there is a mistake in the
bitwise operation. That code wants to check if the least significant bit of
the idt_nmi_seq is set or not, but does the opposite, and checks for all
the other bits, which will always be true after the first exc_nmi()
executed successfully.

This appends the misleading string to the dump "(CPU currently in NMI
handler function)"

Fix it by checking the least significant bit, and if it is set, append the
string.

Fixes: 344da544f177 ("x86/nmi: Print reasons why backtrace NMIs are ignored")
Signed-off-by: Breno Leitao <leitao@debian.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Paul E. McKenney <paulmck@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20240207165237.1048837-1-leitao@debian.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/nmi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/nmi.c b/arch/x86/kernel/nmi.c
index 3082cf24b69e3..6da2cfa23c293 100644
--- a/arch/x86/kernel/nmi.c
+++ b/arch/x86/kernel/nmi.c
@@ -636,7 +636,7 @@ void nmi_backtrace_stall_check(const struct cpumask *btp)
 			msgp = nmi_check_stall_msg[idx];
 			if (nsp->idt_ignored_snap != READ_ONCE(nsp->idt_ignored) && (idx & 0x1))
 				modp = ", but OK because ignore_nmis was set";
-			if (nmi_seq & ~0x1)
+			if (nmi_seq & 0x1)
 				msghp = " (CPU currently in NMI handler function)";
 			else if (nsp->idt_nmi_seq_snap + 1 == nmi_seq)
 				msghp = " (CPU exited one NMI handler function)";
-- 
2.43.0



