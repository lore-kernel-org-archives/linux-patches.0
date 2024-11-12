Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CF23219CB6;
	Tue, 12 Nov 2024 10:45:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731408324; cv=none; b=FC0mI+qY6iO7VO0B1tmAh/LLWTWdpI+JVo3KTirbeTq+vNdyWj1xlQHPltEEVUTkgdjzB6WJy60lONaIUjLorA/UG4PX8d7j/Aku9rJQiJ0NT4mEGW3XuhIAmQE97zQ0XCL49pTmHMLakL9Pngph1ukp76yOoCBY+I8VLGpiaNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731408324; c=relaxed/simple;
	bh=FU3+wVlNLSSNV1r6XoD1A1rXB3ZX+B0IDX+qWgMZ5LY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DXReuu9pQUg1hZ6yKPpqWaScoAcdc7VdE4jyvDk37HeGuy+04reoFDOv6B16ZcQarMO5E9b5VDW/0bpTICdHhOlV5u6Q/MSCTCKAsNMQLIv5uFCiatPkjG16oMCkB1TO2gekRPVm+yHiw1lleYgOiy1eWih71Bod+/35kdX58SY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OxP0Yga2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OxP0Yga2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78C68C4CECD;
	Tue, 12 Nov 2024 10:45:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731408324;
	bh=FU3+wVlNLSSNV1r6XoD1A1rXB3ZX+B0IDX+qWgMZ5LY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OxP0Yga2xtrp3RQOlT9XGj6OxajWy0t0isTEu8K+mi9VJbb1WGVpetZawRiwEfN0Z
	 OhhdHXIFgu3tCigEw3T/IofC2UBu8d+heYhD7G3466rgHbg6AmiEWacjxUeQh/Sk0+
	 9qEW//B2O1Th3FqLDyocuzUAEp58QCMrPNG8AgaY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Ryazanov <ryazanov.s.a@gmail.com>,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.11 126/184] net: wwan: t7xx: Fix off-by-one error in t7xx_dpmaif_rx_buf_alloc()
Date: Tue, 12 Nov 2024 11:21:24 +0100
Message-ID: <20241112101905.702511465@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101900.865487674@linuxfoundation.org>
References: <20241112101900.865487674@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jinjie Ruan <ruanjinjie@huawei.com>

commit 3b557be89fc688dbd9ccf704a70f7600a094f13a upstream.

The error path in t7xx_dpmaif_rx_buf_alloc(), free and unmap the already
allocated and mapped skb in a loop, but the loop condition terminates when
the index reaches zero, which fails to free the first allocated skb at
index zero.

Check with i-- so that skb at index 0 is freed as well.

Cc: stable@vger.kernel.org
Fixes: d642b012df70 ("net: wwan: t7xx: Add data path interface")
Acked-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Link: https://patch.msgid.link/20241101025316.3234023-1-ruanjinjie@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wwan/t7xx/t7xx_hif_dpmaif_rx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wwan/t7xx/t7xx_hif_dpmaif_rx.c
+++ b/drivers/net/wwan/t7xx/t7xx_hif_dpmaif_rx.c
@@ -226,7 +226,7 @@ int t7xx_dpmaif_rx_buf_alloc(struct dpma
 	return 0;
 
 err_unmap_skbs:
-	while (--i > 0)
+	while (i--)
 		t7xx_unmap_bat_skb(dpmaif_ctrl->dev, bat_req->bat_skb, i);
 
 	return ret;


