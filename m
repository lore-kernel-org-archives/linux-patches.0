Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97D3113B293;
	Tue, 27 Feb 2024 13:38:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041088; cv=none; b=syRbEFOfF3mfsen5PqJCxibKtW362GoejtYis6j7f81pDijzh8DFLspfnow7MbWq0T294+4vEo08/1FBoM/4We7m2po/oACzK+2xoCRp8iooqfJi8f1m7pLTtKs8l0lUjAqJq1dLcn2XrWACyJ8Mw8Q0fey9oA2ipabL51G633E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041088; c=relaxed/simple;
	bh=fyhGqPg1jBkv9HQGtmCfD0NkuEfJBWsNOHmTXr/xaO8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d0IST2NlIcYvHGnsGz7j4KiuTcP9R/jfnKnYSyl7NkaMp7XjbzlOWeoB6Xfy8brLM1/D5LwhcpvKGcWDXB/aYLDpwAl7rTLllgD5q7/XHmdiXtpierFRWlyGaAH5o6MUMN0YcUsRPgv+U4rHFYeHS8cdlmk+65CpmlFh+ItMrQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I0MacTZo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I0MacTZo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9583C43390;
	Tue, 27 Feb 2024 13:38:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041088;
	bh=fyhGqPg1jBkv9HQGtmCfD0NkuEfJBWsNOHmTXr/xaO8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I0MacTZokTpmsnBiVu1irhzskEIuFioXJ+vFvlELQh0/fExQG59dlfXV5cRDsmljA
	 5cdbf895e7UxDN4W7pTPMx3YnEbGOf6sLzP/FWwHV9hNTnoWd+iPZygqVdCayId9Zq
	 e4z1Xh7+5lYKGfHfOKxqdVzSzk2Jl08Womc6Fj6Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Song Liu <song@kernel.org>
Subject: [PATCH 6.7 186/334] md: Dont suspend the array for interrupted reshape
Date: Tue, 27 Feb 2024 14:20:44 +0100
Message-ID: <20240227131636.666231084@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yu Kuai <yukuai3@huawei.com>

commit 9e46c70e829bddc24e04f963471e9983a11598b7 upstream.

md_start_sync() will suspend the array if there are spares that can be
added or removed from conf, however, if reshape is still in progress,
this won't happen at all or data will be corrupted(remove_and_add_spares
won't be called from md_choose_sync_action for reshape), hence there is
no need to suspend the array if reshape is not done yet.

Meanwhile, there is a potential deadlock for raid456:

1) reshape is interrupted;

2) set one of the disk WantReplacement, and add a new disk to the array,
   however, recovery won't start until the reshape is finished;

3) then issue an IO across reshpae position, this IO will wait for
   reshape to make progress;

4) continue to reshape, then md_start_sync() found there is a spare disk
   that can be added to conf, mddev_suspend() is called;

Step 4 and step 3 is waiting for each other, deadlock triggered. Noted
this problem is found by code review, and it's not reporduced yet.

Fix this porblem by don't suspend the array for interrupted reshape,
this is safe because conf won't be changed until reshape is done.

Fixes: bc08041b32ab ("md: suspend array in md_start_sync() if array need reconfiguration")
Cc: stable@vger.kernel.org # v6.7+
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Song Liu <song@kernel.org>
Link: https://lore.kernel.org/r/20240201092559.910982-6-yukuai1@huaweicloud.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/md.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -9424,12 +9424,17 @@ static void md_start_sync(struct work_st
 	bool suspend = false;
 	char *name;
 
-	if (md_spares_need_change(mddev))
+	/*
+	 * If reshape is still in progress, spares won't be added or removed
+	 * from conf until reshape is done.
+	 */
+	if (mddev->reshape_position == MaxSector &&
+	    md_spares_need_change(mddev)) {
 		suspend = true;
+		mddev_suspend(mddev, false);
+	}
 
-	suspend ? mddev_suspend_and_lock_nointr(mddev) :
-		  mddev_lock_nointr(mddev);
-
+	mddev_lock_nointr(mddev);
 	if (!md_is_rdwr(mddev)) {
 		/*
 		 * On a read-only array we can:


