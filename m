Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A71013FD94;
	Thu, 11 Apr 2024 10:22:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830956; cv=none; b=bAeiqNsnVnb8oSOKzts6SJwoQtQfKvfcL/B6YkCYDbkYi0FK30eGt3PYzOAhRjST99QiKeJsP1OUyc0tCSEcsGwbfMN/0dhqZK+2CzNkkbWeCwsOulYIE6UmBOxGWL6+1OgHJg56K491kE0MCb44zhwI7piymlFdfSNSLtWeAUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830956; c=relaxed/simple;
	bh=ZbIpoUO0FfkiXKA07oRA3t5Hi5TgK2cRpKciJE3G2C0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FxvR2FT1Nk0LEvgPT6cA5YGAWkvBn29BSiri6b4SHkbO6kFWVyE7aGn+6cPUgf0RDAwD/PeuFVXHpXCYFD/d+MCorhMCmcP/VZtVBu0j75v7zMNccIGSvmU+nwxvdwCDiVtBgXL49uz2DV2RsYoAEYP6sSYun9aqwIuzdbT1ffo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MwoEo43M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MwoEo43M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2296EC433F1;
	Thu, 11 Apr 2024 10:22:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830956;
	bh=ZbIpoUO0FfkiXKA07oRA3t5Hi5TgK2cRpKciJE3G2C0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MwoEo43MEo9PIym0jKD0VT/ZlfQFfBTeL64NLEqSegEV13lwMoTwcbr4l3EZCI2Ok
	 oM735slXzyPn0BIPc0fqrMLJEYdCxYJXqvTUtJm09p81cke8bnOyrL1gzljMbuZw7k
	 VJLrvlWMtrPen1iFFAHjCVjhR96EBNcT5dP1qOKY=
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
Subject: [PATCH 5.4 175/215] VMCI: Fix memcpy() run-time warning in dg_dispatch_as_host()
Date: Thu, 11 Apr 2024 11:56:24 +0200
Message-ID: <20240411095430.131089526@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095424.875421572@linuxfoundation.org>
References: <20240411095424.875421572@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index f50d22882476f..d1d8224c8800c 100644
--- a/drivers/misc/vmw_vmci/vmci_datagram.c
+++ b/drivers/misc/vmw_vmci/vmci_datagram.c
@@ -234,7 +234,8 @@ static int dg_dispatch_as_host(u32 context_id, struct vmci_datagram *dg)
 
 			dg_info->in_dg_host_queue = true;
 			dg_info->entry = dst_entry;
-			memcpy(&dg_info->msg, dg, dg_size);
+			dg_info->msg = *dg;
+			memcpy(&dg_info->msg_payload, dg + 1, dg->payload_size);
 
 			INIT_WORK(&dg_info->work, dg_delayed_dispatch);
 			schedule_work(&dg_info->work);
-- 
2.43.0



