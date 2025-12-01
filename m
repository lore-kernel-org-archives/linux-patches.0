Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 937F426158B;
	Mon,  1 Dec 2025 11:32:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764588763; cv=none; b=AIWYcpDW2Lo97tfllzlXiFbuIcvHjKF2XmYEqhJws0F33dWcSrl0w6Jml/ueUyaV1l94spBziGiC8Va/OxR8yR1YfvDTSCJ9w925yRUkTwN20uBqJ23C86hnO0YV/b0tpalSQtPnkXXHx2go5m7FxiQ6dBx1uuaKoict1dHQSQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764588763; c=relaxed/simple;
	bh=Vo2pBz/+lg0hsTZLBeTU73VmqGLMEjMV8ME65Rsp3Ck=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S8tsrpigfzmEPHhL1+mhEPa08lqNhmF0rBK6UHCGawiPt8U0XBEbPlMgkJ3OoEYD4q0Qx4Ik9k8bJVOw+WXUzYGmnmYQpUxK1/KlqOar1lqvn8cAdPUxDxsJHsI3Gg9eSCWXtSzc38a1QUtHEXg+bGlZ+KIoO4tSrmjOMJBl3LI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JBU3zj+n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JBU3zj+n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F1DBC4CEF1;
	Mon,  1 Dec 2025 11:32:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764588763;
	bh=Vo2pBz/+lg0hsTZLBeTU73VmqGLMEjMV8ME65Rsp3Ck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JBU3zj+nFUrZhZUmajOdQVGtYD08NBpJm8x9f1Nlb3IfryJm+Gn6VlZkYsSlbma1+
	 rWnEA9f+0o3y7foM9Wo1bmJA/sDlmC8cG1oa3fRJebHdMu83B5SjolUb8AREBUwoov
	 18Xkdbw/NFqKyJwc4psSJtd8EyHzQImTPbZQc5tw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Allen Pais <apais@linux.microsoft.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.4 163/187] scsi: target: tcm_loop: Fix segfault in tcm_loop_tpg_address_show()
Date: Mon,  1 Dec 2025 12:24:31 +0100
Message-ID: <20251201112247.102241125@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251201112241.242614045@linuxfoundation.org>
References: <20251201112241.242614045@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>

commit e6965188f84a7883e6a0d3448e86b0cf29b24dfc upstream.

If the allocation of tl_hba->sh fails in tcm_loop_driver_probe() and we
attempt to dereference it in tcm_loop_tpg_address_show() we will get a
segfault, see below for an example. So, check tl_hba->sh before
dereferencing it.

  Unable to allocate struct scsi_host
  BUG: kernel NULL pointer dereference, address: 0000000000000194
  #PF: supervisor read access in kernel mode
  #PF: error_code(0x0000) - not-present page
  PGD 0 P4D 0
  Oops: 0000 [#1] PREEMPT SMP NOPTI
  CPU: 1 PID: 8356 Comm: tokio-runtime-w Not tainted 6.6.104.2-4.azl3 #1
  Hardware name: Microsoft Corporation Virtual Machine/Virtual Machine, BIOS Hyper-V UEFI Release v4.1 09/28/2024
  RIP: 0010:tcm_loop_tpg_address_show+0x2e/0x50 [tcm_loop]
...
  Call Trace:
   <TASK>
   configfs_read_iter+0x12d/0x1d0 [configfs]
   vfs_read+0x1b5/0x300
   ksys_read+0x6f/0xf0
...

Cc: stable@vger.kernel.org
Fixes: 2628b352c3d4 ("tcm_loop: Show address of tpg in configfs")
Signed-off-by: Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Reviewed-by: Allen Pais <apais@linux.microsoft.com>
Link: https://patch.msgid.link/1762370746-6304-1-git-send-email-hamzamahfooz@linux.microsoft.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/target/loopback/tcm_loop.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -933,6 +933,9 @@ static ssize_t tcm_loop_tpg_address_show
 			struct tcm_loop_tpg, tl_se_tpg);
 	struct tcm_loop_hba *tl_hba = tl_tpg->tl_hba;
 
+	if (!tl_hba->sh)
+		return -ENODEV;
+
 	return snprintf(page, PAGE_SIZE, "%d:0:%d\n",
 			tl_hba->sh->host_no, tl_tpg->tl_tpgt);
 }


