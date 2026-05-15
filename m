Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAD2526CE11;
	Fri, 15 May 2026 16:17:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861855; cv=none; b=LnO3XnJkqnsZ/flEPnrNk9Ooe3uMLv2Ze2boH/Qqf5KXvAog6lRX+bBEoy61iq3SZ+1O3TdES2bE7BSKJXYzfoAk8VYTmnJ5Prr4Ye35N9/vX58jMhNeGGz+0p36yUXTrCbDAMZ8ltxp/3Ceydb2MwEmARRtHJi1PAvuD1W3kVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861855; c=relaxed/simple;
	bh=C6rkomUOJ4uVpLd0VMkwTDC+WMwYEL3xK8jiQJfq41o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RB6vkUr9ws2UNm23+U77B1FnjLvHQ40dldaQQr3ttne5GeDLT//1W2aCfTUmjpHUpTVHrC8NZLdvp/+cM5WEAoS+PZ3ygCOfyVVYuG+Lw4lLSaLcpOzEJN7tUo76H9TR6E+00QjyFYn8+0eYtRbL0McasCLJhDkv5noXoOxXcGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JtHwQKnJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JtHwQKnJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61232C2BCB0;
	Fri, 15 May 2026 16:17:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861855;
	bh=C6rkomUOJ4uVpLd0VMkwTDC+WMwYEL3xK8jiQJfq41o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JtHwQKnJshxBRF8VnhRHQnFTx52sa0tJH2M2HXom1Xyw13l/ygGANTWmZLAp+p+gs
	 yFzY2zryecoZ7nUbRJKUiTnyM2ba+pzw4pDy/XMPV27Ay++rYXXKCrMCSOMNdTlCCQ
	 uu4XUoP8J8Wela5FIu5Ts95zVkn/qAS5O1yCzBqI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.18 015/188] media: chips-media: wave5: fix a potential memory leak in wave5_vdi_init()
Date: Fri, 15 May 2026 17:47:12 +0200
Message-ID: <20260515154657.637195528@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154657.309489048@linuxfoundation.org>
References: <20260515154657.309489048@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>

commit 95bd174a453f77b09ea66e1e22834680754ba501 upstream.

Add wave5_vdi_free_dma_memory() in the error path of
wave5_vdi_init() to prevent a potential memory leak.

Fixes: 45d1a2b93277 ("media: chips-media: wave5: Add vpuapi layer")
Cc: stable@vger.kernel.org
Signed-off-by: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>
Reviewed-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/chips-media/wave5/wave5-vdi.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/media/platform/chips-media/wave5/wave5-vdi.c
+++ b/drivers/media/platform/chips-media/wave5/wave5-vdi.c
@@ -49,6 +49,7 @@ int wave5_vdi_init(struct device *dev)
 
 	if (!PRODUCT_CODE_W_SERIES(vpu_dev->product_code)) {
 		WARN_ONCE(1, "unsupported product code: 0x%x\n", vpu_dev->product_code);
+		wave5_vdi_free_dma_memory(vpu_dev, &vpu_dev->common_mem);
 		return -EOPNOTSUPP;
 	}
 


