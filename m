Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A52C27E05E;
	Sat, 30 May 2026 18:22:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780165326; cv=none; b=W5lQl6zfKFT6vegEVMkao7a8i5JywTiePXKPfqpGL0fU1EQ/o6epJHd0RVwhb60nMaZQjfgO0yWQSABTHM4bZisoknXJdV1Kx7Bt2j9m8V6JuFRXD+SjXpQbJZeayKaVJpVw7HOBPwmlZ/CsVgiJtVoDnkQMqrE/ORoboCcrjP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780165326; c=relaxed/simple;
	bh=n+i92UqDPbXzyP6xxRNiiNxCagtQ4kwLZU2cHpYmCJY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fULovijn492dQLFh8OYPuwWTGUjrJD80cfRmc70UGs5xhvYPH/ZH6lMhCxU2gScBPH9abL62quWkwEv3sBUJqUzGwWeYD4R+pJVPw+SxL+cc7Tg2ZWoDcfJWciKcIpvuh7O3CmuQNRBQ3U6eGF4wgIfjuXezwqCvqmUYbe9M3oE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YkNegVQb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YkNegVQb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42FF21F00893;
	Sat, 30 May 2026 18:22:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780165323;
	bh=E1tdAu42nLrFv/YsUBQZJvQW/eELRC4lKeY+0OHhQZc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YkNegVQbA1PVi28yQdf/glCv6poh0ldy/b9e1H3UhlxlAneQlBTaCLQWeIzvBFHHW
	 UuKkmd3wV3UoNvAsYJgaAIPCVCNYutweFfj8gdQwdoWSI1HH+0IrqUycWJdJhVy5+y
	 oiP0+4shGIGWRayBLNYwrRywlMsINO7LZRR4f1XQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	stable <stable@kernel.org>
Subject: [PATCH 5.10 045/589] i2c: s3c24xx: check the size of the SMBUS message before using it
Date: Sat, 30 May 2026 17:58:46 +0200
Message-ID: <20260530160225.775525167@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -511,8 +511,13 @@ static int i2c_s3c_irq_nextbyte(struct s
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


