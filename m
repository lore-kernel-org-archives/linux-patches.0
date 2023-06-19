Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E08AF10974
	for <patches@lists.linux.dev>; Mon, 19 Jun 2023 10:33:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67CAAC433C8;
	Mon, 19 Jun 2023 10:33:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687170782;
	bh=e6FiqSpPzrIqBr4ifo3Fy2T912kqqu+DYRXAE8MmA+A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QEho+q9SgTJZCtSGavH9yvh7QaMnAn1/AZKzr8Cq4yTjyVJZWFVMeGQqv8hE/n9Cd
	 VzrSTHW6xil8uun5+HLWq92GJPUaMpR4Prlp7+SJOrw7sJOXS4Nl3tOhcgPx7k3xXE
	 88QBSJ45uVIc/g6QlJ58SUAVFUgYjWqptxom/2Ug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yue Hu <huyue2@coolpad.com>,
	Sandeep Dhavale <dhavale@google.com>,
	Chao Yu <chao@kernel.org>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 033/187] erofs: use HIPRI by default if per-cpu kthreads are enabled
Date: Mon, 19 Jun 2023 12:27:31 +0200
Message-ID: <20230619102159.249464371@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230619102157.579823843@linuxfoundation.org>
References: <20230619102157.579823843@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Gao Xiang <hsiangkao@linux.alibaba.com>

[ Upstream commit cf7f2732b4b83026842832e7e4e04bf862108ac2 ]

As Sandeep shown [1], high priority RT per-cpu kthreads are
typically helpful for Android scenarios to minimize the scheduling
latencies.

Switch EROFS_FS_PCPU_KTHREAD_HIPRI on by default if
EROFS_FS_PCPU_KTHREAD is on since it's the typical use cases for
EROFS_FS_PCPU_KTHREAD.

Also clean up unneeded sched_set_normal().

[1] https://lore.kernel.org/r/CAB=BE-SBtO6vcoyLNA9F-9VaN5R0t3o_Zn+FW8GbO6wyUqFneQ@mail.gmail.com

Reviewed-by: Yue Hu <huyue2@coolpad.com>
Reviewed-by: Sandeep Dhavale <dhavale@google.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Link: https://lore.kernel.org/r/20230522092141.124290-1-hsiangkao@linux.alibaba.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/erofs/Kconfig | 1 +
 fs/erofs/zdata.c | 2 --
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/erofs/Kconfig b/fs/erofs/Kconfig
index 704fb59577e09..f259d92c97207 100644
--- a/fs/erofs/Kconfig
+++ b/fs/erofs/Kconfig
@@ -121,6 +121,7 @@ config EROFS_FS_PCPU_KTHREAD
 config EROFS_FS_PCPU_KTHREAD_HIPRI
 	bool "EROFS high priority per-CPU kthread workers"
 	depends on EROFS_FS_ZIP && EROFS_FS_PCPU_KTHREAD
+	default y
 	help
 	  This permits EROFS to configure per-CPU kthread workers to run
 	  at higher priority.
diff --git a/fs/erofs/zdata.c b/fs/erofs/zdata.c
index f1708c77a9912..d7add72a09437 100644
--- a/fs/erofs/zdata.c
+++ b/fs/erofs/zdata.c
@@ -369,8 +369,6 @@ static struct kthread_worker *erofs_init_percpu_worker(int cpu)
 		return worker;
 	if (IS_ENABLED(CONFIG_EROFS_FS_PCPU_KTHREAD_HIPRI))
 		sched_set_fifo_low(worker->task);
-	else
-		sched_set_normal(worker->task, 0);
 	return worker;
 }
 
-- 
2.39.2



