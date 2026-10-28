Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212877;
	b=IKU4jcI4KTdUiw42gc1cvMHbwRoNrGYhnL9KY/a396qviHAoY64epEWL5BUov33mrutP
	 kTDw9efN5uTuSSaNYV9U07TJxyXECTBDgf0G+4mgGkkAtvTclwd3q4+YuU/NTnjlsdW4a
	 KuHoZmeXHZaDJDvbrqvAZykv6y9w1Lf8fu+OIW1YA7zLRM0MBgl+TcBSjUya63DvkVOLA
	 Dfp9gMid1Ccp3aN/wtSsJQN3Qn6JGag8xevbbM6K98Clxzh93th9s4n69X7wRjeDkP198
	 yW1kVq5QUekjeznqgw0YotYtcmSIj1F/K4wgwG4T1dHp93Jxo3pVieWr8ELt+gC+NZg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212877;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eHxhisOk6hs0YUjqDGA7ACsQw5MRXHZil0mQHWqMjo4=;
	b=z9mCJ2FY97UCiqZohWskreT2LxAgUg2OTds54u5SGwd+C7ltNslP/xKXCqK4u0lkMXEQ
	 6a9TjN02zg53GZxRZd52/29WTbYmpZvUVrywY2JQMAEFv16G1e/XrKGaI4DCbmNyhTAGg
	 oj5iCdp0HqP0tZtC+js7kAuex5N57yfLwQTnhKRF97Hrd00W5yT21xSk+09+05ysJshbp
	 KTtisuv+yFbBL7fkHgbqzYMt0iTKvCPdI4aP+ooG60gbKUznSoEfNRUW8ktsWTHr66wU8
	 fnxBteaxr5Z3KZil43B31BfJo1+TRv3vra5bXlojz9ndTk3aPfrH8VRtvrqXSDlZvvQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WVtudjqn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7DB6606A31A;
	Wed, 28 Oct 2026 18:41:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WVtudjqn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44D991F01828;
	Wed, 28 Oct 2026 18:41:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212876;
	bh=eHxhisOk6hs0YUjqDGA7ACsQw5MRXHZil0mQHWqMjo4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WVtudjqnVaZb/tj3U2n+XYmZQJAhtX8icRkWF0CHZj1se/WSytZ7dVVzAXPgUCivy
	 lj7O910NunsriYEnIxWGhkUEZdu1+0zf3uG6H6OV51NCDocRa/Yetp2cui1ci8Ah0n
	 43i3sjlRiTaAWXAcVYLKIegIaSrMOc6vfWZUGOxY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	co+77553a7fc66ac133@bugs.sh,
	Christoph Hellwig <hch@lst.de>,
	Hannes Reinecke <hare@kernel.org>,
	Weiming Shi <bestswngs@gmail.com>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 6.1 0309/1887] nvmet-auth: fix out-of-bounds write in nvmet_auth_challenge()
Date: Wed, 28 Oct 2026 17:40:05 +0100
Message-ID: <20261028170506.261604018@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -359,7 +359,7 @@ static int nvmet_auth_challenge(struct n
 	struct nvmet_ctrl *ctrl = req->sq->ctrl;
 	int ret = 0;
 	int hash_len = nvme_auth_hmac_hash_len(ctrl->shash_id);
-	int data_size = sizeof(*d) + hash_len;
+	int data_size = sizeof(*data) + hash_len;
 
 	if (ctrl->dh_tfm)
 		data_size += ctrl->dh_keysize;


