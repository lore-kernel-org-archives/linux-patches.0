Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C37A344AB9E;
	Tue, 21 Jul 2026 21:20:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668827; cv=none; b=LU/Fm2f2+OfqcnjTTKm1JcbmaY3Zu8OdcMStqQBA41MeDfj0vVTqPCy2O6e57CNW8+Gor/g7kgI0txQ2W2WrF8C4exykaP/oakb1uxZG3MZm6FZ7S3S+SWGFowv+KlU7EBbulel375OLtW7pGzZKFZcp94gmPdbJyUD3Yt2rpEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668827; c=relaxed/simple;
	bh=LfGNx+jL2DD4b5K4ysp4gVEUAKHJv+6msCirZvoFfZM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UcUv6aWEbywFvSiE0AdtB5WTHXPXpUwR0bODukbVZ/el+TZWusAcz2FFa3OJfqTXTLKiabFfurqtSypCaAJl5xtdqNwXXJ1hVBqB9ScASVJpadzvtsFpPux82uTnD5LlOpfY6x3VicIFecdo5JzEHOybYDbQ5xGKO1i+WVDuDsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tPLClKYa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tPLClKYa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3580A1F000E9;
	Tue, 21 Jul 2026 21:20:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668826;
	bh=G35ZDJ649V0RzbHf+EFmFl07pyY+FJfimWSZsLoPUGI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tPLClKYaFriW/e3aMPrntIOhP8AbpX2hvRAQ+V8cXuleGNzbPbixnxJoyETdGjUkQ
	 FyHWSN402x9FfJEoe0Q07TX6coz4Ul8oHu0E5j2nJ3oBDjCidt1IP9I1z/YTHCI8fv
	 QhmRCZf5uwM+zdKqirYHWs3w/oKD9bdyEQn68ZTE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Yuwei <zhangyuwei20@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0322/1067] driver core: Use mod_delayed_work to prevent lost deferred probe work
Date: Tue, 21 Jul 2026 17:15:23 +0200
Message-ID: <20260721152431.796284546@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Yuwei <zhangyuwei20@huawei.com>

[ Upstream commit 1137838865bfc9a7cd5869c1dc5c22aa45ec12c8 ]

The deferred_probe_timeout_work may be permanently and unexpectedly
canceled when deferred_probe_extend_timeout() executes concurrently.
Starting with deferred_probe_timeout_work pending, the problem can
occur after the following sequence:

  CPU0                                 CPU1
deferred_probe_extend_timeout
  -> cancel_delayed_work() => true
                                   deferred_probe_extend_timeout
                                     -> cancel_delayed_work()
                                       -> __cancel_work()
                                         -> try_grab_pending()
  -> schedule_delayed_work()
    -> queue_delayed_work_on()
(Since the pending bit is grabbed,
 it just returns without queuing)
                                         -> set_work_pool_and_clear_pending()
                                  (This __cancel_work() returns false and
                                     the work will never be queued again)

The root cause is that the WORK_STRUCT_PENDING_BIT of the work_struct
is set temporarily in __cancel_work() (via try_grab_pending()). This
transient state prevents the work_struct from being successfully queued
by another CPU.

To fix this, replace the original non-atomic cancel and schedule
mechanism with mod_delayed_work(). This ensures the modification is
handled atomically and guarantees that the work is not lost.

Fixes: 2b28a1a84a0e ("driver core: Extend deferred probe timeout on driver registration")
Signed-off-by: Zhang Yuwei <zhangyuwei20@huawei.com>
Link: https://patch.msgid.link/20260410024448.387231-1-zhangyuwei20@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/dd.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index 1c6f266f9367f6..5364bf331421e6 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -326,12 +326,10 @@ void deferred_probe_extend_timeout(void)
 	 * If the work hasn't been queued yet or if the work expired, don't
 	 * start a new one.
 	 */
-	if (cancel_delayed_work(&deferred_probe_timeout_work)) {
-		schedule_delayed_work(&deferred_probe_timeout_work,
-				driver_deferred_probe_timeout * HZ);
+	if (mod_delayed_work(system_wq, &deferred_probe_timeout_work,
+						 driver_deferred_probe_timeout))
 		pr_debug("Extended deferred probe timeout by %d secs\n",
 					driver_deferred_probe_timeout);
-	}
 }
 
 /**
-- 
2.53.0



