Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23BE52F691F;
	Thu, 28 May 2026 20:08:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998885; cv=none; b=VkkffQH287mSn2pnMOCDX1N8I7wDfLc5wvV/MXAvlprTJW9XtlraO0VpkTmdT1y+e1SshrEqkcpQ87ItbYGV6OEd6/QrxX8/35aYBgx1D3vvy7lBOKb5XzdsY6vs/51dzZ3dNUJgjHFkaEDaPhm7u6oiyhnsuZTrErHmgiGIylo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998885; c=relaxed/simple;
	bh=8Ce3b9AJl5Jc+n9iPFPkM8eJRru+x/05VnVvxMxIWyI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TbMYS2PdZ0/7E9sM6WuVcOXOr3FMRo1YyJIDe+oBBh+c5mxZu0YMG1Xj4HNTnb22QGF78ea+JGAuFyxh8WXklyS16cPDXXORcCaSZEaRIzVta1iPgbfHNXY6Fux0hjD12t4ZBM7hayN8u2sfuf80TSu6pLqUzCD9OcT9aEPkfDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y5pmEtwi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y5pmEtwi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 813681F000E9;
	Thu, 28 May 2026 20:08:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998884;
	bh=EslgCiuI+1uh695TXnYuueOOSyqxLSaN3TsmWJmO/6Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y5pmEtwisCtt/tS7u/wGfFnjqeL8iuRBF6pHLWTogTmxDuTSrBSMCq8iLYd1PLr4U
	 vJQMavmDrxzBsyrC8WmKh0Gt6L9DAQfyeUr7sGHRprOc/H3z7Ub9WHANxlh3dSSILS
	 bSC8HwF0tI1RvboXWIfRtMIlxNzoJz7wadhjHZZU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	Mike Christie <michael.christie@oracle.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 332/461] scsi: sd: Fix return code handling in sd_spinup_disk()
Date: Thu, 28 May 2026 21:47:41 +0200
Message-ID: <20260528194656.960564474@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

From: Mike Christie <michael.christie@oracle.com>

[ Upstream commit 6ea68a8dc7d2711504d944811981a5304af7d7a9 ]

As found by smatch-ci, scsi_execute_cmd() can return negative or positve
values so we should use a int instead of unsigned int.

Fixes: b4d0c33a32c3 ("scsi: sd: Fix sshdr use in sd_spinup_disk")
Reported-by: Dan Carpenter <error27@gmail.com>
Closes: https://lore.kernel.org/linux-scsi/agFbI7E6JQwd3wGW@stanley.mountain/T/#u
Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Link: https://patch.msgid.link/20260511175317.114007-1-michael.christie@oracle.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/sd.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index aba22060fcd50..79136d943595c 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2430,8 +2430,7 @@ sd_spinup_disk(struct scsi_disk *sdkp)
 {
 	static const u8 cmd[10] = { TEST_UNIT_READY };
 	unsigned long spintime_expire = 0;
-	int spintime, sense_valid = 0;
-	unsigned int the_result;
+	int the_result, spintime, sense_valid = 0;
 	struct scsi_sense_hdr sshdr;
 	struct scsi_failure failure_defs[] = {
 		/* Do not retry Medium Not Present */
-- 
2.53.0



