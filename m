Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A3673D75B1;
	Fri, 24 Apr 2026 13:36:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777037788; cv=none; b=nC/5NtKpCKdJ/Sqce79tTM8gihN3c80xSfBICmzQtjCoiKKkLt6fReQdTGQF3+lAIKqY3yoGL8/Vr129sH6LBEwEqmYYH2uGnfEo8OtOAspliKZtTwwdDUmSOIzhFnTI0w9NIYPsWkgXd50G6PWwCIHqyWqNokt46uh86otrxr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777037788; c=relaxed/simple;
	bh=KPzyEJ3rrxiuI0VLS+JOE3Z338H8ztlvSvLFZXi2JMU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G5mGKBKzqX741qNhR173SFIKlJu6xhnGxxfqLZCYnu3CbxigQ4s2FJvBQzQv/kgeIsfJVe0clvP96sKukhFHjb3tTm9owqhVsCbOt078ssnotf+rr3gdCMjw1IvQC7YBZBecssgpQIcIA9kEUblVwkPR4DcshSvIuvEEd102I1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dXDvJlq6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dXDvJlq6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8477CC19425;
	Fri, 24 Apr 2026 13:36:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777037787;
	bh=KPzyEJ3rrxiuI0VLS+JOE3Z338H8ztlvSvLFZXi2JMU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dXDvJlq6DIxKHgCrgqM1tyNhBmeGEPtGMddzkZtWM/n1oppgtl6KLBUrkg1RWhSO2
	 73LLJgBIJPaTiqY34aJ+2rVwf3dBryKku+KxhozReLyArBAXGLG7A726LlqiEGoyPT
	 XTGgpxrWMlrB/lC2al6eYuuRPbBQGxD7z+AxInjA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	stable <stable@kernel.org>
Subject: [PATCH 6.6 069/166] i2c: s3c24xx: check the size of the SMBUS message before using it
Date: Fri, 24 Apr 2026 15:29:43 +0200
Message-ID: <20260424132547.236261064@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260424132532.812258529@linuxfoundation.org>
References: <20260424132532.812258529@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -504,8 +504,13 @@ static int i2c_s3c_irq_nextbyte(struct s
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


