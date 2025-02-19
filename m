Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 056321A841F;
	Wed, 19 Feb 2025 08:30:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739953850; cv=none; b=rvxF1tIgXVkM9oxJUjTnCf6kfsNKya0TauPdpZ1Z550mc+liDA2EQMS6/cWBg35XsGZEZhP3/G6R64w7R+wjUFASo8Lsk7J69AJN1rZqVyAS+nDeY34GvW9sU4Vl2ETjJQYrVTyalY7a2rr3PjpQc0Ce3nUb2k1/9oCij2LQjmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739953850; c=relaxed/simple;
	bh=5nIzLrDR0hFEgqmF/GBavf9axOfe8osNAJaXrwFK1a0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M2vhIR3m+qlbm3iMX2u18PT9DfA+5qhfOO7+a0RSkXyFcEHG7riMFX/+XXaJx/LfcdGxIzPgRTcoX4qn3Lvndu6R38mtbAYSQTILdkuEzhJiIf6M9hd09b3yOOMhjEvqZMxBpFVuIJciXifBImaNAbzESWUTHdt/HOJjAX3gLqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sXXYO8ob; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sXXYO8ob"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ABFAC4CED1;
	Wed, 19 Feb 2025 08:30:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739953849;
	bh=5nIzLrDR0hFEgqmF/GBavf9axOfe8osNAJaXrwFK1a0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sXXYO8obGkRI6k90YWVDHHorln53G0hrSdppsCQAEqhnW27aukJGW5VCIzKLxpM1y
	 jRXlM51/vpX7xJ8UjNVn0r4aFXc0vViyndMxB1GkiNudpnu3bwU854ggBJYIKmLohw
	 sGM+EbHNzhcP1dKzj21JnsypNp2onZVnoMnHdPWw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kohei Ito <ito.kohei@socionext.com>,
	Kunihiko Hayashi <hayashi.kunihiko@socionext.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 018/274] spi: sn-f-ospi: Fix division by zero
Date: Wed, 19 Feb 2025 09:24:32 +0100
Message-ID: <20250219082610.252454226@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082609.533585153@linuxfoundation.org>
References: <20250219082609.533585153@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index adac645732fed..56ef114effc97 100644
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



