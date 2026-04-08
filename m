Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41912331A44;
	Wed,  8 Apr 2026 18:35:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673323; cv=none; b=dV40rj7zch9+NWsWwgXTM+ivBIsDmOcFelJ+B6uUUsE1uu51f2aj/8oo7SiF/aGRDGyBo+7IAnG6qKc/HTX470DtPmsNGzDhA0iwDe+gaOgAy69FQGrMcP/UZfMMTTxC+PvHkkpSpUul7LJQVV46YjcgInHUYQ/n1MZVepWg6qw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673323; c=relaxed/simple;
	bh=wOjg4yebH+AIMsAkwKJNMD2NsUxHCJXgNq5VID/7OFI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Re/agIBXAAfxtQFsVO79dj+b9pqnJybbtOSiOU2r5VYbPIR9xeupOOutYg5L0H5r1hakWs6DwK1ZNY63Jil9GU9Kl00Wl6uhhw4z6TzahRRd4cAGvSz2PBh1wivQvdmuLdYji5V6lApj9NBqa88wXPvbyLRgwEgA1H75CK0wk/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EsvdOojZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EsvdOojZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBDB1C19421;
	Wed,  8 Apr 2026 18:35:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673323;
	bh=wOjg4yebH+AIMsAkwKJNMD2NsUxHCJXgNq5VID/7OFI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EsvdOojZjZs6m8FP1h8DICz2V1UMX8hIetsb7Wm8jei75b28TOZF/o3Gsqu92T8/f
	 BzjphxQ9VnpzwRbDMdTk0hHIkRwigAMxqvAsbNV3V/Mfw/4EAGp9XY6H446MepnRS3
	 HvAu/8UJG+gkz87ZxD5XNF2gDsr6hozmTxAjjQ5o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antoniu Miclaus <antoniu.miclaus@analog.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.18 180/277] iio: adc: ade9000: move mutex init before IRQ registration
Date: Wed,  8 Apr 2026 20:02:45 +0200
Message-ID: <20260408175940.585777706@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.836769063@linuxfoundation.org>
References: <20260408175933.836769063@linuxfoundation.org>
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

From: Antoniu Miclaus <antoniu.miclaus@analog.com>

commit 0206dd36418c104c0b3dea4ed7047e21eccb30b0 upstream.

Move devm_mutex_init() before ade9000_request_irq() calls so that
st->lock is initialized before any handler that depends on it can run.

Fixes: 81de7b4619fc ("iio: adc: add ade9000 support")
Signed-off-by: Antoniu Miclaus <antoniu.miclaus@analog.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/ade9000.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/iio/adc/ade9000.c b/drivers/iio/adc/ade9000.c
index db085dc5e526..c62c6480dd0a 100644
--- a/drivers/iio/adc/ade9000.c
+++ b/drivers/iio/adc/ade9000.c
@@ -1706,6 +1706,10 @@ static int ade9000_probe(struct spi_device *spi)
 
 	init_completion(&st->reset_completion);
 
+	ret = devm_mutex_init(dev, &st->lock);
+	if (ret)
+		return ret;
+
 	ret = ade9000_request_irq(dev, "irq0", ade9000_irq0_thread, indio_dev);
 	if (ret)
 		return ret;
@@ -1718,10 +1722,6 @@ static int ade9000_probe(struct spi_device *spi)
 	if (ret)
 		return ret;
 
-	ret = devm_mutex_init(dev, &st->lock);
-	if (ret)
-		return ret;
-
 	/* External CMOS clock input (optional - crystal can be used instead) */
 	st->clkin = devm_clk_get_optional_enabled(dev, NULL);
 	if (IS_ERR(st->clkin))
-- 
2.53.0



