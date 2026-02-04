Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE8B341B34E;
	Wed,  4 Feb 2026 14:54:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770216866; cv=none; b=qYmwVxubgRX3eY9IVmYfMD6vP/8K2GGHZGcr6jOj80eLzLSHSQlTBfXxhtbjRx4gQXJ+Ut2E6hN9YL8Qg/icDWoahJbP01J7urJCc9krVGWnTSYqqbohAVSi85a5SmmX90FEhruXHNYm3/FYoSCHYZxT8xFBrsTIwR4XpWD12fY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770216866; c=relaxed/simple;
	bh=jK0lfOIkoPeTwcyRiXfMu4oN1NQmLSgPZ9voxzvL3TM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HJigT5txMHnG+9cM00QhbTqhI4VZ6snowS/k0/ig2b8uU1flav5Zdm2ueKYqD2DiTwij7geKFQpast1i1LSCL6lXz4sNpcOU+j4aiBzkO/BNS4RL8zqQgN/PuOkg1OLKAk+xleyhIdJ4yns7DcyT3lFUUGkTEc8Zwe1p5L3SJj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jd3LAGk9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jd3LAGk9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2203DC116C6;
	Wed,  4 Feb 2026 14:54:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770216866;
	bh=jK0lfOIkoPeTwcyRiXfMu4oN1NQmLSgPZ9voxzvL3TM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jd3LAGk9/L719et2+w1jj233+ueVAES/23xo1fjk+gM4mOvBkuCWpuQojotbey3GR
	 GDEVfpyR8hHMCVOsndvQZqviCoPYiDxprWFfcboCoUQ5JRNO2hNc+1hdY1Ynm3S3fk
	 70PaGGhyYMbvcMz2VwZZlvi272w+uuqKxwt0+AEk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Grygorii Strashko <grygorii.strashko@ti.com>,
	Yu Kuai <yukuai3@huawei.com>,
	Johan Hovold <johan@kernel.org>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.15 053/206] dmaengine: ti: k3-udma: fix device leak on udma lookup
Date: Wed,  4 Feb 2026 15:38:04 +0100
Message-ID: <20260204143900.127544789@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143858.193781818@linuxfoundation.org>
References: <20260204143858.193781818@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -40,9 +40,9 @@ struct udma_dev *of_xudma_dev_get(struct
 	}
 
 	ud = platform_get_drvdata(pdev);
+	put_device(&pdev->dev);
 	if (!ud) {
 		pr_debug("UDMA has not been probed\n");
-		put_device(&pdev->dev);
 		return ERR_PTR(-EPROBE_DEFER);
 	}
 


