Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 740861E521F;
	Wed, 19 Feb 2025 08:45:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954720; cv=none; b=W5hssDiaJtjXkYD5ahnvconkUBV7eB+i0/2WYOIGPYmZlMmdVFOPDPqqsnMe8cjgiiH2yZ3t7iXJsQsPvUZ90wCm5+TgUPio6Ig/XzLmXGgiqWynmy4ooDRioWn1ms82Ccb9N8ZS2mdVfZzqGObQumPT+Djt7vV2cF9sOU5qbUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954720; c=relaxed/simple;
	bh=fxOxVDNmrh+ZwGpVf2Qk6j7WcfcFI7LC2Bh44bzNOQ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eZuT7b5b7yUZikbP22mIT3kbf2fr2b/rkfmjupYKSjjx5q7El1HhNFRcjX8HV6I6o+76WmQc2183Ymu2mE3s66UF6at9fYp8qaOVM6ky7BkFh/D8T7ApFkkfO0f8VOphca4FXylruff/IzI+Poqi3Dl21O5KMuoOD7veo7pBIZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NUKaAR0V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NUKaAR0V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6396C4CED1;
	Wed, 19 Feb 2025 08:45:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954720;
	bh=fxOxVDNmrh+ZwGpVf2Qk6j7WcfcFI7LC2Bh44bzNOQ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NUKaAR0VsRikJoQXRryJ0Dx68TUwD5ioKsjxFLeeFMNKoliQDHod3wLoBBdb/paXY
	 h6kd0YUX0kZtDoNP3rKgS1bWVNzL1Dg7zYRjS1xHyl+0pY2oBUc4lDyDcaFJ2k0pfN
	 ueTTDdoNxz9jBX+QlwbOrQYvaVT8f9u+lHzR9jXQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kohei Ito <ito.kohei@socionext.com>,
	Kunihiko Hayashi <hayashi.kunihiko@socionext.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 015/230] spi: sn-f-ospi: Fix division by zero
Date: Wed, 19 Feb 2025 09:25:32 +0100
Message-ID: <20250219082602.297658283@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082601.683263930@linuxfoundation.org>
References: <20250219082601.683263930@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>

[ Upstream commit 3588b1c0fde2f58d166e3f94a5a58d64b893526c ]

When there is no dummy cycle in the spi-nor commands, both dummy bus cycle
bytes and width are zero. Because of the cpu's warning when divided by
zero, the warning should be avoided. Return just zero to avoid such
calculations.

Fixes: 1b74dd64c861 ("spi: Add Socionext F_OSPI SPI flash controller driver")
Co-developed-by: Kohei Ito <ito.kohei@socionext.com>
Signed-off-by: Kohei Ito <ito.kohei@socionext.com>
Signed-off-by: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
Link: https://patch.msgid.link/20250206085747.3834148-1-hayashi.kunihiko@socionext.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-sn-f-ospi.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/spi/spi-sn-f-ospi.c b/drivers/spi/spi-sn-f-ospi.c
index a7c3b3923b4af..fd8c8eb37d01d 100644
--- a/drivers/spi/spi-sn-f-ospi.c
+++ b/drivers/spi/spi-sn-f-ospi.c
@@ -116,6 +116,9 @@ struct f_ospi {
 
 static u32 f_ospi_get_dummy_cycle(const struct spi_mem_op *op)
 {
+	if (!op->dummy.nbytes)
+		return 0;
+
 	return (op->dummy.nbytes * 8) / op->dummy.buswidth;
 }
 
-- 
2.39.5



