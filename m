Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69E021422B5;
	Thu, 13 Jun 2024 11:38:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718278701; cv=none; b=X+VtiogTiD3m/FoNmUnB9+fi2U6nTVTvR23Wr74K6yz6PvjVJHOvP+TmgvF82b6UO+XGM1Noom9LqtCH0y0V1pz1oKkrUyi9ov8o5zb/Q9CGmy4XVcOaxUxFIwPonDxQ6efrxMp6p4V178S2WwihKPIcHaTrstDkyQEwArFZVEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718278701; c=relaxed/simple;
	bh=poveDZtGPuKYjKnwvdz6L1DFxgCCeM9WXaJ/jwpfvGw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h0weHwgyWAGHYtofv4hcV+gYKMuWHGMNVUk84vC5JTwxTV9v1uV+Z4Vm2WtWwKiaUO4SQcKXaF9Gh21TsP6Ou2M9IbZFDHIO1EN/9eHYV1PTnDrWOm2DIQnmfRQnHYlNszBSeKvlBBf93ez5yls9ybg3oxLb7Lxt1KjNsg2Tu2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dINVcrzY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dINVcrzY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9C0DC2BBFC;
	Thu, 13 Jun 2024 11:38:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718278701;
	bh=poveDZtGPuKYjKnwvdz6L1DFxgCCeM9WXaJ/jwpfvGw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dINVcrzYA86IG4T3Y09hWigmt9+R+g45cT9iOw6jALuMX+/ndpFYZ1Hg9wQN5lFw3
	 ebgwZzPa4fGQxuX9ZdxP4L2xC5R7T9vFx1V2VQQvPvab+GAW3xeS0e2GKgmvFk9tT3
	 EAPVbMFoAiwjZrgPlyLu3R+wn8HRci5Jl/kROlAs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuri Karpov <YKarpov@ispras.ru>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 040/213] scsi: hpsa: Fix allocation size for Scsi_Host private data
Date: Thu, 13 Jun 2024 13:31:28 +0200
Message-ID: <20240613113229.548504093@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.969123070@linuxfoundation.org>
References: <20240613113227.969123070@linuxfoundation.org>
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
index 25d9bdd4bc698..d68d8a573ae31 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -5771,7 +5771,7 @@ static int hpsa_scsi_host_alloc(struct ctlr_info *h)
 {
 	struct Scsi_Host *sh;
 
-	sh = scsi_host_alloc(&hpsa_driver_template, sizeof(struct ctlr_info));
+	sh = scsi_host_alloc(&hpsa_driver_template, sizeof(struct ctlr_info *));
 	if (sh == NULL) {
 		dev_err(&h->pdev->dev, "scsi_host_alloc failed\n");
 		return -ENOMEM;
-- 
2.43.0



