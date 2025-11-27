Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ECEB296BBC;
	Thu, 27 Nov 2025 14:59:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255595; cv=none; b=PZvxrk81kpX8knhGhoeMx4GBnB+o/9SRA2EpD27l4w7yGZOWTacBH+6ox89cqhK2JWmhpQFcnA3S7N9sueYmDUGB8gL7KR3bI37535wCssMMtfwFJeUCHUYQOOGNAUOh0uoK6zqZZvSYtv7zJfOkataazvR5K/xHGUqddU5+El8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255595; c=relaxed/simple;
	bh=NkInSwz9HsFDv+6GzOCufS1QQS/S/5VKsh1AFIdAAYo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CbjNGNdPHuBXZviYdud+Ef4389EbFBZleWFtlRik/7vQ30v1gFjehL++Q4yMhxrtmsYKAiirqXmYTZ/J+z7e5m97b7jQh9E+JMrN7AB74MeDNS1yqVbSG9N1YnFvNPBYljtmejfyBbYbNiOFApLNT+qjK/KwV9rrO3mk+UeymR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qD8aYasY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qD8aYasY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EEF0C4CEF8;
	Thu, 27 Nov 2025 14:59:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255595;
	bh=NkInSwz9HsFDv+6GzOCufS1QQS/S/5VKsh1AFIdAAYo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qD8aYasY8QCSbzBiVJab3r9OHaz6MsshmEJgkDFSgp3uObgIe57CS9QTv3solQRjw
	 HqZm1/zXUk6zyvGYSuoRpE99ARuL4Vr3PYjxlt5iTim3/Xr7RRBo9/ydLeggv8Aqeu
	 BnN3u7OmMS3+t5OgfHMGxxmAYkNXvBG9Q5js2QAg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Allen Pais <apais@linux.microsoft.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.17 047/175] scsi: target: tcm_loop: Fix segfault in tcm_loop_tpg_address_show()
Date: Thu, 27 Nov 2025 15:45:00 +0100
Message-ID: <20251127144044.684439640@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144042.945669935@linuxfoundation.org>
References: <20251127144042.945669935@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
@@ -894,6 +894,9 @@ static ssize_t tcm_loop_tpg_address_show
 			struct tcm_loop_tpg, tl_se_tpg);
 	struct tcm_loop_hba *tl_hba = tl_tpg->tl_hba;
 
+	if (!tl_hba->sh)
+		return -ENODEV;
+
 	return snprintf(page, PAGE_SIZE, "%d:0:%d\n",
 			tl_hba->sh->host_no, tl_tpg->tl_tpgt);
 }


