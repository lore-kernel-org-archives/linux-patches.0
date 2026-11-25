Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623196;
	b=E/VvpQoPGuVABE79zJ4HewcGbiRTWHmvYwvStAYg20zYTz+gXC1cSIbwan+OFodzavUz
	 Vd/xDrPlJx4LJyfybHRK/DlBdhRslZTyF4ONIdD7ApUb9JrLvcRSVxf2qfINTyd1/JIoo
	 F91FyC1K2qa1hm810j2OWYvdw62MOMbSI8MK2PQGdueosaP0SDnFhu00VqJTvrfYmMrfc
	 wdr3vzmnvbVO5pKfJtBzyVStHpzwlVG9PEQhUk9QqmL47/uJPY/hpgtU2Sg69luoF8aeR
	 MGIVzgSJvq8zQGZKMcjtI5QEmvMrl2rHovK+hDmYTT3PXlby6oskqVqwJpROPr1ZcOA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623196;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hquNXv14uotkvI2FceV6lu5xj3aZ2Xd81hFlnOnh0x4=;
	b=cV3RttqPeDTd7QmWVS0xCrTnO57FOgL64fQCNYp/wypwE3swjfR1cEBRNfTFTyzfhB+b
	 Mzwg00uOcbD028fsRgbUAe+/v+DRT4okx+9XAMoNpKxazxoXft23rgwXzeWYtsrVdMPDr
	 RocgWfyAUY2sBbqtg0q7QsbavRuR9U1M6c3fX+loM8yscvs4Zhw4HPpT6NGgeE/7OKlcr
	 qeld4Qty8c/+4LrgtFvFMa1U1iBL1vaQrj8FThg/4JAMP0faJUAnwtn5/T9sLgJ0M5SWu
	 fkQnyVY/denknJt5KEmRWeUN8Lyfgz1kWS4K1DIm798YrtxZq8wg7Z20Od7PS4RT5ug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mgrir0Nz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4935F606A31E;
	Wed, 25 Nov 2026 16:13:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mgrir0Nz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12FAF1F000C4;
	Wed, 25 Nov 2026 16:13:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623195;
	bh=hquNXv14uotkvI2FceV6lu5xj3aZ2Xd81hFlnOnh0x4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mgrir0Nzx1ZXlKnA2efZtIXU+UaAkWl6nRY4/IyeekO0TgPkY909/B/5by9wOkz/9
	 rhl1ff0F5WLfXaY2twLoqhEx9wk809D9nuf/mLezInno6MHnF04qYRSFtR0G86D/MK
	 a1SYjKcLnS6cWnSthZZAcKKpHFIMeY+AnZ2v8yYg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Mazzini <pmazzini@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.18 779/990] hwmon: (sy7636a) fix negative temperatures
Date: Wed, 25 Nov 2026 15:35:46 +0100
Message-ID: <20261125143840.297416859@linuxfoundation.org>
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

From: Pablo Mazzini <pmazzini@gmail.com>

commit fc8519fab34e162b0c29dacccf73031820878917 upstream.

The thermistor readout is a signed 8-bit value in degrees Celsius.

Fixes: de34a4053250 ("hwmon: sy7636a: Add temperature driver for sy7636a")
Cc: stable@vger.kernel.org
Signed-off-by: Pablo Mazzini <pmazzini@gmail.com>
Link: https://patch.msgid.link/20261108093602.329554-3-pmazzini@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwmon/sy7636a-hwmon.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hwmon/sy7636a-hwmon.c
+++ b/drivers/hwmon/sy7636a-hwmon.c
@@ -29,7 +29,7 @@ static int sy7636a_read(struct device *d
 	if (ret)
 		return ret;
 
-	*temp = reg_val * 1000;
+	*temp = (s8)reg_val * 1000;
 
 	return 0;
 }


