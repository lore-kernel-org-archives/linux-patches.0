Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBEA43B3BFE;
	Fri,  9 Oct 2026 14:35:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556515; cv=none; b=l1A89wefZhHN5vFPrxk01xbCugw5TzJB3nbuTGqYXSWP7zGjuFhuGJFKYKNwW3NJwjrTvmGMNBPIEiYU3zaPJWpg2YQ2M2SCJ6R4kGO7xmYzWs43bGA0JjbHszXzMFc4i40uQrE+bcW9gYYtqGiSQIme1mNykBZh7medCOdkeWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556515; c=relaxed/simple;
	bh=jp6M+RAHoe+PtUvS4qy3Zwr+kPqoYBp9M2IrFMfIXxM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kvzUP9TmV8zlWYhPg+UUc17FaXEskub/vUmzJEW/GVFAIm8cb0k7zcbYQWqurQfKCdMRultfJj4CEAzJPg9AM2OYDZl+pKv4tsAhie1zydX1TQ8bXho7VydqOiTSXioXVv+WX/E4LAuiQzqkzcrwxLbuOZHiOX0kPB3Px22lxJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bOylu8qt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bOylu8qt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 558631F000FF;
	Fri,  9 Oct 2026 14:35:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556513;
	bh=hUTnG2GANmqz51Ot3EztcKzAvxIOgYyUi4LoeTcdO/c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bOylu8qtURFSiE44O2vGBxKs/BtlAaGg6Jfc9eLj6mnxqoWyF21VMu5QQPRVkZUui
	 IS055eAyVLjm2tGopNi6EGrM1+HWMF3BcQAbZZg7KvizBJGFmV6aJuSpUyP0oVM55e
	 vBnYpnCcr1gDhtUnsuHW3bE/OxOX+Ql9wNsB7bPQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	co+77553a7fc66ac133@bugs.sh,
	Christoph Hellwig <hch@lst.de>,
	Hannes Reinecke <hare@kernel.org>,
	Weiming Shi <bestswngs@gmail.com>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 6.18 247/403] nvmet-auth: fix out-of-bounds write in nvmet_auth_challenge()
Date: Fri,  9 Oct 2026 16:10:08 +0200
Message-ID: <20261009140957.944053047@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Weiming Shi <bestswngs@gmail.com>

commit fa6778e030bed9841ddcdf96bc7018da9ac03562 upstream.

nvmet_auth_challenge() receives its output buffer as a void pointer.
sizeof(*d) therefore evaluates to one with GCC and undercounts the fixed
challenge header by 15 bytes.  A short AUTH_RECEIVE buffer can pass the
check before the challenge is copied past the end of its allocation.

Use the typed challenge pointer when calculating the response size.

  BUG: KASAN: slab-out-of-bounds in nvmet_execute_auth_receive (drivers/nvme/target/fabrics-cmd-auth.c:442 drivers/nvme/target/fabrics-cmd-auth.c:569)
  Write of size 32 by task kworker/1:1H/64
  Workqueue: nvmet_tcp_wq nvmet_tcp_io_work
  Call Trace:
  nvmet_execute_auth_receive (drivers/nvme/target/fabrics-cmd-auth.c:442 drivers/nvme/target/fabrics-cmd-auth.c:569)
  nvmet_tcp_try_recv_pdu (drivers/nvme/target/tcp.c:1119 drivers/nvme/target/tcp.c:1243)
  nvmet_tcp_io_work (drivers/nvme/target/tcp.c:1350 drivers/nvme/target/tcp.c:1382 drivers/nvme/target/tcp.c:1445)
  process_one_work (kernel/workqueue.c:3322)
  worker_thread (kernel/workqueue.c:3405 kernel/workqueue.c:3486)
  kthread (kernel/kthread.c:436)
  ret_from_fork (arch/x86/kernel/process.c:158)
  ret_from_fork_asm (arch/x86/entry/entry_64.S:245)
  The buggy address is located 16 bytes inside of
   allocated 33-byte region [ffff888000554e80, ffff888000554ea1)
  Kernel panic - not syncing: KASAN: panic_on_warn set ...

Cc: stable@vger.kernel.org
Fixes: db1312dd9548 ("nvmet: implement basic In-Band Authentication")
Reported-by: co+77553a7fc66ac133@bugs.sh
Closes: https://lore.kernel.org/all/Ah6QavQXwvshtqyUcYD1P1R7XE0ND9fB7lbV@bugs.sh/
Assisted-by: Codex:gpt-5.6
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
Signed-off-by: Weiming Shi <bestswngs@gmail.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/target/fabrics-cmd-auth.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/nvme/target/fabrics-cmd-auth.c
+++ b/drivers/nvme/target/fabrics-cmd-auth.c
@@ -427,7 +427,7 @@ static int nvmet_auth_challenge(struct n
 	struct nvmet_ctrl *ctrl = req->sq->ctrl;
 	int ret = 0;
 	int hash_len = nvme_auth_hmac_hash_len(ctrl->shash_id);
-	int data_size = sizeof(*d) + hash_len;
+	int data_size = sizeof(*data) + hash_len;
 
 	if (ctrl->dh_tfm)
 		data_size += ctrl->dh_keysize;


