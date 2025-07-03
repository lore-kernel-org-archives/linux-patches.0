Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EBDD2E7F0B;
	Thu,  3 Jul 2025 14:55:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554520; cv=none; b=SvFRFFr43QIcXO/tWDrHpd2wZ0FijkjSUrD4bKV3sLydwcDpMvGTbr09d7n9+mnmgxWthvw18FjzeH2K4rfZf0cK/5D5lThTjCaZfDpR9eYb6gRtd82DLn3R0JSuF5QKKID9UGwZCh8mK1RceDcDYuB7cnLxxHLYIDGTvURyGvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554520; c=relaxed/simple;
	bh=DC2Asas4pxn8y5n2w9BAE6XcBlMDUhhKdsQqWTsun/Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sDTWoMlR8SC9hDa1a5tUMwWa1epHcFTrE2vpcj/dDyq7LqF/OzHkRNRzK6gXTLXPc/l48aD+00KufWbvvaODMdQfSIZ9CEme7tLlQVL1tAowuLq9YYWihYKQ9gRm/C675obfuCq7cyl/0GyraxjGbCLFR5RfOwAcsuhjyNt3GRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j1sKPZoI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j1sKPZoI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0516C4CEE3;
	Thu,  3 Jul 2025 14:55:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554520;
	bh=DC2Asas4pxn8y5n2w9BAE6XcBlMDUhhKdsQqWTsun/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j1sKPZoIgapj8D5dAG86SClLrFwsSJ8rV+idwb1BhNhMdZDreDJvpw7xPq50ZUsD4
	 negpRtZrz3At6MsfsomWGOG7xzZDeThd0CKFFd2NAgXiDaAqUmi1akKUW+M/wOWcPX
	 IsX4RpUNJhMP3rNOBH+4RtzKGx7KcXsHXK9s/GTc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Tudor Ambarus <tudor.ambarus@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 213/218] spi: spi-mem: Add a new controller capability
Date: Thu,  3 Jul 2025 16:42:41 +0200
Message-ID: <20250703144004.731610136@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143955.956569535@linuxfoundation.org>
References: <20250703143955.956569535@linuxfoundation.org>
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-mem.c       | 6 ++++++
 include/linux/spi/spi-mem.h | 2 ++
 2 files changed, 8 insertions(+)

diff --git a/drivers/spi/spi-mem.c b/drivers/spi/spi-mem.c
index f8b598ba962d9..d0ae20d433d61 100644
--- a/drivers/spi/spi-mem.c
+++ b/drivers/spi/spi-mem.c
@@ -188,6 +188,12 @@ bool spi_mem_default_supports_op(struct spi_mem *mem,
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
index 44b7ecee0e74c..0f00d74beb24c 100644
--- a/include/linux/spi/spi-mem.h
+++ b/include/linux/spi/spi-mem.h
@@ -306,10 +306,12 @@ struct spi_controller_mem_ops {
  * struct spi_controller_mem_caps - SPI memory controller capabilities
  * @dtr: Supports DTR operations
  * @ecc: Supports operations with error correction
+ * @per_op_freq: Supports per operation frequency switching
  */
 struct spi_controller_mem_caps {
 	bool dtr;
 	bool ecc;
+	bool per_op_freq;
 };
 
 #define spi_mem_controller_is_capable(ctlr, cap)	\
-- 
2.39.5



