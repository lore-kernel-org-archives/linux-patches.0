Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 536281C03
	for <patches@lists.linux.dev>; Mon, 20 Mar 2023 15:00:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9944C4339B;
	Mon, 20 Mar 2023 15:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1679324415;
	bh=h1sONQgw9qZOJu5se/PZZGysohtwrtzMudcWJk/kSmo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K0irG45P/Nr+sfCPVxcUr+t886SIvzppvF9fryb2FSNfMlPheDEqUQMOFQnj+sZkI
	 u+qaTQY6YLyzZcxcM+rSkTTDZOtP9wvw1XPh6jWTEhnKoVWFF1pMsPP0zwHftpHwJh
	 WKZAI8ks9TvwPWIvf4rppC6sdR60h5GzCMR6/7YM=
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
Subject: [PATCH 5.4 16/60] scsi: core: Fix a procfs host directory removal regression
Date: Mon, 20 Mar 2023 15:54:25 +0100
Message-Id: <20230320145431.569660402@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145430.861072439@linuxfoundation.org>
References: <20230320145430.861072439@linuxfoundation.org>
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
index d3a63961b98a9..b97e046c6a6e1 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -319,9 +319,6 @@ static void scsi_host_dev_release(struct device *dev)
 	struct Scsi_Host *shost = dev_to_shost(dev);
 	struct device *parent = dev->parent;
 
-	/* In case scsi_remove_host() has not been called. */
-	scsi_proc_hostdir_rm(shost->hostt);
-
 	/* Wait for functions invoked through call_rcu(&scmd->rcu, ...) */
 	rcu_barrier();
 
-- 
2.39.2



