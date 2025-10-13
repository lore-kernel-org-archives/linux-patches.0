Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19A1B1F1313;
	Mon, 13 Oct 2025 15:16:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368573; cv=none; b=bpbIJHVrgIWIEZDqwZu8btg3mzX6iikiRi13A5f8+dM2wiwxBAHrx2623UOJEhLH2WjJ0DTTD3SZDDay9UXmu+xuwtAlUTnKTXwIfXOcU1cEgKyqlIk1Ki3s7QdUNJpBCqLRx5+DhJboPg1m3bNw3ATlrvkANDabHU+MnWJrBjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368573; c=relaxed/simple;
	bh=QL2G0q7JYoaf5JAwYZtPkQvBaczV7X45pdMs0UYJT9s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eSYIjuXOxocMF6WDXCdaNy/KcM6Osn6JA71b/TYQA2HceavZyN+CsRsL/vCpjkAjlBRBaTuYG0mWqThnOVqJd7xrd41K4pGnpqfOjvkOwwiRC4oDdBBS1W22fBgzcHDGj6VKquk9y4lP4hf/3IBvZoGFcpkSZx70u3oqncy/Wi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e7aaKGTQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e7aaKGTQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FE5CC4CEE7;
	Mon, 13 Oct 2025 15:16:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368572;
	bh=QL2G0q7JYoaf5JAwYZtPkQvBaczV7X45pdMs0UYJT9s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e7aaKGTQx6DOShPSmoH1YxQ7G4RI0DNwiMFUUVGOb6ZRh7eEXkCcAd6P7/ZMiWtB0
	 nIebcyJy2nP625n8Qv/Ynj3uYgwo0Tv9wi9SfVu3o/u08TdUu0+7Ait9sQ2mXRUMbH
	 dManKjdQjKkrecbHX7Y7r0VHVdExHIsllLYrzC3o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 206/262] Bluetooth: hci_sync: Fix using random address for BIG/PA advertisements
Date: Mon, 13 Oct 2025 16:45:48 +0200
Message-ID: <20251013144333.661766219@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144326.116493600@linuxfoundation.org>
References: <20251013144326.116493600@linuxfoundation.org>
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
index 333f32a9fd219..853acfa8e9433 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -1325,7 +1325,7 @@ int hci_setup_ext_adv_instance_sync(struct hci_dev *hdev, u8 instance)
 {
 	struct hci_cp_le_set_ext_adv_params cp;
 	struct hci_rp_le_set_ext_adv_params rp;
-	bool connectable;
+	bool connectable, require_privacy;
 	u32 flags;
 	bdaddr_t random_addr;
 	u8 own_addr_type;
@@ -1363,10 +1363,12 @@ int hci_setup_ext_adv_instance_sync(struct hci_dev *hdev, u8 instance)
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



