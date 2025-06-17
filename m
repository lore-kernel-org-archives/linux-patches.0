Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B0A02FA623;
	Tue, 17 Jun 2025 16:55:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750179358; cv=none; b=DAQGQ2GO/M2yEN/SGIVmqZzkR6REsZ3TkO36ypE4pMDxCHIEfIbRoKO5nsFmHe0uKcmJV7F5wRZPCVxRx3ArhQvdGM2Imrm42iamrmnGBPhjfnX3gUjYCB/i42pr5YnBLHEOqm/AeXGMqxISBdZq2xxxB0ukxuE9p9YNk28z5Xw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750179358; c=relaxed/simple;
	bh=6OubKKOs+kP6A+GilocvmXNMW4a3iyZFKnsGcTaa7Gw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TmmTxg7W6aK2Hl8ehdwsUakRaOqrb3Wj+GG3ikyicubQlVzFkLc/WL37rDxSdawXZX2S1I9Qpz+w62AdX2OVXkqWEH9GWY9w6W/UmKd7lMl6aFqwk4upQZfV2x1U3TS4M6FCr6og3sYUmt8NSKLYIK1oYrTuJiQrGehe6ykTuzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zaVVTmN0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zaVVTmN0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8A1AC4CEE3;
	Tue, 17 Jun 2025 16:55:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750179358;
	bh=6OubKKOs+kP6A+GilocvmXNMW4a3iyZFKnsGcTaa7Gw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zaVVTmN0+piqGppUwXQwfzDCr2ENjynCc3sQIiqNNOBpmaLq/zcxmuzywMdbL55dJ
	 wXiaCiz1VEicNN/U5rIQKaIcGqjdjffhdoxJACMUhyXBodBgvUp1EmBBW89jzpk+2z
	 7jYn7SR0OcchWflebiAlXq7G23HCofHXxZXRet3I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 721/780] net: drv: netdevsim: dont napi_complete() from netpoll
Date: Tue, 17 Jun 2025 17:27:09 +0200
Message-ID: <20250617152520.856717621@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index 0e0321a7ddd71..31a06e71be25b 100644
--- a/drivers/net/netdevsim/netdev.c
+++ b/drivers/net/netdevsim/netdev.c
@@ -369,7 +369,8 @@ static int nsim_poll(struct napi_struct *napi, int budget)
 	int done;
 
 	done = nsim_rcv(rq, budget);
-	napi_complete(napi);
+	if (done < budget)
+		napi_complete_done(napi, done);
 
 	return done;
 }
-- 
2.39.5



