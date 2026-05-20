Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5E8E348C55;
	Wed, 20 May 2026 18:17:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779301031; cv=none; b=htp2UCxz7oi6Jc5gCMg9tCW9Lb7UkpdOmy/gSJhKVLYOyKc+sRHSSci0iJkOicud7pjpjO3+rU1UwQ3GRLvVbQz41u7c6Fx/mbI0NRDevQbOH9kL1Adxy6v4fDzO7/yAAK+IrROVfru1LYrcaeO8z3ApmpVKz8e/kD/2oTjenM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779301031; c=relaxed/simple;
	bh=bMZctTxSXWkksc3UdeImwcQn451OGlaYok3mN1QF1lo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P64UVvEqW2p+eag1oPApGQXkTqWV6E1kLzAp7Ab/p9UCYq5WNKYhe4b2a/XURIdipnCImlz3AYhahBWg5Nq9+bwVdZn/IxrIVQaN3ZdhB5c9O11UMCZ+n7VGTRzC/ovmq46n2KN6xR4Dt/YFejxqYEeE8H3UNLCxB0X5T1BVPh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L5vAZSnO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L5vAZSnO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1743B1F000E9;
	Wed, 20 May 2026 18:17:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779301030;
	bh=i/yTv+J5EWAflKYZSuXOuylWqbFiZ5hNBYesDLq173U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L5vAZSnOviMHaEtqLh9MNGT3aOigKWtS7dcePWqUevmi9pqc41ZpYlKcP97kGSCiY
	 g08bWe71me0Ljf7mGIAPpKYCULDYx1EZLgxhNAJnxqApnfy6fDK32jvYLWuiNaDTKQ
	 li6NpcF/I+3qJWhLA6fKY6LDV6AOKlfF1SI1GU9Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Erkun <yangerkun@huawei.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 401/666] scsi: sg: Fix sysctl sg-big-buff register during sg_init()
Date: Wed, 20 May 2026 18:20:12 +0200
Message-ID: <20260520162119.949588246@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

From: Yang Erkun <yangerkun@huawei.com>

[ Upstream commit 3033c471aaf675254efaa0da431e95d91a104b41 ]

Commit 26d1c80fd61e ("scsi/sg: move sg-big-buff sysctl to scsi/sg.c") made
a mistake. sysctl sg-big-buff was not created because the call to
register_sg_sysctls() was placed on the wrong code path.

Fixes: 26d1c80fd61e ("scsi/sg: move sg-big-buff sysctl to scsi/sg.c")
Signed-off-by: Yang Erkun <yangerkun@huawei.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Link: https://patch.msgid.link/20260127062044.3034148-2-yangerkun@huawei.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/sg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 53dd461508494..0100a2828f803 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -1691,13 +1691,13 @@ init_sg(void)
 	sg_sysfs_valid = 1;
 	rc = scsi_register_interface(&sg_interface);
 	if (0 == rc) {
+		register_sg_sysctls();
 #ifdef CONFIG_SCSI_PROC_FS
 		sg_proc_init();
 #endif				/* CONFIG_SCSI_PROC_FS */
 		return 0;
 	}
 	class_unregister(&sg_sysfs_class);
-	register_sg_sysctls();
 err_out:
 	unregister_chrdev_region(MKDEV(SCSI_GENERIC_MAJOR, 0), SG_MAX_DEVS);
 	return rc;
-- 
2.53.0



