Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3817D42047A;
	Thu, 30 Jul 2026 14:50:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423024; cv=none; b=D5X+lZ72UfL/3unLLMW154vvCtxNL1hSjC2d/9/3xWhTC50W7Z7VSFgUIozCYsJ+8qbSb3UhPZh86i4JjSmRJW2vvKVh6x3HQdVOseT33enVJnjM9h6jfJqxEzr9J93p0HTnuIq9Rt1PeVGvXtV2HHsdQByKk7aoPOkiUMX4EoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423024; c=relaxed/simple;
	bh=mPURS9jdtkATQqyFezC8QQzO1E7yWnvgHpVCk9HKLbQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a4yUmu7bhzOuJoz0CVdA3elVuSx5fIMCSjMDFjALbIIDbSPdSPoOuNQaaqeIIMfjnSaFs3Okw+VAD3g1X+oz54dV7wS0HJFBCaISkT10wGxdtSpzTXwODz1IwsMSS7FRQ7mxz5YU8votg1QxFiFCmBJqXvcCS52U17c9qxYTdlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aBOb8Nlu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aBOb8Nlu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 926B41F000E9;
	Thu, 30 Jul 2026 14:50:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423023;
	bh=3Vsa6GiPmuddetefbDIVOyemQaNWjTZo2PUpwOIUrkg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aBOb8Nlu6QGnjjQEADs6A20mRAj8BD7HhkzN+jzgrRnzMz/dqIWktRhB/snhonoOk
	 SvKmSF08JMDVY2aOaZieLW9HtE9skpa3XbywkPKrDo3D144gKTRfrpZsQ6g3BnU+qP
	 5S+a5pX6zN90Hjv1dMTrCWOWq+C9zizhmi2t3H6o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shihuang Liu <shlomojune6@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Taehee Yoo <ap420073@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.1 638/744] amt: fix use-after-free in AMT delayed works
Date: Thu, 30 Jul 2026 16:15:11 +0200
Message-ID: <20260730141457.832557279@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

From: Shihuang Liu <shlomojune6@gmail.com>

commit ea20c44935d6142daecfa9b39d635033a7553e1b upstream.

When an AMT device is removed, pending delayed works can still access
the freed amt_dev structure, which may result in kernel crashes or
memory corruption.

amt_dev_stop() cancels req_wq and discovery_wq with
cancel_delayed_work_sync(), but these works can be scheduled again
from event_wq after the cancellation. This allows delayed works to
access the freed amt_dev structure after the netdev has been released.

The following is a simple race scenario:

CPU0                         CPU1

amt_dev_stop()
cancel_delayed_work_sync()
                             amt_event_work()
                             mod_delayed_work(req_wq)
free netdev
                             req_wq accesses freed amt_dev

Use disable_delayed_work_sync() in amt_dev_stop() to prevent req_wq and
discovery_wq from being queued again and wait for running work items
to complete.

The delayed works are disabled after initialization in
amt_newlink() and enabled only when the device is successfully opened.
This keeps the delayed work lifecycle synchronized with the lifetime
of the AMT device.

Fixes: cbc21dc1cfe9 ("amt: add data plane of amt interface")
Cc: stable@vger.kernel.org
Signed-off-by: Shihuang Liu <shlomojune6@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Taehee Yoo <ap420073@gmail.com>
Link: https://patch.msgid.link/20260722113919.7723-1-shlomojune6@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/amt.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

--- a/drivers/net/amt.c
+++ b/drivers/net/amt.c
@@ -3034,9 +3034,15 @@ static int amt_dev_open(struct net_devic
 	amt->event_idx = 0;
 	amt->nr_events = 0;
 
+	enable_delayed_work(&amt->discovery_wq);
+	enable_delayed_work(&amt->req_wq);
+
 	err = amt_socket_create(amt);
-	if (err)
+	if (err) {
+		disable_delayed_work(&amt->req_wq);
+		disable_delayed_work(&amt->discovery_wq);
 		return err;
+	}
 
 	amt->req_cnt = 0;
 	amt->remote_ip = 0;
@@ -3062,8 +3068,8 @@ static int amt_dev_stop(struct net_devic
 	struct sk_buff *skb;
 	int i;
 
-	cancel_delayed_work_sync(&amt->req_wq);
-	cancel_delayed_work_sync(&amt->discovery_wq);
+	disable_delayed_work_sync(&amt->req_wq);
+	disable_delayed_work_sync(&amt->discovery_wq);
 	cancel_delayed_work_sync(&amt->secret_wq);
 
 	/* shutdown */
@@ -3317,6 +3323,8 @@ static int amt_newlink(struct net_device
 	INIT_DELAYED_WORK(&amt->req_wq, amt_req_work);
 	INIT_DELAYED_WORK(&amt->secret_wq, amt_secret_work);
 	INIT_WORK(&amt->event_wq, amt_event_work);
+	disable_delayed_work(&amt->req_wq);
+	disable_delayed_work(&amt->discovery_wq);
 	INIT_LIST_HEAD(&amt->tunnel_list);
 	return 0;
 err:


