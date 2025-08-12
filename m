Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E98CA2FE598;
	Tue, 12 Aug 2025 18:57:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025072; cv=none; b=lB4WuKss81+Kx72hp39Z3KccuFlwdUJt8rs9oHvYxrQnEX+Z7H6r1NOkrBE5S6Sng2yUmQ1MHchjcB3ofMp9RLcAaly1mSoB7ESb6BIZD1dryQMoFKI9GsA4XYS4V8QoGmMydUm0d+11w9sNfJItVaRat2JwTdmx6D+efQ5I19o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025072; c=relaxed/simple;
	bh=xEIiGCFV9/Np2b6FYhlNU7Poyh9fBM3uNRBnfRa6yCM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=niTF6LlDnCMuxSyE3K1MWuI6omMu2WCZhJXviCZ5m7FQzb9wke7SJ9aw00fPCjgopzhFY73BmwghC74RLwyUVwozaI4uLd+0SUdpc1S/WUZcFMP19zV/RwBa9YqIBFqwsBQDDR0iSooeMwDzZvjIhrlN62KSraAui4Yw0aJkYyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T84t0iKx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T84t0iKx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 198DEC4CEF0;
	Tue, 12 Aug 2025 18:57:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025071;
	bh=xEIiGCFV9/Np2b6FYhlNU7Poyh9fBM3uNRBnfRa6yCM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T84t0iKxH1deBVI7dKjrzUQfnXRu1n41LUcF/zJilqfK9j2zw+bhFcHpPLNmJ39MR
	 XUA0kXCmGxXWQKtsDHN4CcV4A+QQaaVNvx9SRDugaeC6zjE1L3SuaStHN/+DvfDg01
	 m1r1+JL3YwvGyEyuQ+L1l25tZ8uqnx2mUfPpuTtI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Trimmer <simont@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 528/627] spi: cs42l43: Property entry should be a null-terminated array
Date: Tue, 12 Aug 2025 19:33:43 +0200
Message-ID: <20250812173451.991573535@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index b28a840b3b04..14307dd800b7 100644
--- a/drivers/spi/spi-cs42l43.c
+++ b/drivers/spi/spi-cs42l43.c
@@ -295,7 +295,7 @@ static struct spi_board_info *cs42l43_create_bridge_amp(struct cs42l43_spi *priv
 	struct spi_board_info *info;
 
 	if (spkid >= 0) {
-		props = devm_kmalloc(priv->dev, sizeof(*props), GFP_KERNEL);
+		props = devm_kcalloc(priv->dev, 2, sizeof(*props), GFP_KERNEL);
 		if (!props)
 			return NULL;
 
-- 
2.39.5



