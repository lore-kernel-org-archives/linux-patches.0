Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB8EE2E3B1C;
	Tue, 15 Jul 2025 13:51:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587471; cv=none; b=Mb1YSdo6GdJEN062UK4UhQgt+0Nm8cgvd32SIPYvZ7wImHAVsTydSM6nHor9e3Kq0mbwg56K08vG6FuAY5gNb2jkC7FilpI+4At9HT7oAyKz4xgRKEYwrr/kZE7DRfqi7eXWgwKiAhZunk+pFkTAUVUy4ihfY+wFJtKSzl1aNTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587471; c=relaxed/simple;
	bh=x40OpYkX74CM0/Urv0dD3Zj4G7FXYlB7j6fWb+Ct6Jo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kkKRWi3wTPcTRAVXc0qtpi6jkwDNA485A74wKMbD+uuWtSZh1JEL7EV1pQyLZq4yvbH4QvVB3v+/EIDaXRtDdW0kiXIaunZ/HygBG+hjNJwFMlwwnyo9DyKzP0lDs7qiXTRvd3nzVVGHRSFblT9LF1mlt4qR2GTTT+F3gR4NEp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gtwaQ3zb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gtwaQ3zb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E302C4CEE3;
	Tue, 15 Jul 2025 13:51:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587471;
	bh=x40OpYkX74CM0/Urv0dD3Zj4G7FXYlB7j6fWb+Ct6Jo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gtwaQ3zbSl9xWJBrBRERlUmmmC2PF2qwseFT9+wflj05YvJl5nYbyScN8oDKrWa+e
	 0pdZSJ+JZCCICr0fmKK8naS3/Uw4QCYqMCW/uyQh1BiVRo1BRcq0LsgtrveKqxjGsR
	 gHLiEg7JXG/eqSsRT7mZ7p/Iq9/H9+9b8eSsR2jA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzkaller <syzkaller@googlegroups.com>,
	George Kennedy <george.kennedy@oracle.com>,
	Vishnu Dasa <vdasa@vmware.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 024/208] VMCI: check context->notify_page after call to get_user_pages_fast() to avoid GPF
Date: Tue, 15 Jul 2025 15:12:13 +0200
Message-ID: <20250715130811.805263309@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130810.830580412@linuxfoundation.org>
References: <20250715130810.830580412@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

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
Stable-dep-of: 1bd6406fb5f3 ("VMCI: fix race between vmci_host_setup_notify and vmci_ctx_unset_notify")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/vmw_vmci/vmci_host.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/misc/vmw_vmci/vmci_host.c b/drivers/misc/vmw_vmci/vmci_host.c
index 4a903770b8e1d..cc6da9e5a542b 100644
--- a/drivers/misc/vmw_vmci/vmci_host.c
+++ b/drivers/misc/vmw_vmci/vmci_host.c
@@ -248,6 +248,8 @@ static int vmci_host_setup_notify(struct vmci_ctx *context,
 		context->notify_page = NULL;
 		return VMCI_ERROR_GENERIC;
 	}
+	if (context->notify_page == NULL)
+		return VMCI_ERROR_UNAVAILABLE;
 
 	/*
 	 * Map the locked page and set up notify pointer.
-- 
2.39.5



