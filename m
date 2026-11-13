Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585534;
	b=bU+newz0s7MJbM9LwH5krQ4ubhf0c2RVeskU7rMVzn9Gq+XomB9aG/gnvGbjdy740dgh
	 c6KmEcd0WPO1/IR8WA7cdhyU3+4CBG24eFZdRZve4GnZDq6xWGmkA1kT8NRatpBmZgT8D
	 uxNNkElt4TNzHxgDotaWmvKmXdlOwSxT+XM44+cLT86xp5KGrM/11dav6ap3+FUA9dyn/
	 pGvTedpIUVC3rSVLzl7Vm2yTT0tPY2Wy8DGBQNkP9q8dI/vfT85FD90kjPhUsqUwINbu7
	 EppKH5eB7DsCQUV+6KFuvZPAZ2PA98THCNV65wD0QNh5OykaxANpzhJzvnnKeXPHorQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585534;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8q7dA2k+Edvc/tIEhIGcWShIjcBLj6tzNx0M/aWb5ks=;
	b=e1HQ50i2JueUUjS/9CfL7PEHZJskgztCjYCl9vf/zh7GF0IT/rtquqPBv6+BotqSfsnR
	 UeT6hmcFJsSVrphMzRHhQUrDXIUnPfedPDNK0lNQZrxLV37EsoeiPHfJcO8h4e4UvEI6o
	 YyQAFBd7g5ZkvMI//fmFK70WusinUzILhGNxBVgYZlmD20u8G9xcrMx/lbN/fnoibs2A4
	 /VVqP+lawKI+GsNFVbEt6E4ySvHyqoMTZQtKX7r3ofJlrjb9FefzFsuPemhqUIbvQKifJ
	 MJwWj0cx5d3h8QEodX/SPniVnj1N2gZWwzd9CeYJSl9E2sW3QVu2soSnJXBsrYzqrhg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ca2O22yL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A319B606AE39;
	Fri, 13 Nov 2026 15:58:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ca2O22yL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FC7C1F000C6;
	Fri, 13 Nov 2026 15:58:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585534;
	bh=8q7dA2k+Edvc/tIEhIGcWShIjcBLj6tzNx0M/aWb5ks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ca2O22yLnswlC3GsYpdhxwH48uMngh6gQAR4vVWrOArQyXk41rkWHyD/tyRQCaj3c
	 y8SIUifjgHY5muRCyNtk3yKId7wf+a9oL9CRyeirFOot5sbsXwrP3h33yT7RBQQMfK
	 1DHDQ5C4GdGxoGfb5VqNOe86ij+CxrI6haSfqC+g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 174/507] hwmon: chipcap2: fix off-by-one in command mode retry loop
Date: Fri, 13 Nov 2026 10:47:58 -0500
Message-ID: <20261113153800.378129128@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Javier Carrasco <javier.carrasco.cruz@gmail.com>

[ Upstream commit 4c0e65a4ed665c416ccb1524c58a646a580e491f ]

i == CC2_CM_RETRIES can never be true inside the loop, since it
only runs while i < CC2_CM_RETRIES. Use CC2_CM_RETRIES - 1 so the
last failed retry breaks out immediately instead of doing a useless
disable + 80 ms power-cycle delay before the loop condition ends it
anyway.

Fixes: 3af350929e75 ("hwmon: Add support for Amphenol ChipCap 2")
Cc: stable@vger.kernel.org
Signed-off-by: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Link: https://patch.msgid.link/20261014-chipcap2_locks-v3-2-27ebfc2c5b9e@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/chipcap2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwmon/chipcap2.c b/drivers/hwmon/chipcap2.c
index 8550578928523..8102b6851d3d1 100644
--- a/drivers/hwmon/chipcap2.c
+++ b/drivers/hwmon/chipcap2.c
@@ -226,7 +226,7 @@ static int cc2_command_mode_start(struct cc2_data *data)
 				     2 * CC2_RESP_START_CM_US);
 		}
 		ret = cc2_read_command_status(data->client);
-		if (ret != -ETIMEDOUT || i == CC2_CM_RETRIES)
+		if (ret != -ETIMEDOUT || i == CC2_CM_RETRIES - 1)
 			break;
 
 		/* command window missed, prepare for a retry */
-- 
2.53.0



