Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEEB034EEE3;
	Fri, 21 Nov 2025 13:36:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732178; cv=none; b=GT1hTBWcuSgQdbIG09yxi2GuuFRlzpu2daHI9nYh4DBQYO+bEcNgYlh8qvLQbIKoftwDivGBh7UICwwLBejIVX+t3Da5dDvcLSwAbrdcGdO3DE/9P2B53UZN3jh3tovhjmC6Oj+Op0I+PiIC+p92i0dtP2PBVwCegWbJWWx04FM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732178; c=relaxed/simple;
	bh=QOURxnPE2UN2dpHtr5VqWERprB82JQxe6R9urJl+QhM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H4QOA/+j7QgbdSAUNLdbGrHmZIKQvhFAzcSUexrlDky2FJXjTQYSc86B7xo6D/rscWjfJAx5Fd7iZ+Rm1ZcE7lEh0KcHcq2AefBlwTcxSRPrHbs564M6M4QwVUWBLmW3mx7LPVW6Uy2qXlXKrNzi+ikR6v5+XpusMfykWL0KBYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=11AAHelY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="11AAHelY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 311A6C4CEF1;
	Fri, 21 Nov 2025 13:36:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732178;
	bh=QOURxnPE2UN2dpHtr5VqWERprB82JQxe6R9urJl+QhM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=11AAHelYpUIwHlPIKjFAWWIHSOwjWh+tgKPmJILXe0rVHd47ztJr/VzJvMUJR54s7
	 aAw5tKjr4trUfnhXOaM221McZNVM48gfMXoYBfYNTMQ3n9AYy/RambM5MktQ8Cl6LN
	 WdMoYNpzEs1a3lKlw4MMCAn4pgo7S86jMq3oj49U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wonkon Kim <wkon.kim@samsung.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 023/529] scsi: ufs: core: Initialize value of an attribute returned by uic cmd
Date: Fri, 21 Nov 2025 14:05:22 +0100
Message-ID: <20251121130231.826084680@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

From: Wonkon Kim <wkon.kim@samsung.com>

[ Upstream commit 6fe4c679dde3075cb481beb3945269bb2ef8b19a ]

If ufshcd_send_cmd() fails, *mib_val may have a garbage value. It can
get an unintended value of an attribute.

Make ufshcd_dme_get_attr() always initialize *mib_val.

Fixes: 12b4fdb4f6bc ("[SCSI] ufs: add dme configuration primitives")
Signed-off-by: Wonkon Kim <wkon.kim@samsung.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Link: https://patch.msgid.link/20251020061539.28661-2-wkon.kim@samsung.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/core/ufshcd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 7dcdaac31546b..2080b251580c8 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -4176,8 +4176,8 @@ int ufshcd_dme_get_attr(struct ufs_hba *hba, u32 attr_sel,
 			get, UIC_GET_ATTR_ID(attr_sel),
 			UFS_UIC_COMMAND_RETRIES - retries);
 
-	if (mib_val && !ret)
-		*mib_val = uic_cmd.argument3;
+	if (mib_val)
+		*mib_val = ret == 0 ? uic_cmd.argument3 : 0;
 
 	if (peer && (hba->quirks & UFSHCD_QUIRK_DME_PEER_ACCESS_AUTO_MODE)
 	    && pwr_mode_change)
-- 
2.51.0



