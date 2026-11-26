Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705552;
	b=EXijT6oIYeDu4KsYU7XUZDrupHxZvsi5MwbKypAZI8VriB978FtmBRR+pTfVYyCys2QE
	 LNF7pcE0ZontBiMw7iOyeCRxNTZh6ZUBUN4b+lEotRI599nnG0iTgJfaNWX6SsSsRabNE
	 mrrJobmnNSl0TIGMWGFXmCs3msvmRdIO51+yZJ18zBWv7IIadK6A47GfD5pWNEjssgtk5
	 U6eGO4Z7j5BpBkgfiq1RHcRbkKplzulx4yFZvZO5t8DgQolTrQOWu5keNqL/CaTIMq2y1
	 5/4CRhPEGwk885Vi3WKpKPZL5Uw4LX/9+WnStR1yX3L5P5qubovOED2ZpAnCU2mlhHQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705552;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AF5lhp8J2Qccy8tCTy2vD7fHW8vk5npN9Nhj0BELiaI=;
	b=oVXo2rSeinoahaTYnowTU83Kwu++iYbEtJ6ztRZcDWSBKj0zLC4jwDALn7PssNrBtIOn
	 omrB9Iwb9XWTFtdJhjjBLX6VIKopx7r86D5sxbR25eWOskZ/JwoDkQDLhVtuC/rRhztBi
	 ImWhTt2utJuIIgI6/qhIzYiSmp7x1h3Q6HLWjTpr8+7BhotbXra0OMHTTkT+vdvkXRDzz
	 cvgi0VW1nlcFyu/xssU0+HQSbuLXplH00i9+2bepChWTNzJ+KRncWvW7L7lWQc0HyR+bL
	 lzSpLPJOQltm5S+mk1J/fMZDYBNCvv9RyehX+AbqKc2JDhA/vU+1SwbL9oopff9C1jw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xCVi1SMc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BACD7606A31C;
	Thu, 26 Nov 2026 15:05:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xCVi1SMc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C47B71F000CA;
	Thu, 26 Nov 2026 15:05:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705552;
	bh=AF5lhp8J2Qccy8tCTy2vD7fHW8vk5npN9Nhj0BELiaI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xCVi1SMc2hNLATXZw/JHgA2/Sxgaom92QmIHcfInyaID8pwUruGaZc9Ri762LE9Le
	 /N6izZoEFoeFbD1JmBzvLDtiXEEs+qRtmgKTBwFhe97ipYfTF0af+IYVOh2a6jue5f
	 CxwYrkMNcNqlxp9blhHNImvBGKDaxtzi/Ts9AppI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Subject: [PATCH 5.15 237/319] gpio: brcmstb: fix UAF after IRQ domain setup failure
Date: Thu, 26 Nov 2026 15:40:05 +0100
Message-ID: <20261126144012.096367272@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -505,6 +505,7 @@ static int brcmstb_gpio_irq_setup(struct
 
 out_free_domain:
 	irq_domain_remove(priv->irq_domain);
+	priv->irq_domain = NULL;
 
 	return err;
 }


