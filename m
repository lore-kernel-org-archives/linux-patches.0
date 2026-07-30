Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 320203A641D;
	Thu, 30 Jul 2026 15:03:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423817; cv=none; b=CVfGCAddJvB2CtMsxA8RzW/t07Rj2x88XWpWtg8kRu2urg5YKwidm/wc4uPQPDV67kilPYHsxt8ltID8CUgw8vZbMoUH0hmSh7/KkkmuOaIt7KR7W1RmytKD+JzgTwqygwEfKCDQ1vCbOBE+r2nSi0Jq1RqObLdpL+5ZVVuQqWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423817; c=relaxed/simple;
	bh=o10G4KHzx4StGGNkznTP7Eifwwk66JOn1orroHAgh8Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oOR3yVAROtGUM2mePf+1vjvPmVWijJ4CDd7dChpNyxpYshfCNtbHMnzpLM1g0pPeLaqtgNVFpD1HdUYIkOwAvSIBGOIflnpHbLLxHsH2q9gyaHNctxp5llzOhTWdVgqJ9dAecxlvDvDhwcw/rXdBU6+tWx7qwA6fpvGVWgBcnx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f/tUa3Mf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f/tUa3Mf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DB351F000E9;
	Thu, 30 Jul 2026 15:03:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423816;
	bh=k7//fHXTgZEvpFii8Q4hrMHLYzqtV8IqM34YRs0ROP8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f/tUa3MfUlzgUB6tTbnQu3KhmWpBHmJqRao0oI8k46FJJ70oGFFFkHScYB01bMpJo
	 BdHs/tiaqK+Y4Qqqg02avj3Wwhogq+zwCs4C3eabwFvJ02cYqz1wehtm53RU8c5IqV
	 KRnlcQQXk7JDYDYlRGt2ZoiIHONfCd+FIKbOloFs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Harris <mark.hsj@gmail.com>,
	Nam Cao <namcao@linutronix.de>,
	Michael Ellerman <mpe@kernel.org>,
	Paul Walmsley <pjw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 122/675] riscv: hwprobe: Avoid uninitialized read in hwprobe_get_cpus()
Date: Thu, 30 Jul 2026 16:07:32 +0200
Message-ID: <20260730141447.738976645@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Harris <mark.hsj@gmail.com>

[ Upstream commit 5caae1deee89a6582c761d5dcd4b924b744426cc ]

When cpusetsize < cpumask_size(), hwprobe_get_cpus() did not fully
initialize its copy of the cpu mask, which could cause non-deterministic
results from the riscv_hwprobe syscall on a system with more than 8 CPUs
when the supplied cpu mask is empty.  Address this by fully initializing
the cpu mask.

Fixes: e178bf146e4b ("RISC-V: hwprobe: Introduce which-cpus flag")
Signed-off-by: Mark Harris <mark.hsj@gmail.com>
Reviewed-by: Nam Cao <namcao@linutronix.de>
Reviewed-by: Michael Ellerman <mpe@kernel.org>
Link: https://patch.msgid.link/20260714003056.73707-1-mark.hsj@gmail.com
Signed-off-by: Paul Walmsley <pjw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/sys_hwprobe.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/riscv/kernel/sys_hwprobe.c b/arch/riscv/kernel/sys_hwprobe.c
index 199d13f86f3135..460fb297672e68 100644
--- a/arch/riscv/kernel/sys_hwprobe.c
+++ b/arch/riscv/kernel/sys_hwprobe.c
@@ -409,6 +409,7 @@ static int hwprobe_get_cpus(struct riscv_hwprobe __user *pairs,
 	if (cpusetsize > cpumask_size())
 		cpusetsize = cpumask_size();
 
+	cpumask_clear(&cpus);
 	ret = copy_from_user(&cpus, cpus_user, cpusetsize);
 	if (ret)
 		return -EFAULT;
-- 
2.53.0



