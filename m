Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B952637DE8A;
	Wed, 20 May 2026 18:40:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302457; cv=none; b=sXizZDZcNqZeL3OJcSqjHT2RrzuAC/0Z6+qYbTI2BdSzye19kH+eUZpzUhG/JmTSq+NCgR0ceSQzYdVDt2k+7EHNcKww446ovS9KdiNG6YlhD2ZtraAi5F+7OhvdZ4JqI1Od1Fv8F/3La5Vfc+M24sJvFpafhVJLMQ7U0U7UWdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302457; c=relaxed/simple;
	bh=e7q0J7phOWx6/kWnBCSnfgGbqzs8qY0daLAR9oj5g9M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DqR2VLcb11GtbhyPAK8X0Ko48e60EI2blr5ZRJWulB5+9mwD0o6GRxqUCtxotrfDPLl6ubW7eiPS2hpN/kgVp0X5olJrm6Z6EbrzANjyW8YGuaLIuKWUeSNsSNPx5hnXa+3wK3Z8wN3qPzmGKE17Z3pWPA2xpt1Qp8dKpnycM5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m+wjAt08; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m+wjAt08"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A18C1F000E9;
	Wed, 20 May 2026 18:40:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302456;
	bh=S8GQsGAlYAzjmEd2UodGTz+lv3kqH8BkuwPRQGpteGs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m+wjAt08TTX7yzK1ItH3krlBNyeJOekr38DRE4XK1Pt2BTdGvBhPfFoCccQq+2kKr
	 KbT66Hwb9Njyf9dEJ0xEGGyFlAFgbhJCwG+MYw7/pV5kD4tKoPZ3Se1vh1Ulk1jYsb
	 vGZJNx6vcCjkisAjCmP/Nj2Hu3kV4QnUAkQT1PeE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Erkun <yangerkun@huawei.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 274/508] scsi: sg: Fix sysctl sg-big-buff register during sg_init()
Date: Wed, 20 May 2026 18:21:37 +0200
Message-ID: <20260520162104.581441206@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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
index 799773a879188..f958bdf09587d 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -1693,13 +1693,13 @@ init_sg(void)
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



