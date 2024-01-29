Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AD62157050;
	Mon, 29 Jan 2024 17:07:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548030; cv=none; b=KuCVM6ThgZHUv6VyiIB0DnqXMxDGcb0Mx2rcsR2tw/7ksP9DCqU6HiOBwOnyaIiMjMOHc5NxWmdtIDolhtyMRoqyvKgMobJPSAI/Hfac0EKwWV4ZHDu9WKcCw57NVQ5BSyQdDq4UQO2fICJdqOjkAskUcQlz45nHOZ0jPsi7lv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548030; c=relaxed/simple;
	bh=ZdtF0faehLxQHhpPRPMVmgxBipDxDc9iNjBLxkfN7sU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qa77WMKlTtAfkna2+Aoxhd/IIzFw1MkOgxrUagHBOySBgkA1iPw+nNkU8SBKOG46HPppnVe5hA09CimdDLLwhNPeo7gs0+tBEB0BCdym23gyDXxdhaZqSN3vSexy7Reqj2fs3sEziosBxRacoIvUOIzsPL2XHV5Ki74XbgajelM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xw5tQwlK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xw5tQwlK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41679C43390;
	Mon, 29 Jan 2024 17:07:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548030;
	bh=ZdtF0faehLxQHhpPRPMVmgxBipDxDc9iNjBLxkfN7sU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xw5tQwlKY3kdOhrY4a8U9lZJhKDYQtit7X7vyQ70qFmWql480JTdqC5MZjjrxws8j
	 R/N33CmAy+LRpnlkghK6Av4m2BvrLkhJZnC3ZhG+jwajZ7DkBC9qiYSLTYGqh6/jYc
	 FZrDGnIJ0siKks5H45c/kwI61JQ6w5OUyXkhMpyQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	=?UTF-8?q?Martin=20Hundeb=C3=B8ll?= <martin@geanix.com>
Subject: [PATCH 6.7 025/346] mtd: rawnand: Prevent sequential reads with on-die ECC engines
Date: Mon, 29 Jan 2024 09:00:56 -0800
Message-ID: <20240129170017.119413986@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miquel Raynal <miquel.raynal@bootlin.com>

commit a62c4597953fe54c6af04166a5e2872efd0e1490 upstream.

Some devices support sequential reads when using the on-die ECC engines,
some others do not. It is a bit hard to know which ones will break other
than experimentally, so in order to avoid such a difficult and painful
task, let's just pretend all devices should avoid using this
optimization when configured like this.

Cc: stable@vger.kernel.org
Fixes: 003fe4b9545b ("mtd: rawnand: Support for sequential cache reads")
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Tested-by: Martin Hundebøll <martin@geanix.com>
Link: https://lore.kernel.org/linux-mtd/20231215123208.516590-4-miquel.raynal@bootlin.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/nand/raw/nand_base.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/mtd/nand/raw/nand_base.c
+++ b/drivers/mtd/nand/raw/nand_base.c
@@ -5170,6 +5170,14 @@ static void rawnand_late_check_supported
 	/* The supported_op fields should not be set by individual drivers */
 	WARN_ON_ONCE(chip->controller->supported_op.cont_read);
 
+	/*
+	 * Too many devices do not support sequential cached reads with on-die
+	 * ECC correction enabled, so in this case refuse to perform the
+	 * automation.
+	 */
+	if (chip->ecc.engine_type == NAND_ECC_ENGINE_TYPE_ON_DIE)
+		return;
+
 	if (!nand_has_exec_op(chip))
 		return;
 


