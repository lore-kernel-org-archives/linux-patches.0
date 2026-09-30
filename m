Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6496151DE18;
	Wed, 30 Sep 2026 18:27:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792847; cv=none; b=nQ1FVxCmz1AP1IKgs5JyLJRCy2y7Hem87A0e1Hby5CT6nUtmW1J7lXwXfx5n5OdqVqEAAS7wcvPwpPNQyyL48HGBa6Iif1oDb+UlWUFgCAWa0pIfVLPJQjK5Cfuc+BNmCGDyGt3XuCPFsCqlmZbGwJWtmzjLKPynsl0OAk6nIFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792847; c=relaxed/simple;
	bh=R89lOVjfREG1Nz4JytIegAisl8TtCIb58HIbli0Nm98=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=swj/ZIqhR0bDFq+pdHO/be3qdewM/sYl8D8EcqDV1mmOgT6/R0MANhuDqw3SnXw9K4v12C47Wu9aqgUT+472bJ88YxypxFLVWRTrnQ4PkQHysJJ1F0fxqJTDb5Cwg0W+j3M39a44/LSJ9kg53BudsAUrzG0rM9NHdI649oMVPDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gA3zW7BB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gA3zW7BB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEBB11F000FF;
	Wed, 30 Sep 2026 18:27:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792846;
	bh=fDW/PAEqbtGYNu/bZ8tWZFcHHHG8lfnXcvPO8Zu1E5w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gA3zW7BB8STNvQyrhwF51wYNUjEGaNSJp6e4Xb+R0vq9+B/1l9swPQsQVLY1co2Dr
	 o9CjKLVYFycda9TE9QCqu1laU4/M4dtwV3urMD1iYuhgTVHoiaxr243mWFhif5GS/a
	 l8qdMiLya6ue5Aaacs8Zyo9WlxbhOlyjsmyHdcc4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <zijun.hu@oss.qualcomm.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 046/395] Bluetooth: btnxpuart: Fix skb leak in nxp_process_fw_dump()
Date: Wed, 30 Sep 2026 17:25:08 +0200
Message-ID: <20260930152341.631741672@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 509d837e353e6..c7acf6c7efcf6 100644
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



