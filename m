Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793827213;
	b=bwqlmdzUECjGkKutaeIwcF7vXi9dInLLYJP71XxfVD42ZyHhfEYq8z2eJKSBr2Hw8Zyw
	 dCywoekxELiOMd6Jkx2l+kBkL326nmVDtCV1j7Oe8Ys8XA1d630YbiznetZaAPPS+ZzZz
	 eUb3Lju1bJOXiuSbirTeqdsC/UbJHzu+Z0PipUnMHR9IL1dye4bPph/9VFaAr6m7Anp7Q
	 ZTn8B4ZlhjvENTCdDVG9TOr7aK2gGRreN8rQNbBic14zAyG5OYRwZbdDq7aV6qc3nUjiw
	 nk/ye6C82OAZS+lfX0aGiWLVQAEoDhbaUZPNiRV6Fzu5+KwYF63vv6bLB7RjWA892fg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793827213;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2eqlUlaf1ZvZZnhYb1z9PWaTglAJQzvtRSGVmdkpUGo=;
	b=3l+Cs6Q0x1XFVyWLwFQdH6b/z1RCK5jQudT67CtN7z/7UHyWQtGZl0QoK9tRnWMKYfRZ
	 wQ4FcyhFoJjxW8nFclCuPDEAOTDfnogJPWLQjs9X/crC6ndQebPnXymhiRiNhYKztsv1g
	 nk9FpRJxwvKavdZ9P3q1woQn6khorjbXgBti+RUt/TPOOde5ZHYSExnBmtGT9JdMyNiPM
	 Jm8oJVIQ1Rw5lcJNBu2DUpIOQrzO1gj+2mEFWDKnWIWJ8rGGQAQpAqFXhy+YDJb1qwG/+
	 9dtkcZ15pzqXe3OIlSaeQf86OZl5OpXuVCVcoWD7MnBOTakbMrVGahctLVjmp0OVRVA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=142FVKC2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C284F608C9A1;
	Wed,  4 Nov 2026 21:20:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=142FVKC2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BF671F000C1;
	Wed,  4 Nov 2026 21:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793827212;
	bh=2eqlUlaf1ZvZZnhYb1z9PWaTglAJQzvtRSGVmdkpUGo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=142FVKC2g6jL1qzyEECjXGJN+MNEhOpII7n9ZD5TjwO7DKedaOWGtrfws0y1wZGjw
	 5YhO1tM7uQzHmLr5luyEAe5yfD1LBGiZcsZFQFIuCDIlBFCOuBisO83E+1BYhhfLts
	 ANs5krqQaNsSIxplKune2hVD78xxDjGZXctmxIYw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Sinyavin <sinyavin@gmail.com>,
	Janne Grunau <j@jannau.net>,
	Srinivas Kandagatla <srini@kernel.org>
Subject: [PATCH 7.3 260/547] nvmem: core: Fix OOB read for bit offsets of more than one byte
Date: Wed,  4 Nov 2026 16:07:24 -0500
Message-ID: <20261104211045.575636078@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Janne Grunau <j@jannau.net>

commit 24530401e8001aaa637dd5007fcdc6fbc00300be upstream.

When the bit offset is BITS_PER_BYTE or larger the read position is
advanced by `bytes_offset`. This is not taken into account in the
per-byte read loop which still reads `cell->bytes` resulting in an out of
bounds read of `bytes_offset` bytes. The information read OOB does not
leak directly as the erroneously read bits are cleared.

Detected by KASAN while looking for a use-after-free in simplefb.c.

Cc: stable@vger.kernel.org
Fixes: 7a06ef751077 ("nvmem: core: fix bit offsets of more than one byte")
Tested-by: Dmitry Sinyavin <sinyavin@gmail.com>
Signed-off-by: Janne Grunau <j@jannau.net>
Signed-off-by: Srinivas Kandagatla <srini@kernel.org>
Link: https://patch.msgid.link/20261002101329.1084348-5-srini@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvmem/core.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/nvmem/core.c
+++ b/drivers/nvmem/core.c
@@ -1598,12 +1598,14 @@ static void nvmem_shift_read_buffer_in_p
 		*p = *b++ >> bit_offset;
 
 		/* setup rest of the bytes if any */
-		for (i = 1; i < cell->bytes; i++) {
+		for (i = 1; i < (cell->bytes - bytes_offset); i++) {
 			/* Get bits from next byte and shift them towards msb */
 			*p++ |= *b << (BITS_PER_BYTE - bit_offset);
 
 			*p = *b++ >> bit_offset;
 		}
+		/* point to end of the buffer unused bits will be cleared */
+		p = buf + cell->bytes - 1;
 	} else if (p != b) {
 		memmove(p, b, cell->bytes - bytes_offset);
 		p += cell->bytes - 1;


