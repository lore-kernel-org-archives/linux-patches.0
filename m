Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C43E0151CFA;
	Tue, 20 Feb 2024 21:04:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463053; cv=none; b=B0KdNNL3gU0xC2Fe0z2EyD+zkCk0n4gNTKEtOgKEd5sdjONF+ySDvIFss5WJ+zgCzIZ3QxTbSANKbemYukoapgdrieEAG4iiFEINvR6GBYHih8+U6FAARh72ROX1wjR06yvwGyQh9yx21H+x/a/VoUM1qwwurW5UGMX7RFpGVlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463053; c=relaxed/simple;
	bh=z4zc6galllhQNm2h2EnUynrFIjGC//+yB+HnzQ+u4IA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fopc+CTnIEyhQQhM5FRgfcsUTsH3g2SRCzZYsVUWpvyiPFjL/EWvvtGzoJFiEIWAXXytDWksj5zTEOQ95My3rLxOtTFdq7k/janhqKhsVLB8C15vGWMUreKSgV+QOpgAIwqa+6OK0iPnMMhfzEvU8PGu8J1bJYekcrvVt7kG7G8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XRoPNUaD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XRoPNUaD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 336F6C433C7;
	Tue, 20 Feb 2024 21:04:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463053;
	bh=z4zc6galllhQNm2h2EnUynrFIjGC//+yB+HnzQ+u4IA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XRoPNUaDyXRRYM6L4OdBSFpQq2mtbAVpWL3EhShBoDjZWq29odhZdTcjC+cYAoCMU
	 A+nblvuUMLsALc+ZIgJLUB9Q+OSpOWfeadjzsI/qD9Mb8UlxF3YQebu/Ph1JLGPHr/
	 Okb8ho80v6IuzN62l4NBtZlwGYaLzA9V1ffhXvgI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hugo Villeneuve <hvilleneuve@dimonoff.com>
Subject: [PATCH 6.1 120/197] serial: max310x: set default value when reading clock ready bit
Date: Tue, 20 Feb 2024 21:51:19 +0100
Message-ID: <20240220204844.666396892@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220204841.073267068@linuxfoundation.org>
References: <20240220204841.073267068@linuxfoundation.org>
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

From: Hugo Villeneuve <hvilleneuve@dimonoff.com>

commit 0419373333c2f2024966d36261fd82a453281e80 upstream.

If regmap_read() returns a non-zero value, the 'val' variable can be left
uninitialized.

Clear it before calling regmap_read() to make sure we properly detect
the clock ready bit.

Fixes: 4cf9a888fd3c ("serial: max310x: Check the clock readiness")
Cc: stable@vger.kernel.org
Signed-off-by: Hugo Villeneuve <hvilleneuve@dimonoff.com>
Link: https://lore.kernel.org/r/20240116213001.3691629-2-hugo@hugovil.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/max310x.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/tty/serial/max310x.c
+++ b/drivers/tty/serial/max310x.c
@@ -641,7 +641,7 @@ static u32 max310x_set_ref_clk(struct de
 
 	/* Wait for crystal */
 	if (xtal) {
-		unsigned int val;
+		unsigned int val = 0;
 		msleep(10);
 		regmap_read(s->regmap, MAX310X_STS_IRQSTS_REG, &val);
 		if (!(val & MAX310X_STS_CLKREADY_BIT)) {


