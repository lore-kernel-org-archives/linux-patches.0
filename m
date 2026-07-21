Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B22A430CE3;
	Tue, 21 Jul 2026 22:49:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674153; cv=none; b=dcyg0a963PyV+C5i5Vav6GEyNz5sRdECv+BhOhjvlVrFl56DD0HO3nlkesuWl1/8oCvAFEhGeu7Q00QDdRNj2uhxYNZxqZpp5oHbimmEMzJ3Bi/cIYf0nJtwqH5VBOBoYGvEvRdithAb6BD+vVLYn7Vy7VpYIz1zyPWq/b41taY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674153; c=relaxed/simple;
	bh=pY0vzfSpj1o+n58yTNjv/f9T33Ks2wtiNutQ2X7WZ8s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d6b3gQlGt0KOarWa4rhls26UenKNBsRjYnMNBYrRPDCqskPWU82Pv0SoW9sIAugbtxxVc1Y/XvGuaQbjshlEUTA3csu1RJMkUX69+WXQakEkeFVF0m5rGi+8ikoVPem9EBXLLG/iJiRDFKDsyNvZQGL2DEBxis+iGkX2wLSvtGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MODDitYN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MODDitYN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0EC91F000E9;
	Tue, 21 Jul 2026 22:49:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674152;
	bh=3aZnYmArHs77CJlxFtYBmQVcxHZZF8uJvAyCDb2X01s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MODDitYNiwwzfdsZap331HptureEuugGnUV9asjxvuy3iwoR02igy1XMhczwFButJ
	 67ISb0tJRTdoLeAFgRkKAg3bub71yJtNJ21ZG4M8F2SsJiSpkz+B+JvEvkvRPQuY9o
	 /VuL+S67yYHY+i8bHQmXpq0N/g55YWGnxo4mKeL8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Mei <xmei5@asu.edu>,
	Weiming Shi <bestswngs@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 406/699] Bluetooth: bpa10x: avoid OOB read of revision string in bpa10x_setup()
Date: Tue, 21 Jul 2026 17:22:45 +0200
Message-ID: <20260721152404.852807518@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Weiming Shi <bestswngs@gmail.com>

[ Upstream commit dd068ef044128db655f48323a4acfd5907e04903 ]

bpa10x_setup() sends the vendor command 0xfc0e and passes the response
to bt_dev_info() and hci_set_fw_info() as a "%s" string starting at
skb->data + 1, without checking the length:

	bt_dev_info(hdev, "%s", (char *)(skb->data + 1));
	hci_set_fw_info(hdev, "%s", skb->data + 1);

A device that returns a one-byte response (status only) leaves
skb->data + 1 past the end of the data, and the %s walk reads adjacent
slab memory until it meets a NUL. The same happens when the payload is
not NUL-terminated within skb->len. The out-of-bounds bytes end up in
the kernel log and the firmware-info debugfs file.

Print the revision string with a bounded "%.*s" limited to skb->len - 1
instead. This keeps the string readable for well-behaved devices while
never reading past the received data, and does not fail setup, so a
device returning a short or unterminated response keeps working.

Fixes: ddd68ec8f484 ("Bluetooth: bpa10x: Read revision information in setup stage")
Reported-by: Xiang Mei <xmei5@asu.edu>
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Weiming Shi <bestswngs@gmail.com>
Reported-by: Xiang Mei <xmei5@asu.edu>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/bpa10x.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/bluetooth/bpa10x.c b/drivers/bluetooth/bpa10x.c
index 1fa58c059cbf5c..8942ebd0d0b9f6 100644
--- a/drivers/bluetooth/bpa10x.c
+++ b/drivers/bluetooth/bpa10x.c
@@ -254,9 +254,13 @@ static int bpa10x_setup(struct hci_dev *hdev)
 	if (IS_ERR(skb))
 		return PTR_ERR(skb);
 
-	bt_dev_info(hdev, "%s", (char *)(skb->data + 1));
+	/* Bounded print: the device controls skb->len. */
+	if (skb->len > 1) {
+		int len = skb->len - 1;
 
-	hci_set_fw_info(hdev, "%s", skb->data + 1);
+		bt_dev_info(hdev, "%.*s", len, (char *)(skb->data + 1));
+		hci_set_fw_info(hdev, "%.*s", len, skb->data + 1);
+	}
 
 	kfree_skb(skb);
 	return 0;
-- 
2.53.0



