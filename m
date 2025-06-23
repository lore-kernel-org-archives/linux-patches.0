Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A947E24679C;
	Mon, 23 Jun 2025 13:32:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685531; cv=none; b=AaI3tJGMLSZTbO0jK2xlW5WfNDWuL78/+1CyB+Mg86sQV5D4HJDCTMqEFuYVQsITKbFKjQptNWv1Lnm1WJCO7tE7bKkJaf48DVP9bGFldCI6DQlI9LUcVZHNj0pGnVr46++wylaAoG1jhwodMy6OF/NAAOfNbfyHzpDQ84Ipens=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685531; c=relaxed/simple;
	bh=JgQopz/sQEiFi3fAA9jVff9gsmG4iQw+KwzjKFFt1bI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jPNIQV9NNOBpgWcFxTptcT6X9MGHROLPn9JilpF9XelfkCNr9RuylBesgLqTx2pyMLqrMwSe0Abb3fw45cH30ZYMz5jGYEZhzAO/yON09r3aOVbC8cGMn8p8FJO+k3MYK7bhH+QFxpvb3FOS8pvp4iDcOCfeu7CCtAgdrHje/9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UVIm4eN7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UVIm4eN7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C67CC4CEEA;
	Mon, 23 Jun 2025 13:32:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685531;
	bh=JgQopz/sQEiFi3fAA9jVff9gsmG4iQw+KwzjKFFt1bI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UVIm4eN7+/V9iJ/xFR0LuFsEWDrKz5NtEhAbM7XmEN88wuG2CaipvC8+W/6OAVc6g
	 rIcT0XO2jX7UErOBvIeRYFbIoSoHaZJH1bhdwq1o6ObJNleIuC0nyyL2GOSn/eJMbu
	 UV9Q+vPEpy43J7QkA4vspc1tdMw0asL+PGf0PX/s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 6.1 013/508] thunderbolt: Do not double dequeue a configuration request
Date: Mon, 23 Jun 2025 15:00:58 +0200
Message-ID: <20250623130645.579559944@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


