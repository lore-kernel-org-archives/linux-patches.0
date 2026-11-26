Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704779;
	b=stOWqxLdE3kPZxOFx5ewjPLsEjds72v+wgrGOwbzrPwyX0Zdv6ZzJdjoEqk1jQNnigRu
	 UtzfTnnrUeHkhI/z9aQjER056ezSfL5qRYEqnPNyl79lfO5S1Q8QWZHhGYwUulHBBgJDu
	 kwlohLK8h7ET10WTEY3pcD3I4fGiQbI0uYGbo2RWwXT+5g3m1+BjdZY4ZAuFSpN1UezXi
	 KRe7pYmT46KxfgW5FJzfgittQJD7fZB1LjA1zHPhAygRMSTL6FQH8TTCdgJaMcb4Wdyk6
	 Jj0/VZnlDcHR8DeaqXe8l5rsJ47ejz+Ch3Sdis7b1DUeFSJDpFruK12s0pKIouBwhRw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704779;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dAEaIFmSOXg+nrqetHjOpmanJzgCGUf9xWGxGOtsky4=;
	b=qEQ0OcQNjmmgq1aWMhU6K6W1Cd5FeuxzlZx2QXpyjGnKvyf73B3jWq74QW4j2UT8A36n
	 ibfpMBemju6lA9xlkFkSuupCfHbg21B7KRJ0iFk1R2CRGpKpxcur9zwQ2DXsSFnrZeugT
	 e6MpHFnn0RID/V0GPOe2WgGErzkd2Ug5LJEtwgk2Ntvq08VMSAa3EZmkNzhtA8brhiu/W
	 p1neYBLaODfRCBagc+XctCy/IwpMkgujF4PBC4PX/TGP+x+OjzEEPbrbW9LY3sawFvDol
	 mBBBevevIutkWIA2PRzmApC4I+ei6D6X+P2S9TfAcgm3veir3SKhQcFhC7u6QapSmaQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Iad7sn/J";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC443606A31C;
	Thu, 26 Nov 2026 14:52:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Iad7sn/J
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B71121F000C4;
	Thu, 26 Nov 2026 14:52:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704778;
	bh=dAEaIFmSOXg+nrqetHjOpmanJzgCGUf9xWGxGOtsky4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Iad7sn/Jl8gep8PfdHstXxbUBsQH23TN0iRRCmtvn4lmgweZlpfS7CacXtwWZHY/e
	 ps+CIqs7KMB9p7il+xbqmFttNGgpiguFZeR+u/+MnAYMzxh21Hcbm/MgGsMBhZRBRv
	 8ux1yVMQRDZBtCC5866spvwZbYJTKG/WAwOJZfwk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Subject: [PATCH 5.10 196/265] gpio: brcmstb: fix UAF after IRQ domain setup failure
Date: Thu, 26 Nov 2026 15:38:46 +0100
Message-ID: <20261126143618.909398870@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guangshuo Li <lgs201920130244@gmail.com>

commit baa14758afb3e2828de1f76511edc1de50216f39 upstream.

When devm_request_irq() fails in brcmstb_gpio_irq_setup(), the error
path removes the IRQ domain but leaves priv->irq_domain non-NULL.

The probe error path subsequently calls brcmstb_gpio_remove(), which
checks priv->irq_domain and attempts to access the already-freed
domain through irq_find_mapping(). It also attempts to remove the
domain again, resulting in a use-after-free and potentially further
memory corruption.

Set priv->irq_domain to NULL after removing it so that the common
cleanup path skips the already-freed IRQ domain.

This issue was found by our static analysis tool under development.

Fixes: 0ba31dc201de ("gpio: brcmstb: consolidate interrupt domains")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://patch.msgid.link/20261026115227.41779-1-lgs201920130244@gmail.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpio-brcmstb.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpio/gpio-brcmstb.c
+++ b/drivers/gpio/gpio-brcmstb.c
@@ -506,6 +506,7 @@ static int brcmstb_gpio_irq_setup(struct
 
 out_free_domain:
 	irq_domain_remove(priv->irq_domain);
+	priv->irq_domain = NULL;
 
 	return err;
 }


