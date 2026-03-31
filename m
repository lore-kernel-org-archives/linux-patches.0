Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91C0F41B342;
	Tue, 31 Mar 2026 16:48:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975725; cv=none; b=MNsOYatLwyM2HmS3d/cRL+B9ZldrL09kwuMewn07e0+owMyTGeGZkaoOEK1m7ik1JW/74GoAf+cFHuHVQ3hwjSHX1jc5evsj+aPICC9YQcuzTAq6fVWrwiDDS2D6Eo13puMTgbNwVnkOISptZOPiR0YxiupZb0/JwKRS05hmKmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975725; c=relaxed/simple;
	bh=dRxpPRzFA06ieMaX+DTrpYS9BaBUDdiNFmIqQcWCwWE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dE0HwuZNL6M4gIKSUWGmfUVObMndM2gG7BY9S76GQpo/+Jsbqagm+4K7ZycfKEO6gOD31s/qJxOo92GyDVlgeLTe9imu7Qfb9zrbSi8ThhQb19hMv7rS6zAu5VBbIoKgK9+Wubny4fadsZixYwzQ5uk0vV47K9YRtvqtWLVDP6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nlFYrymj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nlFYrymj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D901EC19424;
	Tue, 31 Mar 2026 16:48:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975725;
	bh=dRxpPRzFA06ieMaX+DTrpYS9BaBUDdiNFmIqQcWCwWE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nlFYrymjWGUWcWnsZYy+9RLNsjbnHizhRGzbxDKqRithXljLuor1nJkqaldbzpfLi
	 0Tvfxwau52wXHOpA2yG9/WEfKFdbIV2v5xQeZrm2IYfQ1kKRVPzu7x4jBPNTbfCjM7
	 D16NV1CMp2OBepG4N/H76lhHXO5SGNDnvU7DLC2o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 061/244] Bluetooth: MGMT: Fix dangling pointer on mgmt_add_adv_patterns_monitor_complete
Date: Tue, 31 Mar 2026 18:20:11 +0200
Message-ID: <20260331161743.942330079@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161741.651718120@linuxfoundation.org>
References: <20260331161741.651718120@linuxfoundation.org>
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

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit 5f5fa4cd35f707344f65ce9e225b6528691dbbaa ]

This fixes the condition checking so mgmt_pending_valid is executed
whenever status != -ECANCELED otherwise calling mgmt_pending_free(cmd)
would kfree(cmd) without unlinking it from the list first, leaving a
dangling pointer. Any subsequent list traversal (e.g.,
mgmt_pending_foreach during __mgmt_power_off, or another
mgmt_pending_valid call) would dereference freed memory.

Link: https://lore.kernel.org/linux-bluetooth/20260315132013.75ab40c5@kernel.org/T/#m1418f9c82eeff8510c1beaa21cf53af20db96c06
Fixes: 302a1f674c00 ("Bluetooth: MGMT: Fix possible UAFs")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/mgmt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index b1df591a53805..ba6651f23d5d0 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -5332,7 +5332,7 @@ static void mgmt_add_adv_patterns_monitor_complete(struct hci_dev *hdev,
 	 * hci_adv_monitors_clear is about to be called which will take care of
 	 * freeing the adv_monitor instances.
 	 */
-	if (status == -ECANCELED && !mgmt_pending_valid(hdev, cmd))
+	if (status == -ECANCELED || !mgmt_pending_valid(hdev, cmd))
 		return;
 
 	monitor = cmd->user_data;
-- 
2.51.0



