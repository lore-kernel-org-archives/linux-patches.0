Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B13E43803EF;
	Mon, 23 Mar 2026 14:14:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774275273; cv=none; b=D7dlPkrjnX+EZHObWs1Ip1MazoFMVxwNYu8Jlj5GTFz42jo5u7jY3L0bZgihep5+c9tDbV9vBRaOYwa8Yz1Lk2N4y+x/lUfCFGT1crsk5i/KMRqlabSxt+1zn5vxV9I2CKVH+Vh9gXYfWZOvIhUm/pYsCyiBVmhCIwg05obnfMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774275273; c=relaxed/simple;
	bh=qGX1j3n3FlUB+dm1XWkV3bRk+jBlaPZhNXOgrAVuA4A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GgdyzFRaJL1MzWrafxAFH5GNEXvveJUmfYxoT/LAgAwYDJX3smSVdIAbeS16tGHoINhX+E1enxlrw10uDOVUM9YNPWF97a/rDaGPCtUwaI4FaeO0ti3Hl4eQyXlmf9BWPddF8RIT0YygxHHstYDAKbCoLDdkLyYuso0j2WuzsEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bnbAnHoi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bnbAnHoi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F626C4CEF7;
	Mon, 23 Mar 2026 14:14:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774275273;
	bh=qGX1j3n3FlUB+dm1XWkV3bRk+jBlaPZhNXOgrAVuA4A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bnbAnHoi8/DSLQWLvnIWqqKXpyvVsLDhl3gZGuRAxdYc9xb00rgWJBF8jQWB3i1Mf
	 jpgN4zpQ9rojiY25Gwaw5KfFBKwWaZ++HByAhqODiBp+wyZAM8enlrd7I8A6Sv5mR/
	 1TdsRk9UwDgzWdmaQSAdwodYUP7CPUH0WKp+GkY0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 010/460] ASoC: cs42l43: Report insert for exotic peripherals
Date: Mon, 23 Mar 2026 14:40:06 +0100
Message-ID: <20260323134526.913207394@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index aa0062f3aa918..3a61f222d85fe 100644
--- a/sound/soc/codecs/cs42l43-jack.c
+++ b/sound/soc/codecs/cs42l43-jack.c
@@ -711,6 +711,7 @@ static int cs42l43_run_type_detect(struct cs42l43_codec *priv)
 	switch (type & CS42L43_HSDET_TYPE_STS_MASK) {
 	case 0x0: // CTIA
 	case 0x1: // OMTP
+	case 0x4:
 		return cs42l43_run_load_detect(priv, true);
 	case 0x2: // 3-pole
 		return cs42l43_run_load_detect(priv, false);
-- 
2.51.0



