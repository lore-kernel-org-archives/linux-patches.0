Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DEBD372ECE;
	Sat, 12 Sep 2026 07:49:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789199396; cv=none; b=YTp4XzRVTYHOqLWnpfVgGYs/cCdKZqj6Ryr20jwIjBrPyfcP8carpNqWqTfLc8DT2Ltj8ctnRoRlRgFJ6aLrwejrbDObutpoOXyRvVHK7JW4K6pupeVZ+IwQn4lIfYVj10N6uxKdJPeVXJOVMWYpmnjg4Q3Issd5dADlhW9pUdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789199396; c=relaxed/simple;
	bh=wz33Ppz/cONX/k4yvnRzEV4iYwlhtXCQ3Gr7En4XxRw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=exfbbG08mbRIJSNFSGqitbAoa7pUOG4mWHK8ADT1qB8O0wtKw1C2BnqOySiqEXQ6pR+/VY1kIuMuCVSgyWF/E+DR7yYAuyhjOO6sRuXie96AuRCxo8+mIp7VzHW2SrGKj6KjoCA01Ugw497sxNXwDFMwG7bcjKIyDDIjDTeaE/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IqsPdRDb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IqsPdRDb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDDE71F000FF;
	Sat, 12 Sep 2026 07:49:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789199395;
	bh=7G9QeBlSnjzMOd52hnUuNgiiVfGeWYyDinta+//05Us=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IqsPdRDbLOxEomGyjJVRbeiGo+VeSVpFDxsBsTAOk/WRUVk/L/NYpi5UfgegDQhYV
	 AEhX4yQNoluaGQ6HJ9oGgvFwZGR1dQo8mLIZxp+MafWm60n6GCOlnyWPf3ColIdjwJ
	 QRanwydzc0NSS7ozzyy4Y91xHLBmCnmfhAWSqCWk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bart Van Assche <bvanassche@acm.org>,
	Leon Romanovsky <leonro@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0575/1815] RDMA/srpt: Pass the mapped task attribute to target_init_cmd()
Date: Sat, 12 Sep 2026 08:38:45 +0200
Message-ID: <20260912065702.379795286@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 7471dfee50dbb..3ec42da1456b8 100644
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



