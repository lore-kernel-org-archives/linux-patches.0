Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E94D2F198B;
	Tue, 17 Jun 2025 16:30:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177829; cv=none; b=kUJsnRBmOLm5qA0wmoNuUvYInBpd69WBAZodMa/0D8Yg/mlEE9jyR8anlT/Z/MtwVIoZmvwAarfvtnSbfGT75OQxCX3ti73Qtb19s0axaLrdJ466xYH5ZBDU8iVhRShBvI/JMUZz9ayyIKYPpFKZvkCIl1o674pAqZmd9U65Zs0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177829; c=relaxed/simple;
	bh=ZpPK4zC7mIPW/Ewg/lngX0lL5lJaPr5qI/mKM3PCkJI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Iqesgf9ly1FfXazFzQzbpnsH3XbaXoXTU5gFaboU8+hiviYdEXJwSLT56SNiJMxk7spzr5aYs9PMmol5fQROpNhkNxKJRBVw6fwOEId3p95i4uEjG+NZZhu2sdEn7rvM1qzszTY/MUo4Ao6rHLCg9CepGU4eTqMEcBGf/nUZG4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KBL/oX3u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KBL/oX3u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81760C4CEF0;
	Tue, 17 Jun 2025 16:30:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177829;
	bh=ZpPK4zC7mIPW/Ewg/lngX0lL5lJaPr5qI/mKM3PCkJI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KBL/oX3uTPssasy0XZviex+m2UW/6AZQi6WE/W8vfU/u5TOJKeHxp+tEZq58ZJmRn
	 qWak7lo7zNWErIXqLUjjJfLFoCrslR6oEJOga2hIS0a8Q+rkJlUWU6zwONn3qI7tIa
	 ECQmAryEtPz8TY0NNiGi9AAD9N//Rc+XqTOGsUK0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tudor Ambarus <tudor.ambarus@linaro.org>,
	=?UTF-8?q?Andr=C3=A9=20Draszik?= <andre.draszik@linaro.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 369/780] firmware: exynos-acpm: fix reading longer results
Date: Tue, 17 Jun 2025 17:21:17 +0200
Message-ID: <20250617152506.478633307@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: André Draszik <andre.draszik@linaro.org>

[ Upstream commit 67af3cd813695fd3e6432b0849c453250c4685aa ]

ACPM commands that return more than 8 bytes currently don't work
correctly, as this driver ignores any such returned bytes.

This is evident in at least acpm_pmic_bulk_read(), where up to 8
registers can be read back and those 8 register values are placed
starting at &xfer->rxd[8].

The reason is that xfter->rxlen is initialized with the size of a
pointer (8 bytes), rather than the size of the byte array that pointer
points to (16 bytes)

Update the code such that we set the number of bytes expected to be the
size of the rx buffer.

Note1: While different commands have different lengths rx buffers, we
have to specify the same length for all rx buffers since acpm_get_rx()
assumes they're all the same length.

Note2: The different commands also have different lengths tx buffers,
but before switching the code to use the minimum possible length, some
more testing would have to be done to ensure this works correctly in
all situations. It seems wiser to just apply this fix here without
additional logic changes for now.

Fixes: a88927b534ba ("firmware: add Exynos ACPM protocol driver")
Reviewed-by: Tudor Ambarus <tudor.ambarus@linaro.org>
Signed-off-by: André Draszik <andre.draszik@linaro.org>
Link: https://lore.kernel.org/r/20250319-acpm-fixes-v2-1-ac2c1bcf322b@linaro.org
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/samsung/exynos-acpm-pmic.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/firmware/samsung/exynos-acpm-pmic.c b/drivers/firmware/samsung/exynos-acpm-pmic.c
index 85e90d236da21..39b33a356ebd2 100644
--- a/drivers/firmware/samsung/exynos-acpm-pmic.c
+++ b/drivers/firmware/samsung/exynos-acpm-pmic.c
@@ -43,13 +43,13 @@ static inline u32 acpm_pmic_get_bulk(u32 data, unsigned int i)
 	return (data >> (ACPM_PMIC_BULK_SHIFT * i)) & ACPM_PMIC_BULK_MASK;
 }
 
-static void acpm_pmic_set_xfer(struct acpm_xfer *xfer, u32 *cmd,
+static void acpm_pmic_set_xfer(struct acpm_xfer *xfer, u32 *cmd, size_t cmdlen,
 			       unsigned int acpm_chan_id)
 {
 	xfer->txd = cmd;
 	xfer->rxd = cmd;
-	xfer->txlen = sizeof(cmd);
-	xfer->rxlen = sizeof(cmd);
+	xfer->txlen = cmdlen;
+	xfer->rxlen = cmdlen;
 	xfer->acpm_chan_id = acpm_chan_id;
 }
 
@@ -71,7 +71,7 @@ int acpm_pmic_read_reg(const struct acpm_handle *handle,
 	int ret;
 
 	acpm_pmic_init_read_cmd(cmd, type, reg, chan);
-	acpm_pmic_set_xfer(&xfer, cmd, acpm_chan_id);
+	acpm_pmic_set_xfer(&xfer, cmd, sizeof(cmd), acpm_chan_id);
 
 	ret = acpm_do_xfer(handle, &xfer);
 	if (ret)
@@ -104,7 +104,7 @@ int acpm_pmic_bulk_read(const struct acpm_handle *handle,
 		return -EINVAL;
 
 	acpm_pmic_init_bulk_read_cmd(cmd, type, reg, chan, count);
-	acpm_pmic_set_xfer(&xfer, cmd, acpm_chan_id);
+	acpm_pmic_set_xfer(&xfer, cmd, sizeof(cmd), acpm_chan_id);
 
 	ret = acpm_do_xfer(handle, &xfer);
 	if (ret)
@@ -144,7 +144,7 @@ int acpm_pmic_write_reg(const struct acpm_handle *handle,
 	int ret;
 
 	acpm_pmic_init_write_cmd(cmd, type, reg, chan, value);
-	acpm_pmic_set_xfer(&xfer, cmd, acpm_chan_id);
+	acpm_pmic_set_xfer(&xfer, cmd, sizeof(cmd), acpm_chan_id);
 
 	ret = acpm_do_xfer(handle, &xfer);
 	if (ret)
@@ -184,7 +184,7 @@ int acpm_pmic_bulk_write(const struct acpm_handle *handle,
 		return -EINVAL;
 
 	acpm_pmic_init_bulk_write_cmd(cmd, type, reg, chan, count, buf);
-	acpm_pmic_set_xfer(&xfer, cmd, acpm_chan_id);
+	acpm_pmic_set_xfer(&xfer, cmd, sizeof(cmd), acpm_chan_id);
 
 	ret = acpm_do_xfer(handle, &xfer);
 	if (ret)
@@ -214,7 +214,7 @@ int acpm_pmic_update_reg(const struct acpm_handle *handle,
 	int ret;
 
 	acpm_pmic_init_update_cmd(cmd, type, reg, chan, value, mask);
-	acpm_pmic_set_xfer(&xfer, cmd, acpm_chan_id);
+	acpm_pmic_set_xfer(&xfer, cmd, sizeof(cmd), acpm_chan_id);
 
 	ret = acpm_do_xfer(handle, &xfer);
 	if (ret)
-- 
2.39.5



