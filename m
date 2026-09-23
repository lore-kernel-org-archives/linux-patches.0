Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD5DF53C3A0;
	Wed, 23 Sep 2026 14:49:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790175001; cv=none; b=eBdYc7R2zm/0BS6C8mRd6HF9W9B+yw9/EK8kWlGGJUtqHuMzL1xmLe8fl7jaKfMKbf+9LeJXTv8BX1iCzqsjolPMXKN8G34VhyVI5sBNnwH9SdzKsi/taYbAyGMBMtUGkNAN5sa1jjwWAFPpNlhhxvwNnEiGVu4yClfk0vGWFCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790175001; c=relaxed/simple;
	bh=k9zT5Mx6WpvbIgTa5b4XsCuqchOOVS+Qp0qNgJ2PESY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DjoMHixyhJxf0NClLM6NZUqWWZmlFdI+j3HuhLo3KyUQzPpeqiv2PsyXKIsR+QTjyGp0fF8wXMsNJ6eYCvegs048au8DJ9qkz08CWoe3d/IllgiMijXxC0qEI7/M8Eb4BFmIxYspMjWxvNWWBZe+oNUsV6bUX8/9V4cpwxQ5J9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JpQxJa7Q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JpQxJa7Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C98A41F000FF;
	Wed, 23 Sep 2026 14:49:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174999;
	bh=ihBDQ0AtCA7jO4rJOB5k4ZgOfJpiv83SgB2AWpuOGeI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JpQxJa7Q5BT4cVQDbte0AKC/R7wewH11TPxJUTfh14sfvbNlN5Qqx2TCwzDzBkjLn
	 elh48ZPpLviBRyHjzmZal9dQ3Od+OD1xPJl/jfc/jwFDHDq88C5p0SDSFRmqkzuNJa
	 PO1GHJB3Phi0ogWEkfa3sLQ3/CSjSG61EXik2x1I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Diogo Ivo (Schneider Electric)" <diogo.ivo@bootlin.com>,
	Judith Mendez <jm@ti.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 6.18 291/398] mmc: sdhci_am654: Reset command and data lines on failed tuning
Date: Wed, 23 Sep 2026 16:06:05 +0200
Message-ID: <20260923140650.968204048@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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

From: Diogo Ivo (Schneider Electric) <diogo.ivo@bootlin.com>

commit 7197d9107d9545730153b82ea5a411c5208b443f upstream.

The CMD/DATA reset after tuning should be performed regardless of
whether tuning succeeded or failed, since tuning data may remain in
the buffer in either case. Move the error return after the reset so
that the controller is always cleaned up.

Fixes: de31f6ab68a3 ("mmc: sdhci_am654: Reset Command and Data line after tuning")
Cc: stable@vger.kernel.org
Signed-off-by: Diogo Ivo (Schneider Electric) <diogo.ivo@bootlin.com>
Reviewed-by: Judith Mendez <jm@ti.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Ulf Hansson <ulfh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/sdhci_am654.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/mmc/host/sdhci_am654.c
+++ b/drivers/mmc/host/sdhci_am654.c
@@ -442,15 +442,13 @@ static int sdhci_am654_execute_tuning(st
 	struct sdhci_host *host = mmc_priv(mmc);
 	int err = sdhci_execute_tuning(mmc, opcode);
 
-	if (err)
-		return err;
 	/*
 	 * Tuning data remains in the buffer after tuning.
 	 * Do a command and data reset to get rid of it
 	 */
 	sdhci_reset(host, SDHCI_RESET_CMD | SDHCI_RESET_DATA);
 
-	return 0;
+	return err;
 }
 
 static u32 sdhci_am654_cqhci_irq(struct sdhci_host *host, u32 intmask)


