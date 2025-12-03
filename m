Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D4453587BC;
	Wed,  3 Dec 2025 16:50:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780629; cv=none; b=g803rM7uLMtohHsHvDlZyz0o03Bxf0lb6RdVSjIIvIu/xXXe4kGmZzIM6sSgm6sXSyguY+hE8uGzGzdW0nQKQXlPwlerTdQq/Hg9UYABtqKQ47597R7dTnRILjXAhRX9rlU1RWu0fRPqiJhOghmGV/SLyQRf6JdNuKef7Jj7JwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780629; c=relaxed/simple;
	bh=jbpyUE3Pts0l88R57613wQaQ8x2bTjR3+H1+aSVXgns=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U2IQ9ZDHFGDVpYxA0e9kQ9OvIYgs4W5uGdsqtwmcEwW9DHza18qRk2oQs9yksCHmFlujecFUL/5YuHx/Pyn3DG85qLOCze/fyA5jBsBvRwxHTLGk4rh2gmFQffCuGhZcoNPlFxYvwXYQu+fYMc7Cveq9DSF2pHcKBYZyt5WPDGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jMfjkbqE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jMfjkbqE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EF35C4CEF5;
	Wed,  3 Dec 2025 16:50:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764780629;
	bh=jbpyUE3Pts0l88R57613wQaQ8x2bTjR3+H1+aSVXgns=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jMfjkbqE6FmRtzeoCl5gl6s9BK8yafl0yvNmsXD97y1zUjVlvocmO+ysfcws9nnd8
	 0owaCdye/KHsIPmz8a4LaGBbfDrTbHksUHrthiU5RVG3cj2Hs8AGlvkfsxMggMAUfi
	 /KLzBoWD1kYZ+tJgLn7bXT86Wc+muDv3A7b9EHxs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Tudor Ambarus <tudor.ambarus@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 043/132] spi: spi-mem: Add a new controller capability
Date: Wed,  3 Dec 2025 16:28:42 +0100
Message-ID: <20251203152344.891280482@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152343.285859633@linuxfoundation.org>
References: <20251203152343.285859633@linuxfoundation.org>
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

From: Miquel Raynal <miquel.raynal@bootlin.com>

[ Upstream commit 1248c9b8d54120950fda10fbeb98fb8932b4d45c ]

There are spi devices with multiple frequency limitations depending on
the invoked command. We probably do not want to afford running at the
lowest supported frequency all the time, so if we want to get the most
of our hardware, we need to allow per-operation frequency limitations.

Among all the SPI memory controllers, I believe all are capable of
changing the spi frequency on the fly. Some of the drivers do not make
any frequency setup though. And some others will derive a per chip
prescaler value which will be used forever.

Actually changing the frequency on the fly is something new in Linux, so
we need to carefully flag the drivers which do and do not support it. A
controller capability is created for that, and the presence for this
capability will always be checked before accepting such pattern.

Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Reviewed-by: Tudor Ambarus <tudor.ambarus@linaro.org>
Link: https://patch.msgid.link/20241224-winbond-6-11-rc1-quad-support-v2-2-ad218dbc406f@bootlin.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 40ad64ac25bb ("spi: nxp-fspi: Propagate fwnode in ACPI case as well")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-mem.c       | 6 ++++++
 include/linux/spi/spi-mem.h | 2 ++
 2 files changed, 8 insertions(+)

diff --git a/drivers/spi/spi-mem.c b/drivers/spi/spi-mem.c
index 12299ce89a1cc..96374afd0193c 100644
--- a/drivers/spi/spi-mem.c
+++ b/drivers/spi/spi-mem.c
@@ -191,6 +191,12 @@ bool spi_mem_default_supports_op(struct spi_mem *mem,
 	    op->max_freq < mem->spi->controller->min_speed_hz)
 		return false;
 
+	if (op->max_freq &&
+	    op->max_freq < mem->spi->max_speed_hz) {
+		if (!spi_mem_controller_is_capable(ctlr, per_op_freq))
+			return false;
+	}
+
 	return spi_mem_check_buswidth(mem, op);
 }
 EXPORT_SYMBOL_GPL(spi_mem_default_supports_op);
diff --git a/include/linux/spi/spi-mem.h b/include/linux/spi/spi-mem.h
index 84ec524987921..c7a7719c26484 100644
--- a/include/linux/spi/spi-mem.h
+++ b/include/linux/spi/spi-mem.h
@@ -311,11 +311,13 @@ struct spi_controller_mem_ops {
  * @ecc: Supports operations with error correction
  * @swap16: Supports swapping bytes on a 16 bit boundary when configured in
  *	    Octal DTR
+ * @per_op_freq: Supports per operation frequency switching
  */
 struct spi_controller_mem_caps {
 	bool dtr;
 	bool ecc;
 	bool swap16;
+	bool per_op_freq;
 };
 
 #define spi_mem_controller_is_capable(ctlr, cap)	\
-- 
2.51.0



