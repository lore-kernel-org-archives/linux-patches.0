Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74E68269825;
	Tue,  8 Apr 2025 12:08:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114132; cv=none; b=nkDoWt7OGw3Yr1E5LkCTuIjf3TeycpKEEeW33n3r2BxiHbHmFUCc3dePqpEX1XMoVdrEMxdduUxDEEIxh0UIiN3Wvkym02gPwKYWQSmrf81jL9Ue5oM/JzfLqi9Ffn111hLcuqNNgCifkxlcgyfH+CzF6Q8F5ThV1aM33rwvWic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114132; c=relaxed/simple;
	bh=1Y61BbcCTf7op7MwDN6aVCHYGXPVPcyl0weOeuALMRc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Qs8UCRh105fFxLHKHu8EdwkKhVJyEX9bldJM98kuLSkEwOxa8aN2759lRWu/NcDIwKC5e/Cytxo+2Oz5MZuUv9poymy8POXZx/7IDcyzO5pgMD0eOeE+/9vXmIDp4il+otl43HUrUaHPlUGzhe/v8I0OzB4ZBBQlp3ltU8iYDwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TjUusmI9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TjUusmI9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1C05C4CEE7;
	Tue,  8 Apr 2025 12:08:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114132;
	bh=1Y61BbcCTf7op7MwDN6aVCHYGXPVPcyl0weOeuALMRc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TjUusmI9dxcpfJ382Lhv78pxp2GVYUYpykpbo8ZTGB6hwDCly0B7ZriYdkol9GM1B
	 v+zpguiGyBSDghWZpcozN/Bj5UnSuqyWRXb8/QyfpqAMh2mAj8GFUcnzfq+T41npIW
	 W3+FkjzozqbMV2K3AvZRs1ImgNbYde42BXMs+PB8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Markus Elfring <elfring@users.sourceforge.net>,
	Jon Mason <jdmason@kudzu.us>
Subject: [PATCH 5.4 147/154] ntb_perf: Delete duplicate dmaengine_unmap_put() call in perf_copy_chunk()
Date: Tue,  8 Apr 2025 12:51:28 +0200
Message-ID: <20250408104820.012504232@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104815.295196624@linuxfoundation.org>
References: <20250408104815.295196624@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Markus Elfring <elfring@users.sourceforge.net>

commit 4279e72cab31dd3eb8c89591eb9d2affa90ab6aa upstream.

The function call “dmaengine_unmap_put(unmap)” was used in an if branch.
The same call was immediately triggered by a subsequent goto statement.
Thus avoid such a call repetition.

This issue was detected by using the Coccinelle software.

Fixes: 5648e56d03fa ("NTB: ntb_perf: Add full multi-port NTB API support")
Cc: stable@vger.kernel.org
Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
Signed-off-by: Jon Mason <jdmason@kudzu.us>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ntb/test/ntb_perf.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/ntb/test/ntb_perf.c
+++ b/drivers/ntb/test/ntb_perf.c
@@ -838,10 +838,8 @@ static int perf_copy_chunk(struct perf_t
 	dma_set_unmap(tx, unmap);
 
 	ret = dma_submit_error(dmaengine_submit(tx));
-	if (ret) {
-		dmaengine_unmap_put(unmap);
+	if (ret)
 		goto err_free_resource;
-	}
 
 	dmaengine_unmap_put(unmap);
 


