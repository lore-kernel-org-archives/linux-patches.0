Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5166143C6E;
	Sun,  1 Sep 2024 16:24:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725207876; cv=none; b=VCSOhMgoDqz3LXWF8u9c/2XY1YEM9IBhF3QMglGuSP0iSJnLVPCserorcLw7U52vPbpKpmsqExYW+fbmWcMD9tpZ7D3QlsKTN5621TzsyF7FRGOPLzzo1K7K81ZFbgJDFGEVSRocQc6vLxqaFvn6CRBRipGW77ZFZn/yrMpXloc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725207876; c=relaxed/simple;
	bh=3PGWYWMq16rvRyC6kQGbDRr8bkDighmFhhIdGhtokhI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sNvRNdlqB6wBG/2538qcvWKbht9E5mzXY7i5kVOyxMuKzdwBUPmkQlULi+QHmr/6cSS51cM5pZ+3zvEDq7JOS/O8p9XhtHp67OuXxQWWlpPdXcFmV7LxHB82s7ZDvtdK2RkqxupP5x9NHqYDmva4T8Uxd0JY0OF/TpFmpF42ds8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TQLPWIUh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TQLPWIUh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A5D0C4CEC3;
	Sun,  1 Sep 2024 16:24:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725207875;
	bh=3PGWYWMq16rvRyC6kQGbDRr8bkDighmFhhIdGhtokhI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TQLPWIUh9+4rmRG+ScAV65p4l0De95lg5FtDtsdusQ63lgqT6XP8eSmTKRq7DfZwo
	 VCplU8Jm+QLb+woHls+8R4tKS6kRx0Zo2LwaLe1UROS+hyB/xo9w7Bn3G4nT4b+J08
	 zjF1begS7tab5Y2q+iOLBI81n1CBqvgbytKtR2kM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Gordon <m.gordon.zelenoborsky@gmail.com>,
	Ben Hutchings <benh@debian.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 96/98] scsi: aacraid: Fix double-free on probe failure
Date: Sun,  1 Sep 2024 18:17:06 +0200
Message-ID: <20240901160807.319016392@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160803.673617007@linuxfoundation.org>
References: <20240901160803.673617007@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Hutchings <benh@debian.org>

[ Upstream commit 919ddf8336f0b84c0453bac583808c9f165a85c2 ]

aac_probe_one() calls hardware-specific init functions through the
aac_driver_ident::init pointer, all of which eventually call down to
aac_init_adapter().

If aac_init_adapter() fails after allocating memory for aac_dev::queues,
it frees the memory but does not clear that member.

After the hardware-specific init function returns an error,
aac_probe_one() goes down an error path that frees the memory pointed to
by aac_dev::queues, resulting.in a double-free.

Reported-by: Michael Gordon <m.gordon.zelenoborsky@gmail.com>
Link: https://bugs.debian.org/1075855
Fixes: 8e0c5ebde82b ("[SCSI] aacraid: Newer adapter communication iterface support")
Signed-off-by: Ben Hutchings <benh@debian.org>
Link: https://lore.kernel.org/r/ZsZvfqlQMveoL5KQ@decadent.org.uk
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/aacraid/comminit.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/aacraid/comminit.c b/drivers/scsi/aacraid/comminit.c
index 0dc7b5a4fea25..0378fd3eb0392 100644
--- a/drivers/scsi/aacraid/comminit.c
+++ b/drivers/scsi/aacraid/comminit.c
@@ -652,6 +652,7 @@ struct aac_dev *aac_init_adapter(struct aac_dev *dev)
 
 	if (aac_comm_init(dev)<0){
 		kfree(dev->queues);
+		dev->queues = NULL;
 		return NULL;
 	}
 	/*
@@ -659,6 +660,7 @@ struct aac_dev *aac_init_adapter(struct aac_dev *dev)
 	 */
 	if (aac_fib_setup(dev) < 0) {
 		kfree(dev->queues);
+		dev->queues = NULL;
 		return NULL;
 	}
 		
-- 
2.43.0



