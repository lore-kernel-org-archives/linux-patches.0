Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B18B9246BCD;
	Sat, 12 Sep 2026 10:14:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789208083; cv=none; b=T+cwSSFCigkvjF4WuzE3+GDHVFEaybAqsfqI9DaFHJGxTz8tV3rdsqMsupDCgrTZwW+dpieR+VQfuwsHbugoDJU/TonLB46PRwj7Yc5m5M66/QhGIYYSsuoETDrlMcozCKzar5DTbd8fdoEdnWRg17gD88iAD6poHo8Hcn4r1QE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789208083; c=relaxed/simple;
	bh=/l05BasmXCj0MsKtP2ELy7GwZ+74oKrarkqIcnodna0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WselzQs1xRWIbVQs5YGhsitsd+r1leDDDccCiWunc19NNrJubPwnInDvW7AYmq2+7Yumg1IdKR5POOLWUyAa5zFkj+BYZIvBO2i0PTnYeKx9xDtSIGShC5xI8SDz3ZdCHewRXUd4NWKZWnY+FmnbfkhqiNI220X3hpOAIHiCWIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L+FoWsiS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L+FoWsiS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51FD21F000FF;
	Sat, 12 Sep 2026 10:14:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789208082;
	bh=JaxVRLjz0F2MYaMfTOZ3BR6o0wd3yWHL5MYMMXtdc0c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L+FoWsiSG8VwnfQs07VOaA2L5yHOtlWWBD7T3r60dPxVSwLusDTkncKktGrC8tiuo
	 lits1VWoIXWRLJAbL2FAiaGFwRIZA6FoqtOjCjgDuxbJ+7/t3D3l8SDrShXI6ML6eL
	 Hv0ao0/v+04H8vhfnbCPtValMmBBw3wI6h3LMBcg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bart Van Assche <bvanassche@acm.org>,
	Leon Romanovsky <leonro@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0508/1518] RDMA/srpt: Pass the mapped task attribute to target_init_cmd()
Date: Sat, 12 Sep 2026 08:44:37 +0200
Message-ID: <20260912065634.937573087@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Leon Romanovsky <leonro@nvidia.com>

[ Upstream commit ef63cc441703412628a517dda354f3e51fe2dc92 ]

srpt_handle_cmd() maps the initiator-supplied srp_cmd->task_attr into
cmd->sam_task_attr, but then hands a hardcoded TCM_SIMPLE_TAG to
target_init_cmd().

Pass the already mapped cmd->sam_task_attr instead, so target core sees the
attribute the initiator requested.

Fixes: 9474b043132f ("ib_srpt: Convert I/O path to target_submit_cmd + drop legacy ioctx->kref")
Link: https://patch.msgid.link/20260721-b4-scsi-ordering-violation-due-to-hardc-v1-1-07205aab71bb@nvidia.com
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 81efda7840aab..212d4c7662c8a 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -1603,7 +1603,7 @@ static void srpt_handle_cmd(struct srpt_rdma_ch *ch,
 
 	rc = target_init_cmd(cmd, ch->sess, &send_ioctx->sense_data[0],
 			     scsilun_to_int(&srp_cmd->lun), data_len,
-			     TCM_SIMPLE_TAG, dir, TARGET_SCF_ACK_KREF);
+			     cmd->sam_task_attr, dir, TARGET_SCF_ACK_KREF);
 	if (rc != 0) {
 		pr_debug("target_submit_cmd() returned %d for tag %#llx\n", rc,
 			 srp_cmd->tag);
-- 
2.53.0



