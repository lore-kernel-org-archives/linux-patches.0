Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 058DE24E4C3;
	Mon, 23 Jun 2025 13:35:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685719; cv=none; b=J+oI+x0yUsejK0uplzcQATpD87QBED6sU/oo9XdpLmeUoQ1GFw/sqnmMk5cZkrBDxKourFNx/2mDqhzBJ/6jjz5QZJ4N6nVruTQ7RVhvQJCsIY8yKeKuv1t+JjleBd4pkByZ3K5BbfV4zKG/Hcrf3fFQ59LumGFSalXg5tx4dtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685719; c=relaxed/simple;
	bh=JOBy1GFYpd8IiIi3Zl4w3sJQCSh5ek1bgdaJB/Ug+6o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EYa6Z0atoTjJWWmr9qLSOlVRDX6gY2kHv7YFqtFjAW0PkMTdCkA4+IBkDekPNg41HtdwP8DAxfpn9cWbdgWg8GA1PYLwGctf3LrmunN1zcqwdnOoEDYfBgyDtywvUHjvAvVcEUM5PlGfcbcBTTW+mC5qX2CuHdbktZeOdTMnJ/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ik1r0QYm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ik1r0QYm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DA09C4CEEA;
	Mon, 23 Jun 2025 13:35:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685718;
	bh=JOBy1GFYpd8IiIi3Zl4w3sJQCSh5ek1bgdaJB/Ug+6o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ik1r0QYmza6YBM7vbfg5eLuHgNPGrtyJGZa/No/VJC0cLbMTE70YXnh5aF88Q0hWT
	 BIqY32HR6e5Dgwvzqo3ClKiKg6VWz1Evlo2o0Pi1HSAy9y62A8vwjUEgFXFv211SmX
	 YsRYTLSV1YLMJD4XgP5jQN2DkluYbpNZ9k/pf9Dg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henry Martin <bsdhenrymartin@gmail.com>,
	Dave Stevenson <dave.stevenson@raspberrypi.com>,
	Stefan Wahren <wahrenst@gmx.net>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 054/411] clk: bcm: rpi: Add NULL check in raspberrypi_clk_register()
Date: Mon, 23 Jun 2025 15:03:18 +0200
Message-ID: <20250623130634.616718727@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Henry Martin <bsdhenrymartin@gmail.com>

[ Upstream commit 73c46d9a93d071ca69858dea3f569111b03e549e ]

devm_kasprintf() returns NULL when memory allocation fails. Currently,
raspberrypi_clk_register() does not check for this case, which results
in a NULL pointer dereference.

Add NULL check after devm_kasprintf() to prevent this issue.

Fixes: 93d2725affd6 ("clk: bcm: rpi: Discover the firmware clocks")
Signed-off-by: Henry Martin <bsdhenrymartin@gmail.com>
Reviewed-by: Dave Stevenson <dave.stevenson@raspberrypi.com>
Link: https://lore.kernel.org/r/20250402020513.42628-1-bsdhenrymartin@gmail.com
Reviewed-by: Stefan Wahren <wahrenst@gmx.net>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/bcm/clk-raspberrypi.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/clk/bcm/clk-raspberrypi.c b/drivers/clk/bcm/clk-raspberrypi.c
index 56c5166f841ae..280fd7a5ac75d 100644
--- a/drivers/clk/bcm/clk-raspberrypi.c
+++ b/drivers/clk/bcm/clk-raspberrypi.c
@@ -199,6 +199,8 @@ static struct clk_hw *raspberrypi_clk_register(struct raspberrypi_clk *rpi,
 	init.name = devm_kasprintf(rpi->dev, GFP_KERNEL,
 				   "fw-clk-%s",
 				   rpi_firmware_clk_names[id]);
+	if (!init.name)
+		return ERR_PTR(-ENOMEM);
 	init.ops = &raspberrypi_firmware_clk_ops;
 	init.flags = CLK_GET_RATE_NOCACHE;
 
-- 
2.39.5



