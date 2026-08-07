Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7226431327A;
	Fri,  7 Aug 2026 15:20:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116001; cv=none; b=lWUu2GkeDiJz48jkdLkiUwX54yIpuDxygLvi+MB5o7mBXmNigqVp/ke4atB/SiMTS0NaYK1BiNdFGSGrDlq5tzmB13ClkRo8UITSE6lZ8vysaqoI231BwIxQDilBerI2aK5gHYEwmohL+Ts2/+g0LHxq8+GtWHFOlJmlXPFzOp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116001; c=relaxed/simple;
	bh=9uD8fx5D1Ilpbox6z0apM/p6azj9zbICveB3PEg9duU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B0ra3v1aBQ/T8abGesLvjN3XwyGH4+xnTDrOoICTnRRmUVZyc1pGXNsVCvfNiY/Fo0WcXi4cp/miGPfM4utFI9OJPFQhTh89fmDiCMw+UvxsucmPgxCPg+UGmT2aVwk838Ex5yoURJhDyq/eQvq9I51G67XlItSG8ylH8LL0/ME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uiwvuCCB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uiwvuCCB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD4661F000E9;
	Fri,  7 Aug 2026 15:19:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116000;
	bh=x1Sbfu8kF3y1Gzzqe8KfD+QNEqTUHVlXAGoTtLS9u9Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uiwvuCCBIbKn+L5Vqsaoi81Uj2tDQB2t/OvBTer82Ujh1JfLYSOiwTFPVDWBJIjnN
	 AA2qQpYyZJuYs+ZZ8h47ucKXYIBu2gN3HA9VhDi8Ct5EuVTAJ6DdbF7ESrzFgBep6Y
	 BUwWOfCS4R+6HFBxMLHKQGQZ3FuTMAP/yh3e1dI4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Minhong He <heminhong@kylinos.cn>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 078/261] can: isotp: check register_netdevice_notifier() error in module init
Date: Fri,  7 Aug 2026 16:37:15 +0200
Message-ID: <20260807143417.069335826@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143415.358597922@linuxfoundation.org>
References: <20260807143415.358597922@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Minhong He <heminhong@kylinos.cn>

[ Upstream commit ef09a13c5afac41a3c4b5f22b8572820d9e7518c ]

Register the netdevice notifier before can_proto_register() and check the
return value. If protocol registration fails, unregister the notifier
before returning the error.

Align isotp_module_init() with the reordering already done for raw.c
(commit c28b3bffe49e ("can: raw: process optimization in raw_init()")) and
bcm.c (commit edd1a7e42f1d ("can: bcm: registration process optimization
in bcm_module_init()")).

Fixes: 8d0caedb7596 ("can: bcm/raw/isotp: use per module netdevice notifier")
Signed-off-by: Minhong He <heminhong@kylinos.cn>
Link: https://patch.msgid.link/20260729085656.134523-1-heminhong@kylinos.cn
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/can/isotp.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/net/can/isotp.c b/net/can/isotp.c
index efc5eeac7c886..062b7bbf1b098 100644
--- a/net/can/isotp.c
+++ b/net/can/isotp.c
@@ -1883,13 +1883,18 @@ static __init int isotp_module_init(void)
 
 	pr_info("can: isotp protocol (max_pdu_size %d)\n", max_pdu_size);
 
+	err = register_netdevice_notifier(&canisotp_notifier);
+	if (err)
+		return err;
+
 	err = can_proto_register(&isotp_can_proto);
-	if (err < 0)
+	if (err < 0) {
 		pr_err("can: registration of isotp protocol failed %pe\n", ERR_PTR(err));
-	else
-		register_netdevice_notifier(&canisotp_notifier);
+		unregister_netdevice_notifier(&canisotp_notifier);
+		return err;
+	}
 
-	return err;
+	return 0;
 }
 
 static __exit void isotp_module_exit(void)
-- 
2.53.0



