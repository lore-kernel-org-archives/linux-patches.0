Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 212DB449B1E;
	Thu, 30 Jul 2026 15:29:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425351; cv=none; b=N1oQGvHXjUA6Jsz0u9Jubu0CTKAz7oKSdcIaBQFc7ZB8OPrz2fXhX+w3dA7wib9eHstpFfZf2bhCW93VSA6Czhchu3eX0xcsk9HZ0EocOUkjctnzuEsV/jAllmZvPVG78J081OETVXjS5h5qxxI1eTpH2LKOuA7QCLiVfgCE7+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425351; c=relaxed/simple;
	bh=pm6dy9wIFDj3UTSOmwC3DkhTJGYBD7Xggd7AHyYsGfY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ouas63aTDN/0myOjeuTNhee2m3xiodCUORbk0aJARXi63Z4nKAR8sV3rLF7g6QTLPStlhE5Fhtx2fLIn7yg40c11F2csvclYXPOxc8z5b8OZW9Ubq8bzFyYzG8qB/nsvnEAGpm7ZVyVPctA1L/ReiR0nIkh9x33FPZxUiXTt5XE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WRqO64KZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WRqO64KZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E59B1F000E9;
	Thu, 30 Jul 2026 15:29:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425350;
	bh=i7Gt2YKLPZZp+HLTrwi1xGDX1UIx8MeY9d6ucgyrF+w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WRqO64KZ76HpSuGBDk90tS43SUCOeMSXfP76woOUBLpXTeo4/CqoQKgs6PAeJaPEP
	 y3yHbvG3WCA43e5T6OHSIBH3CXz7Oq2Zk1dbXFl5n41WSnlgnkWcBicXGL+9KLYGgO
	 RFM3SDLTqLEdQQBEBDNPlH9YVBcf9EjHX877CDBo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Seth Forshee <sforshee@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 037/602] firmware: arm_ffa: Respect firmware advertised RX/TX buffer size limits
Date: Thu, 30 Jul 2026 16:07:09 +0200
Message-ID: <20260730141436.788337396@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

From: Seth Forshee <sforshee@nvidia.com>

[ Upstream commit 53716a4d745f1dac7aff33f3d1494b701eb2f888 ]

FFA_FEATURES reports the minimum size and alignment boundary required
for RXTX_MAP. In FF-A v1.2 and later it can also report a maximum buffer
size, with zero meaning that no maximum is enforced.

