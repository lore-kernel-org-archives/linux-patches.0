Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056694;
	b=2qjgINla35OQR+U/Q8gBjrk3qUwyVTIv1b+Uh5RpFJ88u3Q0126l2Is/76+j4DRUncgP
	 /3wyvOyhfq9O1h1rdbDoJEImkp1bl0MDIj1WDt9guhzgA0ztGodTf7vQ8+1rwDujsGrnf
	 mscj/SZbkpyrAZffNMRItNjI8G3xZNiIKr3j4csaDjWQBKkNP+9usMWg8T7xfOYeU/vWy
	 SNWb/po+fHY/xUjxCrHdspx5Kr9AhgGEkNO8WXdoXLL2fS5H/lwmONXBSw7FIccVYMa9D
	 BrnE+fE4/vEI9j8klWjejSnZAkJT4197HanQcr5JXdOdghaBL5hEnjqcj6AZgVsa+Xg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056694;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jbI55Ucj/JPf6YljzPnGMdt0MAgjbOwyEG04xhXvlwQ=;
	b=xznYpMBaGHuksnZoqqucz4vgRBeou8ZJ1zeRLcDxt03MFx7SbOIxuS+H95q0GJb28lBO
	 B4gZX5wPUHYQBt0WC05O3thZEdmQ30RQTiB3XNiNEWT8tGo9zwCKphCSh4JACYwCRSdSB
	 gxpiQfU0W9NQ9M/i9TdToubQBI6mudknONVvB+nQ6GQw5d4BHsfn/BQrMNG/1UUFoRk10
	 0lc4qvEtseD3Z6zymo7bTNwZteXWXjZJTpOGvMzF7XwBgNMFMloCWMCtF+FkQGNmOAuG9
	 LjovUhIfoXG2en1FVwdLspXjjBGL6B1je9uHF6sFqM4bDH7wWHHDz7DSKYNmPTzqwGQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xVVG8wfV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85980606A32A;
	Thu, 19 Nov 2026 02:51:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xVVG8wfV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC2881F000C4;
	Thu, 19 Nov 2026 02:51:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056694;
	bh=jbI55Ucj/JPf6YljzPnGMdt0MAgjbOwyEG04xhXvlwQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xVVG8wfVxZK8tbiD6QX7kXa59fRsHvAUFbDmTZAe1lQZeeORYsTH0Bye5tB/K4+aW
	 xMuwqb/7XtXKlgsS33HCwdapmfLIRCWtCqnsCWkRLEODNhOwl6Ox8PEqGqw7M2SZ2b
	 lDBmAFlPQlvp+X2Kf1up1VOLpLX6QhbJ+yzX1e2o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Serhat Kumral <serhatkumral1@gmail.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 2038/2214] RDMA/srp: Avoid reading uninitialized has_port on srp_parse_in() failure
Date: Wed, 18 Nov 2026 16:01:54 +0100
Message-ID: <20261118150132.259482790@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Serhat Kumral <serhatkumral1@gmail.com>

[ Upstream commit 4b8f20dc8d25f575e8b8bb5abb09ab803a7e1a3f ]

srp_parse_in() returns -ENOMEM without initializing *has_port if
kstrdup() fails. Only check has_port when srp_parse_in() succeeds.

Fixes: bcef5b721568 ("RDMA/srp: Accept again source addresses that do not have a port number")
Signed-off-by: Serhat Kumral <serhatkumral1@gmail.com>
Link: https://patch.msgid.link/20261016211509.12973-1-serhatkumral1@gmail.com
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index a517869456119..fa2bfce5cb672 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -3469,7 +3469,7 @@ static int srp_parse_options(struct net *net, const char *buf,
 			}
 			ret = srp_parse_in(net, &target->rdma_cm.dst.ss, p,
 					   &has_port);
-			if (!has_port)
+			if (ret == 0 && !has_port)
 				ret = -EINVAL;
 			if (ret < 0) {
 				pr_warn("bad dest parameter '%s'\n", p);
-- 
2.53.0



