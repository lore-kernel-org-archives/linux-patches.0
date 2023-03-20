Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 934521C03
	for <patches@lists.linux.dev>; Mon, 20 Mar 2023 15:09:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB5D4C4339E;
	Mon, 20 Mar 2023 15:09:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1679324978;
	bh=aiCXb7EmAnvhIwH9qron4vDgDmCOBnY/AcfdxXX/20Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G08r6mlfVCi5CDtDdHn45K/7mf7cIGIdxE3r+34y8vfQR2nGTJIvdSa8ZtN69FDbk
	 cKAU6FO+V13Fzb+1ylHzJB3h07ogBq3FZYNcHRD1z+sMTE3DU1YJZvmr2oO69kvqa9
	 S00LXO+n0R0tk9mwzB95vVuYv90C9hsJ89x0k+UU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Garry <john.g.garry@oracle.com>,
	syzbot+645a4616b87a2f10e398@syzkaller.appspotmail.com,
	Bart Van Assche <bvanassche@acm.org>,
	Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 030/198] scsi: core: Fix a procfs host directory removal regression
Date: Mon, 20 Mar 2023 15:52:48 +0100
Message-Id: <20230320145508.752897223@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145507.420176832@linuxfoundation.org>
References: <20230320145507.420176832@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit be03df3d4bfe7e8866d4aa43d62e648ffe884f5f ]

scsi_proc_hostdir_rm() decreases a reference counter and hence must only be
called once per host that is removed. This change does not require a
scsi_add_host_with_dma() change since scsi_add_host_with_dma() will return
0 (success) if scsi_proc_host_add() is called.

Fixes: fc663711b944 ("scsi: core: Remove the /proc/scsi/${proc_name} directory earlier")
Cc: John Garry <john.g.garry@oracle.com>
Reported-by: John Garry <john.g.garry@oracle.com>
Link: https://lore.kernel.org/all/ed6b8027-a9d9-1b45-be8e-df4e8c6c4605@oracle.com/
Reported-by: syzbot+645a4616b87a2f10e398@syzkaller.appspotmail.com
Link: https://lore.kernel.org/linux-scsi/000000000000890fab05f65342b6@google.com/
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Link: https://lore.kernel.org/r/20230307214428.3703498-1-bvanassche@acm.org
Tested-by: John Garry <john.g.garry@oracle.com>
Tested-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/hosts.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 85e66574ec414..45a2fd6584d16 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -341,9 +341,6 @@ static void scsi_host_dev_release(struct device *dev)
 	struct Scsi_Host *shost = dev_to_shost(dev);
 	struct device *parent = dev->parent;
 
-	/* In case scsi_remove_host() has not been called. */
-	scsi_proc_hostdir_rm(shost->hostt);
-
 	/* Wait for functions invoked through call_rcu(&scmd->rcu, ...) */
 	rcu_barrier();
 
-- 
2.39.2



