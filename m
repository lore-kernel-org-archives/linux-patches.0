Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F6B22F531B;
	Sat, 12 Sep 2026 15:12:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789225963; cv=none; b=T02n6yRmZXCnL2Q7eSPxdZK529nd2BuNhNeyLJMsvps99quBt7Cd6g+C0rDt7WMWZ6XJAKCepDvDFCXc9qv3RTPVezEm9WHh8mFBIQhEXxrOb6SY7OiiU4QOi40tINhHz/tkURXyAb1LXr/Gq3kWDtWoVIzKScBYuaW7tcGtc40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789225963; c=relaxed/simple;
	bh=zXhScFD7aBAF59gSe3EgnxhoIhmXa66ABSGwP4li7p4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sMEpGNErvSVE8kq7FvPIT/Ek2TUIasOYGxogoZBLrhtSNJrp3ZqXm2BdfmWfSNpEoUg96mJe4vErtMkI2/NxaWvFzZ8XPcQWSdN70NcmORt+4PudU3CcaB/l2gdsdXnI76IDxT2Zd8tKjTCnqn3pezmFz634euE+Ml89KropGUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0oQ7KMZ0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0oQ7KMZ0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D90071F000FF;
	Sat, 12 Sep 2026 15:12:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789225962;
	bh=c7S2B9GmsPO9ApOgksQSkHLJQEHpNe8YrhZwyGewKdQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0oQ7KMZ0n3EhPn4o7klQUAemGHgBI6PSpnb+guKLqxtS6JRwoq4yFUq/sATSbKPaZ
	 BaDp+iWz1YJV6r8FjsWKwE0naOcrAZvwQelXRMy6lOGUGeuTXzojL1VahnZcFEDU/r
	 bOafSGjv+HsTDLZPHZKqqUr9T2IzO5QS5W2Qjwvc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1304/1424] i3c: mipi-i3c-hci: Switch PIO data allocation to devm_kzalloc()
Date: Sat, 12 Sep 2026 09:02:16 +0200
Message-ID: <20260912065636.467890417@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

From: Adrian Hunter <adrian.hunter@intel.com>

[ Upstream commit 11d17c2855bfc04550557017eae02e92f3eeab1c ]

The driver already uses managed resources, so convert the PIO data
structure allocation to devm_zalloc().  Remove the manual kfree().

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260113072702.16268-7-adrian.hunter@intel.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Stable-dep-of: 308ecb824db3 ("i3c: mipi-i3c-hci: Fix missing STAT_IBI_STATUS_THLD in PIO mode")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master/mipi-i3c-hci/pio.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/i3c/master/mipi-i3c-hci/pio.c b/drivers/i3c/master/mipi-i3c-hci/pio.c
index 653cee2d0645a..9f0e12d2b906a 100644
--- a/drivers/i3c/master/mipi-i3c-hci/pio.c
+++ b/drivers/i3c/master/mipi-i3c-hci/pio.c
@@ -141,7 +141,7 @@ static int hci_pio_init(struct i3c_hci *hci)
 	struct hci_pio_data *pio;
 	u32 val, size_val, rx_thresh, tx_thresh, ibi_val;
 
-	pio = kzalloc(sizeof(*pio), GFP_KERNEL);
+	pio = devm_kzalloc(hci->master.dev.parent, sizeof(*pio), GFP_KERNEL);
 	if (!pio)
 		return -ENOMEM;
 
@@ -219,8 +219,6 @@ static void hci_pio_cleanup(struct i3c_hci *hci)
 		BUG_ON(pio->curr_rx);
 		BUG_ON(pio->curr_tx);
 		BUG_ON(pio->curr_resp);
-		kfree(pio);
-		hci->io_data = NULL;
 	}
 }
 
-- 
2.53.0



