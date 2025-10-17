Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 534AE289811;
	Fri, 17 Oct 2025 15:37:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715444; cv=none; b=qOeindsZ+x08aoFaaRITFpMEiLafZqoDyGNV9wBjhz/vGFzjPSCuCCrpX+WiK5nvW955CZ7JgxSsBW+Xzj02bYoHazYcm60qZlqgeY9lW4R9V4ypDACw9HeN/WEz5IVz2pbdnPxkPA43c6bIINIe4qEory2+1eOiXgs2Nu/aFIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715444; c=relaxed/simple;
	bh=ujpjFsGqLgM1BTKzuNJY7v75XddsFX4OU9gMVSbz9yc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=chdm7oRLC2tRJrumSD6iWprUTjZLjYg7eFRE2/3gBsoFGGy+eTLK2YTVWix6B6ptKmf1972/Poimyff3lGkwHm1UjuRukooqjzCJCqflQRIz4Rj52b4vcXpcCY6z78pdAWJ5/4jg0q7WA3YbbtSofOnsRjcI+cz1zo0cwHqe5vE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jhZ78S3h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jhZ78S3h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAB52C4CEFE;
	Fri, 17 Oct 2025 15:37:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715444;
	bh=ujpjFsGqLgM1BTKzuNJY7v75XddsFX4OU9gMVSbz9yc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jhZ78S3h7vNaZYtttBwGSnnQSjk5wVmPT4GChEfJ5wDm6nCvq0AMH6tq96gHgMfek
	 VPsQgvFkjIP4jSxvJYnUaLqv0cC2ud3Vh9+VJq3UQswwW/gW7Fy8Nkrr6EBAtHgaql
	 uj1EY2I+L4yJ8zLucqlieAf32koVai39URh0rJ4E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jarkko Nikula <jarkko.nikula@linux.intel.com>,
	Frank Li <Frank.Li@nxp.com>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 6.17 218/371] i3c: Fix default I2C adapter timeout value
Date: Fri, 17 Oct 2025 16:53:13 +0200
Message-ID: <20251017145209.974830213@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jarkko Nikula <jarkko.nikula@linux.intel.com>

commit 9395b3c412933401a34845d5326afe4011bbd40f upstream.

Commit 3a379bbcea0a ("i3c: Add core I3C infrastructure") set the default
adapter timeout for I2C transfers as 1000 (ms). However that parameter
is defined in jiffies not in milliseconds.

With mipi-i3c-hci driver this wasn't visible until commit c0a90eb55a69
("i3c: mipi-i3c-hci: use adapter timeout value for I2C transfers").

Fix this by setting the default timeout as HZ (CONFIG_HZ) not 1000.

Fixes: 1b84691e7870 ("i3c: dw: use adapter timeout value for I2C transfers")
Fixes: be27ed672878 ("i3c: master: cdns: use adapter timeout value for I2C transfers")
Fixes: c0a90eb55a69 ("i3c: mipi-i3c-hci: use adapter timeout value for I2C transfers")
Fixes: a747e01adad2 ("i3c: master: svc: use adapter timeout value for I2C transfers")
Fixes: d028219a9f14 ("i3c: master: Add basic driver for the Renesas I3C controller")
Fixes: 3a379bbcea0a ("i3c: Add core I3C infrastructure")
Cc: stable@vger.kernel.org # 6.17
Signed-off-by: Jarkko Nikula <jarkko.nikula@linux.intel.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Reviewed-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Link: https://lore.kernel.org/r/20250905100320.954536-1-jarkko.nikula@linux.intel.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i3c/master.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/i3c/master.c
+++ b/drivers/i3c/master.c
@@ -2492,7 +2492,7 @@ static int i3c_master_i2c_adapter_init(s
 	strscpy(adap->name, dev_name(master->dev.parent), sizeof(adap->name));
 
 	/* FIXME: Should we allow i3c masters to override these values? */
-	adap->timeout = 1000;
+	adap->timeout = HZ;
 	adap->retries = 3;
 
 	id = of_alias_get_id(master->dev.of_node, "i2c");


