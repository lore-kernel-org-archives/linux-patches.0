Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2B7D168AD
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:26:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40E49C4339B;
	Mon,  8 May 2023 10:26:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683541614;
	bh=8RvZ6CD/urFKyt593xqQj3UCzzjSscO1V/dj00aDjqU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W4plAL2a7QzPYGdb8oCwuJzWiuSLdRuLw5wQ4/r9Zv4abn4yMFVsXDq92FTP5eIh6
	 5ycx3vB8zEKfT3nwNegKJNxJ92s4C5WBwIXl6M9Qy8hi4WuRP+mFjbY55iLbFEpo1e
	 3b1nAui2HDHKy46cHIk10uRxFVako1JlTkm1NTAA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Frayer <nfrayer@baylibre.com>,
	Peter Ujfalusi <peter.ujfalusi@gmail.com>,
	Nishanth Menon <nm@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 139/663] soc: ti: k3-ringacc: Add try_module_get() to k3_dmaring_request_dual_ring()
Date: Mon,  8 May 2023 11:39:25 +0200
Message-Id: <20230508094433.032230140@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094428.384831245@linuxfoundation.org>
References: <20230508094428.384831245@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Nicolas Frayer <nfrayer@baylibre.com>

[ Upstream commit 5f1732a8683c1da8faaa90d6ffc3bd6d33013a58 ]

When the k3 ring accelerator driver has been modified to add module build
support, try_module_get() and module_put() have been added to update the
module refcnt. One code path has not been updated and it has introduced
an issue where the refcnt is decremented by module_put() in
k3_ringacc_ring_free() without being incremented previously.
Adding try_module_get() to k3_dmaring_request_dual_ring() ensures the
refcnt is kept up to date.

Fixes: c07f216a8b72 ("soc: ti: k3-ringacc: Allow the driver to be built as module")
Signed-off-by: Nicolas Frayer <nfrayer@baylibre.com>
Reviewed-by: Peter Ujfalusi <peter.ujfalusi@gmail.com>
Link: https://lore.kernel.org/r/20221230001404.10902-1-nfrayer@baylibre.com
Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/ti/k3-ringacc.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/soc/ti/k3-ringacc.c b/drivers/soc/ti/k3-ringacc.c
index e01e4d815230a..8f131368a7586 100644
--- a/drivers/soc/ti/k3-ringacc.c
+++ b/drivers/soc/ti/k3-ringacc.c
@@ -406,6 +406,11 @@ static int k3_dmaring_request_dual_ring(struct k3_ringacc *ringacc, int fwd_id,
 
 	mutex_lock(&ringacc->req_lock);
 
+	if (!try_module_get(ringacc->dev->driver->owner)) {
+		ret = -EINVAL;
+		goto err_module_get;
+	}
+
 	if (test_bit(fwd_id, ringacc->rings_inuse)) {
 		ret = -EBUSY;
 		goto error;
@@ -421,6 +426,8 @@ static int k3_dmaring_request_dual_ring(struct k3_ringacc *ringacc, int fwd_id,
 	return 0;
 
 error:
+	module_put(ringacc->dev->driver->owner);
+err_module_get:
 	mutex_unlock(&ringacc->req_lock);
 	return ret;
 }
-- 
2.39.2



