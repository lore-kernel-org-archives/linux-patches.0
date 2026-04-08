Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC12D3B0AFC;
	Wed,  8 Apr 2026 18:42:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673761; cv=none; b=RstAFzLIARV109s74zufLqappe++Qz8+vKFmwbaOuNp12w4j2be9qyEt4U3bL3PVKe9adTeXHsGxueeBMg8IMj11o+W6FqdVBiJSHRI9ZKJBocRbYCM2EX5FyX+uQRy2FBQueWKFLCCweuTK1WKd3Np7Ivxsl0XT6ZyB/axqr+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673761; c=relaxed/simple;
	bh=KcsIZRq0jW4QApv7QW9+sO2aQD4SF++dc57DlE7KfTA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CIfIwW/E1v694JSxtOUlziMvV/l2s63cwc7dtVfm6VNvGqIoRqmp2zGWC0o2BzXoODYSMcChOaZiF3cBZ34ey7dOjyLusr5W+xRpEuIVkClzYEzSpWuoP/7Z63uOGiqYHbF7YyaXui5keknfqVKv3rgi3WaVQXiDo2VNWwR4iU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CWIEWeim; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CWIEWeim"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C7DBC19421;
	Wed,  8 Apr 2026 18:42:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673761;
	bh=KcsIZRq0jW4QApv7QW9+sO2aQD4SF++dc57DlE7KfTA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CWIEWeimvxhy8Z1PlOtmMknLrrflbZhcAxwPRx5y1SZ3rtcKn0n3ot+QGofGZlcLw
	 24MOYpZCSwKX4WBR9G5C74+1caK9JK4CoY3jVHeln4+fTiWAXDHLqbs/QdxZ/BzFP+
	 vwymX9DGeXuKmXk2NlQ3E2Ub9uXwBdtM8BfQn32k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 080/242] Bluetooth: hci_sync: call destroy in hci_cmd_sync_run if immediate
Date: Wed,  8 Apr 2026 20:02:00 +0200
Message-ID: <20260408175930.077268171@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175927.064985309@linuxfoundation.org>
References: <20260408175927.064985309@linuxfoundation.org>
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

From: Pauli Virtanen <pav@iki.fi>

[ Upstream commit a834a0b66ec6fb743377201a0f4229bb2503f4ce ]

hci_cmd_sync_run() may run the work immediately if called from existing
sync work (otherwise it queues a new sync work). In this case it fails
to call the destroy() function.

On immediate run, make it behave same way as if item was queued
successfully: call destroy, and return 0.

The only callsite is hci_abort_conn() via hci_cmd_sync_run_once(), and
this changes its return value. However, its return value is not used
except as the return value for hci_disconnect(), and nothing uses the
return value of hci_disconnect(). Hence there should be no behavior
change anywhere.

Fixes: c898f6d7b093b ("Bluetooth: hci_sync: Introduce hci_cmd_sync_run/hci_cmd_sync_run_once")
Signed-off-by: Pauli Virtanen <pav@iki.fi>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_sync.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index 1656448649b9f..4f0fdb646d943 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -801,8 +801,15 @@ int hci_cmd_sync_run(struct hci_dev *hdev, hci_cmd_sync_work_func_t func,
 		return -ENETDOWN;
 
 	/* If on cmd_sync_work then run immediately otherwise queue */
-	if (current_work() == &hdev->cmd_sync_work)
-		return func(hdev, data);
+	if (current_work() == &hdev->cmd_sync_work) {
+		int err;
+
+		err = func(hdev, data);
+		if (destroy)
+			destroy(hdev, data, err);
+
+		return 0;
+	}
 
 	return hci_cmd_sync_submit(hdev, func, data, destroy);
 }
-- 
2.53.0



