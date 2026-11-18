Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033368;
	b=kDm8yb248gM0eKMrS12URLARp16bjWTfxX7siGk4X4KBjqlgKyUwEbUslLNVxooAMksV
	 7OeQmsStZt/mraSbVKBsbW8TclctnJT3hquDjPGUWV5Q4krslKEvFKIyG0nGV6/tK6ghz
	 woQqNruHmjcRG4QGfLITh0qUGWr0Z/pltRpxgh6FWOicmRM30DQXF5pG5xL1TK6Ki2eve
	 sAttz3lCUBlCUpVUDpLQ0CFdnLVXKflGkEGW51FsvekYBJ0NN4W1FMbmkA7HLf31b7OEp
	 un9o7DoWp2AUMdXujJbakVCHsSNP8unPcjR9Y49tK7x7RyXqkLzcuTDdCE+CMDcBEDw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033368;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=gNcMpXJZMUkFtKveE5tx0xbFhooN7J7SgHJLEouuOeY=;
	b=vcLM5VPk+/URBSdP/27K0XZJqJwvitjAhe2Lt1foUsgZ7Sp/IpkME/lHLMn+ddPIHVnF
	 3mqf5eSD2U4acYl6WFAgqbC/c3ooU3Eq32wZ9k2PQzIBTWrdtD0Abg9WnaJ4O5I7t1/sS
	 pZCRkRh0v47vZsoCHFj0k9VdjlLD+0N2zyxoymd3kvQI+l1CEz/BGzOB0El3NGIGuFPGM
	 wBrUv0XKOiIMRtsADr3AQFLMkAgXlLLgbL/UeynoseeRL3xF7CcQDhQ7ljYP2TrHYf6V5
	 lDmApuaEX31irwvlZ04Lp69R7/q7qKwoZIY502MTcFbgjTfWFCTPVH0dIUebkhSd9gQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Z5J3vrKf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85B7C606A331;
	Wed, 18 Nov 2026 20:22:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Z5J3vrKf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E8701F000C5;
	Wed, 18 Nov 2026 20:22:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033368;
	bh=gNcMpXJZMUkFtKveE5tx0xbFhooN7J7SgHJLEouuOeY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z5J3vrKf8r0NoyXhYpU4ww1QAsYrEMoGbn16xjwqA0TDVAN0fXpFfXC8UuQrNGd6t
	 /MxrifpioiDOdYBNE8jsDHarAzQP8D3qsQsSLEFvYG16pUNa0535hMaWKHrIKtOoBT
	 wWKVhwwN/7GQaBpxfLtkffCejEombd2SkvLx2Qjs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 6.12 1737/1756] platform/x86/amd/pmc: fix leak in probe()
Date: Wed, 18 Nov 2026 16:04:24 +0100
Message-ID: <20261118150118.703805204@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

commit 01db3d1ff43aeedeaf11c8bc9d09493ec00c8f4a upstream.

Call pci_dev_put(rdev) before returning.

Fixes: 6ad1b2dc0f2a ("platform/x86/amd/pmc: Use managed APIs for mutex")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://lore.kernel.org/r/65e2fffb-a1cb-4297-b725-661d6b790a05@stanley.mountain
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/amd/pmc/pmc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/platform/x86/amd/pmc/pmc.c
+++ b/drivers/platform/x86/amd/pmc/pmc.c
@@ -919,7 +919,7 @@ static int amd_pmc_probe(struct platform
 
 	err = devm_mutex_init(dev->dev, &dev->lock);
 	if (err)
-		return err;
+		goto err_pci_dev_put;
 
 	/* Get num of IP blocks within the SoC */
 	amd_pmc_get_ip_info(dev);


