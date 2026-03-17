Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97D443F660E;
	Tue, 17 Mar 2026 17:10:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773767456; cv=none; b=P1gTJiW17G2wdQeN907ZXybrScprRNe4ycXNKvhaaYDROSor4LTFM36A3w85ABcf/JDvjoSF6lORQBc177P9hwGdKKDwaCEXvM0fZfkxcE2z8wzQCeZjmVx6fLYkX7be/Hns3ZJEi8It7tMzI6yPksxMsk7K6ue3cqzVWf8BkqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773767456; c=relaxed/simple;
	bh=DSzxplRrMGLbi1o5KQ6C2XQcupGT+QN++YtHFgxeJrw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gx+gxBSDswlqOO+cIrmuzB7bWwc18pn98+3yicVL0Dku8PUo9v7s2KBVBfuHfEZe2Od4f4oDQsOhhp7qjkRrNNNZG3Duw9kjxc8vQMmbRj1qzDSJWtqWxWbew7szyaiGXF20bQY6vKMXpSjL+Ioc1q8kqQUIK2cPnv2YLoGAZz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=df29afen; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="df29afen"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA911C4CEF7;
	Tue, 17 Mar 2026 17:10:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773767456;
	bh=DSzxplRrMGLbi1o5KQ6C2XQcupGT+QN++YtHFgxeJrw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=df29afenuEzvP7RABdhE7nwPZwnQwXXT9BcHhFzCXIGProuo2DAS3efzd7dFWZTdr
	 elEku5Gh+j0FeivJeiosPID9Y69EHah2hXSUvytSSSdgegSMkj69PVskXQtEUgq3hn
	 EbqFv/IlmmYrAB9tynYemUjDca2/JYt9KTastuoo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Casey Connolly <casey.connolly@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 090/333] ASoC: detect empty DMI strings
Date: Tue, 17 Mar 2026 17:31:59 +0100
Message-ID: <20260317163002.709015844@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317162959.345812316@linuxfoundation.org>
References: <20260317162959.345812316@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Casey Connolly <casey.connolly@linaro.org>

[ Upstream commit a9683730e8b1d632674f81844ed03ddfbe4821c0 ]

Some bootloaders like recent versions of U-Boot may install some DMI
properties with empty values rather than not populate them. This manages
to make its way through the validator and cleanup resulting in a rogue
hyphen being appended to the card longname.

Fixes: 4e01e5dbba96 ("ASoC: improve the DMI long card code in asoc-core")
Signed-off-by: Casey Connolly <casey.connolly@linaro.org>
Link: https://patch.msgid.link/20260306174707.283071-2-casey.connolly@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/soc-core.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/sound/soc/soc-core.c b/sound/soc/soc-core.c
index 013437f845e06..7a6b4ec3a6990 100644
--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -1860,12 +1860,15 @@ static void cleanup_dmi_name(char *name)
 
 /*
  * Check if a DMI field is valid, i.e. not containing any string
- * in the black list.
+ * in the black list and not the empty string.
  */
 static int is_dmi_valid(const char *field)
 {
 	int i = 0;
 
+	if (!field[0])
+		return 0;
+
 	while (dmi_blacklist[i]) {
 		if (strstr(field, dmi_blacklist[i]))
 			return 0;
-- 
2.51.0



