Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 862542FA64D;
	Tue, 17 Jun 2025 16:37:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178252; cv=none; b=FFcvSHw3h8+eHn7ax9um04DxJFPQRd+kutBYQESEvLLuvZrwqbSa+inR197FKzJbFgmYexQAfnGZF7eT7XSaD0ZSlaGDNKd9aVz49LXpkeY2DkDg4XB7QjmgprpYCK1ThKa5Uk2uKPx1V3xcORvOA1hY0v54aO3AnpFvwHnftKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178252; c=relaxed/simple;
	bh=0egNTOLEcCqzddneay6OpFH/zSM0STc+OoIR0SjF4HU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AUX8QLGvWriLWVzY4RguTgUJIsQ07NfIHWY5ivC0nXJPKNzvy7mEF3j7SGI/rG8lSB26lhurZTzJq8tkiP+EF6Lxcor1qB4ZbOXSYZp0wjI1I+RQFEuUPYv71+mzrMFSyqEr0RCghcxjPbmM1m/TU9hDkq7dP3olO5b2BixDAGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LMUtVm4h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LMUtVm4h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA4B5C4CEE3;
	Tue, 17 Jun 2025 16:37:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178252;
	bh=0egNTOLEcCqzddneay6OpFH/zSM0STc+OoIR0SjF4HU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LMUtVm4hxX/n/dxb3bR8D38YdHRP9qDLAJP9CJ9a1UvnlYITUg+QphQDLId+EEUj4
	 vclMXBHl9H+/cxVyUEGnQ/62vhVThp/ksMQspLs5sQP4bY7HAkyIq0sFv9/80JRJei
	 FZbvpy1bGwMWPpUpWj78gBHvy+JAFeVX/TCcIcoc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 469/512] net: drv: netdevsim: dont napi_complete() from netpoll
Date: Tue, 17 Jun 2025 17:27:15 +0200
Message-ID: <20250617152438.585329091@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 1264971017b4d7141352a7fe29021bdfce5d885d ]

netdevsim supports netpoll. Make sure we don't call napi_complete()
from it, since it may not be scheduled. Breno reports hitting a
warning in napi_complete_done():

WARNING: CPU: 14 PID: 104 at net/core/dev.c:6592 napi_complete_done+0x2cc/0x560
  __napi_poll+0x2d8/0x3a0
  handle_softirqs+0x1fe/0x710

This is presumably after netpoll stole the SCHED bit prematurely.

Reported-by: Breno Leitao <leitao@debian.org>
Fixes: 3762ec05a9fb ("netdevsim: add NAPI support")
Tested-by: Breno Leitao <leitao@debian.org>
Link: https://patch.msgid.link/20250611174643.2769263-1-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/netdevsim/netdev.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/netdevsim/netdev.c b/drivers/net/netdevsim/netdev.c
index 1b29d1d794a20..79b898311819d 100644
--- a/drivers/net/netdevsim/netdev.c
+++ b/drivers/net/netdevsim/netdev.c
@@ -353,7 +353,8 @@ static int nsim_poll(struct napi_struct *napi, int budget)
 	int done;
 
 	done = nsim_rcv(rq, budget);
-	napi_complete(napi);
+	if (done < budget)
+		napi_complete_done(napi, done);
 
 	return done;
 }
-- 
2.39.5



