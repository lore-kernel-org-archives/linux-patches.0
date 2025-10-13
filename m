Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1709430E0CE;
	Mon, 13 Oct 2025 14:57:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367437; cv=none; b=I7O0ti+NZzcZNx0pnFcM4QiTTF/UqwP35eg1TGBLRngiV0QHxUO4e7efdTF9m5eVxL+dhM66xhHlK5uJf2wWEA6nAWzjq5AP9TTQntlR8NKQWby+4cLIQ2uWPie7zJiOE8gRUsD0uKxxpjRTo7MbbFuTtNzivw3L8z39cQd/rHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367437; c=relaxed/simple;
	bh=KTGgZEAafyPgkshie/WXIpccFthq2NC5Aek0VLLdLH0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dRi7aF6j5OZYMruR1ebyEQ6Ykzoc0bk6qe0SpDrxjV/0noM1o7i6ta3SDJ1YSeD18+gSlDfzyDkUAtRPCGDlUZTV2SfnNJMU9qteUn2bmp5Qem6JlOT8yue0ZoLVdZhXQyOV59v90KtfX7vN8xT/0YUkc14Ab2GbIK8cB5oMcX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w0H2xPIA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w0H2xPIA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92AD2C4CEE7;
	Mon, 13 Oct 2025 14:57:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367437;
	bh=KTGgZEAafyPgkshie/WXIpccFthq2NC5Aek0VLLdLH0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w0H2xPIAV7E4y4a/o04WJpSZbkC2VctCrWvqMt5D2MsJ02MUgpoW0fQqfBv0DUTcT
	 lm5O+NjNwiLO0vNIbBP8v1j9tiHRf9rx2fTLPSsswyBQ1iiX6NUbqI3Xn4qxdokncw
	 wKUqHQGFFtu6FyMUHHZML16OZw5Oy+YMmzvTjT6M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 012/196] regmap: Remove superfluous check for !config in __regmap_init()
Date: Mon, 13 Oct 2025 16:43:23 +0200
Message-ID: <20251013144315.639690877@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144315.184275491@linuxfoundation.org>
References: <20251013144315.184275491@linuxfoundation.org>
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

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 5c36b86d2bf68fbcad16169983ef7ee8c537db59 ]

The first thing __regmap_init() do is check if config is non-NULL,
so there is no need to check for this again later.

Fixes: d77e745613680c54 ("regmap: Add bulk read/write callbacks into regmap_config")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://patch.msgid.link/a154d9db0f290dda96b48bd817eb743773e846e1.1755090330.git.geert+renesas@glider.be
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/regmap/regmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index 1209e01f8c7f9..9603c28a3ed82 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -827,7 +827,7 @@ struct regmap *__regmap_init(struct device *dev,
 		map->read_flag_mask = bus->read_flag_mask;
 	}
 
-	if (config && config->read && config->write) {
+	if (config->read && config->write) {
 		map->reg_read  = _regmap_bus_read;
 		if (config->reg_update_bits)
 			map->reg_update_bits = config->reg_update_bits;
-- 
2.51.0



