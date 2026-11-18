Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017923;
	b=NO99qcWtClJ6ImS7NJjKLLqDzgDs9Ukw5CHhShRX3NngK6ZfwdoODC7fa+HACR5TjIVK
	 urXFh9VK3RTBwDmiabJ1n1MwH6EDytWOi7GNY7kfKgX5yaMWNDrZniG0yZ/QKK4gXQyoA
	 4koKiWAK6Ej9mdWjYcpoPDxZBxQy5Ao/kK1+lWidioMxThsS+IIgRJABh5ObpYgD0WwdH
	 uSNKqn5ho9s1Zq7YjKULUavPupMvZobYxH9oF9yXehYULYasyTS6iDDeMWePKsb9e/wx9
	 BDnhCkoyFiyS8pYmci4ofijbwy5euAJU+TPKL6Ql/FBeFeAW5nNLhj16icE+FmCyOyA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017923;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ClJpEXtBwx7zJz0p/0Q8r3HUtZmVRkUWV8GYrv2icng=;
	b=Fbu4VuilTxwpz5iza5KmGvPGkc+Bp9i18/mE6asbHhJqvWSMvgeyPXywbVsccXot2Lzk
	 X/hbE+mYUJvsnrrkkNgIudDdB7z3cIlgipkmLAmAz+HWI8JGfR33DO3+smXP1Yh0FppZR
	 xR8kk0ZNZlq1fBYR/QXbkDWTreiOt5UpiVVzzVmnjIsbT0TRbZKd3OogFP5CWl20Zvwwv
	 tEqy4MfXIIQ5Vff+fvPIuGHRWI8wucOgGzBY4FpS9TKrMBYMQTjsyuw5YIWm5JpQMB+3/
	 s/XrwT/WNmmeAOUysHO5eA1/ZGJ3zcTeXJ1V5iP9diYZFsSNA+gauVgYnqBPY42FaDA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2evSN5PB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DA44606A31C;
	Wed, 18 Nov 2026 16:05:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2evSN5PB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B02AF1F000C4;
	Wed, 18 Nov 2026 16:05:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017923;
	bh=ClJpEXtBwx7zJz0p/0Q8r3HUtZmVRkUWV8GYrv2icng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2evSN5PByVJHYhKz9o6L8TM0cb4xSkl1eulq/TSZ2pB3UsONW6gOpU2HYX7O9RO+7
	 gjiDcRRiFPs4BTeJmp9UsBu34jolSp4XTBJl9m/seRI9fqReylPM182l0VKwIrVxoH
	 CiCR27iBS8ogB/Sib8y6bmAX7gjT2JWrIKwa8TnM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongyan Xu <getshell@seu.edu.cn>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1058/2651] RDMA/hfi1: shut down the trap timer before unregistering
Date: Wed, 18 Nov 2026 15:38:18 +0100
Message-ID: <20261118150326.065073142@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hongyan Xu <getshell@seu.edu.cn>

[ Upstream commit a1c9d476c2316685f85fffb6450ad88d01836357 ]

MAD processing arms a trap timer embedded in each hfi1_ibport. Device
unregistration does not stop the timer, so its callback can run after
the port and its containing hfi1_devdata have been released.

Shut down every port timer before unregistering the IB device. The
shutdown form also prevents a concurrent path from rearming the timer.

Fixes: bf90aadd630c ("IB/hfi1: Send MAD traps until repressed")
Signed-off-by: Hongyan Xu <getshell@seu.edu.cn>
Link: https://patch.msgid.link/20260928134151.1213-1-getshell@seu.edu.cn
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hfi1/verbs.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/infiniband/hw/hfi1/verbs.c b/drivers/infiniband/hw/hfi1/verbs.c
index e569b647d611a..0ef3b1a89a533 100644
--- a/drivers/infiniband/hw/hfi1/verbs.c
+++ b/drivers/infiniband/hw/hfi1/verbs.c
@@ -1888,6 +1888,10 @@ int hfi1_register_ib_device(struct hfi1_devdata *dd)
 void hfi1_unregister_ib_device(struct hfi1_devdata *dd)
 {
 	struct hfi1_ibdev *dev = &dd->verbs_dev;
+	int i;
+
+	for (i = 0; i < dd->num_pports; i++)
+		timer_shutdown_sync(&dd->pport[i].ibport_data.rvp.trap_timer);
 
 	hfi1_verbs_unregister_sysfs(dd);
 
-- 
2.53.0



