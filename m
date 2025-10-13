Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01E263093C8;
	Mon, 13 Oct 2025 15:30:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369453; cv=none; b=Me55yshNygGFTVwrx5mnxH6bz+1CEPft9XqZKaVOL5z6bXbrDrir85aE6M1/IhGcdAz+EwD0n+50lUMF229fXcKYMLZneOwwD3kKRmxBYyeU4XgWlTt2yt9GZy/7ejg5+9JINHBbOuN2s4jUhNsDCmI93UjHDTB+cNWgIH6lxtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369453; c=relaxed/simple;
	bh=ZIRgA0vE3jIAOaufaMj9EFkHta1SZyVJ1FpFhhqZw5c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mv6wnAXbVX+p0x1suH7hh/KoIKnaNPkL2L24S9AY6PO4acBxsW/CBCexbfTaxJwMQVLkgzKJc8oDV/RL9WyoBetjLXWqCUFyYex9mBsw52OgHULNcveQ5wBFLja2tS3v00zn1T79SxasDB/WvP/EVLiNVxhUv25oppZrJPQW8qw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d7t1RexA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d7t1RexA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A122C4CEE7;
	Mon, 13 Oct 2025 15:30:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369452;
	bh=ZIRgA0vE3jIAOaufaMj9EFkHta1SZyVJ1FpFhhqZw5c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d7t1RexAr+pWooYK8r8sSasTfrNToxsBWSX5ACVZ12MpH/+dEon+leVY4USsCa0mR
	 wudoSnzdfWss+qtSVmjd2PBAmXoyRDwZ7XoS7Wgh2/GgV0OJidhvOpfCoSVo/SpEl7
	 X/QbgXkf4yzMewlLQ2BqtnYKgMwcHioVZVBxiT4M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 234/563] usb: host: max3421-hcd: Fix error pointer dereference in probe cleanup
Date: Mon, 13 Oct 2025 16:41:35 +0200
Message-ID: <20251013144419.757116283@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 186e8f2bdba551f3ae23396caccd452d985c23e3 ]

The kthread_run() function returns error pointers so the
max3421_hcd->spi_thread pointer can be either error pointers or NULL.
Check for both before dereferencing it.

Fixes: 05dfa5c9bc37 ("usb: host: max3421-hcd: fix "spi_rd8" uses dynamic stack allocation warning")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://lore.kernel.org/r/aJTMVAPtRe5H6jug@stanley.mountain
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/max3421-hcd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/host/max3421-hcd.c b/drivers/usb/host/max3421-hcd.c
index dcf31a592f5d1..4b5f03f683f77 100644
--- a/drivers/usb/host/max3421-hcd.c
+++ b/drivers/usb/host/max3421-hcd.c
@@ -1916,7 +1916,7 @@ max3421_probe(struct spi_device *spi)
 	if (hcd) {
 		kfree(max3421_hcd->tx);
 		kfree(max3421_hcd->rx);
-		if (max3421_hcd->spi_thread)
+		if (!IS_ERR_OR_NULL(max3421_hcd->spi_thread))
 			kthread_stop(max3421_hcd->spi_thread);
 		usb_put_hcd(hcd);
 	}
-- 
2.51.0



