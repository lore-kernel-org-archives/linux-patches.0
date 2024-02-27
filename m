Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7608D140391;
	Tue, 27 Feb 2024 14:30:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709044200; cv=none; b=BlOw47ibHcjN5TOzdlxEgxy+3rjSWKCP7MscIM54sL8BB7QJx414OXjoJjAPTrjCpmBB0coCMR8bfRaBImIRriwTp80ZgyOozEEviL608GfdpbohkbgAwE/lf5kZJ2xl2nYP7zNakNbnr9AOW6x1B05nC/1Xn6Ba5ieByYJZFF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709044200; c=relaxed/simple;
	bh=OEXb8fFdY/QJqL4bdEDEi6a3QJYUfD5tJg1QF9NkXMY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PlGoKD17XwZAK2jZH1ss3f1+ZyHuzwxBuuB9FpnW2ShOtKx9jZlhFPYFDWzp0ntdGf4DHbaOSQsEwGZj/IokrwvbcgWop3XXjhP74eDH+wMKiA2OJSd+U3K4LJ6kDgexINylv91JvvnzTcsjxH/tur/hH2XvUjAMLSjkcnIC6cU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QePZ8uUQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QePZ8uUQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0289DC433F1;
	Tue, 27 Feb 2024 14:29:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709044200;
	bh=OEXb8fFdY/QJqL4bdEDEi6a3QJYUfD5tJg1QF9NkXMY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QePZ8uUQiyAYjUmuLMV+kLIo5xTtNrwqA4mOICXnVVuxGe+W4Bnh9NR2RlMULyXir
	 GJnFoHh8Sq4GSUyry0262zVttMNefCcfrrL6KD68SBE10kdtUikle3uyctU8El9yzw
	 PkCfCKlITAyuKyENqM8Tz5bCFNkAaXf9OAybQpTI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	LiHonggang <honggangli@163.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 098/122] RDMA/srpt: Support specifying the srpt_service_guid parameter
Date: Tue, 27 Feb 2024 14:27:39 +0100
Message-ID: <20240227131601.909590303@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131558.694096204@linuxfoundation.org>
References: <20240227131558.694096204@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit fdfa083549de5d50ebf7f6811f33757781e838c0 ]

Make loading ib_srpt with this parameter set work. The current behavior is
that setting that parameter while loading the ib_srpt kernel module
triggers the following kernel crash:

BUG: kernel NULL pointer dereference, address: 0000000000000000
Call Trace:
 <TASK>
 parse_one+0x18c/0x1d0
 parse_args+0xe1/0x230
 load_module+0x8de/0xa60
 init_module_from_file+0x8b/0xd0
 idempotent_init_module+0x181/0x240
 __x64_sys_finit_module+0x5a/0xb0
 do_syscall_64+0x5f/0xe0
 entry_SYSCALL_64_after_hwframe+0x6e/0x76

Cc: LiHonggang <honggangli@163.com>
Reported-by: LiHonggang <honggangli@163.com>
Fixes: a42d985bd5b2 ("ib_srpt: Initial SRP Target merge for v3.3-rc1")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Link: https://lore.kernel.org/r/20240205004207.17031-1-bvanassche@acm.org
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 983f59c87b79f..80e99e9e97172 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -79,12 +79,16 @@ module_param(srpt_srq_size, int, 0444);
 MODULE_PARM_DESC(srpt_srq_size,
 		 "Shared receive queue (SRQ) size.");
 
+static int srpt_set_u64_x(const char *buffer, const struct kernel_param *kp)
+{
+	return kstrtou64(buffer, 16, (u64 *)kp->arg);
+}
 static int srpt_get_u64_x(char *buffer, const struct kernel_param *kp)
 {
 	return sprintf(buffer, "0x%016llx\n", *(u64 *)kp->arg);
 }
-module_param_call(srpt_service_guid, NULL, srpt_get_u64_x, &srpt_service_guid,
-		  0444);
+module_param_call(srpt_service_guid, srpt_set_u64_x, srpt_get_u64_x,
+		  &srpt_service_guid, 0444);
 MODULE_PARM_DESC(srpt_service_guid,
 		 "Using this value for ioc_guid, id_ext, and cm_listen_id instead of using the node_guid of the first HCA.");
 
-- 
2.43.0



