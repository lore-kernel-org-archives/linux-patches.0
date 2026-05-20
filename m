Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEEEF17A309;
	Wed, 20 May 2026 17:07:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296863; cv=none; b=RG6iQoH1gEXPzGcTAnsaq0y0pSaQtzN9ib+rS66/huXdcp4erI/rrgsnFGqo4z+rtQvUOXuvflb/c8m68LJIxqsHdynwC4C3z2MPkI/sjUhWjN5U5UVR9c6geKbZEvPA9O/Vw+cv1jWTBPF4r0ZzSrTrr0Bc3gjLuCtc/8jhE2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296863; c=relaxed/simple;
	bh=zG9rACfisyJHL5JLBVHccXzWGcP4869hZSS1Ud0pB/M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sVqLm2yYa2bif2mTE091MkBH+Vy07ZQ/h2L3YxqdQNHOuUNnpTtMAorQ7PcK5RHlll1tHlr76MahHrAey/dXvbRXCTouoIR1+r5aW+d50NRl5Petx4NqiAnn5m6oZ8FyCYzeqUouZW0lHd4lW82X1DDvniS6U+3v0JldEfaENEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mHF1ssKI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mHF1ssKI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A2CF1F000E9;
	Wed, 20 May 2026 17:07:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296861;
	bh=yuvUXtqp5Wm5hZPH/axVnj+RG+pzFnB/QNLPEfriKKI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mHF1ssKIp4g4hJLSKsL/QISOumJpSm3SGiVwL4px0q8u+sclvD0r0OvrSxCZblbdn
	 92xSN5CfOTSnUc7npjvjsUWq5ubrDloVWqdO9Olaf1XoAbFONQUve9W8hVEiCHW4t3
	 dhcGULCNI2JMBTd7gW3nCdp4QKnU7VXOZCTQ715U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0919/1146] spi: spi-mem: Add a packed command operation
Date: Wed, 20 May 2026 18:19:29 +0200
Message-ID: <20260520162209.038953227@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

From: Miquel Raynal <miquel.raynal@bootlin.com>

[ Upstream commit f79ee9e4b23244e77b28d176ce99a2d84d813ac5 ]

Instead of repeating the command opcode twice, some flash devices try to
pack command and address bits. In this case, the second opcode byte
being sent (LSB) is free to be used. The input data must be ANDed to
only provide the relevant bits.

Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://patch.msgid.link/20260410-winbond-6-19-rc1-oddr-v1-2-2ac4827a3868@bootlin.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 8d655748aba1 ("mtd: spinand: winbond: Set the packed page read flag to W35N02/04JW")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/spi/spi-mem.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/include/linux/spi/spi-mem.h b/include/linux/spi/spi-mem.h
index 5774e554c0f02..f54c708f4c506 100644
--- a/include/linux/spi/spi-mem.h
+++ b/include/linux/spi/spi-mem.h
@@ -28,6 +28,14 @@
 		.dtr = true,					\
 	}
 
+#define SPI_MEM_DTR_OP_PACKED_CMD(__opcode, __addr, __buswidth)	\
+	{							\
+		.nbytes = 2,					\
+		.opcode = __opcode << 8 | __addr,		\
+		.buswidth = __buswidth,				\
+		.dtr = true,					\
+	}
+
 #define SPI_MEM_OP_ADDR(__nbytes, __val, __buswidth)		\
 	{							\
 		.nbytes = __nbytes,				\
-- 
2.53.0



