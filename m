Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8E101B29F;
	Wed,  3 Jan 2024 16:59:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SuOXVvGp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C46DC433C7;
	Wed,  3 Jan 2024 16:59:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704301185;
	bh=2cEUtNwNo/9bXvmzyuq8zpa7w2D3f7PBUXOqLj+T4vI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SuOXVvGpBA96kC9cKuK5Ys8JgmnVCc//kTJcjhYHnqfI48W1nquCz0kUCLMEHqNsF
	 IBV3unSMBarbk7tHtTaKy6IISIR+AaUFriYQcveHb3TRDx3kfyH6AFqSwfHK9WKSAs
	 BY9D84O5cltoAuq1Gb7cX7rMACvYmGHFhW/9Vi8I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Talpey <tom@talpey.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 043/100] ksmbd: return invalid parameter error response if smb2 request is invalid
Date: Wed,  3 Jan 2024 17:54:32 +0100
Message-ID: <20240103164902.510162435@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240103164856.169912722@linuxfoundation.org>
References: <20240103164856.169912722@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit f2f11fca5d7112e2f91c4854cddd68a059fdaa4a ]

If smb2 request from client is invalid, The following kernel oops could
happen. The patch e2b76ab8b5c9: "ksmbd: add support for read compound"
leads this issue. When request is invalid, It doesn't set anything in
the response buffer. This patch add missing set invalid parameter error
response.

[  673.085542] ksmbd: cli req too short, len 184 not 142. cmd:5 mid:109
[  673.085580] BUG: kernel NULL pointer dereference, address: 0000000000000000
[  673.085591] #PF: supervisor read access in kernel mode
[  673.085600] #PF: error_code(0x0000) - not-present page
[  673.085608] PGD 0 P4D 0
[  673.085620] Oops: 0000 [#1] PREEMPT SMP NOPTI
[  673.085631] CPU: 3 PID: 1039 Comm: kworker/3:0 Not tainted 6.6.0-rc2-tmt #16
[  673.085643] Hardware name: AZW U59/U59, BIOS JTKT001 05/05/2022
[  673.085651] Workqueue: ksmbd-io handle_ksmbd_work [ksmbd]
[  673.085719] RIP: 0010:ksmbd_conn_write+0x68/0xc0 [ksmbd]
[  673.085808] RAX: 0000000000000000 RBX: ffff88811ade4f00 RCX: 0000000000000000
[  673.085817] RDX: 0000000000000000 RSI: ffff88810c2a9780 RDI: ffff88810c2a9ac0
[  673.085826] RBP: ffffc900005e3e00 R08: 0000000000000000 R09: 0000000000000000
[  673.085834] R10: ffffffffa3168160 R11: 63203a64626d736b R12: ffff8881057c8800
[  673.085842] R13: ffff8881057c8820 R14: ffff8882781b2380 R15: ffff8881057c8800
[  673.085852] FS:  0000000000000000(0000) GS:ffff888278180000(0000) knlGS:0000000000000000
[  673.085864] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  673.085872] CR2: 0000000000000000 CR3: 000000015b63c000 CR4: 0000000000350ee0
[  673.085883] Call Trace:
[  673.085890]  <TASK>
[  673.085900]  ? show_regs+0x6a/0x80
[  673.085916]  ? __die+0x25/0x70
[  673.085926]  ? page_fault_oops+0x154/0x4b0
[  673.085938]  ? tick_nohz_tick_stopped+0x18/0x50
[  673.085954]  ? __irq_work_queue_local+0xba/0x140
[  673.085967]  ? do_user_addr_fault+0x30f/0x6c0
[  673.085979]  ? exc_page_fault+0x79/0x180
[  673.085992]  ? asm_exc_page_fault+0x27/0x30
[  673.086009]  ? ksmbd_conn_write+0x68/0xc0 [ksmbd]
[  673.086067]  ? ksmbd_conn_write+0x46/0xc0 [ksmbd]
[  673.086123]  handle_ksmbd_work+0x28d/0x4b0 [ksmbd]
[  673.086177]  process_one_work+0x178/0x350
[  673.086193]  ? __pfx_worker_thread+0x10/0x10
[  673.086202]  worker_thread+0x2f3/0x420
[  673.086210]  ? _raw_spin_unlock_irqrestore+0x27/0x50
[  673.086222]  ? __pfx_worker_thread+0x10/0x10
[  673.086230]  kthread+0x103/0x140
[  673.086242]  ? __pfx_kthread+0x10/0x10
[  673.086253]  ret_from_fork+0x39/0x60
[  673.086263]  ? __pfx_kthread+0x10/0x10
[  673.086274]  ret_from_fork_asm+0x1b/0x30

Fixes: e2b76ab8b5c9 ("ksmbd: add support for read compound")
Reported-by: Tom Talpey <tom@talpey.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/server.c   | 4 +++-
 fs/smb/server/smb2misc.c | 4 +---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/smb/server/server.c b/fs/smb/server/server.c
index f5d8e405cf6fd..633383e55723c 100644
--- a/fs/smb/server/server.c
+++ b/fs/smb/server/server.c
@@ -115,8 +115,10 @@ static int __process_request(struct ksmbd_work *work, struct ksmbd_conn *conn,
 	if (check_conn_state(work))
 		return SERVER_HANDLER_CONTINUE;
 
-	if (ksmbd_verify_smb_message(work))
+	if (ksmbd_verify_smb_message(work)) {
+		conn->ops->set_rsp_status(work, STATUS_INVALID_PARAMETER);
 		return SERVER_HANDLER_ABORT;
+	}
 
 	command = conn->ops->get_cmd_val(work);
 	*cmd = command;
diff --git a/fs/smb/server/smb2misc.c b/fs/smb/server/smb2misc.c
index e881df1d10cbd..23bd3d1209dfa 100644
--- a/fs/smb/server/smb2misc.c
+++ b/fs/smb/server/smb2misc.c
@@ -440,10 +440,8 @@ int ksmbd_smb2_check_message(struct ksmbd_work *work)
 
 validate_credit:
 	if ((work->conn->vals->capabilities & SMB2_GLOBAL_CAP_LARGE_MTU) &&
-	    smb2_validate_credit_charge(work->conn, hdr)) {
-		work->conn->ops->set_rsp_status(work, STATUS_INVALID_PARAMETER);
+	    smb2_validate_credit_charge(work->conn, hdr))
 		return 1;
-	}
 
 	return 0;
 }
-- 
2.43.0



