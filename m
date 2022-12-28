Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 796AB1C08
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:44:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC795C433EF;
	Wed, 28 Dec 2022 16:44:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672245885;
	bh=cbQ8SyZFREV8vFF9bRS676PytjnbqBvZbE1b8YYjSf8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qMPYqgLGDc0BvhdgAwXlQA5ZBs1yY4pGsx+T4J3ubUvoMGN1llcmgYztS/GpRUSPQ
	 r8lTdGy49hDo24IZmUGuQZJfaFILkHRRHDG8o5zXst3qCAd9wcldnVPmEoGHyGT+yp
	 6C2hiXB1BToiY4ZSW41D2K+bTQLJH2l2pYRhdCNw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gaurav Kohli <gauravkohli@linux.microsoft.com>,
	Michael Kelley <mikelley@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0941/1146] x86/hyperv: Remove unregister syscore call from Hyper-V cleanup
Date: Wed, 28 Dec 2022 15:41:20 +0100
Message-Id: <20221228144355.872945429@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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
index a269049a43ce..85863b9c9e68 100644
--- a/arch/x86/hyperv/hv_init.c
+++ b/arch/x86/hyperv/hv_init.c
@@ -535,8 +535,6 @@ void hyperv_cleanup(void)
 	union hv_x64_msr_hypercall_contents hypercall_msr;
 	union hv_reference_tsc_msr tsc_msr;
 
-	unregister_syscore_ops(&hv_syscore_ops);
-
 	/* Reset our OS id */
 	wrmsrl(HV_X64_MSR_GUEST_OS_ID, 0);
 	hv_ghcb_msr_write(HV_X64_MSR_GUEST_OS_ID, 0);
-- 
2.35.1



