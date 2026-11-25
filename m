Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623341;
	b=qrl9OBNhqaiJRb61leSXaMDshH3DoaYdzKTH1MOzEI5xlanvmumrQguNkJ8w0DpJm3WM
	 4DzxSM+IaHNNzxt89ROqaqzsQgsoNsELe2qIIs6B1N9dX/n3Y7ieTNkcmArb3+veIR708
	 j8DIP7XzYvZL/hTA6DfbUSxkFh0vejt2SQAbgVTbZmxHEFcD9xmKXZDUWMo4qsFsVbrOB
	 6hIOqTryIgn0KZzy3JZu9w6/9N21BtOfoSqlqIhcA8elUu1OwnFsnEQl1V+/qFQBLF4vi
	 f9d8St5jyJ320bZpvIUgixBraSTShIhmA//Tlky5OXP7yWM2TVNcuqbriPj51WkS22w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623341;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3+8wo7dQlqYBLR/tx0saDq5I3eQpV/ibTs0P7tFJXic=;
	b=zOQYmt6W/5rEvj4vQC17xwuBs9cZo+q79CBgsyLCB13lChh4WrK5YTYa0zhuG+TYZdfA
	 cyvJkoxltvTry/bsxr9WwnlOTmbCOpB/jcNKUGmX998AM21JJm/asC+PL4BkyQwvJt9a7
	 stf4koRHUEzIzwUYol7Mnu8g7EmxEJ2TvRmpZs8rYzUnTvl33eL4stJnuTHY7Z1nXsfRu
	 O5JDHDRN36kvfcC3fQR/sfrkD0mvhC9VDsYcOSR8TzrUpnprJo++6YVXpLUmpNMGOFhsp
	 TJth5aD78y0YDvd7OsiZGPoavaYQXraKtJCVKTMvwntNA6VmPg4ymEh/+IoL9B4s+tg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CWuWK5aA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8148606A321;
	Wed, 25 Nov 2026 16:15:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CWuWK5aA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12FDE1F000D0;
	Wed, 25 Nov 2026 16:15:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623341;
	bh=3+8wo7dQlqYBLR/tx0saDq5I3eQpV/ibTs0P7tFJXic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CWuWK5aAM8Dk+NRDFzaH56g3tRFJuvWQwGo5QJCCGd5f3nEEkcH+VnxHgq4a0oiV8
	 pC443fr0YUmYfo1kfQC2ng7iLr7J6yprXYMbiq4gsw5mFDFbTOYzXcA5VgM7Z9hR9Y
	 dijxizuFBrsVOV9NCCkksaY0FsimybkBwuyVtK/c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Billy Tsai <billy_tsai@aspeedtech.com>,
	Andrew Jeffery <andrew@codeconstruct.com.au>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Subject: [PATCH 6.18 825/990] gpio: aspeed: Preserve the pending G7 interrupt status on control writes
Date: Wed, 25 Nov 2026 15:36:32 +0100
Message-ID: <20261125143841.361180156@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

From: Billy Tsai <billy_tsai@aspeedtech.com>

commit 18cc1d1ad94df8a6760fff2617d3d6923550cba0 upstream.

On G7 each line has its own control register, and its interrupt status
bit (bit 12) is write-1-to-clear. aspeed_g7_reg_bit_set() updates a
field by reading the control register, replacing that field and writing
the value back. When the line's interrupt is pending, the status bit
reads as 1 and is written back as 1, so updating an unrelated field
such as the interrupt enable, trigger type, direction or debounce
selection also clears the pending interrupt.

Mask out the status bit when composing the value to write, so it is
written as 1 only when the status field itself is being set to ack the
interrupt.

Fixes: b2e861bd1eaf ("gpio: aspeed: Support G7 Aspeed gpio controller")
Cc: stable@vger.kernel.org
Signed-off-by: Billy Tsai <billy_tsai@aspeedtech.com>
Reviewed-by: Andrew Jeffery <andrew@codeconstruct.com.au>
Link: https://patch.msgid.link/20261104-gpio-aspeed-irq-status-v1-2-9805645f856d@aspeedtech.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpio-aspeed.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/gpio/gpio-aspeed.c
+++ b/drivers/gpio/gpio-aspeed.c
@@ -1172,7 +1172,13 @@ static void aspeed_g7_reg_bit_set(struct
 	u32 write_val;
 
 	if (mask) {
-		write_val = (ioread32(addr) & ~(mask)) | field_prep(mask, val);
+		/*
+		 * The interrupt status bit is write-1-to-clear. Keep it zero
+		 * unless it is the field being written, so that updating any
+		 * other field leaves a pending interrupt latched.
+		 */
+		write_val = ioread32(addr) & ~(mask | GPIO_G7_CTRL_IRQ_STS);
+		write_val |= field_prep(mask, val);
 		iowrite32(write_val, addr);
 	}
 }


