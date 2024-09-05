Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A578519884A;
	Thu,  5 Sep 2024 09:50:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725529844; cv=none; b=Jz1xCG1WIxFSIFXyMqrmVHuTmKj3pxM1yUd79xGUmQ9vU3hqpUdbhCK+UuPimOZOOAzVF0RknbOgRvUOg21+7jDOfKGXXhGLy27lOiqfD6P41zRBh1QRcPPcZc4Gf1LCZW7zCrYbRb0/Fyg4uwp+X35qR/zyfr9Jf9TwILPJvAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725529844; c=relaxed/simple;
	bh=jwgiMgX0WHEUmXc9yhx8WvTHurcKYHS/tjdyrH0MEbw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nnJU6yP/3SpM5pVd8iD91jJyC+d878x9iSdIiiwoLtZEIGPwS8ZnCPinrXErhUqw3zHOTwq2ryDv/6kcWYZBzqpubhpxvBiLYoU+BWRhBeMFJbSeo454vF+w8kxS0CvTV46mBgX21p5wlo6QA6KGMkrGqe6XU1157uv/QQFLu1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vVVz3qbO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vVVz3qbO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13F85C4CEC3;
	Thu,  5 Sep 2024 09:50:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725529844;
	bh=jwgiMgX0WHEUmXc9yhx8WvTHurcKYHS/tjdyrH0MEbw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vVVz3qbOeLGtOsQyUIliuOy+mr14l+ebzju6HrwzXpZuATaO0AhVJMOp7L/uMdK6c
	 oXLWVJz3+NKGzWbUIW+Vx+QW9PGppHosIOHjBtfvnNa8izvcIx/AllVg3Rgbb59Nzc
	 6H15+98KKMWxgY7crcGtWZQystWHRso0gM+wz1gA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shannon Nelson <shannon.nelson@amd.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 129/184] ionic: fix potential irq name truncation
Date: Thu,  5 Sep 2024 11:40:42 +0200
Message-ID: <20240905093737.261802946@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093732.239411633@linuxfoundation.org>
References: <20240905093732.239411633@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shannon Nelson <shannon.nelson@amd.com>

[ Upstream commit 3eb76e71b16e8ba5277bf97617aef51f5e64dbe4 ]

Address a warning about potential string truncation based on the
string buffer sizes.  We can add some hints to the string format
specifier to set limits on the resulting possible string to
squelch the complaints.

Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
Link: https://lore.kernel.org/r/20240529000259.25775-2-shannon.nelson@amd.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/pensando/ionic/ionic_lif.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 1837a30ba08a..f64d18949f68 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -242,7 +242,7 @@ static int ionic_request_irq(struct ionic_lif *lif, struct ionic_qcq *qcq)
 		name = dev_name(dev);
 
 	snprintf(intr->name, sizeof(intr->name),
-		 "%s-%s-%s", IONIC_DRV_NAME, name, q->name);
+		 "%.5s-%.16s-%.8s", IONIC_DRV_NAME, name, q->name);
 
 	return devm_request_irq(dev, intr->vector, ionic_isr,
 				0, intr->name, &qcq->napi);
-- 
2.43.0



