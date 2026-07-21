Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF4F5403AFB;
	Tue, 21 Jul 2026 17:29:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654983; cv=none; b=pjhip3j1l8oUsXOFcXE5ggLapI70bnM0aZiQZEbzNuYTSVF05g3g1+3mG6ggp+NMbTWQOr7b5+Ijlbx5IEP8eY5kD9SOWDP6iehbFo3kdaJ7sbgj2jr2Q1F6v61VcK/X7uEEWK6H9Y/bhrcycI+bwqn+Bq5h1RP+xRIjd6UriiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654983; c=relaxed/simple;
	bh=/gviS18HnmgEmgvLyoKaxVQCCo/e+IzqtdBnC7Mwtno=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bqBqUkJ/np8dawpUm/J+3D+A5GgYHuVa7EgsjalslISUgHAhqv9meddfG8s+hdZubmq3TF7CkLgrg7uXcHUvdaZW3V3m2jZ3/59YdGyT9CB9SBbAwFEbJh38FPOKxyVzukuE9CXob8GQAYMSQ3cX5nexuIbyD8ujWSKM9/telE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v6QeplmT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v6QeplmT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 315CB1F000E9;
	Tue, 21 Jul 2026 17:29:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654981;
	bh=b6BFYT7PsA5FgbmbUbJ9omc4UwD3MQVO3Hy4awfxjzQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v6QeplmTtLalDgzSygXjOPW2q5/BgxOg14B4hiy+K2blbeOsOJsGmRyrPo5rQQRrD
	 EA5xQWHZSeF5FZhzAVhKzlK5L6avVObAk0JMJNqPaDIgnGdSqLKeP/xw4SiVfqVO+K
	 duHFm50MPCXvVHXmQemaJZe/12MYUmQWpL0ogtmE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Loic Poulain <loic.poulain@oss.qualcomm.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.1 1911/2077] net: wwan: t7xx: destroy DMA pool on CLDMA late init failure
Date: Tue, 21 Jul 2026 17:26:24 +0200
Message-ID: <20260721152637.791911601@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1063,6 +1063,9 @@ err_free_tx_ring:
 	while (i--)
 		t7xx_cldma_ring_free(md_ctrl, &md_ctrl->tx_ring[i], DMA_TO_DEVICE);
 
+	dma_pool_destroy(md_ctrl->gpd_dmapool);
+	md_ctrl->gpd_dmapool = NULL;
+
 	return ret;
 }
 


