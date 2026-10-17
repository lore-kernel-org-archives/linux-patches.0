Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F09E2C3255;
	Sat, 17 Oct 2026 17:04:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256650; cv=none; b=GtfnUX72a2ayHBlLEbWU1PXvUeu5s3KL69CSaqQGHk/mSnQFJI22UnNx/pmCGAnz+aMaYohgqpRt/CeMn62mk9Q3dTczsht0nzin9efIstSxWzmOdxb7mtRkDPK0cjqX3WRP0g4ttYPH52xMikBK4/sxX+NjTiLmIXXT026PQIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256650; c=relaxed/simple;
	bh=/7E8jaa3TIC4+u43xW+mxDs//NHcnt+De9AtpiCDKcM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lUtZPqR+k8juZvatICnMc56Rdn/aIcQu4vrdHKIyAmcMvmb37/YaeuFHwcsXtNfmGfo1AI1UpzeoTrczTlzGcTExJK0lQryjUuTYBLhXEAqfy3KjYf7YfTKzLF3Sxutc/BEozaLFW9SMJvWOD1/yYyG/U7LZ1QqmjoETiWt4IwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wR948qBP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wR948qBP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F5491F000C4;
	Sat, 17 Oct 2026 17:04:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256649;
	bh=bHVxmjKnerbMGyg7NJAEEgeo7I/SAl8bDY1qIrXTRx4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wR948qBPJT+B3v6qMaU9gMUPly67r41k1ADZzrl73Jt0Un3kbgkcMRGh4bjjyqgwU
	 H6T4vvqF3Rpzo90Z9BQMQISsjZEgYgi8wkpHDiFmDHEGrMFZ7BJ3hOzJNiBF/MWsqe
	 KW2+BasUlO6MSUnFDEXedW2o2Y4KJ8NBsPxPNdRE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	co+77553a7fc66ac133@bugs.sh,
	Christoph Hellwig <hch@lst.de>,
	Hannes Reinecke <hare@kernel.org>,
	Weiming Shi <bestswngs@gmail.com>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 6.6 0307/1674] nvmet-auth: fix out-of-bounds write in nvmet_auth_challenge()
Date: Sat, 17 Oct 2026 17:42:59 +0200
Message-ID: <20261017160438.998296108@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -373,7 +373,7 @@ static int nvmet_auth_challenge(struct n
 	struct nvmet_ctrl *ctrl = req->sq->ctrl;
 	int ret = 0;
 	int hash_len = nvme_auth_hmac_hash_len(ctrl->shash_id);
-	int data_size = sizeof(*d) + hash_len;
+	int data_size = sizeof(*data) + hash_len;
 
 	if (ctrl->dh_tfm)
 		data_size += ctrl->dh_keysize;


