Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 283BF30C627;
	Mon, 13 Oct 2025 15:11:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368280; cv=none; b=bt+wCNsolqhWJiVwK1tyLCG5e3D+3BpVeLAjDqu2gLimYitgIKatZhN837jbLVcXfBv935N2Ylab17tTzt42Tr8AobDt50PzSVewUzknXkwo5X3Asu+ktqC2/RbbhHxC70q5V9pEpZkVWOh0Gq5l/IaD+8ndlJXua1jbPcY9oFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368280; c=relaxed/simple;
	bh=CJhwsUWph+1ziWMQqu8oLdgciVEWwiEmOrNHnmI++VI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fVhvJ7XV6NleNr1gwIRvNvt2J7FETVPliBvVzo4TEXcHkdhBCOfSempVo9wa2DURBKLJ8GU5/p6ikoKI85PORRoMlsLKP4c1iU343me+uNKFYJBSTAjLL6sUJojk8glEbTxMHXHPsk5sfe/kNZiOOGCE9IteTEM8hORUWhKwBvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jcoj/x8Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jcoj/x8Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A856DC4CEE7;
	Mon, 13 Oct 2025 15:11:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368280;
	bh=CJhwsUWph+1ziWMQqu8oLdgciVEWwiEmOrNHnmI++VI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jcoj/x8YEFsJ0xYti5UuacL15JPYqtleb0I8VZC/77uxlBm8PuHz0OQEcrJmQL7Jx
	 flQaPB6bSvNYA8eiRP6kc+dqA0tUWp0rMZ0LZVvAaHlbhQaNIsTBVth/eQh+8U0Jg6
	 DXkppRODIjkkWAlmB4APVxxZ85tJ9tM6Z59HByqY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stanley Chu <yschu@nuvoton.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 073/262] i3c: master: svc: Recycle unused IBI slot
Date: Mon, 13 Oct 2025 16:43:35 +0200
Message-ID: <20251013144328.755366769@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144326.116493600@linuxfoundation.org>
References: <20251013144326.116493600@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 7d8e1540f02ae..a1945bf9ef19e 100644
--- a/drivers/i3c/master/svc-i3c-master.c
+++ b/drivers/i3c/master/svc-i3c-master.c
@@ -377,6 +377,7 @@ static int svc_i3c_master_handle_ibi(struct svc_i3c_master *master,
 						SVC_I3C_MSTATUS_COMPLETE(val), 0, 1000);
 	if (ret) {
 		dev_err(master->dev, "Timeout when polling for COMPLETE\n");
+		i3c_generic_ibi_recycle_slot(data->ibi_pool, slot);
 		return ret;
 	}
 
-- 
2.51.0



