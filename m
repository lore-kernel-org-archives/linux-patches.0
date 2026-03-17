Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 718343F54BD;
	Tue, 17 Mar 2026 17:04:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773767088; cv=none; b=AAzKgd+34iTYZu/dEBlztTxdz97Y6vO+J35bszyiSYlcoz/9kkCTOlXAzePL/b4bYI2uEndDnEALVm5DNtoZAeyvAZQ0k1LwP88HPf6uG8GzCvg4w5LxeYFOtfyqv6QCot/f7R5MkBFOQoQffpx7RekLBT8ZOQY9obuG5T+q1bI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773767088; c=relaxed/simple;
	bh=sON6Gbxs/EFijza0uB5Axli7zM3UFOYr64+ml4iworg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qY+ODqz6ThdHG/vetuVr6wfyBO1b5mzE3sQmOrLT5nNvcidAMq/PeUhOyHOkplt9bAuGm9vTL11WEXG+ibyGmT6TR98gpw+gUKSixIxc6QR+izy6j84NB97fJ+aeRVTrLYIzwzxPreofQn2KfahlPnU9xb7ec4dk5biHdcImy90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qCtJOQec; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qCtJOQec"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89D4AC4CEF7;
	Tue, 17 Mar 2026 17:04:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773767088;
	bh=sON6Gbxs/EFijza0uB5Axli7zM3UFOYr64+ml4iworg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qCtJOQecECa5ZBBl4BfKHvXlTx7r/g6BI60bhzrSWEn/WOTNJaNyTzT2lSpA3Jeou
	 agtCe1B2xF/rCA0lN5ps+E55EfYI0qML3MazMHlb3B7VQcXGzmEtV0JonGV9Dfkz/I
	 u5iZkkC7bpiDrPCogF51CkLSaT+AVpO5irA/lI3s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 012/333] ASoC: cs42l43: Report insert for exotic peripherals
Date: Tue, 17 Mar 2026 17:30:41 +0100
Message-ID: <20260317162959.814968116@linuxfoundation.org>
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

From: Charles Keepax <ckeepax@opensource.cirrus.com>

[ Upstream commit 6510e1324bcdc8caf21f6d17efe27604c48f0d64 ]

For some exotic peripherals the type detect can return a reserved value
of 0x4. This will currently return an error and not report anything to
user-space, update this to report the insert normally.

Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/20260223093616.3800350-1-ckeepax@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/cs42l43-jack.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/codecs/cs42l43-jack.c b/sound/soc/codecs/cs42l43-jack.c
index 744488f371ea4..ecba6c7952384 100644
--- a/sound/soc/codecs/cs42l43-jack.c
+++ b/sound/soc/codecs/cs42l43-jack.c
@@ -699,6 +699,7 @@ static int cs42l43_run_type_detect(struct cs42l43_codec *priv)
 	switch (type & CS42L43_HSDET_TYPE_STS_MASK) {
 	case 0x0: // CTIA
 	case 0x1: // OMTP
+	case 0x4:
 		return cs42l43_run_load_detect(priv, true);
 	case 0x2: // 3-pole
 		return cs42l43_run_load_detect(priv, false);
-- 
2.51.0



