Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E0D523815B;
	Mon, 23 Mar 2026 14:47:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774277251; cv=none; b=ARMD1iA8PYlhPNPpt7RaOrq5MRTBHULdAmVVkxx2H+xZXEwxASjcOchsrMFBkC9KhZxlrXjjlXyhQmRfpZLPtxNYFTtkFgb1aju0DsPkA1YxGcNyGjgyg3nolXxueRr9QvWeiD4xa0mQSNDEzHx0RsJtFlBTYzQ1hMpPKB4YWSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774277251; c=relaxed/simple;
	bh=TLarNvIdS6zU5M/tq/R45JYd4h9r2R+cnkDCe+h2rsQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DHHURhcOy67pIAWUNKjOGBOzhnrXJVtqsbhnQvKcb8qBZdqNv9Ot2H+I/F4ucTEVquIwJzILRgznWYVz2owqAT0/vDidC2vWss7S3RcT2TyQAC3uLktvYOEsHbS99nv5C8+9RZLsm5pPMfCNndQp/4HfYMta7QfrB2jWQ2cJSEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iBgOUM9Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iBgOUM9Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E748C4CEF7;
	Mon, 23 Mar 2026 14:47:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774277251;
	bh=TLarNvIdS6zU5M/tq/R45JYd4h9r2R+cnkDCe+h2rsQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iBgOUM9QIQQkngcwa+ssp6ke20iI9x64Kb79lR2Vp0qAMpBVknABr7SvMrpx5/hMs
	 A3T1Uq6ZjqZNV1PCuLoRoX6pCuU3pk/NvBzMZFHqg4W+jKcxNNEPXJObpk96TVH/wD
	 ktGHar0BBDao5nq/GSp0hMzVbAsUWk7ep+jBDi1M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 370/460] cache: ax45mp: Fix device node reference leak in ax45mp_cache_init()
Date: Mon, 23 Mar 2026 14:46:06 +0100
Message-ID: <20260323134535.657812610@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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

From: Felix Gu <ustc.gu@gmail.com>

[ Upstream commit 0528a348b04b327a4611e29589beb4c9ae81304a ]

In ax45mp_cache_init(), of_find_matching_node() returns a device node
with an incremented reference count that must be released with
of_node_put(). The current code fails to call of_node_put() which
causes a reference leak.

Use the __free(device_node) attribute to ensure automatic cleanup when
the variable goes out of scope.

Fixes: d34599bcd2e4 ("cache: Add L2 cache management for Andes AX45MP RISC-V core")
Signed-off-by: Felix Gu <ustc.gu@gmail.com>
Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cache/ax45mp_cache.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/cache/ax45mp_cache.c b/drivers/cache/ax45mp_cache.c
index 1d7dd3d2c101c..934c5087ec2bd 100644
--- a/drivers/cache/ax45mp_cache.c
+++ b/drivers/cache/ax45mp_cache.c
@@ -178,11 +178,11 @@ static const struct of_device_id ax45mp_cache_ids[] = {
 
 static int __init ax45mp_cache_init(void)
 {
-	struct device_node *np;
 	struct resource res;
 	int ret;
 
-	np = of_find_matching_node(NULL, ax45mp_cache_ids);
+	struct device_node *np __free(device_node) =
+		of_find_matching_node(NULL, ax45mp_cache_ids);
 	if (!of_device_is_available(np))
 		return -ENODEV;
 
-- 
2.51.0



