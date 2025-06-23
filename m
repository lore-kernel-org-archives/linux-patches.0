Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5ADA13A265;
	Mon, 23 Jun 2025 13:16:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684606; cv=none; b=uXMgsgMkt1cdXKgtPzJER1SpezzWloBvLg9fTIE6KnpZu2Zcx9/XtXAsaEuow83L0sn5hpQArvoAxG9/NyvCaKp0DIUgeV3yfPPJ3py7m/RnQp/xPm/0TmhIR171BOA6SW/+NGv9tLhEhaBOkvLaQuIkI1FdacMkg85abT5mRcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684606; c=relaxed/simple;
	bh=U2k9ZEoT8wtH5BcxbxNMq6kDG0z/c+oFMhXuPek1nf8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YR/LS8zbEl2xgOGg7wJCtw4Qi+VLo4gvh+bHt6EvH5PZFSuDKPK0EnMTO/FBFrgHSAsmLLv/d3V52w1Zg+I/0ZbfsG6I2hI4IFQVKkbyCPB72Q2mpny0+KyBlwF8v+XkdCxjoRu5ZpOdlKG2WglDa6oghRTNbzAoyEaUeQztV/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DRZTRTYc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DRZTRTYc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FDECC4CEEA;
	Mon, 23 Jun 2025 13:16:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684606;
	bh=U2k9ZEoT8wtH5BcxbxNMq6kDG0z/c+oFMhXuPek1nf8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DRZTRTYc2tm6knqchR8Ehr3/WJ4Oc549qf4GzNf45UyjRl5wDnJ5tCW3LeXrgAlMV
	 KkmRqYgRPpq6ahiTGA/t7MbfI6UuwGxlCnRDHAuJwftyaI9bweTmlnsZdS/oIsXBD4
	 QE5KY+xULdcFFL4O/dMk+5CkNb0bWF+44nAPMsns=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niravkumar L Rabara <niravkumar.l.rabara@intel.com>,
	Matthew Gerlach <matthew.gerlach@altera.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Dinh Nguyen <dinguyen@kernel.org>,
	stable@kernel.org
Subject: [PATCH 6.15 132/592] EDAC/altera: Use correct write width with the INTTEST register
Date: Mon, 23 Jun 2025 15:01:30 +0200
Message-ID: <20250623130703.412249231@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1746,9 +1746,9 @@ altr_edac_a10_device_trig(struct file *f
 
 	local_irq_save(flags);
 	if (trig_type == ALTR_UE_TRIGGER_CHAR)
-		writel(priv->ue_set_mask, set_addr);
+		writew(priv->ue_set_mask, set_addr);
 	else
-		writel(priv->ce_set_mask, set_addr);
+		writew(priv->ce_set_mask, set_addr);
 
 	/* Ensure the interrupt test bits are set */
 	wmb();
@@ -1778,7 +1778,7 @@ altr_edac_a10_device_trig2(struct file *
 
 	local_irq_save(flags);
 	if (trig_type == ALTR_UE_TRIGGER_CHAR) {
-		writel(priv->ue_set_mask, set_addr);
+		writew(priv->ue_set_mask, set_addr);
 	} else {
 		/* Setup read/write of 4 bytes */
 		writel(ECC_WORD_WRITE, drvdata->base + ECC_BLK_DBYTECTRL_OFST);


