Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 304368462;
	Thu, 17 Apr 2025 18:15:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744913752; cv=none; b=GeF5OTOvBONZ9C9hpWRNwbf+OdFLwyeDmxoJ3bdsK9IfUVk6+xEi26w/lnv2f0U/Eam+EzTrJ2ubLdsQgKYiwVXaNGCHz7iJc3ScEiQLF7yqkE+981rsdRy5id+nH3R1Z3x7ueUHk4gX4x6yC6wlIYp/tNGYanjgFsyuwspIOEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744913752; c=relaxed/simple;
	bh=XIv0ATNcvxAR5vX2mGsZ6uAKG/WLHZSNbbkupRsy+cY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i3tYl0vvnMlv0Mml7c/CrHrFV7L0MIeBxuyQzOPMUlFW/uPnRxoaJaza+SQqhLUIXav1m8NjcfesVUrAYZQLFRJdaScTkBzDYZoUP+ocM+QQ0qP1RvI9OjU6YoqNxTKwIeWcIkx4D3TSJBuVproky9O4DK7z1zP3GUyeVLdWTXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W++B/2e7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W++B/2e7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48F65C4CEE4;
	Thu, 17 Apr 2025 18:15:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744913752;
	bh=XIv0ATNcvxAR5vX2mGsZ6uAKG/WLHZSNbbkupRsy+cY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W++B/2e7LcfvKRGi5Nft0FiMxlaHmR93g7Mv/1i8w/AgaIUaNrg5yn5qtAkuaEonu
	 Vp7o+CiYaoATli9KPAsog3VpbHjgkFDonvjgN2FJc/hddnZLJPH6uali7gtClxPFIG
	 RRO+hE12bKlFNtaRgAU5rMw6TwXf3uGTkC2rG09s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kevin Hao <haokexin@gmail.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.14 441/449] spi: fsl-qspi: Fix double cleanup in probe error path
Date: Thu, 17 Apr 2025 19:52:09 +0200
Message-ID: <20250417175136.067007134@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kevin Hao <haokexin@gmail.com>

commit 5d07ab2a7fa1305e429d9221716582f290b58078 upstream.

Commit 40369bfe717e ("spi: fsl-qspi: use devm function instead of driver
remove") introduced managed cleanup via fsl_qspi_cleanup(), but
incorrectly retain manual cleanup in two scenarios:

- On devm_add_action_or_reset() failure, the function automatically call
  fsl_qspi_cleanup(). However, the current code still jumps to
  err_destroy_mutex, repeating cleanup.

- After the fsl_qspi_cleanup() action is added successfully, there is no
  need to manually perform the cleanup in the subsequent error path.
  However, the current code still jumps to err_destroy_mutex on spi
  controller failure, repeating cleanup.

Skip redundant manual cleanup calls to fix these issues.

Cc: stable@vger.kernel.org
Fixes: 40369bfe717e ("spi: fsl-qspi: use devm function instead of driver remove")
Signed-off-by: Kevin Hao <haokexin@gmail.com>
Link: https://patch.msgid.link/20250410-spi-v1-1-56e867cc19cf@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-fsl-qspi.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- a/drivers/spi/spi-fsl-qspi.c
+++ b/drivers/spi/spi-fsl-qspi.c
@@ -949,17 +949,14 @@ static int fsl_qspi_probe(struct platfor
 
 	ret = devm_add_action_or_reset(dev, fsl_qspi_cleanup, q);
 	if (ret)
-		goto err_destroy_mutex;
+		goto err_put_ctrl;
 
 	ret = devm_spi_register_controller(dev, ctlr);
 	if (ret)
-		goto err_destroy_mutex;
+		goto err_put_ctrl;
 
 	return 0;
 
-err_destroy_mutex:
-	mutex_destroy(&q->lock);
-
 err_disable_clk:
 	fsl_qspi_clk_disable_unprep(q);
 


