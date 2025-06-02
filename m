Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67AC8231827;
	Mon,  2 Jun 2025 15:05:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748876736; cv=none; b=j9XTByKq/tc1vlSOBwPo+4m2A3hIOJH12Xjdqh3xiIus/CJaw4R6l/IjdAf7kh9PPDW41W1pgM8LEXMN3j2e2uCXZ84ikasGDdS1oOFeBQHGO6wFpYGKtltwroVE5N0+uwHNBGcRtXQFVUUx7ve9QnnJexo9VDLOefnUYINYvfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748876736; c=relaxed/simple;
	bh=0b+ghnFYw7Q8Vo07dT3T0RVpezYROHc81qY29JhYyyw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=anSx3C3rCbnGgyZ09e5K+Az+nBrjL/v8YSHoczDcI1AcchBqV2IouO8220NmKRCLRTJHtR+svxx3yPCSwvKqBMTGEhtO9Z62ADK2mY+oneZaWNXiV+glRlHkgfgGI/IVOiL2kyjQfp1jWSrsiVF8UihuMevTMZV7zS3oBZIUYdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JuQ8CmDT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JuQ8CmDT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA49FC4CEEB;
	Mon,  2 Jun 2025 15:05:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748876736;
	bh=0b+ghnFYw7Q8Vo07dT3T0RVpezYROHc81qY29JhYyyw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JuQ8CmDT2ghHCfU/BOyIQms4qFla3GNFoHNL3be2TBUFGt9tjLapzXvEe01LU6rgm
	 r4gR1SC96pENtBjj6dO7ERPndXQKDKRD019JUYpyxvM/uNp+1eAurA1wLDlDcIYKel
	 ZtNt0KC7t/IP4Qgl6tUk32UURLElC2EhhLFY/iec=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stanley Chu <yschu@nuvoton.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 058/325] i3c: master: svc: Fix missing STOP for master request
Date: Mon,  2 Jun 2025 15:45:34 +0200
Message-ID: <20250602134322.115431379@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134319.723650984@linuxfoundation.org>
References: <20250602134319.723650984@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 38095649ed276..cf0550c6e95f0 100644
--- a/drivers/i3c/master/svc-i3c-master.c
+++ b/drivers/i3c/master/svc-i3c-master.c
@@ -495,6 +495,7 @@ static void svc_i3c_master_ibi_work(struct work_struct *work)
 			queue_work(master->base.wq, &master->hj_work);
 		break;
 	case SVC_I3C_MSTATUS_IBITYPE_MASTER_REQUEST:
+		svc_i3c_master_emit_stop(master);
 	default:
 		break;
 	}
-- 
2.39.5



