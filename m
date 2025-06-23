Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCD024315A;
	Mon, 23 Jun 2025 21:41:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714877; cv=none; b=Sn6mfGIRAUdQN2Tbt/QeKR2ulrsosCx3+DshZmXSdxBzj52EkOftHTOBxvSkkdY2I5k9BKuIPkReXAgXFmI2UyfVHPdLTaYgHhEKvKzzeSCtiW90gBaOk6OZG48VoWtRWM3w7eNVeNPn4CDDIPR6vnBB9QUgjm2z7BYFv5rjv10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714877; c=relaxed/simple;
	bh=vPDLesdtCiXjDFmz0pN+3qFR8CFFQ+Y2EDhlmw1WCtQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gTt9/+azfRlKsQZ8lrFgpVmvfXa9pkCJRQyr9GoYPrBIARNHs+VvcQp0kxQr+D4dXk89FDAp+QmPsvZuZjiKGHhSx2r4B/Fx3omq46WhTCi4ObvOpRpQhEB4iDGHbXmwh1w/As5WxfVT7A2v3i3mEPh31yUZGG/rGA4tKf8mdFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wzE8KkZZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wzE8KkZZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66B43C4CEEA;
	Mon, 23 Jun 2025 21:41:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714877;
	bh=vPDLesdtCiXjDFmz0pN+3qFR8CFFQ+Y2EDhlmw1WCtQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wzE8KkZZyqrCwrkHl9i48KX8V1NQj0KlSrKNHIwWrrLhL73z0NE4Zgm0gJ+xQikSH
	 SRRWZAdtwI9Lklp+kN07khcztGCbe9RrOxZ7eyyQpIDqvfoS8PgFwqOJ3kyv0qUD11
	 MeazrmYYENZXRw+dPWbyuOCdxMeBXvYuuJRNeQMg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niravkumar L Rabara <niravkumar.l.rabara@intel.com>,
	Matthew Gerlach <matthew.gerlach@altera.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Dinh Nguyen <dinguyen@kernel.org>,
	stable@kernel.org
Subject: [PATCH 5.15 235/411] EDAC/altera: Use correct write width with the INTTEST register
Date: Mon, 23 Jun 2025 15:06:19 +0200
Message-ID: <20250623130639.571799860@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
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

From: Niravkumar L Rabara <niravkumar.l.rabara@intel.com>

commit e5ef4cd2a47f27c0c9d8ff6c0f63a18937c071a3 upstream.

On the SoCFPGA platform, the INTTEST register supports only 16-bit writes.
A 32-bit write triggers an SError to the CPU so do 16-bit accesses only.

  [ bp: AI-massage the commit message. ]

Fixes: c7b4be8db8bc ("EDAC, altera: Add Arria10 OCRAM ECC support")
Signed-off-by: Niravkumar L Rabara <niravkumar.l.rabara@intel.com>
Signed-off-by: Matthew Gerlach <matthew.gerlach@altera.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Acked-by: Dinh Nguyen <dinguyen@kernel.org>
Cc: stable@kernel.org
Link: https://lore.kernel.org/20250527145707.25458-1-matthew.gerlach@altera.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/edac/altera_edac.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/edac/altera_edac.c
+++ b/drivers/edac/altera_edac.c
@@ -1718,9 +1718,9 @@ altr_edac_a10_device_trig(struct file *f
 
 	local_irq_save(flags);
 	if (trig_type == ALTR_UE_TRIGGER_CHAR)
-		writel(priv->ue_set_mask, set_addr);
+		writew(priv->ue_set_mask, set_addr);
 	else
-		writel(priv->ce_set_mask, set_addr);
+		writew(priv->ce_set_mask, set_addr);
 
 	/* Ensure the interrupt test bits are set */
 	wmb();
@@ -1750,7 +1750,7 @@ altr_edac_a10_device_trig2(struct file *
 
 	local_irq_save(flags);
 	if (trig_type == ALTR_UE_TRIGGER_CHAR) {
-		writel(priv->ue_set_mask, set_addr);
+		writew(priv->ue_set_mask, set_addr);
 	} else {
 		/* Setup read/write of 4 bytes */
 		writel(ECC_WORD_WRITE, drvdata->base + ECC_BLK_DBYTECTRL_OFST);


