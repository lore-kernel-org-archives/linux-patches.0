Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49365228CB0;
	Mon, 13 Oct 2025 15:40:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760370049; cv=none; b=fyjxq6CJfj+jCLyiIMUZh5+p9MW1+hky2FMIMTdjCYy+DRWuj9ifNNlwUHyzn1QFy2Lw72UTVHPf7bn/2J2JQHfz5pvMtJ31ugKrxj74ZhI51YhmLQRqeE40eFh+V526gditcKJcw1zXIY8BGCBhsIyXbzfEgHI2tyvbwggULZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760370049; c=relaxed/simple;
	bh=1cH4kgdlW8y5Eie+oIkHKMD0tjS2g+TPBOMqwQ3AMIc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i+ToM0VM6dQ4MB1fe/Bjx18cm8Q7wGz9vUj0k0NLf8XiVlOVo/XbDNXwewsEiupFDPN6mMy7v5wF1eqQhFQ1TSzmI6CRlJqd89ECddOtHvh3upSJMEGeEosYnv6uTpi93Pkl+N/aSZy+0XfFF9y+u4EbRE6V02YRUCZRG4P359c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jH4XZ0RU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jH4XZ0RU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA467C4CEFE;
	Mon, 13 Oct 2025 15:40:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760370049;
	bh=1cH4kgdlW8y5Eie+oIkHKMD0tjS2g+TPBOMqwQ3AMIc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jH4XZ0RU50xQNYR3YhOazSPLCN4RdWwKKoL/h6nHcYkBfOBKzp7c3wOB2vphKb7Kx
	 uUoC2W0oquYbrIsM+dXzbiQZy8p02WvfpyLDfu7uXK1IRIfrjkZzE2DvAK5ehgWLD7
	 bHABPp63VR5kOkCDryBMTQBKKuoEJ9qwDFmxyzrE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 461/563] Bluetooth: hci_sync: Fix using random address for BIG/PA advertisements
Date: Mon, 13 Oct 2025 16:45:22 +0200
Message-ID: <20251013144427.985732320@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index 7a7d498908584..eefdb6134ca53 100644
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



