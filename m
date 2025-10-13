Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A385B2F5479;
	Mon, 13 Oct 2025 15:04:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367840; cv=none; b=qSPb6Fbs7wGEyzOOaRd42qVJdNfbFv/hTp7OyUbYBG6R6hN8OHa1BuJJhDNki9yBEA1G1OB/H7qk2PFqALAts+afQg7+tBfkkJWbKtDKjCl6d7+0xXR4C6PuVVDhdbEjoq6o3s9agRBJewEBo8PYnjRTKzGL5ydXbabx7XyV5aI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367840; c=relaxed/simple;
	bh=eMzUvKcb72bYBGWdTodbqSWRsGiAAPpCKolFVRiV5Vk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FAaf2zc81bkgTxvcwCXD5T7gCvPBMynKIhTvrurkA1lDKoj3lD9VUmqs8NtgQBWj7CUigr//jTIdClnovH3EMBPeLESw70bxXJeHTqUWqWnJEc4/Xg7XHz3Td77r+k5fYY4taBzQIWFYyI9hW7xCF3TLqCzIOK8OWAlkj5F2Lgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PX+NiBr9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PX+NiBr9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3086AC4CEE7;
	Mon, 13 Oct 2025 15:04:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367840;
	bh=eMzUvKcb72bYBGWdTodbqSWRsGiAAPpCKolFVRiV5Vk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PX+NiBr9P31CXnSgoZ+7JfFKYs1jXpJiUeJ2NhD0NXqJpi97SGX4NIQTlHu0Bx3gR
	 I3k45CGQUrD8qQvLqNPNafcLibFUWqXO0aZHloyEnP9mP5HVzTUFFXTpbXHQlXqERj
	 lSdgLQ87vs2oqfWGOK/iu2UFhMCuLpwXrQ7FnTMg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 153/196] Bluetooth: hci_sync: Fix using random address for BIG/PA advertisements
Date: Mon, 13 Oct 2025 16:45:44 +0200
Message-ID: <20251013144320.844945252@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144315.184275491@linuxfoundation.org>
References: <20251013144315.184275491@linuxfoundation.org>
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

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit 03ddb4ac251463ec5b7b069395d9ab89163dd56c ]

When creating an advertisement for BIG the address shall not be
non-resolvable since in case of acting as BASS/Broadcast Assistant the
address must be the same as the connection in order to use the PAST
method and even when PAST/BASS are not in the picture a Periodic
Advertisement can still be synchronized thus the same argument as to
connectable advertisements still stand.

Fixes: eca0ae4aea66 ("Bluetooth: Add initial implementation of BIS connections")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_sync.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index dc9209f9f1a6a..a128e5709fa15 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -1347,7 +1347,7 @@ int hci_setup_ext_adv_instance_sync(struct hci_dev *hdev, u8 instance)
 {
 	struct hci_cp_le_set_ext_adv_params cp;
 	struct hci_rp_le_set_ext_adv_params rp;
-	bool connectable;
+	bool connectable, require_privacy;
 	u32 flags;
 	bdaddr_t random_addr;
 	u8 own_addr_type;
@@ -1385,10 +1385,12 @@ int hci_setup_ext_adv_instance_sync(struct hci_dev *hdev, u8 instance)
 		return -EPERM;
 
 	/* Set require_privacy to true only when non-connectable
-	 * advertising is used. In that case it is fine to use a
-	 * non-resolvable private address.
+	 * advertising is used and it is not periodic.
+	 * In that case it is fine to use a non-resolvable private address.
 	 */
-	err = hci_get_random_address(hdev, !connectable,
+	require_privacy = !connectable && !(adv && adv->periodic);
+
+	err = hci_get_random_address(hdev, require_privacy,
 				     adv_use_rpa(hdev, flags), adv,
 				     &own_addr_type, &random_addr);
 	if (err < 0)
-- 
2.51.0



