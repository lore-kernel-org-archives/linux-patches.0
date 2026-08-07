Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10F9738D3ED;
	Fri,  7 Aug 2026 15:39:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117147; cv=none; b=B7PAvZXaDns9aZNRmvXQbS6BS9RG2+exSQVNDq5guJsDekA7XvQg/QQuW84Hji51kj4tun3uVrSxy6hkH6xGAGOTWOUyeV3lLO5v/wrvblusE/ANArjxmyj4HuIleYGhNV2BMvjPylOem7zlhq2AkgEbwTxiryWwtq9TzRsmwJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117147; c=relaxed/simple;
	bh=ZepezzYd2quRYOVq+M1/6vaYO1lzEzBcnuMrMkPgS3U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OXZSqsV2CWQtFTil1xIuavBuHiFfF5K0Nsa46t317AMtj5XKc61dSinchnoO55bzYhu9nYYIXvCryl0Ts9KBW0NSz6vvs2NeeN1QtctgSvGQPu6YWn+KrwPJEoD6vpQhFbM5dcpEHXj0r0t2nAVIjzuALd1SIixb9A68YkaFr7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=le1Wp0am; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="le1Wp0am"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 672CF1F00A3A;
	Fri,  7 Aug 2026 15:39:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786117146;
	bh=ecuDrlUoPrQ24iPdJPTNE9xgkBxC2f/3iuwsDj1TvLg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=le1Wp0amjM5/UKnDik/al8DwS5COgiJzqtrAoW9Pe7D7QXT4fbzT4dMSp+qYrM4w1
	 Z3C2G7VygTMk/VaZM5oilyrD4xg0vbXNznl6c2yLcI6yoR35ZwHnFeV4tkHMwfdjm0
	 ALuDQ4OVfL25jZHRkfnoUEVK0y62la0xlFc2GmGk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Minhong He <heminhong@kylinos.cn>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 162/438] can: isotp: check register_netdevice_notifier() error in module init
Date: Fri,  7 Aug 2026 16:35:58 +0200
Message-ID: <20260807143431.488241807@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 54becaf6898f1..ae6260e98a7a6 100644
--- a/net/can/isotp.c
+++ b/net/can/isotp.c
@@ -1907,13 +1907,18 @@ static __init int isotp_module_init(void)
 
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



