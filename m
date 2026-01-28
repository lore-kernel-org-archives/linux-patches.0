Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E3B7155757;
	Wed, 28 Jan 2026 15:31:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769614279; cv=none; b=qU1Yte/dgEVD3qrzPSzMwC18I7Xh1KaRVGIwyKhWhdRyutMwWXKPMlfjo/ZismDse+dRNAr7L5/QmA4r7VJMCY3F1WHAvc3rzjpQ/CiOuhO8ILu+yMBO8oAxyFo8hnyhwa/QidOUD/3MSNeF2PooWHfpVZuy7WXqkDZszGBeZ6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769614279; c=relaxed/simple;
	bh=7wvo+/J3viy1JyyZ6tB1a19BduzTy+Ywyeu2m1k3FUw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=re8tPs6dfpRWVqW9yg23Y0P6v1IthuCVGK0WyEpjx7wVa9rkF8eH0RlxCVjlD53V3AeXQPStnpb5LBLFg56xP8buiMXsi7S3JGI/hA4Mre8Qc7CXSYXBcDqZrpMKbDLa/9rEemaHDf5uaUNOZwdkoSiP+DkiRxR/39xXQyPmKCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hNlgpEOV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hNlgpEOV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D702DC4CEF1;
	Wed, 28 Jan 2026 15:31:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769614279;
	bh=7wvo+/J3viy1JyyZ6tB1a19BduzTy+Ywyeu2m1k3FUw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hNlgpEOVnlf2D2KWQR2fvcRSyQu71dMHuYpT7ELcOx7IqnDgtztWzIgjnazntuuc6
	 Z+MmzlymqZtaSLhBvkjbKPDJ9zGykJuKosTB+hfAFzSqusibDthxzGRYom1+0J+3e9
	 LxihT6W2ma8S+Hrk5lG2gb/roC/o7GwgNYpbsaQQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Grygorii Strashko <grygorii.strashko@ti.com>,
	Yu Kuai <yukuai3@huawei.com>,
	Johan Hovold <johan@kernel.org>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.6 088/254] dmaengine: ti: k3-udma: fix device leak on udma lookup
Date: Wed, 28 Jan 2026 16:21:04 +0100
Message-ID: <20260128145347.993953090@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.698118637@linuxfoundation.org>
References: <20260128145344.698118637@linuxfoundation.org>
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

From: Johan Hovold <johan@kernel.org>

commit 430f7803b69cd5e5694e5dfc884c6628870af36e upstream.

Make sure to drop the reference taken when looking up the UDMA platform
device.

Note that holding a reference to a platform device does not prevent its
driver data from going away so there is no point in keeping the
reference after the lookup helper returns.

Fixes: d70241913413 ("dmaengine: ti: k3-udma: Add glue layer for non DMAengine users")
Fixes: 1438cde8fe9c ("dmaengine: ti: k3-udma: add missing put_device() call in of_xudma_dev_get()")
Cc: stable@vger.kernel.org	# 5.6: 1438cde8fe9c
Cc: Grygorii Strashko <grygorii.strashko@ti.com>
Cc: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20251117161258.10679-17-johan@kernel.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/ti/k3-udma-private.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/dma/ti/k3-udma-private.c
+++ b/drivers/dma/ti/k3-udma-private.c
@@ -42,9 +42,9 @@ struct udma_dev *of_xudma_dev_get(struct
 	}
 
 	ud = platform_get_drvdata(pdev);
+	put_device(&pdev->dev);
 	if (!ud) {
 		pr_debug("UDMA has not been probed\n");
-		put_device(&pdev->dev);
 		return ERR_PTR(-EPROBE_DEFER);
 	}
 


