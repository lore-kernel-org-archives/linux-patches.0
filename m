Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B46F152CCCA;
	Wed, 23 Sep 2026 14:19:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173194; cv=none; b=Q2B55j1OvtRG2yH1CdOZSft1ZOK3fRd5X06pa4wklBfeQdHgwdr5T1EhLtxQByhC8w0qaYKLJheE0MhDpn5Sgm7y3+bQ1VoUzJc76SHNs4q1/73pAl7I6smEBCDbSgky0LH0oS/i8HPIIB3oQGw9+5Zd6e1NZch+o+NQzorIdXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173194; c=relaxed/simple;
	bh=37LH8BnuOn5/bAqUbZlQ/um/Nzv7IJRl9CdFJsn0dNY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jHvd5CXVjpkkAJmbXNxWtYkFzfh4E7RGnjXe2QXrX/2+yx01eaTB0cCXcE3I5lSOo8s+pM9bZnn96aZqlZpUd9z3b4wpYuVW0irseE8VzBGFdv/Mbq4D5lNwPbz4wwyAAQUB+nZlDI2ALmipD8CV1W0mNBbVu2rU+YW5V3iIM5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HTLuyxaf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HTLuyxaf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE35D1F000FF;
	Wed, 23 Sep 2026 14:19:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173192;
	bh=yYn+505i9Mksd5CCogy0OMZZVXX2gGoKpYWCfU8Ka6U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HTLuyxafuOm9IrdSdJLTLddGntT9AwgKBxNvN1R85LzhWZVBVhMk8ai0N2AQGU0EL
	 UWrtTEoxnJPC2jPp9/nc2cqJlTX8pWVFfjM58g6fTBP5tFZRBDLN9TB2+v+R0wZXH0
	 qFMxkG9YnHp01r/+7v25T7sRCcpkX1Zf4NbRxy8U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 169/438] Bluetooth: btintel_pcie: validate TX skb length in send_sync
Date: Wed, 23 Sep 2026 16:03:10 +0200
Message-ID: <20260923140649.152090721@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

From: Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>

[ Upstream commit 4b837ebd0ea21ae5cc26f02dc042edc6fe7b46b9 ]

btintel_pcie_prepare_tx() copies skb->len bytes into a fixed
BTINTEL_PCIE_BUFFER_SIZE (4096) DMA slot via an unchecked memcpy.
Oversized packets are currently rejected only in
btintel_pcie_send_frame(); any future caller of
btintel_pcie_send_sync() would silently overflow the DMA buffer.

Add the bounds check in btintel_pcie_send_sync() itself, right
before skb_push() and the DMA copy.

Assisted-by: Copilot:claude-sonnet-5 code-review code-generation
Fixes: 6e65a09f9275 ("Bluetooth: btintel_pcie: Add *setup* function to download firmware")
Signed-off-by: Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btintel_pcie.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/bluetooth/btintel_pcie.c b/drivers/bluetooth/btintel_pcie.c
index c64e96fe88976..aad466e453013 100644
--- a/drivers/bluetooth/btintel_pcie.c
+++ b/drivers/bluetooth/btintel_pcie.c
@@ -404,6 +404,12 @@ static int btintel_pcie_send_sync(struct btintel_pcie_data *data,
 	if (tfd_index > txq->count)
 		return -ERANGE;
 
+	if (skb->len > BTINTEL_PCIE_BUFFER_SIZE - BTINTEL_PCIE_HCI_TYPE_LEN) {
+		bt_dev_err(hdev, "TX skb too large (%u > %u)", skb->len,
+			   BTINTEL_PCIE_BUFFER_SIZE - BTINTEL_PCIE_HCI_TYPE_LEN);
+		return -EMSGSIZE;
+	}
+
 	/* Firmware raises alive interrupt on HCI_OP_RESET or
 	 * BTINTEL_HCI_OP_RESET
 	 */
-- 
2.53.0



