Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C70591F75BE;
	Tue, 17 Dec 2024 17:25:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734456322; cv=none; b=Opq7kDPDu+xmZ+8wT2Kj5o8XSc5HGagH9Z1C+Ayr92e0wkypJC2+HxFExAu7Je0ACKrfEOe18OC9GamudegPDBJd9ZYdGpZ8wHop8iuC7RheQjfCD2JODgPk1N47nK0RbiyRsTCIGoiLmnhu89rRUiS2NJa8komUQ26xOKHuOB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734456322; c=relaxed/simple;
	bh=XoewR+VOmOs4bP1oKf/+4zSlXE7gbpI8qolYUG+681I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HonC2p3HGIvGtL7sGDkQb7AenkAO30ivo3mlteWZfr20OCEgYbh6bZGZvIjDPpFK8RQpSTHYDLCAA90buk2TeV/nO2hzfPvC6Cvy5yLJrY8prFjVT9mhlYhGSPcjy8AZAf3fFFv57lNZOiZOcgNA0Mlcu3FCcEcJGkUhlJihbqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QitcBtSb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QitcBtSb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39CE7C4CED3;
	Tue, 17 Dec 2024 17:25:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734456322;
	bh=XoewR+VOmOs4bP1oKf/+4zSlXE7gbpI8qolYUG+681I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QitcBtSbXAyDMJsVaqlTUagDtaU17b5YbIlsQ4E2CoJ/mRoltcAZex+/7fRvbKEbA
	 PT8Zzr5FannuEXnNQQJolXOAq+1Z9WwOMSICfW1hM7mQUSK1Ys7zwxJCkdZZcwKcNq
	 Lj3OGtsZnWPkMUIlVgN/WLG3A5fTiom+ziRL7MSg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Loehle <christian.loehle@arm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.12 023/172] spi: rockchip: Fix PM runtime count on no-op cs
Date: Tue, 17 Dec 2024 18:06:19 +0100
Message-ID: <20241217170547.219280123@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170546.209657098@linuxfoundation.org>
References: <20241217170546.209657098@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Christian Loehle <christian.loehle@arm.com>

commit 0bb394067a792e7119abc9e0b7158ef19381f456 upstream.

The early bail out that caused an out-of-bounds write was removed with
commit 5c018e378f91 ("spi: spi-rockchip: Fix out of bounds array
access")
Unfortunately that caused the PM runtime count to be unbalanced and
underflowed on the first call. To fix that reintroduce a no-op check
by reading the register directly.

Cc: stable@vger.kernel.org
Fixes: 5c018e378f91 ("spi: spi-rockchip: Fix out of bounds array access")
Signed-off-by: Christian Loehle <christian.loehle@arm.com>
Link: https://patch.msgid.link/1f2b3af4-2b7a-4ac8-ab95-c80120ebf44c@arm.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-rockchip.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/drivers/spi/spi-rockchip.c
+++ b/drivers/spi/spi-rockchip.c
@@ -241,6 +241,20 @@ static void rockchip_spi_set_cs(struct s
 	struct spi_controller *ctlr = spi->controller;
 	struct rockchip_spi *rs = spi_controller_get_devdata(ctlr);
 	bool cs_asserted = spi->mode & SPI_CS_HIGH ? enable : !enable;
+	bool cs_actual;
+
+	/*
+	 * SPI subsystem tries to avoid no-op calls that would break the PM
+	 * refcount below. It can't however for the first time it is used.
+	 * To detect this case we read it here and bail out early for no-ops.
+	 */
+	if (spi_get_csgpiod(spi, 0))
+		cs_actual = !!(readl_relaxed(rs->regs + ROCKCHIP_SPI_SER) & 1);
+	else
+		cs_actual = !!(readl_relaxed(rs->regs + ROCKCHIP_SPI_SER) &
+			       BIT(spi_get_chipselect(spi, 0)));
+	if (unlikely(cs_actual == cs_asserted))
+		return;
 
 	if (cs_asserted) {
 		/* Keep things powered as long as CS is asserted */


