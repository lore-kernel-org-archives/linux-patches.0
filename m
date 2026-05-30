Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8816334104B;
	Sat, 30 May 2026 16:28:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780158502; cv=none; b=ciF3pAcqO6MKMFN9hC4LG2NluN8cCqzZX1DcHTHQ5RafXSFi+ARXJnhijSBMz1rUNS1o8C8uFF9X1tZGAcfTw9voOVGnu/RCAFf3M8NiFFu1szJbS8NcSxg3isHuXJt0hkl6ydy7bKS9udfPr1Zp5GMPdguycBOCiIxB/j02KWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780158502; c=relaxed/simple;
	bh=jHZ0CRLMF7Nug1I9/Ol7TpSTTMIB7dyY7O47UqpGSaE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gCoA/reP9llymi62+PE07x9WXQ/5/KEpf6ygaTUUkLnPzC6i1JQhAkehXroape9RP/pQmXp2BkMuWHZoaKMvxQ8Jzzfi8TrCjP7jMxlUk1D7r9JKFHVkwzx/BZen5OGuk+Weaj6VC2/rdcLZj1O2Dq2MMFq3BU+nV9fWMASqzAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MwRRWV6O; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MwRRWV6O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 849171F00893;
	Sat, 30 May 2026 16:28:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780158501;
	bh=GENNxE01bb7+vu1XcVebyk2YGpikP3pNkZr7yriQeLM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MwRRWV6OMxIdwPGUrU7yOTN7ND/ss6A9wKXcFcXQqTIQGHu+bjv/zTsg8olB+Nqcl
	 7/+sKJTHx8oz3G0qb04NKw6TqASlWA8cappNlGBB1UxUCPesBYZdzLVOiHKhlgfdgL
	 Bsi8QLV+O2thTkeCFewbwjxDTgJ2nWWAV7X4zfDo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	stable <stable@kernel.org>
Subject: [PATCH 6.1 058/969] i2c: s3c24xx: check the size of the SMBUS message before using it
Date: Sat, 30 May 2026 17:53:02 +0200
Message-ID: <20260530160301.990506665@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -508,8 +508,13 @@ static int i2c_s3c_irq_nextbyte(struct s
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


