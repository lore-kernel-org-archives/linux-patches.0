Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1D651922D0;
	Tue, 10 Sep 2024 10:16:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963397; cv=none; b=iooo5H7Mj3q+MymdMdYk1kL78mfxp/N1QRRdzn23FC0FtEXfZeTuZjsOhxAWvMAyQQawKfix7mx8AT3pD7LFHVn+DvfjKNBtM/LZ/gJXvJMhdB06CwS8XRDCLAHGtdGnFhIHk4vWqPZvo1xmCi1AlAr30fZ+XnN10DJ2oVmdAr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963397; c=relaxed/simple;
	bh=Jq3RGUjwGX40VVHQvGpmcG26ckjsU7lho7MZtNZlgb4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tJqRS9jlN1dpQm5noFBo628Ahj4JT9SLDoSSZHleGUuR1Hp6j7eyfuql1Ns6QLs7P1uI83DMzHJOkOAbE5qW1uJ6h7h+6edG/hJ24yk7pEVqLaFHptRGRbI6dK8RTIa9yNzC8mnHkULN/8YnLtITeXnbJC4SUL8f+b58HtggXNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TYM3lXDJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TYM3lXDJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C20EC4CEC3;
	Tue, 10 Sep 2024 10:16:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963397;
	bh=Jq3RGUjwGX40VVHQvGpmcG26ckjsU7lho7MZtNZlgb4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TYM3lXDJaJPvXxeWOQvE4Hd/p2BZ4VmtuVrb7ancg+8lSjw1CwtWyWbWF+fwk41BS
	 FUSc8+qbqXp2wBPLy+ecM68hnVz04sPUOZcKr//e16UEcevbLOfeyrH6BhWPzUQEdt
	 dXA7OD4L6/0u0j4NiYoyiG6PPWlgaVKzp61F5X0Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shannon Nelson <shannon.nelson@amd.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 043/214] ionic: fix potential irq name truncation
Date: Tue, 10 Sep 2024 11:31:05 +0200
Message-ID: <20240910092600.530758288@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092558.714365667@linuxfoundation.org>
References: <20240910092558.714365667@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index b791fba82c2f..910d8973a4b0 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -221,7 +221,7 @@ static int ionic_request_irq(struct ionic_lif *lif, struct ionic_qcq *qcq)
 		name = dev_name(dev);
 
 	snprintf(intr->name, sizeof(intr->name),
-		 "%s-%s-%s", IONIC_DRV_NAME, name, q->name);
+		 "%.5s-%.16s-%.8s", IONIC_DRV_NAME, name, q->name);
 
 	return devm_request_irq(dev, intr->vector, ionic_isr,
 				0, intr->name, &qcq->napi);
-- 
2.43.0



