Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A2B8284662;
	Tue, 21 Jul 2026 19:56:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663799; cv=none; b=ZOrugNgFYurq57tYa2wReIwKHKVHPenfz1LfZthrLHXZwebothZbc5TG7YdBdVU4/RCjGz4ecJ5jwAD76mQGBIqIl49UDr+ctyg+UXnu2xJCB8n/0/cd0yba50k80NZiVdi7FrAvz0qPECAUgO65+oaIjGJovi7eNR6WBh9U+W8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663799; c=relaxed/simple;
	bh=4KvHy+D9X0Ki0qoSY/j+X/KVPjy5QOZjMnEeQ5LkO9U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qM8YRE4zLxvNmtRgYbSv4TWBKNBES/FbU90UsoHYt8icqANA0i5GTVBZ6Im6OlTqzvso+bw8eM4HyecfU2zycnx4HMnCKZhpsz9YPF4uayTJr4crHdwqwjblVDE8NPkD01/HoBQfn/O4eoXN6hrYv+e6Osyh05yFIeK9QLVmeuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=php+Th4H; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="php+Th4H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73AEF1F000E9;
	Tue, 21 Jul 2026 19:56:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663797;
	bh=Bv7THlzuCcCudMLtA14AzJqKRMFGRYcZ3y7QsFjtedA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=php+Th4HF0lgjG4Bf6f7v9NdfEkaEXmvDankTvYd5kCPKO3i5FZbVX9opJ34d7osT
	 eL0CmncxGb37qG5Sy6a9O5SKUgWhQFTqicj4d5R2n/zhQLT9kP9WCahCugEbxao6E2
	 NSuas7BUf7LNngo1WLjhztHtE0/LoB11pu1Pie1g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Pratyush Yadav <pratyush@kernel.org>,
	Tudor Ambarus <tudor.ambarus@linaro.org>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Takahiro Kuwano <takahiro.kuwano@infineon.com>,
	Michael Walle <mwalle@kernel.org>
Subject: [PATCH 6.12 0958/1276] mtd: spi-nor: spansion: use die erase for multi-die devices only
Date: Tue, 21 Jul 2026 17:23:21 +0200
Message-ID: <20260721152507.467039709@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takahiro Kuwano <takahiro.kuwano@infineon.com>

commit 306e443156b82a2a14a3f33da908c303be45529c upstream.

Die erase opcode is supported in multi-die devices only. For single die
devices, default chip erase opcode must be used.

In s25hx_t_late_init(), die erase opcode is set only when the device is
multi-die.

Fixes: 461d0babb544 ("mtd: spi-nor: spansion: enable die erase for multi die flashes")
Cc: stable@kernel.org
Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
Reviewed-by: Tudor Ambarus <tudor.ambarus@linaro.org>
Reviewed-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Takahiro Kuwano <takahiro.kuwano@infineon.com>
Reviewed-by: Michael Walle <mwalle@kernel.org>
Signed-off-by: Pratyush Yadav <pratyush@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/spi-nor/spansion.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/mtd/spi-nor/spansion.c
+++ b/drivers/mtd/spi-nor/spansion.c
@@ -674,7 +674,9 @@ static int s25hx_t_late_init(struct spi_
 	params->ready = cypress_nor_sr_ready_and_clear;
 	cypress_nor_ecc_init(nor);
 
-	params->die_erase_opcode = SPINOR_OP_CYPRESS_DIE_ERASE;
+	if (params->n_dice > 1)
+		params->die_erase_opcode = SPINOR_OP_CYPRESS_DIE_ERASE;
+
 	return 0;
 }
 


