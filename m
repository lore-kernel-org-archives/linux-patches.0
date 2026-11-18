Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031369;
	b=r4EznYgRoZFdkX2axaPT3mkg6n6a5CQywoX0fO9Fi3XnlCBfhkserJt8xC98+gzZCGwG
	 7RNpPxFNedVraOoIZmm0804Z9zDXDkVlil8xRZ4BSPsOT5KnuJBXJfzHzFkEuj7CGS/ot
	 tjUG0Tfk45aNnqhJ61QV4YlHsqggJtPB1m15LbvKS88sF7kXxZUr6TJi+3e4cy9jJHnyn
	 3GJEn4MtzZbzwI+vO/lo4fwAsj+okkYRrWDIbi0+4xKxFXvGh36TMFo4owinbQzq8YuU+
	 lZ8Q4w0yg/StP5FVs6ZnmjZLnBora91O5Skkn+ILU4pi7l/Pw9QpOnMY8OOqkmqmCWg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031369;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SqLJaEx9Lzx2Up3wUJK1x4y6cmJ2tC1y0QwvXEsZMsc=;
	b=tUCJEVDHOdeI5oIzHSBaqOpFWJWC8sYF87OdbqUXcjYUYz+7pKzR2kLX+HHkb1d3FO3/
	 I2b19zVgoX4+vi0s6Tjpo09UPOYes9kVVSISmcIw9G5OCPoMdt5EhEXa9kbZedcj9qMBC
	 pJ89o3UYmaVbHJIf9LWEXPeiBa/AOOU/EklplEnlWLW+Ki7O2odWMzy3v3fHst8GbnMjD
	 hGjJVr3OL24PzhL+fpRRykQVxJsfh8zWG8DYIHQhUhkghkGX0NIs+tgshSgHAS3h3OScq
	 eaAbWzfjc1aVecdLgx4XDglNUzsGJYk8fDuoYDYFCeRCELRtDVJh7EYn4i/X12qBDBA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=T+Na8zl3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 203FC606A320;
	Wed, 18 Nov 2026 19:49:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=T+Na8zl3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 644FB1F000C4;
	Wed, 18 Nov 2026 19:49:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031368;
	bh=SqLJaEx9Lzx2Up3wUJK1x4y6cmJ2tC1y0QwvXEsZMsc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T+Na8zl3H7Im/P9NwxIhVem3HiOYYGJdr1MXoCrW+yfL4Es9sZSW5+30iE5TUU1D+
	 cIZ0SnByCZ7bqeZIKDeitUsMu1sqtxvubl8IQQZnuMV/IFDsvCP04Z0h5vZkQ/8K84
	 +WBZapYPAFeiXC1nkPD8/N+9MolpkEbNag4+qMZI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antoni Pokusinski <apokusinski01@gmail.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1034/1756] rtc: abx80x: fix error check after i2c_smbus_read in read_alarm()
Date: Wed, 18 Nov 2026 15:52:41 +0100
Message-ID: <20261118150051.232456069@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 862833519d7f4..ce0bcb03bfbdb 100644
--- a/drivers/rtc/rtc-abx80x.c
+++ b/drivers/rtc/rtc-abx80x.c
@@ -294,8 +294,10 @@ static int abx80x_read_alarm(struct device *dev, struct rtc_wkalrm *t)
 
 	err = i2c_smbus_read_i2c_block_data(client, ABX8XX_REG_ASC,
 					    sizeof(buf), buf);
-	if (err)
+	if (err < 0)
 		return err;
+	if (err < ARRAY_SIZE(buf))
+		return -EIO;
 
 	irq_mask = i2c_smbus_read_byte_data(client, ABX8XX_REG_IRQ);
 	if (irq_mask < 0)
@@ -311,7 +313,7 @@ static int abx80x_read_alarm(struct device *dev, struct rtc_wkalrm *t)
 	t->enabled = !!(irq_mask & ABX8XX_IRQ_AIE);
 	t->pending = (buf[6] & ABX8XX_STATUS_AF) && t->enabled;
 
-	return err;
+	return 0;
 }
 
 static int abx80x_set_alarm(struct device *dev, struct rtc_wkalrm *t)
-- 
2.53.0



