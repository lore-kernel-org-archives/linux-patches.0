Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA29854BD4;
	Tue, 27 Feb 2024 13:58:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042300; cv=none; b=OkBJWGvGKSW43xilgFTBaso7j/4zzCwErGgr3jEVCWuReggWfJlH0SXkhy3viCA6ZRrIxiJZ0tVWvT7H+6xkxlABh8L0pg+vdM5Ni6nii0Y0+24OwmoUef730QRIv3z5Demw1vqdBgx+zg7Qu5j3SHtB9V1+2NTcT+I6TP2i/sU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042300; c=relaxed/simple;
	bh=q1FK9u/IIxPS/MFptfJWgqqbSKrDTMJB2/IDP1vngak=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GPMWOKl1nkPaPrqZ4ghqh46422kbjrgRXLJN88rWNsAtDSqPi3uP44JaWY3HZwBJ3NRlYN6Uz/vgjU31lPoWEmNx8pwLkmIfUPnuMsK65ZkCd/yLch9IIwXlH0IZWeTCrVCqd3pH421NIescihchbz/XLH0LYCSnbmR42R0KxtM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bTkTUiM+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bTkTUiM+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38DD1C433C7;
	Tue, 27 Feb 2024 13:58:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042300;
	bh=q1FK9u/IIxPS/MFptfJWgqqbSKrDTMJB2/IDP1vngak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bTkTUiM+/NANAPjWY1k2JNSQl7awZ6zoWReEjzYE0nNBpmiW9bVgZbUajt2kYVmVQ
	 h8rrm6R+kBuCpa9X3gSKlsxYIQDu9I55Vd82cAMkL/9wKdDNC1OhY1ewga92HqzjK3
	 99l5eDNtf9QqgjmGXzHGwB/VPCL6qvsmlFIbbWHw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	LiHonggang <honggangli@163.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 220/299] RDMA/srpt: Support specifying the srpt_service_guid parameter
Date: Tue, 27 Feb 2024 14:25:31 +0100
Message-ID: <20240227131632.850534311@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
References: <20240227131625.847743063@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index c12005eab14c1..38168d8c626fe 100644
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



