Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BCC851357D;
	Wed, 30 Sep 2026 16:49:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786945; cv=none; b=o/KoOtN/qUY/+3ckqQJWoUyx0MIZk0N2XvGTGA4pG1WEsN3TmzkXXSCOzhsoUQBTkblEhYUyYzMGoACmBhVSnSZOo+TnZST4w4d/wk3zdT/teNhJjYxvl+/KyFMRsC3ZbZiSmLg9Wk3+pIH8z+vEZhnixalLrQpvn7ceVUqmUHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786945; c=relaxed/simple;
	bh=bt67hn2GbjNL8lFUNPAL9lmKF3gTRp6BsVfRCgofGx8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=psjJCrdyke3X4GGKB1/Ns4u5+hzDB5TV6TBkXUL/81gWRGAUzcpP58u13EZphXLrN/uW7O5UdF7HQuvo71OwRsiSdaf389U+JZMBW4ayK39r5h0syAqqT2DzLxABIX4IkUCn80AtRzbgcYqlQ1GKoD8b5nVPg7qdf5fNmlPey1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U7GmPGDF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U7GmPGDF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D441D1F000FF;
	Wed, 30 Sep 2026 16:49:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786944;
	bh=Wf0DMQNh0fzKcaxz3f9cTHy5un/xE8GnWHOjbSesJmk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U7GmPGDFqEfbxkiAb6FA1NCR8e3bPc8j8G9W6k12H/uAd2/YeK9k5tqgDlrbSOYRK
	 2pY1T8+jAtw4B4inOw1NP4xKniDfIQodDSQ2dEBqKQ82jRO1B3bEVisHYi7L8fJGKq
	 jHetmStmXFYbgiCpydvtKctmESgGR6FoJuhre8zU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <zijun.hu@oss.qualcomm.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 055/457] Bluetooth: btnxpuart: Fix skb leak in nxp_process_fw_dump()
Date: Wed, 30 Sep 2026 17:22:40 +0200
Message-ID: <20260930152347.223597784@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zijun Hu <zijun.hu@oss.qualcomm.com>

[ Upstream commit f2bbb36426581045a8bf7793da5419b9375e4348 ]

When CONFIG_DEV_COREDUMP=n, hci_devcd_append() returns -EOPNOTSUPP
without freeing its skb argument. This leaks the cloned skb and also
prevents nxp_set_ind_reset() from being called to perform recovery.

Fix by guarding the hci_devcd_append(hdev, skb_clone(skb, GFP_ATOMIC))
call with IS_ENABLED(CONFIG_DEV_COREDUMP).

Fixes: 998e447f443f ("Bluetooth: btnxpuart: Add support for HCI coredump feature")
Signed-off-by: Zijun Hu <zijun.hu@oss.qualcomm.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btnxpuart.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/bluetooth/btnxpuart.c b/drivers/bluetooth/btnxpuart.c
index e6c15bc6a30b9..73b319c7e1765 100644
--- a/drivers/bluetooth/btnxpuart.c
+++ b/drivers/bluetooth/btnxpuart.c
@@ -1397,9 +1397,11 @@ static int nxp_process_fw_dump(struct hci_dev *hdev, struct sk_buff *skb)
 				      msecs_to_jiffies(20000));
 	}
 
-	err = hci_devcd_append(hdev, skb_clone(skb, GFP_ATOMIC));
-	if (err < 0)
-		goto free_skb;
+	if (IS_ENABLED(CONFIG_DEV_COREDUMP)) {
+		err = hci_devcd_append(hdev, skb_clone(skb, GFP_ATOMIC));
+		if (err < 0)
+			goto free_skb;
+	}
 
 	if (buf_len == 0) {
 		bt_dev_warn(hdev, "==== FW dump complete ===");
-- 
2.53.0



