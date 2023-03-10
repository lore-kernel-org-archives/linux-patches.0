Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C03738821
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:55:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03771C433EF;
	Fri, 10 Mar 2023 14:55:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678460120;
	bh=IvegPonRFZ27fozfMfL+WMmN/6XRuSp+MW08wHsAWew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QmDHroJDFbyk4QqMOur7CO9s6118SxEI5L6BcUlpO5NQG513+d+7V27cb1BY7qVjt
	 /DVzMopTAyCMNBiRvPvQdCy6FTOFu1QTurYULYg2I9JnLdwPL84SAWGQRyxkXMFcAr
	 KQsG6lyTVnLwSkW0UOm2Iui1TEUhJ5rUQaFsjtnw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiheng Lin <linqiheng@huawei.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 230/529] mfd: pcf50633-adc: Fix potential memleak in pcf50633_adc_async_read()
Date: Fri, 10 Mar 2023 14:36:13 +0100
Message-Id: <20230310133815.656377748@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Qiheng Lin <linqiheng@huawei.com>

[ Upstream commit 8b450dcff23aa254844492831a8e2b508a9d522d ]

`req` is allocated in pcf50633_adc_async_read(), but
adc_enqueue_request() could fail to insert the `req` into queue.
We need to check the return value and free it in the case of failure.

Fixes: 08c3e06a5eb2 ("mfd: PCF50633 adc driver")
Signed-off-by: Qiheng Lin <linqiheng@huawei.com>
Signed-off-by: Lee Jones <lee@kernel.org>
Link: https://lore.kernel.org/r/20221208061555.8776-1-linqiheng@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/pcf50633-adc.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/mfd/pcf50633-adc.c b/drivers/mfd/pcf50633-adc.c
index 5cd653e615125..191b1bc6141c2 100644
--- a/drivers/mfd/pcf50633-adc.c
+++ b/drivers/mfd/pcf50633-adc.c
@@ -136,6 +136,7 @@ int pcf50633_adc_async_read(struct pcf50633 *pcf, int mux, int avg,
 			     void *callback_param)
 {
 	struct pcf50633_adc_request *req;
+	int ret;
 
 	/* req is freed when the result is ready, in interrupt handler */
 	req = kmalloc(sizeof(*req), GFP_KERNEL);
@@ -147,7 +148,11 @@ int pcf50633_adc_async_read(struct pcf50633 *pcf, int mux, int avg,
 	req->callback = callback;
 	req->callback_param = callback_param;
 
-	return adc_enqueue_request(pcf, req);
+	ret = adc_enqueue_request(pcf, req);
+	if (ret)
+		kfree(req);
+
+	return ret;
 }
 EXPORT_SYMBOL_GPL(pcf50633_adc_async_read);
 
-- 
2.39.2



