Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A43B27F4CB;
	Tue, 27 May 2025 17:24:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366680; cv=none; b=FWYlbkv2a2YCjzWsZUIEzHJdVIjqdJC/8HuA2jYLZZ6eV2EZRqZLHEv8bAoDf/OB2K58eTlLKD2oeduRHdTC3kiWJbtUi/XNhwaGeQx0ywb6kqbDrJ4x0rh0jqDg6ngVa6tcUZBVHnpYNCxa/LWDryafE1CUTF2zhu0/gGbSJuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366680; c=relaxed/simple;
	bh=Llltz0psRHuP/tE7tm0+MTbexIPBH0st5hrzm/wLD90=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DBwZlk179hiHEfzS0oq/l3tQtwwTBLsyMRAbs2S0sG+oRBNbPQuPPkdGZD7IufbFkW93liGimqtHhQEUOEgDiZD+HYBWo0PwP2HeXzvNxLVa7dgnBv2gNWdSy/1PaSnxJDcGIhHHZym7AQ6pFVvElWlEa6Xe0sJrml3wCmg1+Zc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HxSldwbt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HxSldwbt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDD9AC4CEEA;
	Tue, 27 May 2025 17:24:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366680;
	bh=Llltz0psRHuP/tE7tm0+MTbexIPBH0st5hrzm/wLD90=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HxSldwbt219JNNhlNdMj/wtbpyfsEN1EMhyRfGnK7DAQ/B0YLG9Fef5ciMBPKqEnl
	 xd1EBx6VXW1HaBMpcU7ux8massjn+Jk47C2Wx2SLzN47QhVxewvoSOJrmJVgU0bwZp
	 gQSTtgXqyIkaHBwnSWTq8S1UeYIax/SIGJsyMxhY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stanley Chu <yschu@nuvoton.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 145/783] i3c: master: svc: Fix missing STOP for master request
Date: Tue, 27 May 2025 18:19:02 +0200
Message-ID: <20250527162519.062946235@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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
index 0fc03bb5d0a6e..a18fe62962b0c 100644
--- a/drivers/i3c/master/svc-i3c-master.c
+++ b/drivers/i3c/master/svc-i3c-master.c
@@ -551,6 +551,7 @@ static void svc_i3c_master_ibi_work(struct work_struct *work)
 			queue_work(master->base.wq, &master->hj_work);
 		break;
 	case SVC_I3C_MSTATUS_IBITYPE_MASTER_REQUEST:
+		svc_i3c_master_emit_stop(master);
 	default:
 		break;
 	}
-- 
2.39.5



