Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9C4520B3E;
	Tue, 23 Apr 2024 21:42:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908546; cv=none; b=U0VcYGTsKbiBZDqNFYmdyG2JKDYRL9HhiRg4R44FhvRWpFdasQPoTd+oG89zE0+5ZXXL0OZTDt5d3pj7iPfZvngUpOGBBrVX5Xg9paEjtIpREBFleuMxAn71Tg4PhHjI1ucZWvik4GC89R0hG6IzE/nFLhk8zpR35xfGs27hSMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908546; c=relaxed/simple;
	bh=dbBjf9tskrHH6eCX0WNkd7nAa1Xr3qs+b37ZHmJ2cFI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CNB2IkaEhqC1zOzwQlZvF/yzW6iR6c4MMVDnt6L1N5CfDP/alMjdjdRjigbuJ2xz55vJOYQktWmr5/phcNKZFLZm1m0Rt0auywJhD94atFlkagfa82K2xJWUDpV0hs3+2+qqYQ6mUGQXvUqbwDWd7SJNB8SfnOLYXrJEV2m1iGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QNLBWVoy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QNLBWVoy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F0E1C3277B;
	Tue, 23 Apr 2024 21:42:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908546;
	bh=dbBjf9tskrHH6eCX0WNkd7nAa1Xr3qs+b37ZHmJ2cFI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QNLBWVoy6u0+JaJI/jJqbGO3DCZG8ZewmMJ5Mnr9udP2HPW2S3qBp0TE/n5IN+vH5
	 n8C0kyEsYpmhOzsGoZGWOymJ2z0bVHh+J+xtFKzbV1Ke0LdkvSrAKjgdK68uttQBlr
	 iv/SPwE+NAjbyfhzHcrOs8bQd6VY8NcAD87ZDEKM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>
Subject: [PATCH 6.8 117/158] usb: dwc2: host: Fix dereference issue in DDMA completion flow.
Date: Tue, 23 Apr 2024 14:38:59 -0700
Message-ID: <20240423213859.727854430@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.824778126@linuxfoundation.org>
References: <20240423213855.824778126@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>

commit eed04fa96c48790c1cce73c8a248e9d460b088f8 upstream.

Fixed variable dereference issue in DDMA completion flow.

Fixes: b258e4268850 ("usb: dwc2: host: Fix ISOC flow in DDMA mode")
CC: stable@vger.kernel.org
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/linux-usb/2024040834-ethically-rumble-701f@gregkh/T/#m4c4b83bef0ebb4b67fe2e0a7d6466cbb6f416e39
Signed-off-by: Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>
Link: https://lore.kernel.org/r/cc826d3ef53c934d8e6d98870f17f3cdc3d2755d.1712665387.git.Minas.Harutyunyan@synopsys.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc2/hcd_ddma.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/usb/dwc2/hcd_ddma.c
+++ b/drivers/usb/dwc2/hcd_ddma.c
@@ -867,13 +867,15 @@ static int dwc2_cmpl_host_isoc_dma_desc(
 	struct dwc2_dma_desc *dma_desc;
 	struct dwc2_hcd_iso_packet_desc *frame_desc;
 	u16 frame_desc_idx;
-	struct urb *usb_urb = qtd->urb->priv;
+	struct urb *usb_urb;
 	u16 remain = 0;
 	int rc = 0;
 
 	if (!qtd->urb)
 		return -EINVAL;
 
+	usb_urb = qtd->urb->priv;
+
 	dma_sync_single_for_cpu(hsotg->dev, qh->desc_list_dma + (idx *
 				sizeof(struct dwc2_dma_desc)),
 				sizeof(struct dwc2_dma_desc),


