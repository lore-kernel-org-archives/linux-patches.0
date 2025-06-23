Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFDB4253B47;
	Mon, 23 Jun 2025 13:21:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684897; cv=none; b=pr+/nFWkMx9eB5juiTbNbtXHtNvTEaLfOQkCDphLoFtmtvmQX45g18RSa/FzWASUYUBjm77qC0fPNY8pFlU/m4ICtu8ANt6PJNX2gIa7UyaSSaa8Dih1UFpkTJDledAxiFjvkaMK+cNnNLurLcwuXQmf5HM/hlwSKFbeTIeD5QU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684897; c=relaxed/simple;
	bh=ukGayRdj0enmx+UFFXdsd/JY5w6/uVfZf8veEDx+3mU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OCH+pZChj0MD06itxHSgNDmLg+hOxY5LvEkms90tE7ctrn42rZpyBP6M78p559B0kRCoNI9gStZ42ZP/j6J9P8etGqKGp309pksnSKkLTrbOLVqQtTHP80AxRkrc/cJn+A8LpOCPrfYOM4zfZuUDwneU9K179RMx8bi3O2EniDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nexKXbhB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nexKXbhB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 757D7C4CEEA;
	Mon, 23 Jun 2025 13:21:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684896;
	bh=ukGayRdj0enmx+UFFXdsd/JY5w6/uVfZf8veEDx+3mU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nexKXbhBOMGw5ONCczOqkeTrNJ47oHjV0x+wMIe4dtowkDKCwjvOefnX5iEOnbvwM
	 Hhxsi5yO3Bmf2rMEnSwCocrxtsR2RSJKL6phXd8RlxBme0528Fd9k1XSIeKL1ry/A4
	 ITTUEOD8iHfUydvKzZlc6JjKyQAl+Ig7VkGqOCKM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 5.10 008/355] thunderbolt: Do not double dequeue a configuration request
Date: Mon, 23 Jun 2025 15:03:29 +0200
Message-ID: <20250623130626.990118838@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
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

From: Sergey Senozhatsky <senozhatsky@chromium.org>

commit 0f73628e9da1ee39daf5f188190cdbaee5e0c98c upstream.

Some of our devices crash in tb_cfg_request_dequeue():

 general protection fault, probably for non-canonical address 0xdead000000000122

 CPU: 6 PID: 91007 Comm: kworker/6:2 Tainted: G U W 6.6.65
 RIP: 0010:tb_cfg_request_dequeue+0x2d/0xa0
 Call Trace:
 <TASK>
 ? tb_cfg_request_dequeue+0x2d/0xa0
 tb_cfg_request_work+0x33/0x80
 worker_thread+0x386/0x8f0
 kthread+0xed/0x110
 ret_from_fork+0x38/0x50
 ret_from_fork_asm+0x1b/0x30

The circumstances are unclear, however, the theory is that
tb_cfg_request_work() can be scheduled twice for a request:
first time via frame.callback from ring_work() and second
time from tb_cfg_request().  Both times kworkers will execute
tb_cfg_request_dequeue(), which results in double list_del()
from the ctl->request_queue (the list poison deference hints
at it: 0xdead000000000122).

Do not dequeue requests that don't have TB_CFG_REQUEST_ACTIVE
bit set.

Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: stable@vger.kernel.org
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thunderbolt/ctl.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/thunderbolt/ctl.c
+++ b/drivers/thunderbolt/ctl.c
@@ -131,6 +131,11 @@ static void tb_cfg_request_dequeue(struc
 	struct tb_ctl *ctl = req->ctl;
 
 	mutex_lock(&ctl->request_queue_lock);
+	if (!test_bit(TB_CFG_REQUEST_ACTIVE, &req->flags)) {
+		mutex_unlock(&ctl->request_queue_lock);
+		return;
+	}
+
 	list_del(&req->list);
 	clear_bit(TB_CFG_REQUEST_ACTIVE, &req->flags);
 	if (test_bit(TB_CFG_REQUEST_CANCELED, &req->flags))


