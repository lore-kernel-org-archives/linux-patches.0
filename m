Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DF4F403B1B;
	Wed, 30 Sep 2026 19:33:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796835; cv=none; b=dNS2RyU1rQ5dyUBovMhIqSpmMpO1TUu19LftiXwZJqht4jyrVC8PWIcOqzfsD7uydBO/yjkReL1GcQ7SoB8sh/+FdFnG67OaYf/V8KvV5g9sTQupev5e8Ld9wZc1+QZGty/dTqHS1ADUO65J94mPIUO5nxUKFosM2lBf18gtj3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796835; c=relaxed/simple;
	bh=lpDo+VcNuVBWIax2Fh9Ji1sJho34LJxhKalpXyasNf8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GJQii3zWygdirLjHmEnt6R3gyDymDjJXa7n5RmtFZNivPnKolIGmXtVthhwomAvZtkBpYOpZ2nQuWGhHh/FP9ZXWE8B9SlIvXzt2JY7v8dJi269CnAUroAJub4GoMrc7eBpGktFr8hJUDcbUq3ElHOa7dWcg2w0IjG5DcbCNwRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rkDVu8un; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rkDVu8un"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BDBB1F00898;
	Wed, 30 Sep 2026 19:33:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796834;
	bh=lVs3b3Nwtu4rngbuzMUqYtq4DtqehVXl/6rF4PZwD6w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rkDVu8unCvE8DOU47iVoDqpzfYGA9sQMNmPCspO+PxRpRL2MUm01Yo1DRTJrgEACm
	 4iGFsEtJUF+N+W1l4WJq+n/4GRGLJHas+jAhdKJNKx05HSaVrzSqzaBfjI2vbz5FoQ
	 ClNuZImT7GHatkk+4b4iwRmD7g540YqztjIMMF3E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	David Heidelberg <david@ixit.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1046/1193] nfc: st21nfca: validate ISO15693 inventory length
Date: Wed, 30 Sep 2026 17:28:50 +0200
Message-ID: <20260930152457.458571410@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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



