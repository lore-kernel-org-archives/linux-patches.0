Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B5072C1595;
	Sun,  7 Jun 2026 10:40:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780828856; cv=none; b=uHTBeWB8YoBmGfl2N7nZG2sHrEQdUVilh92fNSUGVzziYY4JamM+e05rBx9RzNKOmycU8yBW2/IbrVKiSbdsMGKP3nlGSqtcKW0oS9UdXyTdfbxOuyo5V2FG95b2SDQFfQfAllK3LdJ7e4t7zSUE2ZnVJKU5mRe/nctvjF7pYDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780828856; c=relaxed/simple;
	bh=WAK9zWcLvKwvRe9Vz/SjTjyA2F7h4EDjd1yVTR6KuNA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ex99WmK8s41XnVBfS8jXc15NxKgOaK5OapsfPsduEBhzZpgWDfSJXqnyo31o6ZRzQfCThH2Xef0qcYKtb8A/HV37waxaeUEgUnNgzgZh5ca6q2DJIWOPO0/rViFDap36Avcix8kUZrNa+8BQ35b5HgzUIjFsidgvgdOt0WaU8FM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SvybQSdI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SvybQSdI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41E4A1F00893;
	Sun,  7 Jun 2026 10:40:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780828854;
	bh=FdtpPhfXosVpDWN+zIPentIGCWjaBIQbLsYrsQ5ah70=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SvybQSdIizOfoXCzX0F2DdLLWpmAdtOYOAdZZd09f0r0Ev4gVRpVps8C02skR8Kbd
	 1tjBJ41ZtnzFAPgRKPHT42aSrNRg4d8RKDm6uiIUmffnW8WYL2hIUOh0PAHXn+ZKnB
	 UBbrJZqu+MOYt5XDVOPZRjkRvhiqGeuZJYm4cut0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tianyu Xu <xtydtc@gmail.com>,
	Santhosh Kumar K <s-k6@ti.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 7.0 221/332] spi: spi-mem: avoid mutating op template in spi_mem_supports_op()
Date: Sun,  7 Jun 2026 11:59:50 +0200
Message-ID: <20260607095736.178830239@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
@@ -279,13 +279,20 @@ static bool spi_mem_internal_supports_op
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
 


