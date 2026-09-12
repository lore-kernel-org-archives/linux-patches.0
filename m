Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E38F2FFDEA;
	Sat, 12 Sep 2026 14:22:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789222921; cv=none; b=YbtLNoQ1xJW4vXNDfw8FbB7RByPSkOzBslXuKBQrFI1sdo+BHs4/AYmfUPINqKzDGzY/0FZf9hhvcztb+mD7Y4iMfs5XEMZnMy7k7S7thbx83Gb1YJCFG1SrS9zex+VVyCvmKq6nBX7yH5LuMTdr4NC5Jf+I9YAkP4YK1PJ3Wzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789222921; c=relaxed/simple;
	bh=pwjWQ4GrGsieMeVKWEQP4INbvo1DPPpTfmiKn+Nsl7g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l2RuCG40fUI4LknskHmHztArkwoqZauDrQcksUTPJWHbwbt+JjpsGTiNlckqAVTpgBbEMnGe/MrIsdrkoxQCqiHLIYRLIqwhwUHWLw6gdKk+ChjPG2DhnmwCPXsIYyn6BTIUm1ox/Mas/VqbG684hOHAVanfbSCr1UdosCC905U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TTU40Wdc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TTU40Wdc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF9D01F000FF;
	Sat, 12 Sep 2026 14:21:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789222920;
	bh=rV+R2YZ0um23HG6ihcs6JuyQXiz2pM/5STdWJVbF2gw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TTU40Wdc9wcBkeZ7r1eNf6FNnzzZgVPx0RaviS8kMpdFqfDYbjesBmRzOdGp5W01b
	 EIhRNTGuJlD4ePL17gQdKsdojgiTTsaV7HrGdQ2DLuLTaKdfxj2vcKlM7oJYti7SLi
	 ZaY7rHLWlx2aAIvrZVVLXIHcbXTq1cls0t5buzbw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongyan Xu <getshell@seu.edu.cn>,
	Slavin Liu <220245772@seu.edu.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0685/1424] usb: gadget: r8a66597: avoid double free of ep0_req in probe error path
Date: Sat, 12 Sep 2026 08:51:57 +0200
Message-ID: <20260912065622.642636993@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

From: Hongyan Xu <getshell@seu.edu.cn>

[ Upstream commit 41d541e3718db01668a4cd29815ee4b3b55f76d2 ]

If usb_add_gadget_udc() fails, r8a66597_probe() jumps to err_add_udc
and frees ep0_req, then falls through to clean_up2 where ep0_req is
freed again when it is non-NULL.

Remove the redundant free from err_add_udc and keep the cleanup in
clean_up2 so the request is released exactly once.

Fixes: 776976a67ae2 ("usb: gadget: r8a66597-udc: cleanup error path")
Issue found using a prototype static analysis tool
and confirmed by code review.

Signed-off-by: Hongyan Xu <getshell@seu.edu.cn>
Signed-off-by: Slavin Liu <220245772@seu.edu.cn>
Link: https://patch.msgid.link/20260624140908.1282-1-getshell@seu.edu.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/udc/r8a66597-udc.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/usb/gadget/udc/r8a66597-udc.c b/drivers/usb/gadget/udc/r8a66597-udc.c
index 51b665f15c8e8..91fe432fc674b 100644
--- a/drivers/usb/gadget/udc/r8a66597-udc.c
+++ b/drivers/usb/gadget/udc/r8a66597-udc.c
@@ -1951,7 +1951,6 @@ static int r8a66597_probe(struct platform_device *pdev)
 	return 0;
 
 err_add_udc:
-	r8a66597_free_request(&r8a66597->ep[0].ep, r8a66597->ep0_req);
 clean_up2:
 	if (r8a66597->pdata->on_chip)
 		clk_disable_unprepare(r8a66597->clk);
-- 
2.53.0



