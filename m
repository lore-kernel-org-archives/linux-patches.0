Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8EA3221D92;
	Mon,  2 Jun 2025 14:52:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748875979; cv=none; b=rWEi1CFDiK1i8xuVLIgW4LieTDuXeUAgLLhf8TQL1vimfioGOpxaTbLTpyKzMxamv0dM06XSa2LASmBtnU/L3nI4olB285YXDlcLwn4WHxhiU8DKnstwSiicjqOJDvH2NwiVNbo6dT9yuHcWg67XrXaH5KsYtByT60qZXvSzyHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748875979; c=relaxed/simple;
	bh=r9ENm83W3YTWIOuIzTAXSnvRcy+VEELJBuRjM2IL67s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oTbgLHVrUIdw7En+ehArdSu8UIg6/xZ8sD+KWAVhyIAc5DTOz47ffatIOZvOP6dRSwBDqCwoTaQ+Mcj4sbb38euA9CMMf7iJTOiCANSm5i1w0ilao4SLe1Una1V+VXcYJTfmZLeAAyHWlGw9hES4FG/aqpaZUNc/m+L5UNJGIfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ymqw9vlB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ymqw9vlB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D38BC4CEEB;
	Mon,  2 Jun 2025 14:52:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748875979;
	bh=r9ENm83W3YTWIOuIzTAXSnvRcy+VEELJBuRjM2IL67s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ymqw9vlB0WjjKUnt8pH+eYXAjo5vNPXYVsHUdDK72tR44HFCL5lKCJ60VDQw3ZgBQ
	 wj/s9YGo8NMp33ji5kcDTDM8Z6O+mtfqkMZqEhTZBUU1dMNypjooBZtCN94xbiifnq
	 HdTIAcYZj4WeU7WdAXKHq+TCNRkFQTNpfesYVfsk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stanley Chu <yschu@nuvoton.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 034/207] i3c: master: svc: Fix missing STOP for master request
Date: Mon,  2 Jun 2025 15:46:46 +0200
Message-ID: <20250602134300.099350997@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134258.769974467@linuxfoundation.org>
References: <20250602134258.769974467@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanley Chu <yschu@nuvoton.com>

[ Upstream commit 0430bf9bc1ac068c8b8c540eb93e5751872efc51 ]

The controller driver nacked the master request but didn't emit a
STOP to end the transaction. The driver shall refuse the unsupported
requests and return the controller state to IDLE by emitting a STOP.

Signed-off-by: Stanley Chu <yschu@nuvoton.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://lore.kernel.org/r/20250318053606.3087121-4-yschu@nuvoton.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master/svc-i3c-master.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/i3c/master/svc-i3c-master.c b/drivers/i3c/master/svc-i3c-master.c
index 368429a34d600..92488ba5b5f2a 100644
--- a/drivers/i3c/master/svc-i3c-master.c
+++ b/drivers/i3c/master/svc-i3c-master.c
@@ -437,6 +437,7 @@ static void svc_i3c_master_ibi_work(struct work_struct *work)
 		queue_work(master->base.wq, &master->hj_work);
 		break;
 	case SVC_I3C_MSTATUS_IBITYPE_MASTER_REQUEST:
+		svc_i3c_master_emit_stop(master);
 	default:
 		break;
 	}
-- 
2.39.5



