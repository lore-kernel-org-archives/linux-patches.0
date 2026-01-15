Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 145173BC4D7;
	Thu, 15 Jan 2026 17:00:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496446; cv=none; b=u5WiSlVFP7JuSApNDJEazUc5Kbzd4GQbtfXoELa5L6N3HkakPteGlI0DB0RHtkpWxqZhjHZGTCmPScB/6fLzJxfF9//OKzyzeNAebUMnU1F1UI7jDPHUbDbgLhUcBNFPUWVtfH0Tvi3tINkCP8oLYf5MDxeKy1Ce82lfKGSK2PI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496446; c=relaxed/simple;
	bh=iKMwoiKhIU8kLzpV4FJfOw+oyHBRbBbQKij3XlRfOOc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iKBP6mp+XqZOWLqMzWw9BonJGVruZdUHN0/aDPy0MzNSAtnMti6Vw06TcTeCOKcAGDvHJ53fITP5f9p1d4FtKXUiGkH9OYdIhkNgtW9XHDsbYYACv8iGOZdxdVDv0HGOt8bXJGS4jelaF0dWgMKYsD5uJDqVdyYC8x07/8J0x2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=idsQB0zL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="idsQB0zL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 932BBC116D0;
	Thu, 15 Jan 2026 17:00:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496446;
	bh=iKMwoiKhIU8kLzpV4FJfOw+oyHBRbBbQKij3XlRfOOc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=idsQB0zLGaMpejAT6Yb7oboWinPS/1so4KYl2sQim75ifz6Fhiv3crcSxu0AsIKSa
	 s3ZAHwRX3uYR8GxWgigPE4gcj01WYUUQMcv8kVgodI+a1atpKbxnyWuey1WqwdCU4g
	 MnI9VcREQ+WzEEB3NgZCbzdUp7QTs0sSJK6pWn64=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaoqian Lin <linmq006@gmail.com>,
	Javier Martinez Canillas <javierm@redhat.com>,
	Linus Walleij <linusw@kernel.org>
Subject: [PATCH 6.12 016/119] drm/pl111: Fix error handling in pl111_amba_probe
Date: Thu, 15 Jan 2026 17:47:11 +0100
Message-ID: <20260115164152.548889935@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164151.948839306@linuxfoundation.org>
References: <20260115164151.948839306@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miaoqian Lin <linmq006@gmail.com>

commit 0ddd3bb4b14c9102c0267b3fd916c81fe5ab89c1 upstream.

Jump to the existing dev_put label when devm_request_irq() fails
so drm_dev_put() and of_reserved_mem_device_release() run
instead of returning early and leaking resources.

Found via static analysis and code review.

Fixes: bed41005e617 ("drm/pl111: Initial drm/kms driver for pl111")
Cc: stable@vger.kernel.org
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/20251211123345.2392065-1-linmq006@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/pl111/pl111_drv.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/pl111/pl111_drv.c
+++ b/drivers/gpu/drm/pl111/pl111_drv.c
@@ -294,7 +294,7 @@ static int pl111_amba_probe(struct amba_
 			       variant->name, priv);
 	if (ret != 0) {
 		dev_err(dev, "%s failed irq %d\n", __func__, ret);
-		return ret;
+		goto dev_put;
 	}
 
 	ret = pl111_modeset_init(drm);


