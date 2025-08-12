Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C02C2192F4;
	Tue, 12 Aug 2025 18:21:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755022913; cv=none; b=PSLg+Q3Nh9EFNA6rKOystS7V6B+/ZipkZdZ0moXo7FE/E+CUY5cL/y/TaNQeoWjMTwsc+PKWp6cWmUjc8ZFCo45ryUXXHi5ig6QU9u0r7xV/oQTXPIBU+yewBaoKA2tMHwgnESPeppc9IGpizOBif5p/M4fHFVYdQIbrVjIHmhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755022913; c=relaxed/simple;
	bh=IHHdzhBwYco9x+4gZY59qLiI0/TEsZiQG9QPbD5kYXA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UAROy7BtO1Q6jC31NNITiNnHTGubAtfCKAekETyDn4qgg4ZI9oSH5LucJazSfDdXvBjY4VAqt9Xdbpfg5rg/1he9U65jTS1eb3gwkuI3xrHYNUGmZqn0JkjfV+hHPg7tEUdDX51wfVuqLNu7pJ3WeEL4/A5MT21sGdFE/canNlI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wz5WaDE1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wz5WaDE1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC38BC4CEF0;
	Tue, 12 Aug 2025 18:21:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755022913;
	bh=IHHdzhBwYco9x+4gZY59qLiI0/TEsZiQG9QPbD5kYXA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wz5WaDE1IxVxwZcIaXgV0a3PoOkeXILqu0OwK2WKbRPmclnaTX6luyJX39b8ewxp5
	 p4Usrh+N7TVLsBH7ET/rMncyUbOevQrIm0E0LXG9si0n81Dh9G4fQMLtQTaA7j+5RO
	 uqrQsBgJT5AahBv6GVmEggDW3fnYb8rP77UDGcz4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Trimmer <simont@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 297/369] spi: cs42l43: Property entry should be a null-terminated array
Date: Tue, 12 Aug 2025 19:29:54 +0200
Message-ID: <20250812173027.899868505@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Simon Trimmer <simont@opensource.cirrus.com>

[ Upstream commit ffcfd071eec7973e58c4ffff7da4cb0e9ca7b667 ]

The software node does not specify a count of property entries, so the
array must be null-terminated.

When unterminated, this can lead to a fault in the downstream cs35l56
amplifier driver, because the node parse walks off the end of the
array into unknown memory.

Fixes: 0ca645ab5b15 ("spi: cs42l43: Add speaker id support to the bridge configuration")
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=220371
Signed-off-by: Simon Trimmer <simont@opensource.cirrus.com>
Link: https://patch.msgid.link/20250731160109.1547131-1-simont@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-cs42l43.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/spi-cs42l43.c b/drivers/spi/spi-cs42l43.c
index 5b8ed65f8094..7a02fb42a88b 100644
--- a/drivers/spi/spi-cs42l43.c
+++ b/drivers/spi/spi-cs42l43.c
@@ -265,7 +265,7 @@ static struct spi_board_info *cs42l43_create_bridge_amp(struct cs42l43_spi *priv
 	struct spi_board_info *info;
 
 	if (spkid >= 0) {
-		props = devm_kmalloc(priv->dev, sizeof(*props), GFP_KERNEL);
+		props = devm_kcalloc(priv->dev, 2, sizeof(*props), GFP_KERNEL);
 		if (!props)
 			return NULL;
 
-- 
2.39.5



