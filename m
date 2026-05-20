Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CE4C3D75D3;
	Wed, 20 May 2026 17:36:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298608; cv=none; b=EnTPqCrO7xp7IS7/0rQ10I+hJmTUszwgwTA8oUyQYw56beDmlAt/GkFPhK6nf0ZnJfx5S9LFCkf3znd4aT1eHqqZdof9OvHnnZKVyMJQ35c5wGwsmCjZxMjnMjW7QK/5W1OUjsPFmdSb0FB5JujGCed1C2XtNBun0HNRS7wTs74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298608; c=relaxed/simple;
	bh=1xYCdNHVk8dfQB8QnDXmeif0GnU2s5FL9GCLNfD70Tg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H5/sDMG0vV/b/n4VELw6vm7HQJVsbpW8J1DK7r8k81F4LG8ScD3o4dZKD+qUULVGtPnaFOaA9IaHSxyMu91n22q6E3TEBZl2X8w3NM9xQaT4V6H/OxMNxA4t1Xtauy3n0ubGThMPbHK/Zz44kTapnyLzdsoG7NwNJRL1x3uwv3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BdMzL7h5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BdMzL7h5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 832611F000E9;
	Wed, 20 May 2026 17:36:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298607;
	bh=x8OXY2YXyxGgEwX9DT5ESe0E/l88mW6FfcW11jMhxkk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BdMzL7h5qL+A5K3o6gS8THeFvm82hmuJ75UjXiJbX74bfTg7MO0/Nbsjxl2HIHWVN
	 qzF8RlfH/zARIS8AM/K0wwQrplijfFJSXHZZ8cxhmNRuGSJxhVQvowBd5K0lYlL/iM
	 0UI2fQKv0qqLQbw+4ftMsIOjIKoWOetU43IJunI4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tudor Ambarus <tudor.ambarus@linaro.org>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 474/957] mtd: spinand: Add missing check
Date: Wed, 20 May 2026 18:15:57 +0200
Message-ID: <20260520162144.805379367@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miquel Raynal <miquel.raynal@bootlin.com>

[ Upstream commit aab8a4c656379a6a1a4ca716f48118680560eaab ]

The update cache variant is mandatory, both read and write versions are
being checked, but not this one. All chip drivers seem to implement this
variant, so there should be no breakage.

Reviewed-by: Tudor Ambarus <tudor.ambarus@linaro.org>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Stable-dep-of: 25a915fad503 ("mtd: spinand: winbond: Clarify when to enable the HS bit")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/spi/core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/mtd/nand/spi/core.c b/drivers/mtd/nand/spi/core.c
index 697877584a285..33e6b76944ab8 100644
--- a/drivers/mtd/nand/spi/core.c
+++ b/drivers/mtd/nand/spi/core.c
@@ -1436,6 +1436,9 @@ int spinand_match_and_init(struct spinand_device *spinand,
 
 		op = spinand_select_op_variant(spinand,
 					       info->op_variants.update_cache);
+		if (!op)
+			return -ENOTSUPP;
+
 		spinand->op_templates.update_cache = op;
 
 		return 0;
-- 
2.53.0



