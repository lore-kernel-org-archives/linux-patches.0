Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC77C17B50B;
	Sun,  1 Sep 2024 16:36:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208573; cv=none; b=bTVHwtTihN7xFN8lc8A2JhLrKzznaGDgxj+MrT619I+MDL5RJEbYgeglhu+QraEbuqhYsGVze/3PnA9JHi32AG9rG1lTTokaBnqGZsTDNGnegify9bWJlG7obQSg37JJLEwGkEMoBBaRIhRss7/Z8OvaLZwPyMjST4l4njAWVUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208573; c=relaxed/simple;
	bh=NIEPBDkbfmN+RyF2SeWNusQ5bFUOlibIWeACZCoakW4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DLGwJdDoLEbYys7eoJojPkJniffeUkpbBZK2wFnFwlMGEMwi4FgNRXadOE0vwgNBKozExYBssAbGAhz/d19yv4CJENMdGbCRUS8vXsyTwGozzMqb5tn7wuNPifRSy0IGQhKFVG+kHMyLZBich0s/oiluu3Tv1YInClY8/6eyt2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ucC5aUNp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ucC5aUNp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B5A0C4CEC3;
	Sun,  1 Sep 2024 16:36:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208573;
	bh=NIEPBDkbfmN+RyF2SeWNusQ5bFUOlibIWeACZCoakW4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ucC5aUNpeDCaDIYgzu+yKcZOfR9S+D8a5bJph6UVgFjN8Tjskusc0tuirVKMYtzNM
	 tkQzchjO0PPe0CUPs7tAsC6goZ+e6NV5HF9uGoAA/UEv05HnQULQjv+KnVxg/i5K8t
	 JUrHpizuwCFQ4WMj5eAIGTuqoPqRsR4Q/MTiB5lg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 092/149] Bluetooth: hci_core: Fix not handling hibernation actions
Date: Sun,  1 Sep 2024 18:16:43 +0200
Message-ID: <20240901160820.924134170@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160817.461957599@linuxfoundation.org>
References: <20240901160817.461957599@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index b488d0742c966..9493966cf389f 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -2431,10 +2431,16 @@ static int hci_suspend_notifier(struct notifier_block *nb, unsigned long action,
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



