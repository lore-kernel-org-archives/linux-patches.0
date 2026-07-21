Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2557F1D7E5C;
	Tue, 21 Jul 2026 20:29:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665749; cv=none; b=nB04aryjVYYAja9fmoLM/RXNpMaeobYZVh6AKk1N7MWSQTzBzplTi0wQk0jK3j1HVk/xKacpENpprrJWcdJqRxIrLJ2TuVumpnLl5b3RfoebxkTnwT4PDr8JdICNEUkbcvHi9xTtru7UDhx7odz1ZQ5Qdz6OCwCFhE8+2bj8o8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665749; c=relaxed/simple;
	bh=oJZGCzJYtebs05PWUkSFnq95EBed2qUqrY9U3+TYaAA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uNOoUE/Jm04JZYPA8mVyEIQ7qFKwH2A17E62YH6Bojxbm4AkEKQDa4Mo+meEqAwfciWAPJAJ1W43RkxZdGmAbUUKnM+wq3id1r5NEfYixi93UFWpxegRUWYgXpuQyNqWMssyeGNNfvn+swYWO02H25U5G/Nl9lsfWAmEq7g66BI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RKz/vkMn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RKz/vkMn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AA0A1F000E9;
	Tue, 21 Jul 2026 20:29:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665748;
	bh=pwV/UUpnU6VvPNaPLMWOSR19nBfszHZIDhLt7lPkTPI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RKz/vkMnk6Th6C8/m//2j4nc6srPzLxvRCd/Ys/TpOmCsweMDHHmmu3KG5G/AtNiN
	 QsP5h45T2aIXNjTXRx159O745rdf4tTwCdLGZULdYeLsvAMKP5ivSSC9zQ+Cv6dFby
	 c3/Cito/x950L80IIzcKGt+fFERuCS4zcR24W07E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Yuwei <zhangyuwei20@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0422/1266] driver core: Use mod_delayed_work to prevent lost deferred probe work
Date: Tue, 21 Jul 2026 17:14:19 +0200
Message-ID: <20260721152451.282910458@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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
index 44f9d0a06d5b70..115b24d5e73d1c 100644
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



