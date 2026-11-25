Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623345;
	b=IXQtsFaPZSn0Da9VW0tr4FjhIERiZ4LfnQptD53KhLlU6OwXg+kH1xO82Zo5KyzoxKjG
	 /B/juVLBIFQnCIf1D1crC99YX0Fq0JPBdhM1PYWE87bmiDcEHDTJRa7EEiA6Yqf9wXlC6
	 xffBAaNaCXnwlUpwPlufRevnaKQx8hJF0HfvJ6E5WFciX92VtYaPfw/xDYRXAQ3oLMyLm
	 Fhl6b2zwZZ8mHAE5LgMgfpOIX8B4r70QXVCL3ddAEJG3MYh66L56Sy8eHcZ8Al/1N7mfN
	 H2UxOHBEgiegiDAvceCLpae75JWnRxlDOD4gFpRNqHAWAyPWviE2ulEKztQOTygtaow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623345;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Nk/W97AfRCMOflBRIwooGRVnxeCI08HuwpW38VN/4M0=;
	b=fEbnGpuCeBup61iwMn8EWlN+i6z15KzxB3VvnXakaJ0uSVdbLT8wNCKGEDFV9MDabFlu
	 kg+s+TtUqw6m7VmdIAGJNQxdV0M4r4uIJMa7kmZ0cKcfHWTfWPVAnYBqqvQvaTzcfDpqc
	 Mp3rWcIOAYqFDh2bNL1eNBGDgBwGoS5YNRhSX9+aYXRVuaSmHO1fMGu6fnfQ4AR/ecc9C
	 QiqghDPUZiRODl3kqmSfxW/X6EpSCevf3iPxMxMOZ1ew3GopSBW/+vT+8veP+7G8cK/z5
	 ostl74XHz2pau3ZnVhaFl8g73LNqa1CU23EJDFMrXgF4XBg7dF0DlhrpJuM3FPrX7Mw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hG1dgoBn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2C10606A31E;
	Wed, 25 Nov 2026 16:15:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hG1dgoBn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F1AD1F000CA;
	Wed, 25 Nov 2026 16:15:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623344;
	bh=Nk/W97AfRCMOflBRIwooGRVnxeCI08HuwpW38VN/4M0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hG1dgoBnz3dkwIfz4Ly2wGKGaJ4VDH/89fHxeg+1XS0uiKKze8YnZkTi1tm1ImSxD
	 z+1DeJGnVvkMy7yRSh5edZhPB5QgzWWAGSAPBqlzYR3iE+b5pEm+tbQXbX5oLxv+Gb
	 4m/g/ur5qYRoHp3GsEbvrS2IUJvPY5m3wRn/Se8k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Subject: [PATCH 6.18 826/990] gpio: brcmstb: fix UAF after IRQ domain setup failure
Date: Wed, 25 Nov 2026 15:36:33 +0100
Message-ID: <20261125143841.384129019@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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
@@ -486,6 +486,7 @@ static int brcmstb_gpio_irq_setup(struct
 
 out_free_domain:
 	irq_domain_remove(priv->irq_domain);
+	priv->irq_domain = NULL;
 
 	return err;
 }


