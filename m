Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5044C1494DB;
	Thu,  5 Sep 2024 10:03:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725530593; cv=none; b=LVasHkMvRYEQQv56xg0TKFesSf5NOQJa+xgi6iG7SOn6adUt3jJ9GCxnOGpM5vnMTWyTX+0Zg/1dGgKw8ApBZajNZ+jLughCqmIXmYRrNIhm8tuHsPeqtSKEeJZH26nNL6jkEHClO9/psTzqBIqnFPLDaRbmfbpklJ9HwPEHL4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725530593; c=relaxed/simple;
	bh=MAPuVg1EgBMTNPK9S8+AnUBTFZN4WEeNWWNpgJMHuKs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZONy/g1CHZHoWxRM26Xo8RpzJLuuNQ++6DJvvFeaYWyogKYf8wZByGQix+PJmKNojWeni0Z+EiorSkV2jXcAlrXYZbxLxh+zOEMqAM/i+B7tMYYExWyWF9B7ZvApm5t5AIPTBqe8JpYIb2QpG3ONNWaqE4VYoVYQm6wCF+vQTrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q7XHekcf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q7XHekcf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD12BC4CEC3;
	Thu,  5 Sep 2024 10:03:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725530593;
	bh=MAPuVg1EgBMTNPK9S8+AnUBTFZN4WEeNWWNpgJMHuKs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q7XHekcfx/ZWyBsk/mbYkay6P8RYWS3knVTu8k/Q/Uvx/Udv7fcYOeemgmMIPwLS9
	 GC8ceiQlw8W9N76Jcw9CQpfDKB3CIbVghjjRoFfmd9py47PO6b4fHikqXBIgkbnbqD
	 2ZtL3guUH4nzLgVN9V2jPrbIMQqCZXJb/TRRuLM4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shannon Nelson <shannon.nelson@amd.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 073/101] ionic: fix potential irq name truncation
Date: Thu,  5 Sep 2024 11:41:45 +0200
Message-ID: <20240905093718.989343942@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093716.075835938@linuxfoundation.org>
References: <20240905093716.075835938@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index d34aea85f8a6..14865fc245da 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -230,7 +230,7 @@ static int ionic_request_irq(struct ionic_lif *lif, struct ionic_qcq *qcq)
 		name = dev_name(dev);
 
 	snprintf(intr->name, sizeof(intr->name),
-		 "%s-%s-%s", IONIC_DRV_NAME, name, q->name);
+		 "%.5s-%.16s-%.8s", IONIC_DRV_NAME, name, q->name);
 
 	return devm_request_irq(dev, intr->vector, ionic_isr,
 				0, intr->name, &qcq->napi);
-- 
2.43.0



