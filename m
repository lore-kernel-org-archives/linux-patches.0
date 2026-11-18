Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043972;
	b=eC3uG0TURSa36C4HWY1O4LhdIF+aHf41d0jMZprPHJuc0NA9biU54QJeHli2sqg41QPW
	 Jm0pfnweGDJXYcnumUvdVSx9Ky96cym73qFLkxHBS1LXguQVDhNQMQvSEwtQMD+2Wk75T
	 rUUuw1bIbsB3BdcHNph9UoZkXFuBiTP1RYceoY6bwyqWevdGSpiFN0HNMoQhuHAKp1Btz
	 ruskK91gf0T8RWMeh0v85S1xJwKkLn1hUBLPY10Id2ehUX+U637JdyTCQu+QuxHpKL6IG
	 pQB6UYAn0/fygm3oZrUkkbPvtCzglh2A3F92ESSaV8wb66tGkN35mFIhBAzSAepiM+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043972;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jc8Q/1dow5zg4ZraKHAOsrZsWqHYuSUcHzqt7crC4Qw=;
	b=xQzo4OV0sbmS7ECHIxjB6iqAskUJ91i7TnkbwwYqDmVi/ssUETDRXmkjf0yVnc2cN9aV
	 lvkPdP9qOZeNL4iGIGZvrIu3iYJAU8/qgE4fBApIV7NRzEvBXIzOXJny6W91tgAZs8no0
	 XAbhBPqu4k/wyWl/dqpDvsakcE5ixoJbr+5N4OTcKfhcnof9KT/Tv/Awig4h2rw9bHHfu
	 yTRHMaaNAp4bIcvhhtQSmeomujfTTRAXgKDjJw9rfnKBCq4eeWgiqGCi9d+LOMDBrvNZj
	 msC8uDCRTuUROjvplYF22YtD81Sc1c4rbhzXKfV6nCQmLSZHm3Y7fRTPWzxCMoGq96Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PAtOcVYv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90D3A606A320;
	Wed, 18 Nov 2026 23:19:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PAtOcVYv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 985281F000C4;
	Wed, 18 Nov 2026 23:19:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043972;
	bh=jc8Q/1dow5zg4ZraKHAOsrZsWqHYuSUcHzqt7crC4Qw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PAtOcVYvOP8AOlUNIqersJvrCoq89wrGhOwv0owhfi64Kyd7eR5C2He3ffBQLVPNM
	 gSnipzXPaJsATMhmpLbDxveF3AZ6mADawhEUb99+9dtcgp5MAcyRdhXNVNkEpWsp2A
	 DNli8aaJPz4CsIwW6OToCXb77qViyB/zVECV1188=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Wu <fanwu01@zju.edu.cn>,
	Ulf Hansson <ulfh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0400/2857] mmc: hsq: Fix use-after-free in retry work
Date: Wed, 18 Nov 2026 15:23:54 +0100
Message-ID: <20261118150215.791657795@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fan Wu <fanwu01@zju.edu.cn>

[ Upstream commit 5d132990475f02cfa1debe03d50b479432864ebd ]

mmc_hsq_pump_requests() queues retry_work when request_atomic() returns
-EBUSY; today sdhci-sprd is the only consumer that implements
request_atomic(). The work is embedded in a devm-allocated mmc_hsq, but
is never cancelled during driver removal. Work still pending at unbind
can therefore run after the devm allocation has been released and
dereference hsq->mmc and hsq->mrq.

Use devm_work_autocancel() to cancel and drain retry_work before the devm
allocation is released. By the time devres cleanup begins,
mmc_remove_host() has already stopped the host, so no new requests can
arm the work.

This issue was found by an in-house static analysis tool.

Fixes: 6db96e5810e0 ("mmc: host: Introduce the request_atomic() for the host")
Cc: stable@vger.kernel.org
Assisted-by: Codex:gpt-5.6
Signed-off-by: Fan Wu <fanwu01@zju.edu.cn>
Signed-off-by: Ulf Hansson <ulfh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/mmc_hsq.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/mmc/host/mmc_hsq.c b/drivers/mmc/host/mmc_hsq.c
index 424dc7b07858f..473aa02973d65 100644
--- a/drivers/mmc/host/mmc_hsq.c
+++ b/drivers/mmc/host/mmc_hsq.c
@@ -7,6 +7,7 @@
  * Author: Baolin Wang <baolin.wang@linaro.org>
  */
 
+#include <linux/devm-helpers.h>
 #include <linux/mmc/card.h>
 #include <linux/mmc/host.h>
 #include <linux/module.h>
@@ -324,6 +325,7 @@ static const struct mmc_cqe_ops mmc_hsq_ops = {
 
 int mmc_hsq_init(struct mmc_hsq *hsq, struct mmc_host *mmc)
 {
+	int ret;
 	int i;
 	hsq->num_slots = HSQ_NUM_SLOTS;
 	hsq->next_tag = HSQ_INVALID_TAG;
@@ -341,7 +343,11 @@ int mmc_hsq_init(struct mmc_hsq *hsq, struct mmc_host *mmc)
 	for (i = 0; i < HSQ_NUM_SLOTS; i++)
 		hsq->tag_slot[i] = HSQ_INVALID_TAG;
 
-	INIT_WORK(&hsq->retry_work, mmc_hsq_retry_handler);
+	ret = devm_work_autocancel(mmc_dev(mmc), &hsq->retry_work,
+				   mmc_hsq_retry_handler);
+	if (ret)
+		return ret;
+
 	spin_lock_init(&hsq->lock);
 	init_waitqueue_head(&hsq->wait_queue);
 
-- 
2.53.0



