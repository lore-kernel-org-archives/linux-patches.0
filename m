Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFCF28489
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:18:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7575EC433D2;
	Fri, 10 Mar 2023 14:18:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678457902;
	bh=JwiaiJePlYKy+Z6LmfFH7t3aPBmB+Po3NczqPZBfy58=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H6IniPwiv7rGQ8tmm5V1FZ1cC0j1Qd8SqLgc9Di2+cmCNHJUCwwpLYf2m+Gi3rPTX
	 LBH3Dw2YiVDKgJb0i293AYNHPDalxFxj6yvpal0Zcskw7wRoYIc/4LXNWGVY5/GWQN
	 btVXxxmEUW7++dwZ0YoKe82hGoAhXInQtwaEPE5E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiheng Lin <linqiheng@huawei.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 098/252] mfd: pcf50633-adc: Fix potential memleak in pcf50633_adc_async_read()
Date: Fri, 10 Mar 2023 14:37:48 +0100
Message-Id: <20230310133721.784634885@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.803482157@linuxfoundation.org>
References: <20230310133718.803482157@linuxfoundation.org>
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
index c1984b0d1b652..a4a765055ee6b 100644
--- a/drivers/mfd/pcf50633-adc.c
+++ b/drivers/mfd/pcf50633-adc.c
@@ -140,6 +140,7 @@ int pcf50633_adc_async_read(struct pcf50633 *pcf, int mux, int avg,
 			     void *callback_param)
 {
 	struct pcf50633_adc_request *req;
+	int ret;
 
 	/* req is freed when the result is ready, in interrupt handler */
 	req = kmalloc(sizeof(*req), GFP_KERNEL);
@@ -151,7 +152,11 @@ int pcf50633_adc_async_read(struct pcf50633 *pcf, int mux, int avg,
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



