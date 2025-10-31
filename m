Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B26DD34C80D;
	Fri, 31 Oct 2025 14:06:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761919611; cv=none; b=pBIhVux+Gny3RftrQfUySAW/Qrcc58SCqMafzjGTKU4uXHsAFCOD8N8Et0E01Fv4crwqnckLH++19BPlLBKZlEjpcqEUjlxdmvyLpLtYf0Jeh9GrhC2l6lK44I375/p8+bPoYOe4sc+ytcnWQvGxOvVdm9JsoCRxOdWw7fWFDMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761919611; c=relaxed/simple;
	bh=MJlMjPYH9Dwb5Cf9HAZum2Z4P7XmsaHOEyxU/03d0JM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qlq6lVZC7wver4tOBak8c/coOhkNxzYEXCM36gt/0/UR7SSmOy2QrV3iQaIxcOs27gjEiXFV4snHrrflASogJMVz7UnG1Ps4qpXvxiVN9GtXPsM+xGf19PzM9tyBaetnTinCf8/+PDO8k2yamx7wd9yDH0ca9S66yUhT6UrU5U0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DNa9D55m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DNa9D55m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35FADC4CEE7;
	Fri, 31 Oct 2025 14:06:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761919611;
	bh=MJlMjPYH9Dwb5Cf9HAZum2Z4P7XmsaHOEyxU/03d0JM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DNa9D55m8ThMcsXEDdmUcBIzKypi8Vh3GjtzVMNedE2X8DHqWPtTx0sfPmUhF8f7X
	 M57wfuvoCyB6hY9zP0lsaYVPX+h9v8t/22a6TQKx+hS/CuXYuDpQ8+cVv6AoYMdJvq
	 GBdi9G/Xkdd2J+A3J/YRCCaM5qwuXAtPDgdhlDYU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 09/35] genirq/manage: Add buslock back in to enable_irq()
Date: Fri, 31 Oct 2025 15:01:17 +0100
Message-ID: <20251031140043.782206852@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251031140043.564670400@linuxfoundation.org>
References: <20251031140043.564670400@linuxfoundation.org>
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

From: Charles Keepax <ckeepax@opensource.cirrus.com>

[ Upstream commit ef3330b99c01bda53f2a189b58bed8f6b7397f28 ]

The locking was changed from a buslock to a plain lock, but the patch
description states there was no functional change. Assuming this was
accidental so reverting to using the buslock.

Fixes: bddd10c55407 ("genirq/manage: Rework enable_irq()")
Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://patch.msgid.link/20251023154901.1333755-4-ckeepax@opensource.cirrus.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/irq/manage.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 7d68fb5dc2428..400856abf6721 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -789,7 +789,7 @@ void __enable_irq(struct irq_desc *desc)
  */
 void enable_irq(unsigned int irq)
 {
-	scoped_irqdesc_get_and_lock(irq, IRQ_GET_DESC_CHECK_GLOBAL) {
+	scoped_irqdesc_get_and_buslock(irq, IRQ_GET_DESC_CHECK_GLOBAL) {
 		struct irq_desc *desc = scoped_irqdesc;
 
 		if (WARN(!desc->irq_data.chip, "enable_irq before setup/request_irq: irq %u\n", irq))
-- 
2.51.0



