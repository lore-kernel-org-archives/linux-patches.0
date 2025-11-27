Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E944730EF64;
	Thu, 27 Nov 2025 14:54:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255267; cv=none; b=SdY3Cd4IYrf59DAFfUMIe/tofAE58Sd3CQsMAHw7AbFk/4uFydGWfbCCAVqJEOvxvprngMZnGJx50IKTMTb144LOSseM5bB6q5lVBPpgQsU5ikmBLcwh0pCYYJ5VD32hrMjUB+ck7XYYWOIZwJurk6FfQR4UHb1umuLaEJVmmtI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255267; c=relaxed/simple;
	bh=mgtgP5OuwcvEWYKpvsbo7b3CuIHDobxlC7ngcipLJRc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JiEk84276SDD9ykJwoh7z2CdPqBHnSuWT5aCDEducVlNPlG9mFMOoP5RI+hGG+/6TaUfVRFy4KvgqKf678ok+nehH3NnQ13y9ECZY5VY71cYw6gHT+Wb6g3ZUQ9TLYbs3ejZ7ZR+jDwiCodjI0ovSNYehrWS4fTsWCx6+HhFw0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r25R6b0M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r25R6b0M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 722A9C4CEF8;
	Thu, 27 Nov 2025 14:54:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255266;
	bh=mgtgP5OuwcvEWYKpvsbo7b3CuIHDobxlC7ngcipLJRc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r25R6b0MdjPzK3IR+6pmKZlOPoY6MG7tn2loz3cp7RqgdgV5GQ1zBTyA5bxGJmVIq
	 Hnm3Nr+SJ7V8V/TOyxNc264QLb0qMd+t+MyTCyxZ8/nXOsnzQmXw73h+cV2hLghGLl
	 ZRCwdp7lCFB75b/ou+vKVpo2wrQNe+Uf4dUjqa3w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Allen Pais <apais@linux.microsoft.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.12 032/112] scsi: target: tcm_loop: Fix segfault in tcm_loop_tpg_address_show()
Date: Thu, 27 Nov 2025 15:45:34 +0100
Message-ID: <20251127144034.014677721@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144032.705323598@linuxfoundation.org>
References: <20251127144032.705323598@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -893,6 +893,9 @@ static ssize_t tcm_loop_tpg_address_show
 			struct tcm_loop_tpg, tl_se_tpg);
 	struct tcm_loop_hba *tl_hba = tl_tpg->tl_hba;
 
+	if (!tl_hba->sh)
+		return -ENODEV;
+
 	return snprintf(page, PAGE_SIZE, "%d:0:%d\n",
 			tl_hba->sh->host_no, tl_tpg->tl_tpgt);
 }


