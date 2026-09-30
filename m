Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F150A36826E;
	Wed, 30 Sep 2026 19:26:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796362; cv=none; b=sLc21woATkzt9zhYIR/gjp9TPdo/rKpdNUv30vrRWUvRsihgVJnaVkmLvJkPnfUHZiIQSuAiJAIbqsXAvmkQPGrvzG1YFiyadD7MoCpXJiXtRqDtGBJshmIi7u+K/JMNXWrDjAArsEVcxNBQF91E2DjDDAM/rWBfkOQrp5rrmdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796362; c=relaxed/simple;
	bh=5El2E15xbXgDRPidCU7bv/fY+B3nEMLuuFDkTuTjRvE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MxSjZ0Kea6yCmbTiSkrpM467pPNmD/7HEtr5ClIxWeVkbv8mmEAFHhg+4r28f21kB1/kdhNt7iML4AxfJIwfJP72EDwD9jDD9kBnyuCoZRngrseHw0R7v1PqeZJBpn9D/tlSWBlif+LhnbDcbII64156EDOSEO1E56pI9MnxxjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FD0dy2Pq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FD0dy2Pq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09D561F000FF;
	Wed, 30 Sep 2026 19:25:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796360;
	bh=4pGrBExenMYtHHqhH+RDbOuKOYz/A8gNcVhx3x8BEXw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FD0dy2PqF0FEg6U7L+usXLZ7IGcP/Aay0SPJ4GM4FZSOenjxaA50B0noY0U+A+wwj
	 ULkvaAdxGwGkYq5HzaGNrx/+7byLqGiqnHHtJPyFdwTY34HUN9uyHVWILDS+eIhKJD
	 +BqB55o1SOf8oh8bLtOc2hDDZIbq1vA0La9vDp0Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Wu <fanwu01@zju.edu.cn>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 6.6 0885/1193] mmc: hsq: Fix use-after-free in retry work
Date: Wed, 30 Sep 2026 17:26:09 +0200
Message-ID: <20260930152453.908907940@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fan Wu <fanwu01@zju.edu.cn>

commit 5d132990475f02cfa1debe03d50b479432864ebd upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/mmc_hsq.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/mmc/host/mmc_hsq.c
+++ b/drivers/mmc/host/mmc_hsq.c
@@ -7,6 +7,7 @@
  * Author: Baolin Wang <baolin.wang@linaro.org>
  */
 
+#include <linux/devm-helpers.h>
 #include <linux/mmc/card.h>
 #include <linux/mmc/host.h>
 #include <linux/module.h>
@@ -324,6 +325,7 @@ static const struct mmc_cqe_ops mmc_hsq_
 
 int mmc_hsq_init(struct mmc_hsq *hsq, struct mmc_host *mmc)
 {
+	int ret;
 	int i;
 	hsq->num_slots = HSQ_NUM_SLOTS;
 	hsq->next_tag = HSQ_INVALID_TAG;
@@ -341,7 +343,11 @@ int mmc_hsq_init(struct mmc_hsq *hsq, st
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
 


