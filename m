Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 687DF51B163;
	Wed, 30 Sep 2026 18:22:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792577; cv=none; b=jXP3ZzN5NEFIDOEYUauNKYBDgeWFh18mZzFvaWrQhVl4zmXZ6+WqAo8czNf2qvb10DJCUKeRo6cAG2HKghe2MWiYscO4ZF4Hkmka6RdFPZYVrk3kDK7UPAbSH4Bj9P/YJlSN4lcAsGE8ByYgG6TPDWNgKkYa5I20abWcdCTA0rE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792577; c=relaxed/simple;
	bh=IBX1UKtsfiRzSxvgo841/nR/uAeEjOI6+ClshXiyf+w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JOT8zD3aZkP0794YY49+dWic2/xj1hV6WkD0IVnPbbeuYS7P2aGORDZLxNqzdK5saQOCP2Iv87B2KX35das8pz2xw0QVjtgrKcoEVdTzGaszqfWS++zWxU9K0kedjjPJanEXXpgqahGQdDkB0vp46X93Sf75AOdRf2JMbNq5mPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LCw7DXTf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LCw7DXTf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BABC61F000FF;
	Wed, 30 Sep 2026 18:22:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792576;
	bh=CR7u2wc7CaYDZEyMO/uTuJMe3OcJa4bJZ+KTZsUZ6+s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LCw7DXTffYhlkRxsTB9Dj/8e5Xqtgkdq/PiWzSsAkx5rVnchDUA8D+lrAZAYLAjTa
	 tbyEQmmQPid6VReHBNxGJ1+cIrBhP+uCSOEmbPElEJBJiljdOJBBE2N6KC0GbQHiab
	 KFei7BnZxyVxxjJw7sRnm7piqL+h3PUDRZvawQtI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	David Heidelberg <david@ixit.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 658/752] nfc: st21nfca: validate ISO15693 inventory length
Date: Wed, 30 Sep 2026 17:28:48 +0200
Message-ID: <20260930152412.494937676@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 7f2ea5ed588c03d481f0301e6c3d4240132383fb ]

The ISO15693 inventory helper removes a two-byte prefix without checking
that it exists, then accepts a one-byte remainder before reading data[1] as
the DSFID.

Require the prefix and at least two remaining bytes before copying the UID
data and reading the DSFID.

Fixes: 7974728094d3 ("NFC: st21nfca: Add ISO15693 Reader/Writer support")
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260830132958.6397-1-pengpeng@iscas.ac.cn
Signed-off-by: David Heidelberg <david@ixit.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nfc/st21nfca/core.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/nfc/st21nfca/core.c b/drivers/nfc/st21nfca/core.c
index 161caf2675cfc..7eb5e5f0686be 100644
--- a/drivers/nfc/st21nfca/core.c
+++ b/drivers/nfc/st21nfca/core.c
@@ -577,9 +577,7 @@ static int st21nfca_get_iso15693_inventory(struct nfc_hci_dev *hdev,
 	if (r < 0)
 		goto exit;
 
-	skb_pull(inventory_skb, 2);
-
-	if (inventory_skb->len == 0 ||
+	if (!skb_pull(inventory_skb, 2) || inventory_skb->len < 2 ||
 	    inventory_skb->len > NFC_ISO15693_UID_MAXSIZE) {
 		r = -EPROTO;
 		goto exit;
-- 
2.53.0



