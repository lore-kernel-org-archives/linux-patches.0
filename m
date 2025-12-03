Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D56983161AC;
	Wed,  3 Dec 2025 15:42:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776573; cv=none; b=kQnm98+CkaIOk4nshAqwoQw/YuftbfXkA3bVMPrDMX8MRYPR1E5HKeiUSenerGxSp6SuoXuj6KuhDahW8RO0g2pgAGCQFDTHthyllpAVUGjbe7uZVYSUWaE0b94loa+XXuuVo8RmJ1pnLNLXo6KuA5PgAM/Jrz+11y6EySZofR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776573; c=relaxed/simple;
	bh=aNQQh18+RLjRP96BuAtdHnZaVlnS0aPinTU5sjhBYQ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Iz9KLCffCHEbFwqmrbU0VFrdNcsVq7FYDrmwO5ZIoi/IzeXy72BiOMQ9Jhe6nNzZQq8ypOMVKC8O6hKinvzCq9zIlwaNc33uvQJEPZJls1cUKiJQrIT1k7BPbgYOocxQiY6ioqWNig+dSTDVjkdEE2h6q4Iu3Kbcigyim0tqF9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S39rk+Tw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S39rk+Tw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F02F1C4CEF5;
	Wed,  3 Dec 2025 15:42:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764776573;
	bh=aNQQh18+RLjRP96BuAtdHnZaVlnS0aPinTU5sjhBYQ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S39rk+TwKiTtE9plkKRRi1+Jm9z7Vof0r7K5RQKd6JBoT5YwxmruyVcWa9Dez+kgW
	 d3A20rL/UUZUpNt8HmjHLV8sJg+ii1RpLcxdED1sy7T/1LWRpwhb5ID3QqsoKDAyZf
	 USTLgFpIDWS9hHOSJhbhYxzHaaF/+hdKt7ibKGC0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Allen Pais <apais@linux.microsoft.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.10 223/300] scsi: target: tcm_loop: Fix segfault in tcm_loop_tpg_address_show()
Date: Wed,  3 Dec 2025 16:27:07 +0100
Message-ID: <20251203152408.885107512@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152400.447697997@linuxfoundation.org>
References: <20251203152400.447697997@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


