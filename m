Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063525;
	b=33218pHMAwpthlIaB9dwLiovbTjFrrlNrfKY5hKaiAllCAQERjzrK6D6U9/D5tHkLPS9
	 klV+Fpe+MkPv3dyKd/hl/Ds/WaL3DoWjHEpdanp9OevQ+r0m+o0Do0R7hFyX005bjx6il
	 aMlrSdfrDDgpJSa4NJtAn++IEP9Z/Mvs7fLgwsLN1pfkkBhjugTL5BkPaVhNRFISP9kFl
	 PUYO64Fzoq0yAH+SdpQg94vQOj5Q9at5RbNQe8E1tFYZYmkU0xXce4hkMKDfrEAx2p6uo
	 o6E33wCoFJ9HOP0mkUwfZDBOXk79QqdTnvq5+jzxNXoDJvEOtgc67t4eIb3ltPwbNxg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063525;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HlkAsMUR7J3xLy/QrnkyP7n8GglE2EVH/kvmsYS+p0A=;
	b=hW+iKUEHiCaw1Sa7F1YsGPHpsD83QjuVqLLCFQDe3hx8y+6Q9xQmaBgdzPMyyUvfV5gR
	 nziztJN8VJmi3GBsoOCBNsVMTVUYWXzJaDOOkJUNjISr+govJok0fAOKPsjaf4RAz5v8s
	 V8Y5eCk9aLiHD4kmaq+5vQFGkt5NvzdCVFHEkA/8UrdN1t6kJpwodpRJ9wGlpS3c39A1Q
	 uCfY1yMFIP/BNfCtMvnYXYs5JcUmGpdiAQyRP/g12S1tVyF9FQFNPpVYtmOpj4VVH1rUT
	 6+3ojZ79JU1Lp/x5Fe4ti7EerolOUI7FHp9DGlgpNWOjEu8NyocRHcoiukrmH3qnV2Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bj9lqrJp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A49D9606EE83;
	Sat,  7 Nov 2026 14:58:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bj9lqrJp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50E981F0089F;
	Sat,  7 Nov 2026 14:58:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063525;
	bh=HlkAsMUR7J3xLy/QrnkyP7n8GglE2EVH/kvmsYS+p0A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bj9lqrJp7fYfbshfQsm52IFc8wsVQAuzi9FnvLwvjdHQHbRxd2bEcXQJ5elHwtVcX
	 r5ZyIv++hzkESotBjWzvNHDleCxBgrjCLsW3rfht246Z2+SCLGRW0b7XEJ5g+tRf+W
	 29cd9HougG/QtCQfhTMgdUuFEkQ7szX9e5Z2D0QA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Baek Kyu, Kim" <pocj8ur4in@gmail.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 665/869] gpiolib: Free chip resources when allocating the label fails
Date: Sat,  7 Nov 2026 08:55:47 -0500
Message-ID: <20261107134915.691612095@linuxfoundation.org>
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

From: Baek Kyu, Kim <pocj8ur4in@gmail.com>

[ Upstream commit 8381e1f15e27087fcb6f07046a526ac8b9b9b2b9 ]

If desc_set_label() fails after the chip's request callback succeeds,
gpiod_request_commit() clears GPIOD_FLAG_REQUESTED without calling the
free callback. The caller receives an error and has no GPIO to release,
leaving resources acquired by the request callback held.

Call the chip's free callback, if present, before clearing the requested
bit on label allocation failure. Leave request callback errors on the
existing path to avoid freeing a failed request.

Cc: stable@vger.kernel.org
Fixes: 1f2bcb8c8ccd ("gpio: protect the descriptor label with SRCU")
Signed-off-by: Baek Kyu, Kim <pocj8ur4in@gmail.com>
Link: https://patch.msgid.link/20261018044456.1259250-1-pocj8ur4in@gmail.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpiolib.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index d0efcb96d2769..635b77c0eab53 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -2464,10 +2464,13 @@ static int gpiod_request_commit(struct gpio_desc *desc, const char *label)
 
 	ret = desc_set_label(desc, label ? : "?");
 	if (ret)
-		goto out_clear_bit;
+		goto out_free_gpio;
 
 	return 0;
 
+out_free_gpio:
+	if (guard.gc->free)
+		guard.gc->free(guard.gc, offset);
 out_clear_bit:
 	clear_bit(GPIOD_FLAG_REQUESTED, &desc->flags);
 	return ret;
-- 
2.53.0



