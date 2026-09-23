Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1B8D492E5C;
	Wed, 23 Sep 2026 14:29:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173780; cv=none; b=mcvzzmijAaKG6D8woRU9yvnyfp3SAA4D9UZGCleqzeX9poR87Ixab4UT57ZyMXyNAA+yIAi6Dm0m7Kb1gFRWpDKJ30VaEta2C86bhaQbR4Uic+V4Im/hfiH1zKvtv1gYOqwLTH+VDLvJVUKUAgT9EgD9X6LWhuGt6sWSbhT3aTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173780; c=relaxed/simple;
	bh=dn7jupPSfDjnRjSPR9ZemJvoDzXt1lbj5PLr8LM2Mog=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FrIW76RY6yNgvsH/8HAbDnrlD6C+rpgC60GkS3rdbLatlM7KiVbgdtWsIHcI3QcnYOiH2h12DyCj2Igc3l5cdyBO/IZmHL7tbs00iWYzKN2ULEQztzwgfpLj0Jl65qaHvbH4Dw2LK+I6rjz3oosyXME7FRWc5LeSRJEI8wEaMkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RvkGqZhT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RvkGqZhT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDF601F000FF;
	Wed, 23 Sep 2026 14:29:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173777;
	bh=XBffoSSGRxhlVwD11jCwhsfEZn6fMJoWTo3X9Q8c134=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RvkGqZhTTPnlo8zyHbQK0LSCiceJa+zSTSSH81S9p/f24J/bKDui1dzuep8Uuw/Nl
	 e+NcM75iPxZTzM+aHW1iVaba9Bp2SP1hQqjA23Pggm098IQQZyE7iFzLGISBNZ1cOg
	 xPbvbq22vilGt89WlcCX1+xOW38jXcEwYaorqG1w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Wu <fanwu01@zju.edu.cn>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 7.2 341/438] mmc: hsq: Fix use-after-free in retry work
Date: Wed, 23 Sep 2026 16:06:02 +0200
Message-ID: <20260923140653.655527614@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -345,6 +346,7 @@ static const struct mmc_cqe_ops mmc_hsq_
 
 int mmc_hsq_init(struct mmc_hsq *hsq, struct mmc_host *mmc)
 {
+	int ret;
 	int i;
 	hsq->num_slots = HSQ_NUM_SLOTS;
 	hsq->next_tag = HSQ_INVALID_TAG;
@@ -363,7 +365,11 @@ int mmc_hsq_init(struct mmc_hsq *hsq, st
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
 


