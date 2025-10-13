Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C46121930A;
	Mon, 13 Oct 2025 14:51:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367067; cv=none; b=Xs2VIqHoyFTSRuSEN0SCNqiiRb1ZpQUtEnmGpOBAbpgcJoEvyg7TyRnojOlZNYRCdaUQ4XGYlX/qVkGfCvTmb8dAl/IC3sJdctDPB20spPp9Fi/Znob6mmZqPczrKHA5Poo+Q9GjhK4s37AgEAhCrMDK1NT99SkUxKLynQGcPeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367067; c=relaxed/simple;
	bh=dhbUzt4y4GTQ1mTJXEM01gV/wFnlgpgk5BbbTGr63AU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b+gU4qlG0DXYwUf677tDWyMSmlO5hlHuadKIApmf/YYAhKVs35rPfmAu0BKMf/6SsUQOpYVfG31Azd+pfAJu+hl3RtRm7JQyt0uKSrbrdbWcV97jpuYrIs4ysQ4wbbL6Z9o4sFDqrjx1OVUaLdtwHC+bZyZgr/qNiytugXJdyrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c1zUTikP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c1zUTikP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3860C4CEE7;
	Mon, 13 Oct 2025 14:51:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367067;
	bh=dhbUzt4y4GTQ1mTJXEM01gV/wFnlgpgk5BbbTGr63AU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c1zUTikP5pAhERqPPQBxPBtz1GfybQXmBDENGS0I+pOufitSXLJA0w4B+r5NEKf0Y
	 6glq/cYJZFb7UZgwTw7oKZ9Hp/t3UmtoTTUXPexSVz9FgSxspdemRvvlyNgg+SY1Lt
	 3DVw0A/D5ayFG7hXsYBb7ll3XgFC3QBJjiYOLy4E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stanley Chu <yschu@nuvoton.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 079/196] i3c: master: svc: Recycle unused IBI slot
Date: Mon, 13 Oct 2025 16:44:12 +0200
Message-ID: <20251013144317.433800705@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144314.549284796@linuxfoundation.org>
References: <20251013144314.549284796@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanley Chu <stanley.chuys@gmail.com>

[ Upstream commit 3448a934ba6f803911ac084d05a2ffce507ea6c6 ]

In svc_i3c_master_handle_ibi(), an IBI slot is fetched from the pool
to store the IBI payload. However, when an error condition is encountered,
the function returns without recycling the IBI slot, resulting in an IBI
slot leak.

Fixes: c85e209b799f ("i3c: master: svc: fix ibi may not return mandatory data byte")
Signed-off-by: Stanley Chu <yschu@nuvoton.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://lore.kernel.org/r/20250829012309.3562585-3-yschu@nuvoton.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master/svc-i3c-master.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/i3c/master/svc-i3c-master.c b/drivers/i3c/master/svc-i3c-master.c
index a18d5876678c1..fda472d84549b 100644
--- a/drivers/i3c/master/svc-i3c-master.c
+++ b/drivers/i3c/master/svc-i3c-master.c
@@ -361,6 +361,7 @@ static int svc_i3c_master_handle_ibi(struct svc_i3c_master *master,
 						SVC_I3C_MSTATUS_COMPLETE(val), 0, 1000);
 	if (ret) {
 		dev_err(master->dev, "Timeout when polling for COMPLETE\n");
+		i3c_generic_ibi_recycle_slot(data->ibi_pool, slot);
 		return ret;
 	}
 
-- 
2.51.0



