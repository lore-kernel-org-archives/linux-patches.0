Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 295DF1EE7C6;
	Mon, 23 Jun 2025 21:30:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714216; cv=none; b=iVrve8NZ3lG82q4SagJbnQ9D0MWbFo1j2arXijS3O0OaeFXtKESuggGzaRVoqLSr0gkc+6NOWjqRgs1L9yrj9cKl6Cwzar5vYUCJUTssjNH0coLF8OEuCkQ0sRTlRtrS66eu9YNVvLgxVcTG2+8pqCs6FGwgfYvhCBCdLkXE2to=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714216; c=relaxed/simple;
	bh=Iqvwoc3xEswH6W/TEUDTm8BYpH4fH+drL8bt7ppzi08=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lq6S8QpCEf3WaCKu3/v1RP0Xwx5hYXKm967f6tyW8l4G6p15GDbN7rZnK3OQiC42+BzosL9jV5AM3rPLl8z2Vd2kkRqcm5VOs5NhAtuAmuy8uQSy4rQB97s6SE+SReiOMtkLs7ymg4poyDgcFNvxMdWaQdhzBxarYcG7GG6bG7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zZtGnrm4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zZtGnrm4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7B24C4CEEA;
	Mon, 23 Jun 2025 21:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714216;
	bh=Iqvwoc3xEswH6W/TEUDTm8BYpH4fH+drL8bt7ppzi08=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zZtGnrm4jOP+Uw1X9L5doijAD4d1Btb8tstebPBFKqaOu3W6F7j3CRL8mnZv5rYBv
	 ScEk4feWb6YqKgu/Y+v0X1kbuOcKksS4gklJ54W5urrkXj9EJcqkLvcyt/0pCJCHow
	 VxVmpgyuiAulapRgJBKJzSGEq2rV94KRSzM2kziY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niravkumar L Rabara <niravkumar.l.rabara@intel.com>,
	Matthew Gerlach <matthew.gerlach@altera.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Dinh Nguyen <dinguyen@kernel.org>,
	stable@kernel.org
Subject: [PATCH 5.10 192/355] EDAC/altera: Use correct write width with the INTTEST register
Date: Mon, 23 Jun 2025 15:06:33 +0200
Message-ID: <20250623130632.450988336@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1704,9 +1704,9 @@ static ssize_t altr_edac_a10_device_trig
 
 	local_irq_save(flags);
 	if (trig_type == ALTR_UE_TRIGGER_CHAR)
-		writel(priv->ue_set_mask, set_addr);
+		writew(priv->ue_set_mask, set_addr);
 	else
-		writel(priv->ce_set_mask, set_addr);
+		writew(priv->ce_set_mask, set_addr);
 
 	/* Ensure the interrupt test bits are set */
 	wmb();
@@ -1736,7 +1736,7 @@ static ssize_t altr_edac_a10_device_trig
 
 	local_irq_save(flags);
 	if (trig_type == ALTR_UE_TRIGGER_CHAR) {
-		writel(priv->ue_set_mask, set_addr);
+		writew(priv->ue_set_mask, set_addr);
 	} else {
 		/* Setup read/write of 4 bytes */
 		writel(ECC_WORD_WRITE, drvdata->base + ECC_BLK_DBYTECTRL_OFST);


