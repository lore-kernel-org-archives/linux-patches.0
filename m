Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65A4C44C97;
	Sun,  1 Sep 2024 16:27:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208037; cv=none; b=aa8eI4uViwFz0CaIK5JL3KUXj7B4wxYr7Y3LZSJ2BUPpcLe+JG9+taPruqxAY9KUmN6LXqYkAjJtR6zc04ZYRyh7cJqyW9sUdBY45+XC8t2PtmH+jnkQglOqd+Y1/C3HkjdOGjRpYkPnlZQtMzMK0KVHrn/cULW0LETovHQRojc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208037; c=relaxed/simple;
	bh=vgBtFu8xTGWD3HTi4ZngssjuUplN6TMz51PyNmHAjus=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jJMezsZqgywY0phR2GYrJEv8W074Oc+eHqFbKwxIz4E+eN0aSM6sITI9c1Vfmf7Qk1xiHh39sx0/xwyhHo/kvS2ATP8DYIIp2sNDMWgz2qEsyTH60snOfsQSN9Wlxcn/WdGTKnZjX8A2wYwPgU0IyxBkkKyDSKyaVtQMsWcvnEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O96AMlwe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O96AMlwe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBDCCC4CEC3;
	Sun,  1 Sep 2024 16:27:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208037;
	bh=vgBtFu8xTGWD3HTi4ZngssjuUplN6TMz51PyNmHAjus=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O96AMlweZgTW7OHCCMSVzSfeXhTcB9iSwS0+DXK3cFSSjAYwkK6FTcV8OWvObjmuJ
	 uFKsze668kjEWa5velOVO31nSXk4Fb/iGSamWbKUIPKOW80RJWrCebPhBw3b+P+fqw
	 lE6DIjWTwKJGXpHKOFGhm/e3Tl3cTvochHGrUelU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 54/93] Bluetooth: hci_core: Fix not handling hibernation actions
Date: Sun,  1 Sep 2024 18:16:41 +0200
Message-ID: <20240901160809.398051398@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160807.346406833@linuxfoundation.org>
References: <20240901160807.346406833@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit 18b3256db76bd1130965acd99fbd38f87c3e6950 ]

This fixes not handling hibernation actions on suspend notifier so they
are treated in the same way as regular suspend actions.

Fixes: 9952d90ea288 ("Bluetooth: Handle PM_SUSPEND_PREPARE and PM_POST_SUSPEND")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_core.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index e660b3d661dae..1b56355c40eaf 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -2394,10 +2394,16 @@ static int hci_suspend_notifier(struct notifier_block *nb, unsigned long action,
 	/* To avoid a potential race with hci_unregister_dev. */
 	hci_dev_hold(hdev);
 
-	if (action == PM_SUSPEND_PREPARE)
+	switch (action) {
+	case PM_HIBERNATION_PREPARE:
+	case PM_SUSPEND_PREPARE:
 		ret = hci_suspend_dev(hdev);
-	else if (action == PM_POST_SUSPEND)
+		break;
+	case PM_POST_HIBERNATION:
+	case PM_POST_SUSPEND:
 		ret = hci_resume_dev(hdev);
+		break;
+	}
 
 	if (ret)
 		bt_dev_err(hdev, "Suspend notifier action (%lu) failed: %d",
-- 
2.43.0



