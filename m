Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E5BAFBE7
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:28:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A633AC433D2;
	Mon, 15 May 2023 17:28:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684171710;
	bh=869JPjm8BrTCNzpF2FJl580eYMjSJ9ykLkFepzB+MFc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uRYTy2FoqoUlW5D5hcyEmklPzv+KbAleKo2yus95UNqRgXCxHPx/WyPdeUNVimNYV
	 ruCbd+EzQyAOjn5eZPqQBFO3CpbC1qsNZtsmr/oWI91wM+PtmR/SsalmWUzUUYuYT7
	 z5YWCbOIaf2577VT9y6i3qMhObj5aef9fjtg29a0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Corentin Labbe <clabbe@baylibre.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 054/134] crypto: engine - check if BH is disabled during completion
Date: Mon, 15 May 2023 18:28:51 +0200
Message-Id: <20230515161704.950352944@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161702.887638251@linuxfoundation.org>
References: <20230515161702.887638251@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Corentin Labbe <clabbe@baylibre.com>

[ Upstream commit 4058cf08945c18a6de193f4118fd05d83d3d4285 ]

When doing iperf over ipsec with crypto hardware sun8i-ce, I hit some
spinlock recursion bug.

This is due to completion function called with enabled BH.

Add check a to detect this.

Fixes: 735d37b5424b ("crypto: engine - Introduce the block request crypto engine framework")
Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Stable-dep-of: 4140aafcff16 ("crypto: engine - fix crypto_queue backlog handling")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/crypto_engine.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/crypto/crypto_engine.c b/crypto/crypto_engine.c
index cff21f4e03e32..fecf6baaa4f7d 100644
--- a/crypto/crypto_engine.c
+++ b/crypto/crypto_engine.c
@@ -53,6 +53,7 @@ static void crypto_finalize_request(struct crypto_engine *engine,
 				dev_err(engine->dev, "failed to unprepare request\n");
 		}
 	}
+	lockdep_assert_in_softirq();
 	req->complete(req, err);
 
 	kthread_queue_work(engine->kworker, &engine->pump_requests);
-- 
2.39.2



