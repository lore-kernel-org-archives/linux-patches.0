Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3AD018D65E;
	Thu,  5 Sep 2024 09:58:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725530294; cv=none; b=WhIXWH6tcaAbgG1ksG1bMAELfvfUn5n4PWYeW578ET69fiQ9IVVH7qckV+CdWKQp9EjlBKxSTdTCsLSXzAqmaV2H7DolsnnJ1UVa8bIY99wx2oaTNB/IdhGYGi+G2r8YjrY/I5l8oQv7fgE7YXPxxCt+lFMSe+xhBPd0T6Af0KA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725530294; c=relaxed/simple;
	bh=p/dtfHaazzL1BtkO6n1u512gptK34yjlWW6msknp1c4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=myrXgtxjerDXwUz8qqUi/Q3FXAhWr+HB0/JbKfRWNHOaVpV/pqehTerB0GE3EXLIWL4fX/4h78G5FLjgzORFnZqjrgJ6/mJ01O2ESKr0CR2322BPenX1tw19nhap2yLEv6+MC67oS0+OWWlfQf8lkabygqNKSo6HLxi9tGYfTb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p3/kNWQt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p3/kNWQt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31693C4CEC3;
	Thu,  5 Sep 2024 09:58:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725530294;
	bh=p/dtfHaazzL1BtkO6n1u512gptK34yjlWW6msknp1c4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p3/kNWQtgyJxwJyZBF0Qm5NLxotor77dd4gwAeuJnOX0voNNSJ+nR/uXaEOgEzJAb
	 hFXqmPU+bjU4lq84ZCeiYLyURjkVVyWyEtF1AY2pAAkabxe6y2w15qcRCaqjZouwoJ
	 YA9sA1ZyntO5LkvQaEPu8uXlDWbsvdY8Qt8RR2zQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shannon Nelson <shannon.nelson@amd.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 096/132] ionic: fix potential irq name truncation
Date: Thu,  5 Sep 2024 11:41:23 +0200
Message-ID: <20240905093725.976388793@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093722.230767298@linuxfoundation.org>
References: <20240905093722.230767298@linuxfoundation.org>
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
index 7e6e1bed525a..9d724d228b83 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -234,7 +234,7 @@ static int ionic_request_irq(struct ionic_lif *lif, struct ionic_qcq *qcq)
 		name = dev_name(dev);
 
 	snprintf(intr->name, sizeof(intr->name),
-		 "%s-%s-%s", IONIC_DRV_NAME, name, q->name);
+		 "%.5s-%.16s-%.8s", IONIC_DRV_NAME, name, q->name);
 
 	return devm_request_irq(dev, intr->vector, ionic_isr,
 				0, intr->name, &qcq->napi);
-- 
2.43.0



