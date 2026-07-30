Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EEB637B012;
	Thu, 30 Jul 2026 15:46:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426381; cv=none; b=WMJGhr4im+tVMTowJid0A6qhm5tK+1mEFXPf84R7IbxQv7f1s15ltm5hu1/EC+Euh6AhAAQrTB7JU2EOayY2AB3HJv/RDC/yypadfw0LL2blsQ9BwgwskMhhhTdG+wKuNVZeUhuS/HAvJstF7fQ+vHDEEgQtLPsd3cwOon3FNw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426381; c=relaxed/simple;
	bh=SioyfHPBT+keI0aZIGZ5tElzO7pW32wTTTYxjX7zhXU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QiQB7xdHtmaHGM2//1X2p4JRR0CelbDQq6awBzhpxsgDzlnwpmprwDXZ9aG8LT8gRnZyGa0ZVGFGP8ztWLI7+iHUcG3MNm+WobKpULbui4g7UvjRcB8pTGLDyoKnlo+WEx0hNmdYP/Nhc4CXpjZwGHS06q2/6NGbSxB7crk3aG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n7CtB0yt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n7CtB0yt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F5D21F000E9;
	Thu, 30 Jul 2026 15:46:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426379;
	bh=2ByDplMUiHgyVjdq0CXoVFxo1zhg3wWEfiTDUEBqOfE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n7CtB0ytFVNesRvAx/p6cGAclxMwCSzrOGPPLbJtGgRjZPpC6HrE0tzy6QRu+lbBn
	 1ophlXLSzJ1cy2YN+JzccI7N7ioiixjb5EdngsQz5liiPgMT6Wq5Rs3vNxdpWFMWST
	 cQj7jQxhTFxtFZGAB2D9fE1iGxuq+UMEMCEW/q9c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shihuang Liu <shlomojune6@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Taehee Yoo <ap420073@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 399/602] amt: fix use-after-free in AMT delayed works
Date: Thu, 30 Jul 2026 16:13:11 +0200
Message-ID: <20260730141444.345456151@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3029,9 +3029,15 @@ static int amt_dev_open(struct net_devic
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
@@ -3057,8 +3063,8 @@ static int amt_dev_stop(struct net_devic
 	struct sk_buff *skb;
 	int i;
 
-	cancel_delayed_work_sync(&amt->req_wq);
-	cancel_delayed_work_sync(&amt->discovery_wq);
+	disable_delayed_work_sync(&amt->req_wq);
+	disable_delayed_work_sync(&amt->discovery_wq);
 	cancel_delayed_work_sync(&amt->secret_wq);
 
 	/* shutdown */
@@ -3313,6 +3319,8 @@ static int amt_newlink(struct net *net,
 	INIT_DELAYED_WORK(&amt->req_wq, amt_req_work);
 	INIT_DELAYED_WORK(&amt->secret_wq, amt_secret_work);
 	INIT_WORK(&amt->event_wq, amt_event_work);
+	disable_delayed_work(&amt->req_wq);
+	disable_delayed_work(&amt->discovery_wq);
 	INIT_LIST_HEAD(&amt->tunnel_list);
 	return 0;
 err:


