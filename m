Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EFB9288A8;
	Wed,  7 May 2025 19:01:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644485; cv=none; b=mfR/VET2SWyJQpc9rXSjBxA4e+0Di7I75ubC8SvqDOiJth2Q68bvhxL1bkRVPjYhN8C3MQXEmDZNsFNd/6cfc/D60Npmq9dtiKbqVEvNPP6fS/H5Tah2ZOBIewg5gRPypKWmYYJUUOZ54O8gUC9OJ49VZjLclS+bgxyGdKFtVlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644485; c=relaxed/simple;
	bh=EC3EaA8M8nTw6wuXfYWK3VYRgCQSkPRObd1g7zJilGs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E86gJXHTiGLfYKiTJhsmaRSuevbYKY50bRMAVU3jpOxWO3NLqllPc/OIAGw1+d7dAW0KEa9F8NKeoGlZ7n/IctavDwEUT1NP3+JUe8prYqfQf4hG9Fn/gpW1qPZZDs0oM8TBhn6NFY8qqXlqYgZ1DSN987P4Hgky4jvmBQCzsOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K5x+nKxW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K5x+nKxW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46391C4CEE2;
	Wed,  7 May 2025 19:01:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644484;
	bh=EC3EaA8M8nTw6wuXfYWK3VYRgCQSkPRObd1g7zJilGs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K5x+nKxW3mb8YRH7IvO5S9R/io6xwT+M8HHSccJgNzUQyGnSg9HtYyKAiEmIIRiqt
	 Q9Q32S4uXrxmBqWD9vcNkwFilpVwqqY7Tgr5nENl1DnpizBTCUsUmKyP+eZWTJ+FvP
	 6UZOrzN5DJ6XvaDbGn3cP/IsEvZjBHUbyQJ1hHgI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aaron Kling <webgeek1234@gmail.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.12 028/164] spi: tegra114: Dont fail set_cs_timing when delays are zero
Date: Wed,  7 May 2025 20:38:33 +0200
Message-ID: <20250507183822.006055486@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183820.781599563@linuxfoundation.org>
References: <20250507183820.781599563@linuxfoundation.org>
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

From: Aaron Kling <webgeek1234@gmail.com>

commit 4426e6b4ecf632bb75d973051e1179b8bfac2320 upstream.

The original code would skip null delay pointers, but when the pointers
were converted to point within the spi_device struct, the check was not
updated to skip delays of zero. Hence all spi devices that didn't set
delays would fail to probe.

Fixes: 04e6bb0d6bb1 ("spi: modify set_cs_timing parameter")
Cc: stable@vger.kernel.org
Signed-off-by: Aaron Kling <webgeek1234@gmail.com>
Link: https://patch.msgid.link/20250423-spi-tegra114-v1-1-2d608bcc12f9@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-tegra114.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/spi/spi-tegra114.c
+++ b/drivers/spi/spi-tegra114.c
@@ -728,9 +728,9 @@ static int tegra_spi_set_hw_cs_timing(st
 	u32 inactive_cycles;
 	u8 cs_state;
 
-	if (setup->unit != SPI_DELAY_UNIT_SCK ||
-	    hold->unit != SPI_DELAY_UNIT_SCK ||
-	    inactive->unit != SPI_DELAY_UNIT_SCK) {
+	if ((setup->unit && setup->unit != SPI_DELAY_UNIT_SCK) ||
+	    (hold->unit && hold->unit != SPI_DELAY_UNIT_SCK) ||
+	    (inactive->unit && inactive->unit != SPI_DELAY_UNIT_SCK)) {
 		dev_err(&spi->dev,
 			"Invalid delay unit %d, should be SPI_DELAY_UNIT_SCK\n",
 			SPI_DELAY_UNIT_SCK);


