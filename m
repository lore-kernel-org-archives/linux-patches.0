Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E5C7197A69;
	Thu,  6 Jun 2024 14:13:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683233; cv=none; b=LSRFPnDJb6hDO9HQV6xbIABw6rsdKb04jTSZnAQGtTveOUoXRv2H8tthmTXFTCZETeuusGdGUyP5AnvtiG3yUBA+R/P3oX8O+vNDOxaKzIu5J57YhsOWflOqJRv6IXU81RgOP4EPPIV+GpHREdm0/MgrkMKFcfgGa7MJ/F0yWD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683233; c=relaxed/simple;
	bh=iImWpJ93zp4xRaHnTJ8PknGTJatyAmwpfCuI+gdCwL8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tk2SJLMoH7/VfiZ9GFRFok49biQ983I5Yy5tquv859hsTmPc7keUXfXoFPRd2rzleQZnmJWS2bX4WR4wGdjPgpcsAzcMnlOnOyKHxAuWKug4i7PzyZpvZciw7cHb9fJVQnGswG52Igq/TXmTZd6+6IcQVngOtTqx8TVSdh2Jn5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E+8uBpwN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E+8uBpwN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FE49C2BD10;
	Thu,  6 Jun 2024 14:13:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683233;
	bh=iImWpJ93zp4xRaHnTJ8PknGTJatyAmwpfCuI+gdCwL8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E+8uBpwNe97I1pyuEJ3PnIWl4dxER5LbJ9AfJnmyyqH24MlYykal4m3KnoU4xGWOT
	 kSXzep/vNmpH5gvmyNS6qI8Ij4mXUVM4pJlG3yAyWIYyF2yC55CDf9GZ5ucSUt5lKL
	 9GF4Pgz4PouMF0Rh7z+C0wQTLfYlWuwjEK8OtI6Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuri Karpov <YKarpov@ispras.ru>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 178/744] scsi: hpsa: Fix allocation size for Scsi_Host private data
Date: Thu,  6 Jun 2024 15:57:30 +0200
Message-ID: <20240606131738.142868829@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuri Karpov <YKarpov@ispras.ru>

[ Upstream commit 504e2bed5d50610c1836046c0c195b0a6dba9c72 ]

struct Scsi_Host private data contains pointer to struct ctlr_info.

Restore allocation of only 8 bytes to store pointer in struct Scsi_Host
private data area.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: bbbd25499100 ("scsi: hpsa: Fix allocation size for scsi_host_alloc()")
Signed-off-by: Yuri Karpov <YKarpov@ispras.ru>
Link: https://lore.kernel.org/r/20240312170447.743709-1-YKarpov@ispras.ru
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/hpsa.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index af18d20f30794..49c57a9c110b5 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -5850,7 +5850,7 @@ static int hpsa_scsi_host_alloc(struct ctlr_info *h)
 {
 	struct Scsi_Host *sh;
 
-	sh = scsi_host_alloc(&hpsa_driver_template, sizeof(struct ctlr_info));
+	sh = scsi_host_alloc(&hpsa_driver_template, sizeof(struct ctlr_info *));
 	if (sh == NULL) {
 		dev_err(&h->pdev->dev, "scsi_host_alloc failed\n");
 		return -ENOMEM;
-- 
2.43.0



