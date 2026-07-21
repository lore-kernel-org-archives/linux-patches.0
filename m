Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C02203E49D4;
	Tue, 21 Jul 2026 17:10:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784653854; cv=none; b=eNx+NVHW1s3VYEThx2a6UyxgSQHfmtIkYaidWZc2ZEJElkx2zpBpUcr7fsDi37EPABELT/Gay2v9JxeLwPQZBS51366tNVfPBPnTzfdkT8kn0J8z5XXnDTZ50VGZQL6MVfLD5/mQu2XWlT4+Nwc1pxF5xiaaL+WOlcGBP0GD1DY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784653854; c=relaxed/simple;
	bh=iITelDixSf95LZYZNTWhbbdg56pelW9BsG9IPe2bV0Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HK5mvKTQ+zaBxYj6qdgbZoJbLcGQDcK1TCv4xaOAWeD08xhPyntkZrvtPEjePLgzrn9UyUfEu8yIkKxqXrHn7b5+W1hRY7WCpIIKh1hWgOi1vhJnrxToWFCT8b7pc+mWLhvw1UM+rAMVSPTr28yxlJzpyQPVZ3gu+PDtmrvYzZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cMjq725d; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cMjq725d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32C2D1F000E9;
	Tue, 21 Jul 2026 17:10:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784653853;
	bh=Gy2zVFdiju6uk/N3YFzLNojKXRWfmTmhZ9b1I8TjXo4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cMjq725dgIfN3YF/XV9n/jzgk1gcLnLfw7Ie39Gsymxota1BRcok+4QGv14u3SV7X
	 6YtlHvMlHfgdxEvGDtjYk/wpyOtEa1anwaWBFaRGFTXvYSMBVbD/x1tugpe7hCIMyE
	 RU5ymdp+fWwv8fQTqvbO4opuC27B+kLRs72vuecc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1485/2077] gpio: mvebu: free generic chips on unbind
Date: Tue, 21 Jul 2026 17:19:18 +0200
Message-ID: <20260721152627.825746097@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit b11c513ad943f35cf5e8007d3a56279c79b7ed4b ]

irq_alloc_domain_generic_chips() allocates generic chip data that must
be freed via irq_domain_remove_generic_chips(). The devres action
mvebu_gpio_remove_irq_domain() only called irq_domain_remove(), which
only frees the generic chips if IRQ_DOMAIN_FLAG_DESTROY_GC is set.
Call irq_domain_remove_generic_chips() explicitly before
irq_domain_remove() instead.

Fixes: 812d47889a8e ("gpio/mvebu: Use irq_domain_add_linear")
Assisted-by: opencode:big-pickle
Signed-off-by: Rosen Penev <rosenp@gmail.com>
Link: https://patch.msgid.link/20260707232358.1218077-1-rosenp@gmail.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-mvebu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpio/gpio-mvebu.c b/drivers/gpio/gpio-mvebu.c
index 689dc6354c2d78..a010604e5ff795 100644
--- a/drivers/gpio/gpio-mvebu.c
+++ b/drivers/gpio/gpio-mvebu.c
@@ -1110,6 +1110,7 @@ static void mvebu_gpio_remove_irq_domain(void *data)
 {
 	struct irq_domain *domain = data;
 
+	irq_domain_remove_generic_chips(domain);
 	irq_domain_remove(domain);
 }
 
-- 
2.53.0



