Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1D0C2C11DF;
	Fri, 15 May 2026 16:26:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862369; cv=none; b=s6bx8BSYXJ7gAjO8Qy1uoarwQDP2Dc9mjVdDZNEfrbOqJ7CxP3mf6WHHlHSgPURjg9kPiCw3GItp/7aXTu4rLJusfAF2X1/IcWswIexphM1WJMr1oHF0jDR4IpwqgDT7MbE8OG75lR8FDHI8BOmMjKAAMysCiyrKFWewzQ12jf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862369; c=relaxed/simple;
	bh=FRJQz5Z6nP3EEQ9rJF9zhpaoz0n8Ocd4Ia74yak9S3o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P5oHRHLWhsL1nGfSyHQSwAdqEw+aOOMSMIjWKIJZUz7lBWAkQyf3W6Cd1zvtFTRVuryZt4Z5TK89hHRTHh9HU2NY2+yZB2tBQS8vfE0tWty14E3Cwltl0n76nrcQEdhsCV2di4wZcE9K6C7Ulk5XwyCIOXXVT6YC9cNirqEhZa4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jAMNymg7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jAMNymg7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46FBFC2BCB0;
	Fri, 15 May 2026 16:26:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862369;
	bh=FRJQz5Z6nP3EEQ9rJF9zhpaoz0n8Ocd4Ia74yak9S3o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jAMNymg7MbB0KXDI6Izv/lzQRSSJhgVgWWnfa3nWBr0Fgh1Rl331AutN3jp4Oup9R
	 pIMQHoxaWT5AUgufU2c5bcSFRzwrdMV81pG4nq+RHYJWXAG0bhvnFbkrWm7v2dk3rK
	 Ywq3UGzlOdEftaYK3PF0h7pcVJMmDDJiF5M3g98E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 7.0 022/201] media: chips-media: wave5: fix a potential memory leak in wave5_vdi_init()
Date: Fri, 15 May 2026 17:47:20 +0200
Message-ID: <20260515154659.013956534@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154658.538039039@linuxfoundation.org>
References: <20260515154658.538039039@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
 


