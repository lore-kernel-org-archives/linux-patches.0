Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2723D306D2A;
	Wed, 23 Sep 2026 14:13:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790172799; cv=none; b=VAd3rNqhf1IHqR6qpDmhkBgnfo6CMd5gs/QeFtoneZ3xXQ7BoUTEC4HMoaYUiNippTbALSU4Rt9lDDdlrVY33zvPTlY3vrcANXoQfmCyQ9JYY+ppSV0Q+em0NzFlKPWuSZU8IyrideN6HdBZuiFVEqEPUopudkiRD2dfI5iF9A0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790172799; c=relaxed/simple;
	bh=6w1S8RotSGRBLfFsk6066YPO0aoIV7dk9lWdvrdaQX0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tnIV0QR+J1K9icbvh8umuLUYmsu9FcSHsSuXaYW3bR38zNDvSIP7M2ssPSzZXDSm9FUbFOt9CwEtl+y+Mlm5WVIgFkxnebA8gUQLrGqbwhDF+VFaTf8VhSxYfzWiEpuDiANu3Aet1cNRM1O9xN/gkW8/b5117n8BriUT/tEjxXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QlIdm+CO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QlIdm+CO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 455971F000FF;
	Wed, 23 Sep 2026 14:13:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790172797;
	bh=MrQhI1qBXQrGDIjVZfu287n/H0IbIis78XE+ZYBbV94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QlIdm+CO7WQc3Zd1A1qWb1PGG1E5yKQKXPbTO9lwdSCZ2Yfo4u1TYRvZl8gnKqa25
	 dX9dwcx85oEk3KgLQ+8+RNt0ZLzRncX2zcwooJS6fVxXIdMoT18ueBZSSqXXzaTGYf
	 P1a5AewRz1RKBJNNSfxZNiKrkRI+sYayTV/+zRbY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+189dcafc06865d38178d@syzkaller.appspotmail.com,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 064/438] wifi: cfg80211: dont free driver-owned scan requests
Date: Wed, 23 Sep 2026 16:01:25 +0200
Message-ID: <20260923140646.452162874@linuxfoundation.org>
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

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit dab68a74e90b8e07f08ed9deaa5884857a3cfe89 ]

When an interface goes down while a scan is running, cfg80211 completes
the scan towards userspace and frees the scan request. However, the
driver can be convinced that it owns the request, since the cancellation
is (intended to be) asynchronous.

The WARN_ON() in the netdev notifier was meant to catch this, but it's
not actually avoidable, so it triggers and we get a UAF in scan_done().

There doesn't seem to be a great way around it, so just track that the
driver is still convinced it owns the request, and then just free it on
completion if it was already cancelled. Also remove the warnings since
they can trigger in the intended architecture.

