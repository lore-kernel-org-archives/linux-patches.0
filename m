Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4025E46D545;
	Tue, 21 Jul 2026 15:44:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648650; cv=none; b=Af04rH8lmyiUJ9fmxEQ8Ndh0L5DNuHvRXzOUJPBsBENJYLVHHH/epYuVodApHqqfzxk+OdsbqK3YH/O5YEIw1TxoNF4mm7dJzVOPR9OLXvJ8cin43Y8no6Ezy68Tf9xpB1guwPHEl8sDYR9qHfbm2HK74fAAJ8k4+9iifuYWQSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648650; c=relaxed/simple;
	bh=AhUCe/IC4EJnW2dH0Aj8G/kQoF8CkweP4A1Uf8g0K0Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q2ph7W2NkQvYSvNL7uMlZCDF+K9WsGDIGQyRdlT3Y3gOHUPEWEeFZD5NRr+ZDiUayQAGMZ2uVIWyLF+rziiH4TqA6x8uMVzaVOyg1b5LYJLxc0mHv2hFtb/tvWmqjKjVndXCl0osfh7ZsxhXFaeeyc1vIHr+39AsS6kfkMmblGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uHtpB1fN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uHtpB1fN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5D581F000E9;
	Tue, 21 Jul 2026 15:44:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648648;
	bh=YamixvfP7c1Sm2dcQhPCPrkhTgCVl3jofzVFZgr3j3I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uHtpB1fNdtqVIJX0d25PHg5paefpUv9RMHunvK7M6taoMpBYKoMJra1f+MqVQcTsP
	 sdnhHN0xa1+YJecOeYEC3iv5L+sjBSSq4zhD701ZvJkyZL/6rRS+BHser6OYd64uPp
	 ybmGOvkszfJQstyPivbojDwoONuB7322uroyS5GU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Yuwei <zhangyuwei20@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0280/2077] driver core: Use mod_delayed_work to prevent lost deferred probe work
Date: Tue, 21 Jul 2026 16:59:13 +0200
Message-ID: <20260721152559.285282330@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 1dc1e3528043c3..3523a5d8ec5030 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -323,12 +323,10 @@ void deferred_probe_extend_timeout(void)
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



