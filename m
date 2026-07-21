Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0146646D57D;
	Tue, 21 Jul 2026 17:47:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656048; cv=none; b=UsnFzl7Vs+d3GZ+uxolscyBU8ouEsMvq3NyOR6fRx03D/75pGWkjGLg1zIc/odSV3Bw1CKoRy/53RUvz3BkZNoyx+MZsuwlOKAGp5hh6nAUjK0oER3l0h6xornpHQIwD6MXKeDqVJoCzSuJly+gn0nmqwoRzBjGhpkYxfC26i/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656048; c=relaxed/simple;
	bh=m1VUAaJ85ugLazt+tl7O4S5+CjHyQWeSjv+1FLgw5P4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N8Yz4UFgNq6V1Nz/M4HJzBjnB0ThyrgCbCyz0J8axR286dB2fsyeI6zIFJrQ2p6JZOueyRWzHQHYJhn3n+BrOZatZ/s6jsprxoQtZ4PPpaqTQOw92Uf9VlZrUABQHRcPPv3wJW/jRxhJHOPS0X0zvc9fnLEpEoy0qUEgZJzKBEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K/aC1pW+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K/aC1pW+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31D9E1F00A3A;
	Tue, 21 Jul 2026 17:47:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656046;
	bh=w2FXPQp4dsn6DOcclIKebbmCoE+mA3w7cWJmIfZpLZc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K/aC1pW+paVyAqV6lpMKQZLTHTnAsdnFCqUk9QK3M2m5GZowfqZj8NeyBoA4mHlry
	 22Nexurs5EU+TbCN/gsBNmFU8Kxz6evyOx6KcjIdILd0OLvf/7D9OuiJwDdt8p4diL
	 vdA4NzD+NE1FCCjMnZ/GefED1+Qx+DPd6T4SPrHw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Yuwei <zhangyuwei20@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0196/1611] driver core: Use mod_delayed_work to prevent lost deferred probe work
Date: Tue, 21 Jul 2026 17:05:12 +0200
Message-ID: <20260721152519.356237622@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 2c3a610f52a749..c42643e26e28af 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -327,12 +327,10 @@ void deferred_probe_extend_timeout(void)
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



