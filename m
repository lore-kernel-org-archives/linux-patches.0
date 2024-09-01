Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A27E92B9C7;
	Sun,  1 Sep 2024 16:42:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208921; cv=none; b=j5y6orYgxxQnwsN23mqp0AkXt01YTr3YPUGukLi7+z86qk+9plpyXh4KDooH2xAA8CqXVqMvbmbzMflxUWY8bwax/cJBSEqQkF5cU8CBy5gURPa5ugSEtWkeKl37MeqWMRjsUGxuJvbkpStDqZnPeOqmREiZ2cnp4RsP7T/bIIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208921; c=relaxed/simple;
	bh=vo/17mCWQWoQJaN87SoYKPsyEsiWuOtYqYMddRkQ7hc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GzKo9WVJsps3Yt8GBxtlj8OLYAgqBjHj246bfAq6STyvlAxsQ8SzKbUC4Sz7uuOxQiUwRvn+5qFZ3M1LjXIVkSEn3QSqDiquAiOVQYh7SL2dUol+QiKpj05/gtDQoPZbGRG+O2mkuWzAPylB49/JVCenmxd5WKuQgcCJZZy2sBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jre+DbmQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jre+DbmQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12E4FC4CEC3;
	Sun,  1 Sep 2024 16:42:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208921;
	bh=vo/17mCWQWoQJaN87SoYKPsyEsiWuOtYqYMddRkQ7hc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jre+DbmQdGwNwKtm7Jk8tEiZ9GS5T7f7o9+w9sci+mREtrmgLAD1sDlV+sG2YQJd7
	 yCYAowBU9yebK3qY3c4dWXLIf4AsCW7KWmUhizido4Zxva9B5dbQjtoZ31tAGENuKs
	 DQxEoKfp1fis8FBfcXTtgCt6/UgI1HdFRFSzPtIc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Marcel Holtmann <marcel@holtmann.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 080/134] Bluetooth: Make use of __check_timeout on hci_sched_le
Date: Sun,  1 Sep 2024 18:17:06 +0200
Message-ID: <20240901160813.110000056@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160809.752718937@linuxfoundation.org>
References: <20240901160809.752718937@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit 1b1d29e5149990e44634b2e681de71effd463591 ]

This reuse __check_timeout on hci_sched_le following the same logic
used hci_sched_acl.

Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Stable-dep-of: 932021a11805 ("Bluetooth: hci_core: Fix LE quote calculation")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_core.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index 71a7e42097cc0..6caef575c628c 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -4240,15 +4240,10 @@ static void hci_sched_le(struct hci_dev *hdev)
 	if (!hci_conn_num(hdev, LE_LINK))
 		return;
 
-	if (!hci_dev_test_flag(hdev, HCI_UNCONFIGURED)) {
-		/* LE tx timeout must be longer than maximum
-		 * link supervision timeout (40.9 seconds) */
-		if (!hdev->le_cnt && hdev->le_pkts &&
-		    time_after(jiffies, hdev->le_last_tx + HZ * 45))
-			hci_link_tx_to(hdev, LE_LINK);
-	}
-
 	cnt = hdev->le_pkts ? hdev->le_cnt : hdev->acl_cnt;
+
+	__check_timeout(hdev, cnt);
+
 	tmp = cnt;
 	while (cnt && (chan = hci_chan_sent(hdev, LE_LINK, &quote))) {
 		u32 priority = (skb_peek(&chan->data_q))->priority;
-- 
2.43.0



