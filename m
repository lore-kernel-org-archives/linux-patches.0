Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 073B1612D7;
	Tue, 20 Feb 2024 21:18:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463925; cv=none; b=VF1L+nMGxzmny71Kl7TvmKYIBKS+HdUXe28YYSBj8cJ0RyGruay0Y8GMxmr8T1VVAVeppgnt6gFdAY4wPCvIlflmLuW7rB/jz2qHUf0eyxCFPqrZMZIdwHe40oUd8bsX6Q04Qr9Zi0BvQpwWOJF2W3M4pyftMdJVDfg1yodpSfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463925; c=relaxed/simple;
	bh=hj7SjW58BUWknqXeMP8iuCidxQkrtumIc8izjLITRP8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fzLd8gO7tO84Io6JpRE1ojLnXEOa2SD0nmn5LD7z5CFTWuNRUtsRICaRDnHhyHVrAwl8RSMnS1MUICAA4egLhRK3fPjZ+MgZ9SOeNpLFXV68Q20qqrtVelSsnFDmuWEWvI6GqnAXiwATl5zIivD7gT+wE9NIlvmE6QadxRoU0zk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WxNKARsv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WxNKARsv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C435C43394;
	Tue, 20 Feb 2024 21:18:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463924;
	bh=hj7SjW58BUWknqXeMP8iuCidxQkrtumIc8izjLITRP8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WxNKARsvCCDPByXpT5vGK8DqmabHbqF7y8YH8SLjIbf2W3n6Sq5IHZA9Fvs736kcr
	 iB+A0zNyJm/2+0wyF6nSwBisbMAOF7fdEYHoYRMAhYQaVLwSGFuF8Wa6O10DzH4W14
	 QkD+vlsjLxwO7wv296c5vzDABy2Q9q0SkA99XNQs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hugo Villeneuve <hvilleneuve@dimonoff.com>
Subject: [PATCH 6.6 179/331] serial: max310x: set default value when reading clock ready bit
Date: Tue, 20 Feb 2024 21:54:55 +0100
Message-ID: <20240220205643.136516868@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


