Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EEC1377A8C;
	Fri,  7 Aug 2026 15:02:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114932; cv=none; b=cSqZw0Q3nUBvaCY8waCmEP2e7AijS44+M5RCwxiL0T/nkfXm9KynU7s/6ywzPf1jDiYi9gDcpq/jif1iNrRiOMQ7PeFnHhK2vilqzDW8USuBuW7w3u4FQoWzbeWYWpnkc1aRlj2Gasq0jMoHdu0p3DRFQT/rqp1cfgh2P/C/OrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114932; c=relaxed/simple;
	bh=mWhk6VHDvPTzW3dK8JJYo4karLelXl5WOsCvV2vWud8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=km91qKm65SqR9PnrqUlsvSJfrr4O1W/LaWG+FTZz0f5H3pXxx+/uXqn7tHUHMOPMNaxox4k+CgZaEcLoS2NaoAPkgJ4BZoS7iDD/gR8i3QAe+mlw7gi0Mm4lsWDeM/qh3S0H0Hb+wZv5gtFobnZF6QT45GK7tsINHWVzNaSE2Qc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jHGlwe3O; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jHGlwe3O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3C8E1F000E9;
	Fri,  7 Aug 2026 15:02:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114931;
	bh=iAFdo9kRudx4ppwZopDKJ2jQKDQ29GgE35UmXboIYFM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jHGlwe3OK4BBsHb55pdq7DjF3MQGboKEgQz6a8lRkQP5YCdcjK3QIkrNfmuGhlGgB
	 m0rOazmDrhl9qTroGd/q2qupktdhGRn3h16Ir2Og8tP/TNDiLm+rbKfUNrCe3SGz2n
	 bTjP2texJ2igYNeA23epKplPOcHIQEiD7fm+NF/4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.dev>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 053/396] ASoC: SDCA: Ensure that Control Range is large enough for header
Date: Fri,  7 Aug 2026 16:33:33 +0200
Message-ID: <20260807143425.411326409@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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

[ Upstream commit 951e921b039b793bef7050eaf5c5fb1a4a5341d1 ]

When reading the Ranges structure from an SDCA Control, ensure that the
read data is large enough to encompass the required header before
accessing it.

Fixes: 64fb5af1d1bb ("ASoC: SDCA: Add parsing for Control range structures")
Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.dev>
Link: https://patch.msgid.link/20260722103500.872714-5-ckeepax@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sdca/sdca_functions.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/soc/sdca/sdca_functions.c b/sound/soc/sdca/sdca_functions.c
index 4417278e39bb1..e0cae47641ba5 100644
--- a/sound/soc/sdca/sdca_functions.c
+++ b/sound/soc/sdca/sdca_functions.c
@@ -849,6 +849,8 @@ static int find_sdca_control_range(struct device *dev,
 		return 0;
 	else if (num_range < 0)
 		return num_range;
+	else if (num_range < 2 * sizeof(*limits))
+		return -EINVAL;
 
 	range_list = devm_kcalloc(dev, num_range, sizeof(*range_list), GFP_KERNEL);
 	if (!range_list)
-- 
2.53.0



