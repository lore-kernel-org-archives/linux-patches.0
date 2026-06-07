Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2997632AAA3;
	Sun,  7 Jun 2026 10:40:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780828849; cv=none; b=g034j/vgy1EckTCp3UodIa1wd7//qk3TRs6F9FJ42nudhaHcizKhTvTQWQfl6oCmZlAW1OTrcD3TSummXeD/XMR4R5n68uNM+sn7CeHTbWH8BXJyI6FabCOJUmnkct8xkoT8wYypfq+HzBXEjVIQZ8fxVy/tqTgGXDIkV+6no28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780828849; c=relaxed/simple;
	bh=WbCK5/02Xsf3gtJuABcd/CaHEj93cycl5PvrIyrUofQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O6VkUaeC8ya9hgJcJ2nT5mgSWMiVMqfXj7phxp8wgeWY+5l3MyqwYQ+iw77fsyOawsz8ecgbBzVtTriG+8A0bHadbtoULjHegw9RRHYU3FzkDBC34HlnL5cKkmSh8cYoY2xuzLRPvmZuNrtHlOa9LJ+8/v74+8C+GNTgtm2pNOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tfkh8jXv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tfkh8jXv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F45A1F00893;
	Sun,  7 Jun 2026 10:40:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780828847;
	bh=Ig+l3yze5BMJxIH05qrU9D2Ze7eYyNrkLhzANVdjNNY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tfkh8jXvx+1zJG2fAQgabO4Hgbxl+Cv2y25zXj0x/auuL4VnNX7r1+QuH6JUKblnz
	 6W8xz5b94dnQqWHC1giZqwPyS8Xp3dUj927ndZyay5LX756teZGg7E/s07aOuuN61n
	 PtmcYuHaQXGCSoZ3GWiaZ2Bj4QxESVJYWsGBtWu0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tianyu Xu <xtydtc@gmail.com>,
	Santhosh Kumar K <s-k6@ti.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.18 196/315] spi: spi-mem: avoid mutating op template in spi_mem_supports_op()
Date: Sun,  7 Jun 2026 11:59:43 +0200
Message-ID: <20260607095734.770563336@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.528828913@linuxfoundation.org>
References: <20260607095727.528828913@linuxfoundation.org>
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

From: Santhosh Kumar K <s-k6@ti.com>

commit 79378db6a86c7014cce40b65252e6c18f5b8bcc2 upstream.

spi_mem_supports_op() accepts a const struct spi_mem_op pointer but
casts away const internally to call spi_mem_adjust_op_freq(). This
mutates the caller's op template, which causes stale max_freq values
when callers reuse persistent templates - subsequent calls won't
re-apply the device frequency cap since spi_mem_adjust_op_freq()
skips non-zero values.

Fix by operating on a stack-local copy instead.

Fixes: a4f8e70d75dd ("spi: spi-mem: add spi_mem_adjust_op_freq() in spi_mem_supports_op()")
Cc: Tianyu Xu <xtydtc@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Santhosh Kumar K <s-k6@ti.com>
Reviewed-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://patch.msgid.link/20260527173736.2243004-1-s-k6@ti.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-mem.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

--- a/drivers/spi/spi-mem.c
+++ b/drivers/spi/spi-mem.c
@@ -276,13 +276,20 @@ static bool spi_mem_internal_supports_op
  */
 bool spi_mem_supports_op(struct spi_mem *mem, const struct spi_mem_op *op)
 {
-	/* Make sure the operation frequency is correct before going futher */
-	spi_mem_adjust_op_freq(mem, (struct spi_mem_op *)op);
+	struct spi_mem_op eval_op = *op;
 
-	if (spi_mem_check_op(op))
+	/*
+	 * Work on a local copy; this is a pure capability check and must
+	 * not modify the caller's op. Stored templates with max_freq == 0
+	 * must remain unset so their frequency is always re-capped to the
+	 * current device maximum at execution time.
+	 */
+	spi_mem_adjust_op_freq(mem, &eval_op);
+
+	if (spi_mem_check_op(&eval_op))
 		return false;
 
-	return spi_mem_internal_supports_op(mem, op);
+	return spi_mem_internal_supports_op(mem, &eval_op);
 }
 EXPORT_SYMBOL_GPL(spi_mem_supports_op);
 


