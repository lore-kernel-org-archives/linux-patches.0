Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 586BB50B437;
	Wed, 30 Sep 2026 16:43:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786626; cv=none; b=BhNV8BthPTmPoofwGiF9xl9+uF95OBmR/ennCWSEwEgYI7+paBufvLTZX7+yRQDhINMm9MVn2AzsIF4UEWJK2jzaBC9fIBB63yr2iiY27RQraafbQk+37+oCIhYl3G13kyPtdOnQCFl693cnbuaqcwlQ66G7DN9ZB3cNtZpB2dI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786626; c=relaxed/simple;
	bh=mpTpeHTM9elPXBH5sK4KfXeUZ/dLUULizMGW7SvStfQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZGDJutEHz+zAvrHVzK9kWZphrVVaNwJ+yPN1oyxsA19L2/nsCFlg6Ip4u4WxwCHYIiRDegbvcdclCr6zf01+PqdVwcg+CWN+M0ZrclUFnSFvXS+4IID/k7upG27rEaoHU3lC9juDK7XKfTvK4F1lyfDsm5j3Wk57Lrjn2lw//oc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vFmndTrE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vFmndTrE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA6CD1F000FF;
	Wed, 30 Sep 2026 16:43:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786625;
	bh=Qtd4TznUGb4WaCbVcJoGZe+SwEtWfCHhTAlsftslisI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vFmndTrEitn9PDgWO/4KWw/fYAxqnmw7AaOOiXGVCoJ22ju4Vw7dX6U6GOQ3nXTTP
	 ZrAC9h7PfNbajtc10jSQQCcwpZULOBAc6utd3rvnuApCuGDt+SotaqUt2RQhl5VAFU
	 bSBUw9sabdqEvOrVllex3of05UMJ9KPBz3XAStDk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	David Heidelberg <david@ixit.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 883/982] nfc: st21nfca: validate ISO15693 inventory length
Date: Wed, 30 Sep 2026 17:26:59 +0200
Message-ID: <20260930152435.714977159@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



