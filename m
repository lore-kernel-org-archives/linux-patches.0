Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062713;
	b=AD3R6NDJQQhwm+fX1AmqZdJrZDUpabVsKeufnEHUb7Tb0SbgRBOcLDZJUxjYlalAsrC3
	 nSWvLhUzFMMYfNnfHgrbrcLHgv8sD2J7sM78fpK60gwL9N7KSgCM77STcWu0sUUQDv4St
	 WhiMh7ggQfsbeNfIDD+tJZ9Wh20hCrCVvA5OivyvKqbTUmtnSbHwfGU0kMGD/WM7TtCqh
	 1LEE7zWCJCpU85QVr0NMSrrYrLLmMGb0bcOoqbi8+cBoQWTLM3rksVv4NXrZkNwlitA7a
	 Muzgpl4g2CS7uHZNRNhinPOix5sWTpOGeePbwTaUa4McY0Ka7OLS903fjiIcaQEfulw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062713;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5Jn0PP3TSswe8NR2zxFFRopMfPxkxo2fZbLLAnqJSw8=;
	b=di3X2uNQcdLs1J4pkcUygetu18ayxKaPQnP/2UUyrnteiiAzK9Kr3z5VKnQOxbhxTXmb
	 BPMt1GFT4TXTVOL4EPnlm4RbVH6prDss2DjMLTrETK4wARLeV92waiES+aUf+RPWnkDFM
	 N3X/JSaX4PSX9NhYWTwFN41/A/GOJEebIWPeQIY0ZaJH2/ws7K57nGeZ0EZwgEiB0mafE
	 aUruzoyMl99sa2tuEz3MsIvPqRhwHpR/yATSXMojGWMbjAeRIUls9xINcBQo7XOLBl5YH
	 GW+VOZC9keq/1Nl1sxka6747XeCsWmdr9asWJRlk89BTO5GEVrGRUQh64upzGjZ0Ocg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HOycpIgj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D79CD606A32E;
	Sat,  7 Nov 2026 14:45:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HOycpIgj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4691B1F008A1;
	Sat,  7 Nov 2026 14:45:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062712;
	bh=5Jn0PP3TSswe8NR2zxFFRopMfPxkxo2fZbLLAnqJSw8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HOycpIgjxJMH6P19XBVBAeV1lK9W0Ne0Ki62uZsUqJ870hAgmXHzy6ZXGc6DLa89p
	 /Wqukoj+Y04ZfSWQKC8SarNBLVAbBE8y/gAEnBe31+tbUGtM+MrH9a8YESCwPyfXvS
	 NWPD7f+GoTXnVOwPVAyKErGmEnr76wiLi1ItVIaA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Young <sean@mess.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 034/869] media: sunxi-cir: Ensure no more interrupts can occur before free
Date: Sat,  7 Nov 2026 08:45:16 -0500
Message-ID: <20261107134853.336733492@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Young <sean@mess.org>

[ Upstream commit f9b33ec404200c03dd490ec133b8f9bf599c5444 ]

Only call rc_free_device() once the hardware has been stopped.

Fixes: dccc0c3ddf8f ("media: rc: fix race between unregister and urb/irq callbacks")
Signed-off-by: Sean Young <sean@mess.org>
Cc: stable@vger.kernel.org
Reviewed-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/rc/sunxi-cir.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/rc/sunxi-cir.c b/drivers/media/rc/sunxi-cir.c
index 28e840a7e5b8c..af1ee08ffdbec 100644
--- a/drivers/media/rc/sunxi-cir.c
+++ b/drivers/media/rc/sunxi-cir.c
@@ -374,8 +374,8 @@ static void sunxi_ir_remove(struct platform_device *pdev)
 	struct sunxi_ir *ir = platform_get_drvdata(pdev);
 
 	rc_unregister_device(ir->rc);
-	rc_free_device(ir->rc);
 	sunxi_ir_hw_exit(&pdev->dev);
+	rc_free_device(ir->rc);
 }
 
 static void sunxi_ir_shutdown(struct platform_device *pdev)
-- 
2.53.0



