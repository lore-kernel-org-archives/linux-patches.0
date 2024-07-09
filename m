Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9107955E4C;
	Tue,  9 Jul 2024 11:32:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720524741; cv=none; b=M0/qsvtlWR57YQiTkeZIrWQEMls/2+17M28qvlXp+2pxgHbv1p14Y5tNdmLWFu5Cqg6wFVEtZ8CsqhaVOKIKYV5NUZQQ9ZAiQ7AatWKAlDpSWPHUSHxeYuGXQwlKDBzolKAISvMUMsEbFKoiRcrZndzQc4hmmBqi9CMTcCmETII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720524741; c=relaxed/simple;
	bh=Dp/PosKa0kceIGBlKkkbNa1Ia3ZRceLfyPfc+UArsQo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KPeUBaCNZ8XoK/tRehIURr0o1nUvmrsH+3bVGp9EH6imsxIEsU1HdGweyvM/YMhKbWE6urjzbpVKiwNuKZzB03TvvaAdsCOIX0ZTXOEFMQFeSEeXbrVeNwMk7HmtlvsJvOhap078/ruCTOkAQIRkVAZFmWKuXkamDZ4MCgfAYbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lel4jKjg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lel4jKjg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B42AC3277B;
	Tue,  9 Jul 2024 11:32:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720524741;
	bh=Dp/PosKa0kceIGBlKkkbNa1Ia3ZRceLfyPfc+UArsQo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lel4jKjg2ieWLpuVPVS+q7cCfvoJdJxM+84E7OOT1NVF1AwgnJW/tuS7frdLk+/8X
	 m5xFRrRP5SiHPFGtyJKgmlC6yzjKQ0TNlJdykCUWMloeK/qmXhRjY22IHvOYNrU2R8
	 vFvd5ouVMVnY3129PMOS4FdL/NX6vy5KDbizw3FA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 6.1 084/102] media: dw2102: fix a potential buffer overflow
Date: Tue,  9 Jul 2024 13:10:47 +0200
Message-ID: <20240709110654.643054325@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110651.353707001@linuxfoundation.org>
References: <20240709110651.353707001@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Mauro Carvalho Chehab <mchehab@kernel.org>

commit 1c73d0b29d04bf4082e7beb6a508895e118ee30d upstream.

As pointed by smatch:
	 drivers/media/usb/dvb-usb/dw2102.c:802 su3000_i2c_transfer() error: __builtin_memcpy() '&state->data[4]' too small (64 vs 67)

That seemss to be due to a wrong copy-and-paste.

Fixes: 0e148a522b84 ("media: dw2102: Don't translate i2c read into write")

Reported-by: Hans Verkuil <hverkuil@xs4all.nl>
Reviewed-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/usb/dvb-usb/dw2102.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/usb/dvb-usb/dw2102.c
+++ b/drivers/media/usb/dvb-usb/dw2102.c
@@ -786,7 +786,7 @@ static int su3000_i2c_transfer(struct i2
 
 			if (msg[j].flags & I2C_M_RD) {
 				/* single read */
-				if (1 + msg[j].len > sizeof(state->data)) {
+				if (4 + msg[j].len > sizeof(state->data)) {
 					warn("i2c rd: len=%d is too big!\n", msg[j].len);
 					num = -EOPNOTSUPP;
 					break;


