Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BCFE36A352;
	Wed, 20 May 2026 16:56:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296180; cv=none; b=RGFzMO5t2zYwesCbdRFnMMZ7BOAplLJOFkyJ6kgGiTruU6FJB9uXD6LtcsudYslvedzSr3RLTHsehc/4QJCU+nBuAjGWnfFP4ZOAKpOCRD+FFvIHAuxeNOsphuCMcMDr3YzBDWTH7zJze2oGvE17ellRYxpxyFZUkMMPGw2GolE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296180; c=relaxed/simple;
	bh=mhJ+mMEAnhKYI1xp5g4dUBlG2wBjsUX1oNml5eC6LvU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TsMt+SCKGacx4gb9PPqDkJ1JthCN0eqyx20CiRLDxE3rWA5B35hfx9tI7pIyR+0gIYH7evzyqzxkRF5aBbwd3SdfQw3v9zUiIzWG55dvQPtxSTeR4ExHe9nERJt065KTNLNXLjyAyYPi3oifvV3+Ofyy8rTQ8ISbTqMT7L5wwlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FgEske0D; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FgEske0D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71EC71F00893;
	Wed, 20 May 2026 16:56:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296178;
	bh=rN8ZqO+cICMhxNrltruQrRYAZj1bfKxSpqHr2h+0Zeo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FgEske0DMS7dd2Lg7ca46O0rDBqud5g24E3q+MYQbm/8OsmIablpHJHKEJk2F3Yps
	 FqBDejykwjxHNBwdEtq33kdQN6BN6TSsn7cxy+dYN0O3iczu+ZtTJA+6l1bJ5xJGuz
	 S8cHVQw5HHPCyqbED4C1KffBiHxHi58W5B6G8RUs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Erkun <yangerkun@huawei.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0702/1146] scsi: sg: Fix sysctl sg-big-buff register during sg_init()
Date: Wed, 20 May 2026 18:15:52 +0200
Message-ID: <20260520162204.078096359@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
index 37bac49f30f0d..71d34186dec93 100644
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



