Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C219A47A6A;
	Mon,  1 Apr 2024 16:13:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711987999; cv=none; b=Kgvw5zFJIap7eZIRhW9NcyLewhozEcY/lLU4c4oQa7/Yag3xXgxMTTQk04vwvLvtC8sK6pSzGqytSmUevEUMjjfW0NLDApw5W8lJcsV+lspTF5AZsWqHrE38gbNjq94gJYkVAyik01g1IXGkcDUIUNInJOAaAubsRd2QjF6a894=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711987999; c=relaxed/simple;
	bh=a3G0f5Ii08+YbS890KtPt2A45StH2klNxFvpt0XlOGo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BR4ZZ5w6lx5TdBBBAoTW23i4X4fM15iq9HMF0JZ/l7b045X85YlJO6Axz9MIUcX+NP0W5izgq58WbkNSkSBhRIVv20IH5WxDFFA2+t0z0sNBxeSgeiMOoDidVKuvAVbm9RJFiHFCwNHnq8kSXNFm8xY6vPFdMVA06a+VpByOPc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yr4JfhaS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yr4JfhaS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32D0BC433F1;
	Mon,  1 Apr 2024 16:13:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711987999;
	bh=a3G0f5Ii08+YbS890KtPt2A45StH2klNxFvpt0XlOGo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yr4JfhaS+EeU92IVAyvJ6IMYXBzROapFSVBzcyswwYkfDg7a+c7w1h37GBomh8dla
	 EGElzxKnn5aZr+cquO/Nf+Pf04TezARP2eGUCPEWIUYARieJPRWHZMkeXkO57kIS4p
	 RnDHxoK7SkGBaXz6eXl0Vzc4/wTgW2XPZwoyAtKI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 055/432] x86/nmi: Fix the inverse "in NMI handler" check
Date: Mon,  1 Apr 2024 17:40:42 +0200
Message-ID: <20240401152554.768019226@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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



