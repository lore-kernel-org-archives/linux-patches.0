Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F74A476CED;
	Thu, 20 Aug 2026 17:57:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787248652; cv=none; b=Gm53IdjmkMml1LdeXhGGhzjmLKRbBFOx2+/idTL6gMLnW2IvMDCCdSQPA08kvj7cad3ChMZ/j+JJPnZDC8UVyrXlcWjrW/ewdzI3GbjWhFD3Te+B6CGd8mdB/hdTkNPu9T4y009dmLL+q7CnKZZAKX0sKTNFA2+NLE+ZBsMeIXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787248652; c=relaxed/simple;
	bh=F88x30NM62uVqRizxbYlZxtpXSBd6eF3BCw0rC0RKjg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t31PrZx8TAJ8RT6akgyaJ/QasxhRvCk/cJJgj/h344nztWRACsYn9aInoCkDdjluArb8+VRWvFvGM7GhF+D4zqnqdjEtxXpF06DHzezR7Y+QSdGO/NuHqwL6AKF4YE4QA2ozJOgfDteLQtz7jI4aYFqLW9zyAkqfL91rV0QohXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ynH1Rw29; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ynH1Rw29"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA1C61F000E9;
	Thu, 20 Aug 2026 17:57:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787248651;
	bh=ZARpjhLOSpuucgSMHsm4jBS1yE2ng1QMpQk5jReXRPA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ynH1Rw29dquhv8dGfXAkuWkxzZa+qsAqj8iADdhSMy+ImnoU2e7lr69jiwp6yNTsg
	 Z2EfPNDYBy48zHMW4oIHot0doA0JXwCUrsiTxq+x5HADhs3CyMJm/d2lqaZZ0V+8vB
	 TcXTemAsGFLVB89PZPr8zT/PxBkLuZpFK3E7eyLw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.1 301/303] Bluetooth: hci_sync: call destroy in hci_cmd_sync_run if immediate
Date: Thu, 20 Aug 2026 16:57:17 +0200
Message-ID: <20260820145302.515712457@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145253.200766705@linuxfoundation.org>
References: <20260820145253.200766705@linuxfoundation.org>
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

From: Pauli Virtanen <pav@iki.fi>

commit a834a0b66ec6fb743377201a0f4229bb2503f4ce upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/hci_sync.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -820,8 +820,15 @@ int hci_cmd_sync_run(struct hci_dev *hde
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


