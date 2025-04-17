Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A94E02571C3;
	Thu, 17 Apr 2025 17:54:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744912450; cv=none; b=q7Y+SU5htKQOhldoUtjRrRZ50cFq6zHuHvluYQVwWMDnrftqQsHkzz7S19eY5kejjKr/SX2e2aU74FKYRK4wW04x3uvzSTZTE0KpdO/Nu8i9M0c5vi5UkNdiI6cY+YLOt+R67kB1SvvQowAurGFL0PXGOyZYkI0kQDe1+gVge+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744912450; c=relaxed/simple;
	bh=xWxIhs/DW8uQ/8FO50sPUfrQQQXho71VHfizlPqFxMs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V1F43H0KwSUD/yCJKRxYZFALsWTyFiBrUwM+O2FEfXYYShe7kYkYo7SSOlnIv1IN6dv1gSp8hBFvX0GA2BwR0gURRN8lLGHg23zIewKkifRTIjsENmz1Nsb7Y/8/hR+CQuuzdk2e9jDBUHeyP4MJr5O8itVxiiKpVTyT5jzYEuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wj4lWQeo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wj4lWQeo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72685C4CEE4;
	Thu, 17 Apr 2025 17:54:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744912450;
	bh=xWxIhs/DW8uQ/8FO50sPUfrQQQXho71VHfizlPqFxMs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wj4lWQeo/S/kLB8dkT7OQFAuyVvjQbABij4Y+Sct11Tc62WR6Vi8MmkReYu1AZroC
	 AE4x3FZ/VqFCbKhmpCytX/+AcJe8EfyE5IRzgT3yaWdkwH3Di/Bqcj4OEYyBeC/a/5
	 uGApHwu/1S9lzwl/iSfk9ppxB/jWL3iFbv/zNs6Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henry Martin <bsdhenrymartin@gmail.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 015/449] ata: pata_pxa: Fix potential NULL pointer dereference in pxa_ata_probe()
Date: Thu, 17 Apr 2025 19:45:03 +0200
Message-ID: <20250417175118.603584206@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Henry Martin <bsdhenrymartin@gmail.com>

[ Upstream commit ad320e408a8c95a282ab9c05cdf0c9b95e317985 ]

devm_ioremap() returns NULL on error. Currently, pxa_ata_probe() does
not check for this case, which can result in a NULL pointer dereference.

Add NULL check after devm_ioremap() to prevent this issue.

Fixes: 2dc6c6f15da9 ("[ARM] pata_pxa: DMA-capable PATA driver")
Signed-off-by: Henry Martin <bsdhenrymartin@gmail.com>
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/pata_pxa.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/ata/pata_pxa.c b/drivers/ata/pata_pxa.c
index 434f380114af0..03dbaf4a13a75 100644
--- a/drivers/ata/pata_pxa.c
+++ b/drivers/ata/pata_pxa.c
@@ -223,10 +223,16 @@ static int pxa_ata_probe(struct platform_device *pdev)
 
 	ap->ioaddr.cmd_addr	= devm_ioremap(&pdev->dev, cmd_res->start,
 						resource_size(cmd_res));
+	if (!ap->ioaddr.cmd_addr)
+		return -ENOMEM;
 	ap->ioaddr.ctl_addr	= devm_ioremap(&pdev->dev, ctl_res->start,
 						resource_size(ctl_res));
+	if (!ap->ioaddr.ctl_addr)
+		return -ENOMEM;
 	ap->ioaddr.bmdma_addr	= devm_ioremap(&pdev->dev, dma_res->start,
 						resource_size(dma_res));
+	if (!ap->ioaddr.bmdma_addr)
+		return -ENOMEM;
 
 	/*
 	 * Adjust register offsets
-- 
2.39.5



