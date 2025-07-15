Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7E8D2E7BB8;
	Tue, 15 Jul 2025 13:24:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752585861; cv=none; b=nzAvWblxQzCuAyMsA3iS83ZQiKf0qjpoCzKlt3Thyko4stC7SzTw9JyNT6V3qg4cL7e2hzrFfZM9JuuVObgHbiqY8279sLJxM5HPo0EaN600iV/E7VI2HS/7TLsuUKAO0w9KBClFLBwpdRU4jxCb1MZwkGsnZYZKrdTSGzTRtlo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752585861; c=relaxed/simple;
	bh=kdZNjm9O3eCpEBKHrVvwhLTr1xodz5z+XCUL9Cq7PTs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nbFesmn/RixdFEI4lx6Lhbz4lPmMqFvJZmkuWjSjris7CKg7nfWblG5eeSB9hhhJO6ZobW2f4G3u/4kmt3HzndNvJjnAgzYg+qg+4thlT8r3IQSSOwOxvn+AG/QjD0wIkVXe2hobDnJ5cmU7cbh6S2pqoIKOKZVL14mE3uAUfjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2SRUNFcY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2SRUNFcY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40D43C4CEF6;
	Tue, 15 Jul 2025 13:24:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752585859;
	bh=kdZNjm9O3eCpEBKHrVvwhLTr1xodz5z+XCUL9Cq7PTs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2SRUNFcYJrA/VjvU4FEwAO4h80+JL2uJ4/EL0rh6nxEmIcg6afvjAPvv2+AquaZy2
	 baWMULaBcVEDYPsgh2WIBhURx2PEkm5Dy4doNR7+66mPeOFVQ8KVXb/ZrpOhuJ+u7z
	 62E/V7gxbxvI7yAYso+uHgDBP/ZGFtSnC+KXyd+8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 007/109] Bluetooth: hci_sync: Fix not disabling advertising instance
Date: Tue, 15 Jul 2025 15:12:23 +0200
Message-ID: <20250715130759.168929441@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130758.864940641@linuxfoundation.org>
References: <20250715130758.864940641@linuxfoundation.org>
User-Agent: quilt/0.68
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

[ Upstream commit ef9675b0ef030d135413e8638989f3a7d1f3217a ]

As the code comments on hci_setup_ext_adv_instance_sync suggests the
advertising instance needs to be disabled in order to update its
parameters, but it was wrongly checking that !adv->pending.

Fixes: cba6b758711c ("Bluetooth: hci_sync: Make use of hci_cmd_sync_queue set 2")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_sync.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index d602e9d8eff45..71736537cc6e3 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -1247,7 +1247,7 @@ int hci_setup_ext_adv_instance_sync(struct hci_dev *hdev, u8 instance)
 	 * Command Disallowed error, so we must first disable the
 	 * instance if it is active.
 	 */
-	if (adv && !adv->pending) {
+	if (adv) {
 		err = hci_disable_ext_adv_instance_sync(hdev, instance);
 		if (err)
 			return err;
-- 
2.39.5