Assisted-by: LLM
Fixes: 4a58e7c38443 ("cfg80211: don't "leak" uncompleted scans")
Reported-by: syzbot+189dcafc06865d38178d@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=189dcafc06865d38178d
Link: https://patch.msgid.link/20260904165614.375e543228b1.I03cbb5a54cb02d6bba5034286af1ed73aba134d1@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/core.c     | 11 +++++------
 net/wireless/core.h     | 10 ++++++++++
 net/wireless/rdev-ops.h |  3 +++
 net/wireless/scan.c     | 31 +++++++++++++++++++++++++++++--
 4 files changed, 47 insertions(+), 8 deletions(-)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index d13310fef691a..8bb2cbd66b488 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -244,9 +244,8 @@ void cfg80211_stop_p2p_device(struct cfg80211_registered_device *rdev,
 	rdev->opencount--;
 
 	if (rdev->scan_req && rdev->scan_req->req.wdev == wdev) {
-		if (WARN_ON(!rdev->scan_req->notified &&
-			    (!rdev->int_scan_req ||
-			     !rdev->int_scan_req->notified)))
+		if (!rdev->scan_req->notified &&
+		    (!rdev->int_scan_req || !rdev->int_scan_req->notified))
 			rdev->scan_req->info.aborted = true;
 		___cfg80211_scan_done(rdev, false);
 	}
@@ -1758,9 +1757,9 @@ static int cfg80211_netdev_notifier_call(struct notifier_block *nb,
 		wiphy_lock(&rdev->wiphy);
 		cfg80211_update_iface_num(rdev, wdev->iftype, -1);
 		if (rdev->scan_req && rdev->scan_req->req.wdev == wdev) {
-			if (WARN_ON(!rdev->scan_req->notified &&
-				    (!rdev->int_scan_req ||
-				     !rdev->int_scan_req->notified)))
+			if (!rdev->scan_req->notified &&
+			    (!rdev->int_scan_req ||
+			     !rdev->int_scan_req->notified))
 				rdev->scan_req->info.aborted = true;
 			___cfg80211_scan_done(rdev, false);
 		}
diff --git a/net/wireless/core.h b/net/wireless/core.h
index ac6ce9f967ec7..979e968ff5959 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -24,6 +24,16 @@
 struct cfg80211_scan_request_int {
 	struct cfg80211_scan_info info;
 	bool notified;
+	/*
+	 * set while the request is handed to the driver, i.e. between
+	 * rdev_scan() and cfg80211_scan_done()
+	 */
+	bool driver_owns;
+	/*
+	 * set when cfg80211 is done with the request but the driver still
+	 * owns it, so that cfg80211_scan_done() knows to just free it
+	 */
+	bool stale;
 	/* must be last - variable members */
 	struct cfg80211_scan_request req;
 };
diff --git a/net/wireless/rdev-ops.h b/net/wireless/rdev-ops.h
index 63c26e8b11395..8f466e1ab1d72 100644
--- a/net/wireless/rdev-ops.h
+++ b/net/wireless/rdev-ops.h
@@ -464,7 +464,10 @@ static inline int rdev_scan(struct cfg80211_registered_device *rdev,
 		return -EINVAL;
 
 	trace_rdev_scan(&rdev->wiphy, request);
+	request->driver_owns = true;
 	ret = rdev->ops->scan(&rdev->wiphy, &request->req);
+	if (ret)
+		request->driver_owns = false;
 	trace_rdev_return_int(&rdev->wiphy, ret);
 	return ret;
 }
diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 071083cc33672..1a28f95246764 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -1114,6 +1114,21 @@ int cfg80211_scan(struct cfg80211_registered_device *rdev)
 	return 0;
 }
 
+/*
+ * Release the scan request, but free it only if the driver is also done,
+ * e.g. mac80211 may cancel it asynchronously and still use it.
+ */
+static void cfg80211_put_scan_req(struct cfg80211_scan_request_int *req)
+{
+	if (!req)
+		return;
+
+	if (req->driver_owns)
+		req->stale = true;
+	else
+		kfree(req);
+}
+
 void ___cfg80211_scan_done(struct cfg80211_registered_device *rdev,
 			   bool send_message)
 {
@@ -1173,10 +1188,10 @@ void ___cfg80211_scan_done(struct cfg80211_registered_device *rdev,
 
 	dev_put(wdev->netdev);
 
-	kfree(rdev->int_scan_req);
+	cfg80211_put_scan_req(rdev->int_scan_req);
 	rdev->int_scan_req = NULL;
 
-	kfree(rdev->scan_req);
+	cfg80211_put_scan_req(rdev->scan_req);
 	rdev->scan_req = NULL;
 
 	if (!send_message)
@@ -1199,6 +1214,18 @@ void cfg80211_scan_done(struct cfg80211_scan_request *request,
 	struct cfg80211_scan_info old_info = intreq->info;
 
 	trace_cfg80211_scan_done(intreq, info);
+
+	intreq->driver_owns = false;
+
+	if (intreq->stale) {
+		/*
+		 * The scan is already completed as far as we're concerned,
+		 * it was just kept around for the driver - done now, free it.
+		 */
+		kfree(intreq);
+		return;
+	}
+
 	WARN_ON(intreq != rdev->scan_req &&
 		intreq != rdev->int_scan_req);
 
-- 
2.53.0



