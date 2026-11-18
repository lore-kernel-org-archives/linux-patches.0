Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042141;
	b=macaX5oYpWNxohX+WSC8dSIl6btMtEwoimEwjVrzlfESUFS/1E5dqQXI/IyZdg2nZZVE
	 c9VK3ZlMBQ2+LxK8jvfiZzO4EyNIdNyN31fEKhoxBw8yjVKcyPL3mLbElc4j9FduH4RIo
	 EEqLkgU+3YAt0vTEOZ6gEcvh/6TILZfWEQZN9Vwy2rMK/79p3BbbbU5uQPqp54i7HV5N4
	 JMLq7VwE8ITpCbHGiR9lxlJ59sE/DhO7O0rJSsIfWm/QeDoVOsmj2gj/p0w/fr1JjKrVM
	 a22MARL/6FXnlrOJaysrMIYPDD06obY93ePAsIa0IKle6oijvIgFv8SDfVxZbPcFwBQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042141;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oDH78dV0tVuuhHsvtys2ETVxdccOMXhpuMhtKytcsDk=;
	b=Mgkg1MH01gcuxKrWTnrKvxJkuOUFuPljma+GMx++cXYmrlTj8fkGnc8tZ7MKDI0j9yOw
	 CpOAZf1dqZu1ZloDy5m+UKaO5VJUcdYzuK3Wot3c9f8oVvGK2WYKeqCjUSlmcGqmz9dFg
	 mit5OdZLfT1oLxEQ/ApEsn42cJRr+mKgTj0WMX56bMl6XGgo1qut/d05tHaQySMxbLJxu
	 6zIzFE94skjzZXUUjup7l7KdcXRDSSAcLXRgoz6x/HcNp4yMhrNUafbuWmS9SUv49nNlP
	 iu62AcHEfiirAh3liTCW8CvqsMlFrn7ObOnTdN88GE/d/IyMBWfcfHp9akDdnf0spCQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VzNsWw61;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02B9A606A320;
	Wed, 18 Nov 2026 22:49:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VzNsWw61
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 823301F000C4;
	Wed, 18 Nov 2026 22:49:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042140;
	bh=oDH78dV0tVuuhHsvtys2ETVxdccOMXhpuMhtKytcsDk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VzNsWw61/cm/1nWfWdZlxAibnRhydndM6J0VuCsJ9Ap6pZ21q4FV0OnQrOPwtJa1u
	 wXr4RodFMV2IhshKQ1X9E5TZ/LwlxD2l4c9OooCUo/C+oDAqUoOAcGmhb3icvbUe00
	 /OQlUzssqCZg4rqqwsFztAwV0aXjabjaPyZtfKQk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Serhat Kumral <serhatkumral1@gmail.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3027/3318] RDMA/srp: Avoid reading uninitialized has_port on srp_parse_in() failure
Date: Wed, 18 Nov 2026 16:00:49 +0100
Message-ID: <20261118150451.005492951@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 13eddbe0841aa..66679798355c2 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -3477,7 +3477,7 @@ static int srp_parse_options(struct net *net, const char *buf,
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



