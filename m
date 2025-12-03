Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CC1334D918;
	Wed,  3 Dec 2025 16:50:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780622; cv=none; b=PerB+8wPO41Q5dg27KUvF9xlecWwM+oSMHmtyV+l6F0QvIMDh0iG9vVD3j11pOI+GcN0ielGX6XrHzOJq4rG9N9VBmrMuqxQ6siiKVjTXnoKKOhJIPrrANjxnTAaof9CrrHopfaqcwIVbkgz3flclRvOn4Mu09TqjxIOu3U7+Zo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780622; c=relaxed/simple;
	bh=txRaVSPl9MCA5CX56FjIcdl5GN5Vr0QDlqEp/lDPRzQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZzRca7+K77O0p1WExFrqvNayu5gbPCopIoIahd2X8VEVB89eTGRgQPyVdnhYra/2FC6GGAUMN4zKmA9PM+REKTH7cyKhTpoQKgJjBUcg0NGNQvNC29lrgV787qvsnZWncke9B6cPDxkQLmNtyeUZrDrEsd7kTkWPfl74Y19qWgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NsPOpPhS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NsPOpPhS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1130C4CEF5;
	Wed,  3 Dec 2025 16:50:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764780622;
	bh=txRaVSPl9MCA5CX56FjIcdl5GN5Vr0QDlqEp/lDPRzQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NsPOpPhSna7J5L6MypyXYdlqb6UaWhbim/SrbYYV4TEjVdLKOM5oveMg+NpsJcOC6
	 qDObdweAL9JvuBZ3iyVR5CqhpoVKGzHgcFxgYfS9wZwHEi202EYOb18/J/JF+SPJuB
	 RLiZtFrqgCdM4H+11rYhjex2ZlwJSOPwkTuPDl8g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Walle <mwalle@kernel.org>,
	JaimeLiao <jaimeliao@mxic.com.tw>,
	AlvinZhou <alvinzhou@mxic.com.tw>,
	Mark Brown <broonie@kernel.org>,
	Tudor Ambarus <tudor.ambarus@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 041/132] spi: spi-mem: Allow specifying the byte order in Octal DTR mode
Date: Wed,  3 Dec 2025 16:28:40 +0100
Message-ID: <20251203152344.817852784@linuxfoundation.org>
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

From: Tudor Ambarus <tudor.ambarus@linaro.org>

[ Upstream commit 030ace430afcf847f537227afceb22dfe8fb8fc8 ]

There are NOR flashes (Macronix) that swap the bytes on a 16-bit
boundary when configured in Octal DTR mode. The byte order of
16-bit words is swapped when read or written in Octal Double
Transfer Rate (DTR) mode compared to Single Transfer Rate (STR)
modes. If one writes D0 D1 D2 D3 bytes using 1-1-1 mode, and uses
8D-8D-8D SPI mode for reading, it will read back D1 D0 D3 D2.
Swapping the bytes may introduce some endianness problems. It can
affect the boot sequence if the entire boot sequence is not handled
in either 8D-8D-8D mode or 1-1-1 mode. Therefore, it is necessary
to swap the bytes back to ensure the same byte order as in STR modes.
Fortunately there are controllers that could swap the bytes back at
runtime, addressing the flash's endianness requirements. Provide a
way for the upper layers to specify the byte order in Octal DTR mode.

Merge Tudor's patch and add modifications for suiting newer version
of Linux kernel.

Suggested-by: Michael Walle <mwalle@kernel.org>
Signed-off-by: JaimeLiao <jaimeliao@mxic.com.tw>
Signed-off-by: AlvinZhou <alvinzhou@mxic.com.tw>
Acked-by: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/r/20240926141956.2386374-3-alvinzhou.tw@gmail.com
Signed-off-by: Tudor Ambarus <tudor.ambarus@linaro.org>
Stable-dep-of: 40ad64ac25bb ("spi: nxp-fspi: Propagate fwnode in ACPI case as well")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-mem.c       | 3 +++
 include/linux/spi/spi-mem.h | 8 +++++++-
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-mem.c b/drivers/spi/spi-mem.c
index 17b8baf749e6a..abc6792e738c7 100644
--- a/drivers/spi/spi-mem.c
+++ b/drivers/spi/spi-mem.c
@@ -172,6 +172,9 @@ bool spi_mem_default_supports_op(struct spi_mem *mem,
 		if (!spi_mem_controller_is_capable(ctlr, dtr))
 			return false;
 
+		if (op->data.swap16 && !spi_mem_controller_is_capable(ctlr, swap16))
+			return false;
+
 		if (op->cmd.nbytes != 2)
 			return false;
 	} else {
diff --git a/include/linux/spi/spi-mem.h b/include/linux/spi/spi-mem.h
index f866d5c8ed32a..c46d2b8029be5 100644
--- a/include/linux/spi/spi-mem.h
+++ b/include/linux/spi/spi-mem.h
@@ -90,6 +90,8 @@ enum spi_mem_data_dir {
  * @data.buswidth: number of IO lanes used to send/receive the data
  * @data.dtr: whether the data should be sent in DTR mode or not
  * @data.ecc: whether error correction is required or not
+ * @data.swap16: whether the byte order of 16-bit words is swapped when read
+ *		 or written in Octal DTR mode compared to STR mode.
  * @data.dir: direction of the transfer
  * @data.nbytes: number of data bytes to send/receive. Can be zero if the
  *		 operation does not involve transferring data
@@ -124,7 +126,8 @@ struct spi_mem_op {
 		u8 buswidth;
 		u8 dtr : 1;
 		u8 ecc : 1;
-		u8 __pad : 6;
+		u8 swap16 : 1;
+		u8 __pad : 5;
 		enum spi_mem_data_dir dir;
 		unsigned int nbytes;
 		union {
@@ -297,10 +300,13 @@ struct spi_controller_mem_ops {
  * struct spi_controller_mem_caps - SPI memory controller capabilities
  * @dtr: Supports DTR operations
  * @ecc: Supports operations with error correction
+ * @swap16: Supports swapping bytes on a 16 bit boundary when configured in
+ *	    Octal DTR
  */
 struct spi_controller_mem_caps {
 	bool dtr;
 	bool ecc;
+	bool swap16;
 };
 
 #define spi_mem_controller_is_capable(ctlr, cap)	\
-- 
2.51.0



