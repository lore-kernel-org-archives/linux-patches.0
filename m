Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBE84143888;
	Tue, 23 Apr 2024 21:43:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908640; cv=none; b=o0/SRE1nuFGLZpXx0VJgv5AsYwi3KCzNXru5qQPTN1vMnpqp7a20za6o3nuOakBYY8ouGz4eQbsiUU0i/AyTo7qU1e2FXG6/yRmmdhanSR+kpD/AORMM6Cro9eqw8hIJNuQgxpR28mf9glkmeYsy7t8cOYIUc7ScK6AKT9/z7oc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908640; c=relaxed/simple;
	bh=p8T9PU/zwPiF3AM0iMSBKKOuFJCXx5Mv3G6wggENP04=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aHgP3nGLv4Xabn44uzExEW7jXAucUJzK7UhMYVcskFWBxIIdMurIXzYd1g7hPiVHHwu4k/6LFp0i+0MRHbsDNy6fnN84umulqA7yk99rNMpVuhwhSDpx6Zd19vRwCVOfoV+K99tqqW58JIEStPIyAXAZJVheLLhkMmQq/A/8+rA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jnPpC4oo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jnPpC4oo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD94BC116B1;
	Tue, 23 Apr 2024 21:43:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908639;
	bh=p8T9PU/zwPiF3AM0iMSBKKOuFJCXx5Mv3G6wggENP04=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jnPpC4oodzvq1zdon1llrj5anZaun0MfoKqb3Lhm7t+2FS0MXa3uuqvTOsObd/kGw
	 yxSC12kj3moEL0IpCK7udAu4RD2Yk6Qucx+s1zcYJDoMSQghgrPEkQ92D1DNE5GHbV
	 YcdtN2IWjbR3kijs5USvh4GeEKt9qBztCcXH53vA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>
Subject: [PATCH 6.6 122/158] usb: dwc2: host: Fix dereference issue in DDMA completion flow.
Date: Tue, 23 Apr 2024 14:39:19 -0700
Message-ID: <20240423213859.698507889@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.696477232@linuxfoundation.org>
References: <20240423213855.696477232@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


