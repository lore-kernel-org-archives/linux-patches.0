Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B5F7BA35
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:32:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8730DC433D2;
	Tue,  7 Mar 2023 17:32:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678210373;
	bh=kuDlEyKFMm3hkU0qV64QqInuOViRoocDeoJjbnYDs1w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nWvKF80BEB9csXPVZNNH+0GaAGN9VL3MaZ5i0VFixYXQzX0r+yfF+rMX6xcBP8BPR
	 U0csmS0ITtE8/QvgNMWnGHRvYO2cxn5KxUw+Fwbx12XWEz9LtzINp5RpyyjV+8zlTp
	 P28UOA18IJUj0tYAEsnXzPyVKTfhJyUrDLfyvkJc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzkaller <syzkaller@googlegroups.com>,
	George Kennedy <george.kennedy@oracle.com>,
	Vishnu Dasa <vdasa@vmware.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0519/1001] VMCI: check context->notify_page after call to get_user_pages_fast() to avoid GPF
Date: Tue,  7 Mar 2023 17:54:51 +0100
Message-Id: <20230307170043.962056425@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: George Kennedy <george.kennedy@oracle.com>

[ Upstream commit 1a726cb47fd204109c767409fa9ca15a96328f14 ]

The call to get_user_pages_fast() in vmci_host_setup_notify() can return
NULL context->notify_page causing a GPF. To avoid GPF check if
context->notify_page == NULL and return error if so.

general protection fault, probably for non-canonical address
    0xe0009d1000000060: 0000 [#1] PREEMPT SMP KASAN NOPTI
KASAN: maybe wild-memory-access in range [0x0005088000000300-
    0x0005088000000307]
CPU: 2 PID: 26180 Comm: repro_34802241 Not tainted 6.1.0-rc4 #1
Hardware name: Red Hat KVM, BIOS 1.15.0-2.module+el8.6.0 04/01/2014
RIP: 0010:vmci_ctx_check_signal_notify+0x91/0xe0
Call Trace:
 <TASK>
 vmci_host_unlocked_ioctl+0x362/0x1f40
 __x64_sys_ioctl+0x1a1/0x230
 do_syscall_64+0x3a/0x90
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

Fixes: a1d88436d53a ("VMCI: Fix two UVA mapping bugs")
Reported-by: syzkaller <syzkaller@googlegroups.com>
Signed-off-by: George Kennedy <george.kennedy@oracle.com>
Reviewed-by: Vishnu Dasa <vdasa@vmware.com>
Link: https://lore.kernel.org/r/1669666705-24012-1-git-send-email-george.kennedy@oracle.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/vmw_vmci/vmci_host.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/misc/vmw_vmci/vmci_host.c b/drivers/misc/vmw_vmci/vmci_host.c
index da1e2a773823e..857b9851402a6 100644
--- a/drivers/misc/vmw_vmci/vmci_host.c
+++ b/drivers/misc/vmw_vmci/vmci_host.c
@@ -242,6 +242,8 @@ static int vmci_host_setup_notify(struct vmci_ctx *context,
 		context->notify_page = NULL;
 		return VMCI_ERROR_GENERIC;
 	}
+	if (context->notify_page == NULL)
+		return VMCI_ERROR_UNAVAILABLE;
 
 	/*
 	 * Map the locked page and set up notify pointer.
-- 
2.39.2



