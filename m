Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91825236457;
	Tue, 17 Jun 2025 15:29:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174195; cv=none; b=s4j0ZlzebSK6JJNFJE6kA+qBR2xscozjw6Q5TeArsTgtyEzYwpBiBDZSfcYwjRreQnkZZvzYLW+6X09M0g5zhhH4HRDw4tYH+UYX9ZRHI2uLKEJSDizhcDa/TiEoX5fCieg2YF5wMLMtZs55U0Wpg9php5rEZhQtxUAzKG8x3Ec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174195; c=relaxed/simple;
	bh=Qk4RN92WOaPMlGQbi9ghAyT9B/w16OlL/pq8oWHLEnY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XKMSDAVFFdcjNLzTRpqMT/ORuO1YZX8Lw5/xKiNxd9WxLGhCPaasjl3HPM8Cu+63b7I06xP+JlxVORhD3FLA+CqVtaazTuLAu5tivD1tIPO/Hvwj5nx8XM4JKyaRW1/GSPLF2zB4lIZxcjknVdChxNynyv9L9fkj1LLpuyolebM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=efgExZ2C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="efgExZ2C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C17E1C4CEF0;
	Tue, 17 Jun 2025 15:29:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750174195;
	bh=Qk4RN92WOaPMlGQbi9ghAyT9B/w16OlL/pq8oWHLEnY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=efgExZ2Crgtmdqqtd1Idpo5XaTmt8EfKYYStP6GLXnGn4+RkrsbgPk7Z5IIFw40L/
	 qfYk7c70vFEtnE+xX+mlS2IcLNeYb08buqZedefN5YIf5Xr8zlrJ+6n43DvPpbsrJz
	 QH2eG4vQ0N9elUtNTjIiAbR+sgtq6ttwmm5j8QVU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 6.6 014/356] thunderbolt: Do not double dequeue a configuration request
Date: Tue, 17 Jun 2025 17:22:09 +0200
Message-ID: <20250617152338.808591252@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -143,6 +143,11 @@ static void tb_cfg_request_dequeue(struc
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


