Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE33D2EAE5;
	Thu, 11 Apr 2024 10:05:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712829908; cv=none; b=Btjw0zBFH3aozJT2DMNoiYZi+7BRQnjfKCskH4fRcwaTn5TowU0mf+1r20pqDR6R/C/pNJQ4fN0bSBUw/cQBfhEQyO+VsXKNTWVU39FVrdn/IF6DAbrFR0rl7owCMto9yWP4Rpd5zDFWT4GiYa+mfr7W2AmgZrRDZ5YTh93hbpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712829908; c=relaxed/simple;
	bh=fNG+qQN1ypequkuSCGA/x6WODWR7lxd1EamfrkW/pnY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jHvvNZLs0V920uWAqu8EWF3HLqeIuuF1ciN0sArP9GQYCw72zpP2IqmebVBJkdQPfFG1A3LCR6BfhqcrNIhIHa4x5FtSBTaq9DshQn32s89jMn4SzmEGGFmluYGNhC+uO8X+Bd+MLxo8JTprp+4iCeIr5jRjj/4oGwdy/mvDc18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eW+cwI6Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eW+cwI6Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34992C43390;
	Thu, 11 Apr 2024 10:05:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712829908;
	bh=fNG+qQN1ypequkuSCGA/x6WODWR7lxd1EamfrkW/pnY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eW+cwI6QYV+Wgmcd44bI3SaVbE7wvDFsyCKiRMWUpRA3Rqp7ZT9mlEnqtBHFRQ6QV
	 ZhaJpuRhrX6A+bsl1m6j9sRhuvatL/v9MYd5xOGqml6Y1GCz3pllRfUD+msJgMy+s3
	 e6knMkrar7LyAqomCjPuu2NqkIADlgtYlOzU4/hU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzkaller <syzkaller@googlegroups.com>,
	Vegard Nossum <vegard.nossum@oracle.com>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
	Kees Cook <keescook@chromium.org>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 146/175] VMCI: Fix memcpy() run-time warning in dg_dispatch_as_host()
Date: Thu, 11 Apr 2024 11:56:09 +0200
Message-ID: <20240411095423.958401972@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095419.532012976@linuxfoundation.org>
References: <20240411095419.532012976@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

[ Upstream commit 19b070fefd0d024af3daa7329cbc0d00de5302ec ]

Syzkaller hit 'WARNING in dg_dispatch_as_host' bug.

memcpy: detected field-spanning write (size 56) of single field "&dg_info->msg"
at drivers/misc/vmw_vmci/vmci_datagram.c:237 (size 24)

WARNING: CPU: 0 PID: 1555 at drivers/misc/vmw_vmci/vmci_datagram.c:237
dg_dispatch_as_host+0x88e/0xa60 drivers/misc/vmw_vmci/vmci_datagram.c:237

Some code commentry, based on my understanding:

544 #define VMCI_DG_SIZE(_dg) (VMCI_DG_HEADERSIZE + (size_t)(_dg)->payload_size)
/// This is 24 + payload_size

memcpy(&dg_info->msg, dg, dg_size);
	Destination = dg_info->msg ---> this is a 24 byte
					structure(struct vmci_datagram)
	Source = dg --> this is a 24 byte structure (struct vmci_datagram)
	Size = dg_size = 24 + payload_size

{payload_size = 56-24 =32} -- Syzkaller managed to set payload_size to 32.

 35 struct delayed_datagram_info {
 36         struct datagram_entry *entry;
 37         struct work_struct work;
 38         bool in_dg_host_queue;
 39         /* msg and msg_payload must be together. */
 40         struct vmci_datagram msg;
 41         u8 msg_payload[];
 42 };

So those extra bytes of payload are copied into msg_payload[], a run time
warning is seen while fuzzing with Syzkaller.

One possible way to fix the warning is to split the memcpy() into
two parts -- one -- direct assignment of msg and second taking care of payload.

Gustavo quoted:
"Under FORTIFY_SOURCE we should not copy data across multiple members
in a structure."

Reported-by: syzkaller <syzkaller@googlegroups.com>
Suggested-by: Vegard Nossum <vegard.nossum@oracle.com>
Suggested-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Reviewed-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Reviewed-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://lore.kernel.org/r/20240105164001.2129796-2-harshit.m.mogalapalli@oracle.com
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/vmw_vmci/vmci_datagram.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/misc/vmw_vmci/vmci_datagram.c b/drivers/misc/vmw_vmci/vmci_datagram.c
index 8a4b6bbe1beed..275542e8b2ad9 100644
--- a/drivers/misc/vmw_vmci/vmci_datagram.c
+++ b/drivers/misc/vmw_vmci/vmci_datagram.c
@@ -242,7 +242,8 @@ static int dg_dispatch_as_host(u32 context_id, struct vmci_datagram *dg)
 
 			dg_info->in_dg_host_queue = true;
 			dg_info->entry = dst_entry;
-			memcpy(&dg_info->msg, dg, dg_size);
+			dg_info->msg = *dg;
+			memcpy(&dg_info->msg_payload, dg + 1, dg->payload_size);
 
 			INIT_WORK(&dg_info->work, dg_delayed_dispatch);
 			schedule_work(&dg_info->work);
-- 
2.43.0



