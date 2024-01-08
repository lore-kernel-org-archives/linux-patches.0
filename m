Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2205F4C3BE;
	Mon,  8 Jan 2024 15:39:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UkE3iZoE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AF38C433C7;
	Mon,  8 Jan 2024 15:39:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704728352;
	bh=85SozzfJGjBbW4+7ok0etKhalcHTLVIKZrVglxc0ekM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UkE3iZoErBowxjiEG95Z1RcKdIWFQ30AgT+326F4wnK8tKX0jrsik1PP7VNPZfDKK
	 Mw5b1nTji3oEw36Gz7i28ydXaPNqjktCbKqKlV0x6ywpbksliaV1w+jurEWFwRlmHA
	 yhNe0SGYju/ZND0PKHlKymfh7eeI+OiGSes09Hnk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	henaumars <henaumars@sina.com>,
	Wen Gu <guwen@linux.alibaba.com>,
	Tony Lu <tonylu@linux.alibaba.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 049/150] net/smc: fix invalid link access in dumping SMC-R connections
Date: Mon,  8 Jan 2024 16:35:00 +0100
Message-ID: <20240108153513.503067263@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240108153511.214254205@linuxfoundation.org>
References: <20240108153511.214254205@linuxfoundation.org>
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

From: Wen Gu <guwen@linux.alibaba.com>

[ Upstream commit 9dbe086c69b8902c85cece394760ac212e9e4ccc ]

A crash was found when dumping SMC-R connections. It can be reproduced
by following steps:

- environment: two RNICs on both sides.
- run SMC-R between two sides, now a SMC_LGR_SYMMETRIC type link group
  will be created.
- set the first RNIC down on either side and link group will turn to
  SMC_LGR_ASYMMETRIC_LOCAL then.
- run 'smcss -R' and the crash will be triggered.

 BUG: kernel NULL pointer dereference, address: 0000000000000010
 #PF: supervisor read access in kernel mode
 #PF: error_code(0x0000) - not-present page
 PGD 8000000101fdd067 P4D 8000000101fdd067 PUD 10ce46067 PMD 0
 Oops: 0000 [#1] PREEMPT SMP PTI
 CPU: 3 PID: 1810 Comm: smcss Kdump: loaded Tainted: G W   E      6.7.0-rc6+ #51
 RIP: 0010:__smc_diag_dump.constprop.0+0x36e/0x620 [smc_diag]
 Call Trace:
  <TASK>
  ? __die+0x24/0x70
  ? page_fault_oops+0x66/0x150
  ? exc_page_fault+0x69/0x140
  ? asm_exc_page_fault+0x26/0x30
  ? __smc_diag_dump.constprop.0+0x36e/0x620 [smc_diag]
  smc_diag_dump_proto+0xd0/0xf0 [smc_diag]
  smc_diag_dump+0x26/0x60 [smc_diag]
  netlink_dump+0x19f/0x320
  __netlink_dump_start+0x1dc/0x300
  smc_diag_handler_dump+0x6a/0x80 [smc_diag]
  ? __pfx_smc_diag_dump+0x10/0x10 [smc_diag]
  sock_diag_rcv_msg+0x121/0x140
  ? __pfx_sock_diag_rcv_msg+0x10/0x10
  netlink_rcv_skb+0x5a/0x110
  sock_diag_rcv+0x28/0x40
  netlink_unicast+0x22a/0x330
  netlink_sendmsg+0x240/0x4a0
  __sock_sendmsg+0xb0/0xc0
  ____sys_sendmsg+0x24e/0x300
  ? copy_msghdr_from_user+0x62/0x80
  ___sys_sendmsg+0x7c/0xd0
  ? __do_fault+0x34/0x1a0
  ? do_read_fault+0x5f/0x100
  ? do_fault+0xb0/0x110
  __sys_sendmsg+0x4d/0x80
  do_syscall_64+0x45/0xf0
  entry_SYSCALL_64_after_hwframe+0x6e/0x76

When the first RNIC is set down, the lgr->lnk[0] will be cleared and an
asymmetric link will be allocated in lgr->link[SMC_LINKS_PER_LGR_MAX - 1]
by smc_llc_alloc_alt_link(). Then when we try to dump SMC-R connections
in __smc_diag_dump(), the invalid lgr->lnk[0] will be accessed, resulting
in this issue. So fix it by accessing the right link.

Fixes: f16a7dd5cf27 ("smc: netlink interface for SMC sockets")
Reported-by: henaumars <henaumars@sina.com>
Closes: https://bugzilla.openanolis.cn/show_bug.cgi?id=7616
Signed-off-by: Wen Gu <guwen@linux.alibaba.com>
Reviewed-by: Tony Lu <tonylu@linux.alibaba.com>
Link: https://lore.kernel.org/r/1703662835-53416-1-git-send-email-guwen@linux.alibaba.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/smc/smc_diag.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/smc/smc_diag.c b/net/smc/smc_diag.c
index 80ea7d954eceb..801044e7d1949 100644
--- a/net/smc/smc_diag.c
+++ b/net/smc/smc_diag.c
@@ -153,8 +153,7 @@ static int __smc_diag_dump(struct sock *sk, struct sk_buff *skb,
 			.lnk[0].link_id = link->link_id,
 		};
 
-		memcpy(linfo.lnk[0].ibname,
-		       smc->conn.lgr->lnk[0].smcibdev->ibdev->name,
+		memcpy(linfo.lnk[0].ibname, link->smcibdev->ibdev->name,
 		       sizeof(link->smcibdev->ibdev->name));
 		smc_gid_be16_convert(linfo.lnk[0].gid, link->gid);
 		smc_gid_be16_convert(linfo.lnk[0].peer_gid, link->peer_gid);
-- 
2.43.0



