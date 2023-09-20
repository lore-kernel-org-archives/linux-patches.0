Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 976C72AB21
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 11:58:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D755C433CB;
	Wed, 20 Sep 2023 11:58:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695211084;
	bh=motg3+a2ViGENVufdgYaLX/7RJleQkuPT+BAliHTxbk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=05rSNNhjQlLsaGgDBCpMxv9AdHSjCVrmqTQc7tP5xGxNjslL14C5yDcXlbctwM3zO
	 XkSvzan4ViIHcAQm/+KMza9eYROK68y2Qb2KZFUXvvyVvYHVy38aDWOewnQio1IKql
	 NG3klnmkruafzT8fTDi3zORtVVmMbpmtoQ7iHBu8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Disseldorp <ddiss@suse.de>,
	Mike Christie <michael.christie@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 102/139] scsi: target: core: Fix target_cmd_counter leak
Date: Wed, 20 Sep 2023 13:30:36 +0200
Message-ID: <20230920112839.372867890@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112835.549467415@linuxfoundation.org>
References: <20230920112835.549467415@linuxfoundation.org>
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

From: David Disseldorp <ddiss@suse.de>

[ Upstream commit d14e3e553e05cb763964c991fe6acb0a6a1c6f9c ]

The target_cmd_counter struct allocated via target_alloc_cmd_counter() is
never freed, resulting in leaks across various transport types, e.g.:

 unreferenced object 0xffff88801f920120 (size 96):
  comm "sh", pid 102, jiffies 4294892535 (age 713.412s)
  hex dump (first 32 bytes):
    07 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 38 01 92 1f 80 88 ff ff  ........8.......
  backtrace:
    [<00000000e58a6252>] kmalloc_trace+0x11/0x20
    [<0000000043af4b2f>] target_alloc_cmd_counter+0x17/0x90 [target_core_mod]
    [<000000007da2dfa7>] target_setup_session+0x2d/0x140 [target_core_mod]
    [<0000000068feef86>] tcm_loop_tpg_nexus_store+0x19b/0x350 [tcm_loop]
    [<000000006a80e021>] configfs_write_iter+0xb1/0x120
    [<00000000e9f4d860>] vfs_write+0x2e4/0x3c0
    [<000000008143433b>] ksys_write+0x80/0xb0
    [<00000000a7df29b2>] do_syscall_64+0x42/0x90
    [<0000000053f45fb8>] entry_SYSCALL_64_after_hwframe+0x6e/0xd8

Free the structure alongside the corresponding iscsit_conn / se_sess
parent.

Signed-off-by: David Disseldorp <ddiss@suse.de>
Link: https://lore.kernel.org/r/20230831183459.6938-1-ddiss@suse.de
Fixes: becd9be6069e ("scsi: target: Move sess cmd counter to new struct")
Reviewed-by: Mike Christie <michael.christie@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/target/target_core_transport.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 687adc9e086ca..0686882bcbda3 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -264,6 +264,7 @@ void target_free_cmd_counter(struct target_cmd_counter *cmd_cnt)
 		percpu_ref_put(&cmd_cnt->refcnt);
 
 	percpu_ref_exit(&cmd_cnt->refcnt);
+	kfree(cmd_cnt);
 }
 EXPORT_SYMBOL_GPL(target_free_cmd_counter);
 
-- 
2.40.1



