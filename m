Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F24F0221570;
	Tue, 29 Apr 2025 17:46:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745948820; cv=none; b=hl/gVDMuvQeCKYdCFfWHVWXUQJdWlCN5riW2VT3SlUSe1ZRVqMW1QomTyxWkFI5cxMcivkN5Xs0N43ZAnnnke0AMkw9g2fJJ919pF3iCitE95dp49WnvVfmgLriShO2+uIyenFe8d2CBDRUgpKcBBrk5FG+4mFgMHhpDETmOQcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745948820; c=relaxed/simple;
	bh=q6kECP1cu8veytxj/ozee6JPozXWLF5nj46ICJaNxss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n+N5XvrowXoXnrTTL+w0O9/lspucXxO9wV1M8wh1hPoW9HidMQ4RmdT3OPWRFSOVeeKt9YUyRB/Rxc+QaLPEaA19UEObSZETUHsM6znp8jahjCIM22ZiPpbJntV+eKJpyYx2rwFFrp1hvIo1KDph3VvhFa0wHyq6pOqBgUhUiLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I+dpa0E/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I+dpa0E/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85CE0C4CEE3;
	Tue, 29 Apr 2025 17:46:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745948819;
	bh=q6kECP1cu8veytxj/ozee6JPozXWLF5nj46ICJaNxss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I+dpa0E/BIAssiPDZb4uafT9ZlkMOR0Qard7ZpdSFft0/id5av31HG4ORXqu3+Sq+
	 PUT+oQRggvEZFSDcS++Lh5oNZxKh7bMQkN0dN0F7TzBDYuzlwn7LLX1B79NVy+m5xx
	 /9uwYr5PhSpXLhAAkQ5ie7V5YKxPy+yKcWidZg78=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 5.15 097/373] mtd: rawnand: Add status chack in r852_ready()
Date: Tue, 29 Apr 2025 18:39:34 +0200
Message-ID: <20250429161127.145018560@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Wentao Liang <vulab@iscas.ac.cn>

commit b79fe1829975556854665258cf4d2476784a89db upstream.

In r852_ready(), the dev get from r852_get_dev() need to be checked.
An unstable device should not be ready. A proper implementation can
be found in r852_read_byte(). Add a status check and return 0 when it is
unstable.

Fixes: 50a487e7719c ("mtd: rawnand: Pass a nand_chip object to chip->dev_ready()")
Cc: stable@vger.kernel.org # v4.20+
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/nand/raw/r852.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/mtd/nand/raw/r852.c
+++ b/drivers/mtd/nand/raw/r852.c
@@ -387,6 +387,9 @@ static int r852_wait(struct nand_chip *c
 static int r852_ready(struct nand_chip *chip)
 {
 	struct r852_device *dev = r852_get_dev(nand_to_mtd(chip));
+	if (dev->card_unstable)
+		return 0;
+
 	return !(r852_read_reg(dev, R852_CARD_STA) & R852_CARD_STA_BUSY);
 }
 


