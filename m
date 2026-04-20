Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1195333DEDF;
	Mon, 20 Apr 2026 16:09:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776701389; cv=none; b=j0jemTlhHprx01fOJHxHykfEi+OyZKWGDDlQeBPDtN0XOVP5RsoXf0Ohx08w+diHlv63/bcTTAo1qxCEbJN7AhZQBQDKFZil1GDOtWURfiR2nrnbt4xDxkopnVLbAn/yqs3aKfn0Bzm9f84twuQQc74hEHN5TZJSWd+7aHoiBso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776701389; c=relaxed/simple;
	bh=oRXOs3IIbjhrywYayWehoctM/jNF9Nt3lszGoC9its4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MDpODQzv5ECS+BRdxuRm/ox1FunIB1nhsLOv8xGkV5NJKRS+ZYPJ+22yayIaj7DAVlMwIJ0+RGOCT28dqAHp9VPo2+OEB7zfPBn1OTcJS+loXypoFQtOvukN9UQV0a02vfP9OxONrYw6Six4jfhzuIfUrB2OFlRRi6fC0wviEvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mzQIwHQ3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mzQIwHQ3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61ADFC19425;
	Mon, 20 Apr 2026 16:09:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776701388;
	bh=oRXOs3IIbjhrywYayWehoctM/jNF9Nt3lszGoC9its4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mzQIwHQ3TGy6Ofqj7Bnt8igsl9pg6uNpiTKvSaJTbfsNktaOfUHf0lebbU4PnNmj8
	 Yd4q2e1ji2mx9vpNV7ibojdHnY1jcSgwM2oesBW8yb34cJZFbcwRzIFHDblv+Xhvep
	 vpZ3Jh+rmkIK3Mkf1Z+2Ut7M1xPkZcEwZvtoNX/w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	stable <stable@kernel.org>
Subject: [PATCH 6.12 095/162] i2c: s3c24xx: check the size of the SMBUS message before using it
Date: Mon, 20 Apr 2026 17:42:07 +0200
Message-ID: <20260420153930.477130820@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153927.006696811@linuxfoundation.org>
References: <20260420153927.006696811@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit c0128c7157d639a931353ea344fb44aad6d6e17a upstream.

The first byte of an i2c SMBUS message is the size, and it should be
verified to ensure that it is in the range of 0..I2C_SMBUS_BLOCK_MAX
before processing it.

This is the same logic that was added in commit a6e04f05ce0b ("i2c:
tegra: check msg length in SMBUS block read") to the i2c tegra driver.

Cc: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Alim Akhtar <alim.akhtar@samsung.com>
Cc: Andi Shyti <andi.shyti@kernel.org>
Cc: stable <stable@kernel.org>
Assisted-by: gkh_clanker_2000
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://lore.kernel.org/r/2026022314-rely-scrubbed-4839@gregkh
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-s3c2410.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/i2c/busses/i2c-s3c2410.c
+++ b/drivers/i2c/busses/i2c-s3c2410.c
@@ -504,8 +504,13 @@ static void i2c_s3c_irq_nextbyte(struct
 		i2c->msg->buf[i2c->msg_ptr++] = byte;
 
 		/* Add actual length to read for smbus block read */
-		if (i2c->msg->flags & I2C_M_RECV_LEN && i2c->msg->len == 1)
+		if (i2c->msg->flags & I2C_M_RECV_LEN && i2c->msg->len == 1) {
+			if (byte == 0 || byte > I2C_SMBUS_BLOCK_MAX) {
+				s3c24xx_i2c_stop(i2c, -EPROTO);
+				break;
+			}
 			i2c->msg->len += byte;
+		}
  prepare_read:
 		if (is_msglast(i2c)) {
 			/* last byte of buffer */


