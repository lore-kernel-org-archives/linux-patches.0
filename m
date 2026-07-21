Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C71A24746A6;
	Tue, 21 Jul 2026 20:58:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667507; cv=none; b=F9G0pm0rVPBxbH+Fh07V9sYTFp1bLAifli9cN5v8jPTVbiOfW/S4HRY9J0c/eZaJY3gYpvEPjFCJEj5EtE9eL5yWwwL2sBh2VOP2CSUcE0CYMxfieiGtUokmAvy37kywjFyd6bFk1jDPQEgZHWa+KFzbHGwWWCuJ95p5PEzISsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667507; c=relaxed/simple;
	bh=2lSdh18JwAsQ9OjjgYWC4BVHkuTZmf/Nw4+W/f1NbZk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NB8LLbNla/B3Nl5epp9Z9J5V7UUnaQk1lQOoL6n70rUwpeGivxNYXThlBLivb5CpxNWEXYasRhi8mKTnxGxF7ssjhDNh7FHVeJrgP2Wg1MgnXNvXm2X8Twq9/I+E+unNm2SbpkgyRoalKc3dEj8tHd6u5Fm755VgRlPzip19I+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g+FzYC8I; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g+FzYC8I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16D6F1F00A3E;
	Tue, 21 Jul 2026 20:58:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667490;
	bh=2zBYyUlIw7pfX777FidV2iz4QX2ceehLM+6VJWZYq9A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g+FzYC8I7SdVcKa12aq9r/3R/BLi49W/eDw8PEGYUo94kml4yRH8JRfeiZpG9wcv6
	 EXHpYDt6HUnqp+hXNObfV11f1+oakuKTShru5jl8H2kPmVm2+eAEgMnhu9ysk5mQcs
	 0Z5NJp5oygnPUDLb9kEgWJAVfckBJL/jTDff8rHc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Loic Poulain <loic.poulain@oss.qualcomm.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 1081/1266] net: wwan: t7xx: destroy DMA pool on CLDMA late init failure
Date: Tue, 21 Jul 2026 17:25:18 +0200
Message-ID: <20260721152506.001286035@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haoxiang Li <haoxiang_li2024@163.com>

commit 2bd6f26d4ce1e87de4d736b1e8896daf3acf1c0e upstream.

t7xx_cldma_late_init() creates md_ctrl->gpd_dmapool before
initializing the TX and RX rings. If any ring initialization
fails, the error path frees the already initialized rings but
leaves the DMA pool allocated.

Destroy md_ctrl->gpd_dmapool on the late-init failure path
to avoid leaking the DMA pool.

Fixes: 39d439047f1d ("net: wwan: t7xx: Add control DMA interface")
Cc: stable@vger.kernel.org
Signed-off-by: Haoxiang Li <haoxiang_li2024@163.com>
Reviewed-by: Loic Poulain <loic.poulain@oss.qualcomm.com>
Link: https://patch.msgid.link/20260621031714.3605022-1-haoxiang_li2024@163.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wwan/t7xx/t7xx_hif_cldma.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/net/wwan/t7xx/t7xx_hif_cldma.c
+++ b/drivers/net/wwan/t7xx/t7xx_hif_cldma.c
@@ -1053,6 +1053,9 @@ err_free_tx_ring:
 	while (i--)
 		t7xx_cldma_ring_free(md_ctrl, &md_ctrl->tx_ring[i], DMA_TO_DEVICE);
 
+	dma_pool_destroy(md_ctrl->gpd_dmapool);
+	md_ctrl->gpd_dmapool = NULL;
+
 	return ret;
 }
 