The driver only used the minimum value and then rounded it up to PAGE_SIZE
before invoking RXTX_MAP after commit 83210251fd70 ("firmware: arm_ffa:
Use the correct buffer size during RXTX_MAP"). On systems where PAGE_SIZE
is larger than the advertised minimum, this can exceed a non-zero maximum
reported by firmware. Older implementations do not advertise a maximum and
may also reject the rounded-up size.

Decode the maximum size and clamp the page-aligned minimum to it when it
is present. If no maximum is advertised and RXTX_MAP rejects the rounded
size with INVALID_PARAMETERS, retry with the advertised minimum size.
Record drv_info->rxtx_bufsz only after RXTX_MAP succeeds so it reflects
the size registered with firmware.

While there, also update RXTX_MAP_MIN_BUFSZ() to use FIELD_GET() for
consistency.

Fixes: 83210251fd70 ("firmware: arm_ffa: Use the correct buffer size during RXTX_MAP")
Suggested-by: Sudeep Holla <sudeep.holla@kernel.org>
Signed-off-by: Seth Forshee <sforshee@nvidia.com>
Link: https://patch.msgid.link/20260602-b4-ffa-rxtx-map-fixes-v2-1-7cb06508da84@nvidia.com
(sudeep.holla: Minor rewording subject and commit message)
Signed-off-by: Sudeep Holla <sudeep.holla@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_ffa/driver.c | 27 ++++++++++++++++++++-------
 1 file changed, 20 insertions(+), 7 deletions(-)

diff --git a/drivers/firmware/arm_ffa/driver.c b/drivers/firmware/arm_ffa/driver.c
index 3b221ba990aa1e..67fc9e46001b77 100644
--- a/drivers/firmware/arm_ffa/driver.c
+++ b/drivers/firmware/arm_ffa/driver.c
@@ -32,6 +32,7 @@
 #include <linux/interrupt.h>
 #include <linux/io.h>
 #include <linux/kernel.h>
+#include <linux/minmax.h>
 #include <linux/module.h>
 #include <linux/mm.h>
 #include <linux/mutex.h>
@@ -55,7 +56,9 @@
 	(FIELD_PREP(SENDER_ID_MASK, (s)) | FIELD_PREP(RECEIVER_ID_MASK, (r)))
 
 #define RXTX_MAP_MIN_BUFSZ_MASK	GENMASK(1, 0)
-#define RXTX_MAP_MIN_BUFSZ(x)	((x) & RXTX_MAP_MIN_BUFSZ_MASK)
+#define RXTX_MAP_MAX_BUFSZ_MASK	GENMASK(31, 16)
+#define RXTX_MAP_MIN_BUFSZ(x)	(FIELD_GET(RXTX_MAP_MIN_BUFSZ_MASK, (x)))
+#define RXTX_MAP_MAX_BUFSZ(x)	(FIELD_GET(RXTX_MAP_MAX_BUFSZ_MASK, (x)))
 
 #define FFA_MAX_NOTIFICATIONS		64
 
@@ -1855,7 +1858,7 @@ static int __init ffa_init(void)
 {
 	int ret;
 	u32 buf_sz;
-	size_t rxtx_bufsz = SZ_4K;
+	size_t rxtx_min_bufsz = SZ_4K, rxtx_max_bufsz = 0, rxtx_bufsz;
 
 	ret = ffa_transport_init(&invoke_ffa_fn);
 	if (ret)
@@ -1878,15 +1881,18 @@ static int __init ffa_init(void)
 	ret = ffa_features(FFA_FN_NATIVE(RXTX_MAP), 0, &buf_sz, NULL);
 	if (!ret) {
 		if (RXTX_MAP_MIN_BUFSZ(buf_sz) == 1)
-			rxtx_bufsz = SZ_64K;
+			rxtx_min_bufsz = SZ_64K;
 		else if (RXTX_MAP_MIN_BUFSZ(buf_sz) == 2)
-			rxtx_bufsz = SZ_16K;
+			rxtx_min_bufsz = SZ_16K;
 		else
-			rxtx_bufsz = SZ_4K;
+			rxtx_min_bufsz = SZ_4K;
+
+		rxtx_max_bufsz = RXTX_MAP_MAX_BUFSZ(buf_sz) * SZ_4K;
+		if (rxtx_max_bufsz != 0 && rxtx_max_bufsz < rxtx_min_bufsz)
+			rxtx_max_bufsz = rxtx_min_bufsz;
 	}
 
-	rxtx_bufsz = PAGE_ALIGN(rxtx_bufsz);
-	drv_info->rxtx_bufsz = rxtx_bufsz;
+	rxtx_bufsz = min_not_zero(PAGE_ALIGN(rxtx_min_bufsz), rxtx_max_bufsz);
 	drv_info->rx_buffer = alloc_pages_exact(rxtx_bufsz, GFP_KERNEL);
 	if (!drv_info->rx_buffer) {
 		ret = -ENOMEM;
@@ -1902,10 +1908,17 @@ static int __init ffa_init(void)
 	ret = ffa_rxtx_map(virt_to_phys(drv_info->tx_buffer),
 			   virt_to_phys(drv_info->rx_buffer),
 			   rxtx_bufsz / FFA_PAGE_SIZE);
+	if (ret == -EINVAL && !rxtx_max_bufsz && rxtx_min_bufsz < rxtx_bufsz) {
+		rxtx_bufsz = rxtx_min_bufsz;
+		ret = ffa_rxtx_map(virt_to_phys(drv_info->tx_buffer),
+				   virt_to_phys(drv_info->rx_buffer),
+				   rxtx_bufsz / FFA_PAGE_SIZE);
+	}
 	if (ret) {
 		pr_err("failed to register FFA RxTx buffers\n");
 		goto free_pages;
 	}
+	drv_info->rxtx_bufsz = rxtx_bufsz;
 
 	mutex_init(&drv_info->rx_lock);
 	mutex_init(&drv_info->tx_lock);
-- 
2.53.0



