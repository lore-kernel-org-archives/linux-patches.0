Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032384;
	b=j1nIRdgB8a+z4xQr7YkJdtvyx2BrVpy7fVtd+I9w56mXxfvwJfBkLdaxDnbzBdHKIn+A
	 PJ94lrZtTR+DX607bkeksbhTuQMcYb0/sP86ZpEmXfWt1t1CQxKyoMCPg1Oq9YxJVDI/N
	 Y9rM1gln/Cmiy0pnMfwKlJpRewVgATDciM5TmiI6lsYXoc6vw8PXHhzg68Nyxk0dr0uJe
	 5L14NGcAdyOQsuVHdILqkZcKPWLPpht8zMnV/Y0UCpKKDbdpoO48eenKUI9qevr4oxgQU
	 f304NYs/Io+64jFVU+wckMZRpznMbdI3m5Qinh6SmR/OZjvd6daVFw4PKtuOQ30aPqw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032384;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TZQY1E9PL5wLwImcnvrb1LYl1KoEN6wadeXMnWirTv8=;
	b=IRJ0EeVVsMZbsCcrjZzs8mawmGvldnqZsN7jI3s0KZxF+vPPxlUjNck1WKmTAEo11pz1
	 S5O9p6b+G9Qgznj33vJz6DCC2whPmWapsYZp8KWjRWr57L4v3+bQUXoQ5GJ1UhiWY2KBP
	 kFZOVj6XGn5xaE2398ghQ22dzh1Gpjd6emSxFVjg5oiYxVoDw1TzbBy2XXLYnZVwGksAn
	 jqimmqgv8Y8Aa3Xc27w2g+gw//5qLaySALnYKWHtLXbek2Vo7TXZpdBYAu7Kn3wVbbPED
	 AznmGVQmgbGgXCYMou/FIPzOr4Xv+Zl9BqFODyK8UYolbK/ZsXkVArwsyrcJHIKq/YQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SMQig6sw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 238E1606A32F;
	Wed, 18 Nov 2026 20:06:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SMQig6sw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 433451F000C7;
	Wed, 18 Nov 2026 20:06:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032383;
	bh=TZQY1E9PL5wLwImcnvrb1LYl1KoEN6wadeXMnWirTv8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SMQig6sw35GesP0tHRXhdiXpmp1BvjS5JYQrYP8Y295Bd+Xzls6iG8cZiT1hXGsaQ
	 LAKFdPIlf0Z4NCWO5oc00aDuBlu216viO6KaQWG7jtuse8d/RXg/ozBptoDYEzqf2E
	 etfqAxaD/i+ECa1xiP4+TSXEYD+uAaECeptlJZ2k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Serhat Kumral <serhatkumral1@gmail.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1393/1756] RDMA/srp: Avoid reading uninitialized has_port on srp_parse_in() failure
Date: Wed, 18 Nov 2026 15:58:40 +0100
Message-ID: <20261118150104.598196841@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



