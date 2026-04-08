Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DBDF2494F0;
	Wed,  8 Apr 2026 18:22:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775672540; cv=none; b=LBODACjjpQ4ucZsMrB4xAwRZ/SlbCgirHFLYhe7XmZQbNusi42KzHOKr1ROEc6TVzR893FS+TMrYZGGmgq01cIBKyPesUUPGAQCL0oMMN3zdtLX/xtEojV1QVyMO/7wtZ4VHRhwUBxm9HsQdI1D1NHbnwHWKsUYZvnjWTUmbIC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775672540; c=relaxed/simple;
	bh=t06QK9n+l/TsuBejMHAvsdxHZp7+4Q5TYNY+W4Cdn1Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rOcGCV4ah5MrJiT+yl4Nffe7uu6M8Dg6vDkyO8kLXyhnFiBjfVTilG41BLC7EQup0t/IAXL3nUjrzuj/k9pTG9lQB7u15J4tdP/OxFqeTsUojofpCKXZcfTTUeSiwhUvCBmCdbEeftGA4+YnymmUUc3jlKyLVJilCkPrqQYHwO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ymSvoDNn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ymSvoDNn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8389C19421;
	Wed,  8 Apr 2026 18:22:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775672540;
	bh=t06QK9n+l/TsuBejMHAvsdxHZp7+4Q5TYNY+W4Cdn1Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ymSvoDNnv/GDDKuVAVtWDMDfGLPQkR2OJg/TYUpEPMYGW8OKAZNqxohjXVH9ihp9b
	 K46VW5WMkWk4Zq5w2uhrVI/aGmxkiwGXVEfbi9nW8Qj2X1vRziwUWEAb93bscxV1+l
	 mh1qOpbgF3N6bCNPBvm6Bs6iCGvrvNuepHWvVZuw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 046/160] Bluetooth: hci_sync: call destroy in hci_cmd_sync_run if immediate
Date: Wed,  8 Apr 2026 20:02:13 +0200
Message-ID: <20260408175914.928778194@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175913.177092714@linuxfoundation.org>
References: <20260408175913.177092714@linuxfoundation.org>
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
index c1c9d82faa658..a41cfc76e98bf 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -825,8 +825,15 @@ int hci_cmd_sync_run(struct hci_dev *hdev, hci_cmd_sync_work_func_t func,
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



