Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C28931C07DF;
	Tue, 15 Oct 2024 13:13:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997998; cv=none; b=rsyhZkPpCKALc4N1nEPYpY/bStkV16Ngfgy+MVptD9fNndTtAN3XVJM48s0+zY16jr5FvpFGGEhcOm1NPQbWVVQvAnxcqNMeYG3ikRKWYgqreT684MSEGSfNsTgiUzfscfHoDWlw+UFJVdX5isgqpB6cH7wDUVEI0Jqnn6VhA0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997998; c=relaxed/simple;
	bh=Z+U5PRzM0iuLdYsdOjfjqFoZpls7R7N5loLHxL83wwk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jOoBSbDAc4zhb37P547qvblWmSBk4JO3Zgq0/mqB7BXIPQs0cEIyr38fZUMMUVtTJIctB4TEREI6f+emlqbq5z0LQg9XWgzsCnqmLVEI2LKuXiz210D5Ha5r98N0fYumY3xj9DUI/YKj+8Jk4wpjwbTisWgYzB9EOc36pZcwK70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T/UiWGSg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T/UiWGSg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAB7EC4CEC6;
	Tue, 15 Oct 2024 13:13:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997998;
	bh=Z+U5PRzM0iuLdYsdOjfjqFoZpls7R7N5loLHxL83wwk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T/UiWGSgBThnb4I2MbobgnosSEXZ7hzRUx5ZTv+VOg7Cwt6+7N7r9L+Vi+GzGcPRX
	 XUppyYxKCef4zqlD7BU5idBoVOKIrebY5UoViJOudjrvn2HAUOuZaFDRfL6hFjWiaL
	 tIzao+V24do0C5EynODOc13l4isH4zN1rZmbH/EI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 350/518] of/irq: Refer to actual buffer size in of_irq_parse_one()
Date: Tue, 15 Oct 2024 14:44:14 +0200
Message-ID: <20241015123930.478062964@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 39ab331ab5d377a18fbf5a0e0b228205edfcc7f4 ]

Replace two open-coded calculations of the buffer size by invocations of
sizeof() on the buffer itself, to make sure the code will always use the
actual buffer size.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/r/817c0b9626fd30790fc488c472a3398324cfcc0c.1724156125.git.geert+renesas@glider.be
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/of/irq.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/of/irq.c b/drivers/of/irq.c
index ad0cb49e233ac..70ac9cb3b2c67 100644
--- a/drivers/of/irq.c
+++ b/drivers/of/irq.c
@@ -301,8 +301,8 @@ int of_irq_parse_one(struct device_node *device, int index, struct of_phandle_ar
 	addr = of_get_property(device, "reg", &addr_len);
 
 	/* Prevent out-of-bounds read in case of longer interrupt parent address size */
-	if (addr_len > (3 * sizeof(__be32)))
-		addr_len = 3 * sizeof(__be32);
+	if (addr_len > sizeof(addr_buf))
+		addr_len = sizeof(addr_buf);
 	if (addr)
 		memcpy(addr_buf, addr, addr_len);
 
-- 
2.43.0



