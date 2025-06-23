Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4ADC221DAE;
	Mon, 23 Jun 2025 21:12:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713162; cv=none; b=eAEhiYjDNP0HZS/RgF/NyDyMfajB+bhrz6JYnhpCirVosuzkVvEumMBWfKU72wlFJC7RFg/hZ6/5meTXSX+UrGarhKPtSbDrrXICYlTMkzq9+XX4xn73dJRqE/vw68uTHlONrd/D3ZrxGvyCVEe6IdrVfWx9b8NS9HpP/ihv6Bg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713162; c=relaxed/simple;
	bh=+8c0WI741GyccjG+o0WrrtcZllVUWql/NXNaqrUIl70=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c9n5tx3W6gqqIiBFC+4DS2kAK1JzhdMmgOyS9E8GUsPwam0XM1oVIuKn2bzlnrI46zecChgWxfxoYCUlMV/Yu3JBJMuK2Nupy7ZV7jmqrVsttVKQyYUnk/lE8Fj2C3Ht9n0f2BQnQlzxDp3ctuvGxFG4aQpPg0TqomxGChyyM8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2qX6bfAz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2qX6bfAz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BC78C4CEEA;
	Mon, 23 Jun 2025 21:12:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713162;
	bh=+8c0WI741GyccjG+o0WrrtcZllVUWql/NXNaqrUIl70=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2qX6bfAzTWmC7kDfzMbaEv8YAupi3XjiF2nRswxzQ3bkJIvie+d1bXtwd2aeOWudM
	 +mboOFmx8L0sCVKM3gqTc90D3DYkF5m/iIsNIgrXfTrVzLgKuen7C0ZdZlnmAbgfId
	 GByoxF6FyxA0IxwTVx2SpsHEcGAvkI5PVhALk7OM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henry Martin <bsdhenrymartin@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 108/411] serial: Fix potential null-ptr-deref in mlb_usio_probe()
Date: Mon, 23 Jun 2025 15:04:12 +0200
Message-ID: <20250623130636.238595874@linuxfoundation.org>
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

[ Upstream commit 86bcae88c9209e334b2f8c252f4cc66beb261886 ]

devm_ioremap() can return NULL on error. Currently, mlb_usio_probe()
does not check for this case, which could result in a NULL pointer
dereference.

Add NULL check after devm_ioremap() to prevent this issue.

Fixes: ba44dc043004 ("serial: Add Milbeaut serial control")
Signed-off-by: Henry Martin <bsdhenrymartin@gmail.com>
Link: https://lore.kernel.org/r/20250403070339.64990-1-bsdhenrymartin@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/milbeaut_usio.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/serial/milbeaut_usio.c b/drivers/tty/serial/milbeaut_usio.c
index 8f2cab7f66ad3..d9f094514945b 100644
--- a/drivers/tty/serial/milbeaut_usio.c
+++ b/drivers/tty/serial/milbeaut_usio.c
@@ -523,7 +523,10 @@ static int mlb_usio_probe(struct platform_device *pdev)
 	}
 	port->membase = devm_ioremap(&pdev->dev, res->start,
 				resource_size(res));
-
+	if (!port->membase) {
+		ret = -ENOMEM;
+		goto failed;
+	}
 	ret = platform_get_irq_byname(pdev, "rx");
 	mlb_usio_irq[index][RX] = ret;
 
-- 
2.39.5



