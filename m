Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E90D31875
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:53:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 597ABC43396;
	Wed, 28 Dec 2022 15:53:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672242781;
	bh=iv68qWuwZhSAhJiol+KNif9+UsN3ck260qQGw6e9kYg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=esIExnxfroij22/PrV0RFGhVbGhAdcZWeCjX1fcgPaxpmSiXXyAX0Tdqdh/EZ817b
	 iHgmtp3+9xVnOJ5BDXlgMT3sWa6Qokz+7nJ2WAIfoQJ7MIFHUo1P/Qaboex67rB/tQ
	 8JobGT98u/xR7SYSReK8h/cXoCFa0XqFEqxymBwU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gaurav Kohli <gauravkohli@linux.microsoft.com>,
	Michael Kelley <mikelley@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 618/731] x86/hyperv: Remove unregister syscore call from Hyper-V cleanup
Date: Wed, 28 Dec 2022 15:42:05 +0100
Message-Id: <20221228144314.445993345@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Gaurav Kohli <gauravkohli@linux.microsoft.com>

[ Upstream commit 32c97d980e2eef25465d453f2956a9ca68926a3c ]

Hyper-V cleanup code comes under panic path where preemption and irq
is already disabled. So calling of unregister_syscore_ops might schedule
out the thread even for the case where mutex lock is free.
hyperv_cleanup
	unregister_syscore_ops
			mutex_lock(&syscore_ops_lock)
				might_sleep
Here might_sleep might schedule out this thread, where voluntary preemption
config is on and this thread will never comes back. And also this was added
earlier to maintain the symmetry which is not required as this can comes
during crash shutdown path only.

To prevent the same, removing unregister_syscore_ops function call.

Signed-off-by: Gaurav Kohli <gauravkohli@linux.microsoft.com>
Reviewed-by: Michael Kelley <mikelley@microsoft.com>
Link: https://lore.kernel.org/r/1669443291-2575-1-git-send-email-gauravkohli@linux.microsoft.com
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/hyperv/hv_init.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/x86/hyperv/hv_init.c b/arch/x86/hyperv/hv_init.c
index 762f10cdfb7a..95f98af74fdc 100644
--- a/arch/x86/hyperv/hv_init.c
+++ b/arch/x86/hyperv/hv_init.c
@@ -469,8 +469,6 @@ void hyperv_cleanup(void)
 {
 	union hv_x64_msr_hypercall_contents hypercall_msr;
 
-	unregister_syscore_ops(&hv_syscore_ops);
-
 	/* Reset our OS id */
 	wrmsrl(HV_X64_MSR_GUEST_OS_ID, 0);
 
-- 
2.35.1



