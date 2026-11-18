Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055996;
	b=wOJx8twW1vxST18Vmnm/v9Y0MLklTuLHo8oGk8lp+aa9N8NCOemVwfDWPl+ru0o5xQX8
	 qlsRbLBDA1Ltw+k5EBRIdQR/h/m2AQxLaY+Ue5fhtn9TK6x3YL+FFY5oMd4uUoRM1X/y5
	 sqLN/P00Pns4mwJ9W0NVReahpGmOIqDd/0PO0nJNXR9pyEjp2tHvSHoczlfqgmdjpf9yF
	 6tw/4DjeKU0bomz0G16fgnVwH0bWtfQfbLUyNFUqiJEgKTi9jGAQrLLZ/t/ax2YAz7o8n
	 cHJiqjB2NiwbYTBfApfRXl+xRmRE0aFfelreYtRWYSarxVp9hzDjLeUbxCKRc+rcdQA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055996;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FS4GpBe5fxfcQyyvQ2XkNlF0IWu0Xlo2bT9R9620xd0=;
	b=h3hGpkLJxmy1RKFYRmvV+EXhHptMm04WQ5R3sLDKbYGCbFrnhmcdlxAkU4MTeQwAdLpt
	 /rA0vE4YagaiJ9eX1eYfbKsDr+CIVa45QFULWvhFhNj/nThlnDAXEdpVGZNkebdb4x3TH
	 O1/KRW7mS82GxQ/99tWNNIAFGyjhTd9l60hNFHEn8SatAhi95soVVT52SnN4QojPIX5Du
	 jLIbvIiyg5B1hwseaNr4MT2emhJFNVlposLyYKbXVKqDRHvDTn40B8OCAJ3o2w9aLCRWL
	 lpv5nO1aHu9KSZKWzUItfcIy8/8OAvAcYZ2glxYYElmpplFN3naMkn0Jcerdq2j9AiQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L1+459pO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13EDC606A335;
	Thu, 19 Nov 2026 02:39:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L1+459pO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D4EF1F000C9;
	Thu, 19 Nov 2026 02:39:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055995;
	bh=FS4GpBe5fxfcQyyvQ2XkNlF0IWu0Xlo2bT9R9620xd0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L1+459pOEYL6PaBtnCVIH0QvVyikQsjbnDjQtEA1OF/6I4ZnDOcA7tfMHopb4AysV
	 zFjZIcFdAxVJknwVERuRmj2QsbVt+IwZxqt3soEEWTM658jh+QZ+kmJQbjgtCKFBzi
	 cPZ7N8grM4Y8MMTuLYXfxxmKB0K+zuPatx+vmVow=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antoni Pokusinski <apokusinski01@gmail.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1831/2214] rtc: abx80x: fix error check after i2c_smbus_read in read_alarm()
Date: Wed, 18 Nov 2026 15:58:27 +0100
Message-ID: <20261118150124.683049422@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

From: Antoni Pokusinski <apokusinski01@gmail.com>

[ Upstream commit 07c57022afb3afc0d7c20efef45a4d3c7389b1c0 ]

i2c_smbus_read_i2c_block_data() returns the number of bytes read on
success and a negative error code on failure. The existing code treated
any non-zero return value as an error.

Fix the error handling by checking only for negative return values.

Fixes: 718a820a303c ("rtc: abx80x: add alarm support")
Signed-off-by: Antoni Pokusinski <apokusinski01@gmail.com>
Link: https://patch.msgid.link/20260916205138.16771-3-apokusinski01@gmail.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-abx80x.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/rtc/rtc-abx80x.c b/drivers/rtc/rtc-abx80x.c
index fa5f51d7f527a..6b3a47c6d0108 100644
--- a/drivers/rtc/rtc-abx80x.c
+++ b/drivers/rtc/rtc-abx80x.c
@@ -282,8 +282,10 @@ static int abx80x_read_alarm(struct device *dev, struct rtc_wkalrm *t)
 
 	err = i2c_smbus_read_i2c_block_data(client, ABX8XX_REG_ASC,
 					    sizeof(buf), buf);
-	if (err)
+	if (err < 0)
 		return err;
+	if (err < ARRAY_SIZE(buf))
+		return -EIO;
 
 	irq_mask = i2c_smbus_read_byte_data(client, ABX8XX_REG_IRQ);
 	if (irq_mask < 0)
@@ -299,7 +301,7 @@ static int abx80x_read_alarm(struct device *dev, struct rtc_wkalrm *t)
 	t->enabled = !!(irq_mask & ABX8XX_IRQ_AIE);
 	t->pending = (buf[6] & ABX8XX_STATUS_AF) && t->enabled;
 
-	return err;
+	return 0;
 }
 
 static int abx80x_set_alarm(struct device *dev, struct rtc_wkalrm *t)
-- 
2.53.0



