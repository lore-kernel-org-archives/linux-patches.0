Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41DE037C925;
	Thu, 20 Aug 2026 15:14:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238860; cv=none; b=mWFRr/NMDsezRj0Dik5zonX4ZvDjLy5MyeGcr4KF5DpyP9Z4Oi+cic2AeqoRQi4RDEc2gg70nzT8d+s/DYwjfVLZhk376rWOViO+wKFgp6vd36p7uxB4ZWyoW4PYpXbbrcWEZmCTmz14TxPREbDPSGtW27hz8/yPj7/rpPrb1uE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238860; c=relaxed/simple;
	bh=3WFuokoNc3qTHJiYevDvY1JkQreiMmZDZssoPQP6L/I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fWaaxSjYs6IVXIZZXnmfP+2EED/7dd1k1N8Vs+kCKYbiVgq18SdTD/pdm1hUVQLvuwO5OcbGl6+vpZxB7ro9VXTTCZfQhYe7mkXle3lTWEyfWRiR+uCniHCa8HSQ6GIlxBLe7OYzA9oLJkVlPesmqnR/hNEI2wM+EjLQUoCcNK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PtdcTP8c; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PtdcTP8c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6290D1F000E9;
	Thu, 20 Aug 2026 15:14:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238859;
	bh=nDxxHBE5ZTAgyP56xJpP2qkTYe1h9GTWdXLxYE7XPDU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PtdcTP8cdnSde4VsbMvlE8mv26MXMQQAHAYpM+yzunl4rk5yn5yQ6BxHqinq0jSNR
	 GYWBmVPQ3GFXZdjsv5bi13yrEXeC9h8AMWx8hyzNs5HybMdKZWpb7L2G1U2egt7LnG
	 rHm7IrxiAc/YghDLQ/QzTcSh8VbXVuvOXzQBS1kQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhan Xusheng <zhanxusheng@xiaomi.com>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 6.18 065/217] mmc: omap_hsmmc: fix busy_timeout overflow in ns conversion on 32-bit
Date: Thu, 20 Aug 2026 16:53:53 +0200
Message-ID: <20260820145239.579244691@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145237.531699751@linuxfoundation.org>
References: <20260820145237.531699751@linuxfoundation.org>
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

From: Zhan Xusheng <zhanxusheng1024@gmail.com>

commit f64ea900e4bda3055ef24a2c906f8d049cf1c3bd upstream.

omap_hsmmc_prepare_data() converts the command busy timeout to nanoseconds
with:

	timeout = req->cmd->busy_timeout * NSEC_PER_MSEC;

busy_timeout is an unsigned int (milliseconds) and timeout is a u64, but
NSEC_PER_MSEC is 1000000L.  On 32-bit builds the multiplication is
performed in 32-bit arithmetic and wraps for busy_timeout values above
~4294 ms, before the result is assigned to the u64.

The driver does not set mmc->max_busy_timeout, so the core does not cap the
busy timeout, and commands such as erase or SANITIZE (MMC_SANITIZE_TIMEOUT_MS
is 240000 ms) can pass a busy_timeout far larger than 4294 ms.  The wrapped,
much smaller ns value is then programmed via set_data_timeout(), so the data
timeout is set too short and the operation can time out prematurely.

Cast busy_timeout to u64 before the multiplication so the conversion is done
in 64-bit arithmetic.

Fixes: 8cc9a3e73de1 ("mmc: host: omap_hsmmc: use generic_cmd6_time to program timeout value for CMD6")
Cc: stable@vger.kernel.org
Signed-off-by: Zhan Xusheng <zhanxusheng@xiaomi.com>
Signed-off-by: Ulf Hansson <ulfh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/omap_hsmmc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mmc/host/omap_hsmmc.c
+++ b/drivers/mmc/host/omap_hsmmc.c
@@ -1357,7 +1357,7 @@ omap_hsmmc_prepare_data(struct omap_hsmm
 	if (req->data == NULL) {
 		OMAP_HSMMC_WRITE(host->base, BLK, 0);
 		if (req->cmd->flags & MMC_RSP_BUSY) {
-			timeout = req->cmd->busy_timeout * NSEC_PER_MSEC;
+			timeout = (u64)req->cmd->busy_timeout * NSEC_PER_MSEC;
 
 			/*
 			 * Set an arbitrary 100ms data timeout for commands with


