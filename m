Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063424;
	b=qtFZTdtKr2ogLBwAxkT0C4WN9JBP9IfcN1RI25lBdWj98gMseYaqCrSfN617M2QDOiv2
	 guVojUjUj6ppKZ6YkDs1ge9T6QOF7rdfcaAWmQNYbFaXsJ1c7CDY4Yl99ARYzZS5Xtqp+
	 D4rvhjw1pgVDs5uyPWjpnUQrTlWqygQcK7YVwehb45iF5fN3P/lfYO6py2tfhUOVWiyYw
	 HbhbMPNTBvH1MCrPwxIrg6i+QQVwlhr8ga1GVbMaioEnAqipq9ufIPZb3OS22rTicWBk+
	 /BrVFfY+OAbXFRIrANbsBuiZge5A/njoY6rRgYICKJG2KtuG5Yiv76whXNs10MX319g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063424;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2uBkqtHQ7qhMKUskQSEwyfZfJcik9NTD/AGNEc6FDME=;
	b=njJK3Lu6fEPuPBjuqJHnSOkI8mRQOEjE9YHNSAW/k9NCJy9Uj4Um1Q8b8ync1mY8W8g1
	 pE7BgcgpbocSlfNOCxxTwiJ54Pwm5bN0u16+JJMVpDCHziBtv6jNMfbvoasyOOasI2EB0
	 AXMzJnLrDmQQ1KnrwkxcTEWL/VAvn0nBdpPM5QMtTIV7Sg5jMkOzYNf2cThRLW8GYJFr0
	 ZIcY0NZJqI8T7V8vhRNQSf/EfN6JACm4kTbvzcTI28RsnsBOFLSEOCh6OsqwU5YZfQqx+
	 6FcH9aU+z8xY3YH4VI4m2A4DLizllmLfaXbTjsYu2wamZEn+MBFtHoBLa4QiiynZHUw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="fyMN/2BR";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2190A606EE83;
	Sat,  7 Nov 2026 14:57:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fyMN/2BR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C41B71F0089F;
	Sat,  7 Nov 2026 14:57:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063424;
	bh=2uBkqtHQ7qhMKUskQSEwyfZfJcik9NTD/AGNEc6FDME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fyMN/2BRbyHK6CJhS24RcqHxKwRR0HxsdGxts6HTJdRLYuZUik28sMjoslttNp7yt
	 /BsbX6RZMYX9E8+q/4dLUq+f/eIO2QU/JYj5m4zzJe1gDSY175H7dn72nW4Ls+/Qwp
	 PSrNvWfEEstH9bKVySY4GGGjUpiqRUD6tQ3WVIFA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Radiy Zhambakiev <r.zhambakiev@prosoftsystems.ru>,
	Andreas Kemnade <andreas@kemnade.info>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 589/869] mfd: tps65217: Fix NULL pointer dereference on IRQ init failure
Date: Sat,  7 Nov 2026 08:54:31 -0500
Message-ID: <20261107134913.101403092@linuxfoundation.org>
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

From: Radiy Zhambakiev <r.zhambakiev@prosoftsystems.ru>

[ Upstream commit 0473a5b0663663b75573bf284beb77459e07c461 ]

tps65217_probe() ignores the return value of tps65217_irq_init(), so
when the irq domain creation fails the probe still completes and the
driver ends up bound with a NULL tps->irq_domain. Unloading the
module then makes tps65217_remove() call irq_domain_remove() on the
NULL pointer and oops the kernel. On top of that, irq_find_mapping()
may fall back to the default irq domain and dispose of mappings that
belong to other interrupt controllers.

Check the return value and abort the probe on failure so the error
is reported and no inconsistent state is left for removal.

Fixes: 6556bdacf646fcaa ("mfd: tps65217: Add support for IRQs")
Cc: stable@vger.kernel.org
Signed-off-by: Radiy Zhambakiev <r.zhambakiev@prosoftsystems.ru>
Reviewed-by: Andreas Kemnade <andreas@kemnade.info>
Link: https://patch.msgid.link/20261002113624.178588-2-r.zhambakiev@prosoftsystems.ru
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/tps65217.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/mfd/tps65217.c b/drivers/mfd/tps65217.c
index c240fac0ede76..2d04d9e0ae29c 100644
--- a/drivers/mfd/tps65217.c
+++ b/drivers/mfd/tps65217.c
@@ -333,7 +333,9 @@ static int tps65217_probe(struct i2c_client *client)
 	}
 
 	if (client->irq) {
-		tps65217_irq_init(tps, client->irq);
+		ret = tps65217_irq_init(tps, client->irq);
+		if (ret)
+			return ret;
 	} else {
 		int i;
 
-- 
2.53.0



