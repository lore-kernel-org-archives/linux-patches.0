Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FD23221F00;
	Mon, 22 Sep 2025 19:46:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758570377; cv=none; b=CfknKo0CfAD187LY0KjQdeLctRYmElz0SHcAWuVUtUCJuNZHp9lN8XEZwdIbsDN4udhQsWu6TI8HuF6mV11ZOIADgbDBOYdN2w19cbFXoFn+l6XeDMiDqr2eVzDTEi53MPGGmytv1sFDH2bdV6GaMJJaP0/a+y0oWWReRVpYUD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758570377; c=relaxed/simple;
	bh=zWRwZfZAShoVoqbvZYwGWjdg5MzNGYOoQa5pjaHWmvE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SRhqGqJCI6yjWWdaWlwRg9W58VaEikXf518+Eo1Kppo40pBUbhedjdgtr81a2NN0pDErJ+TtCpEUlzYehO1fBWyRCiYeY7Bmnb9qwFQWjScGiNdFGDkmtvhnOsoKAssAxMEDk0/UWu5SJkbSC9TUhPI97hXlDXq+AnxK1uWs0gM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ts33+vkA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ts33+vkA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5334C4CEF0;
	Mon, 22 Sep 2025 19:46:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758570377;
	bh=zWRwZfZAShoVoqbvZYwGWjdg5MzNGYOoQa5pjaHWmvE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ts33+vkAa6sj+Eyj5fnFOZeKU9/Q4+7185j5v14winWG/ynASQNUCg8KPcWQGtwRF
	 eCC1jU8HeG4A3VrQheqAbQsFNm9NR3jV4znmsaK77E8TacOUfY9nNbkw2dMxR3sEkY
	 V3jahmLDPz/8qeYenGSuRVVMvqDdgtC8t70oZKso=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 113/149] ASoC: SDCA: Fix return value in sdca_regmap_mbq_size()
Date: Mon, 22 Sep 2025 21:30:13 +0200
Message-ID: <20250922192415.725755780@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192412.885919229@linuxfoundation.org>
References: <20250922192412.885919229@linuxfoundation.org>
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

From: Charles Keepax <ckeepax@opensource.cirrus.com>

[ Upstream commit f81e63047600d023cbfda372b6de8f2821ff6839 ]

The MBQ size function returns an integer representing the size of a
Control. Currently if the Control is not found the function will return
false which makes little sense. Correct this typo to return -EINVAL.

Fixes: e3f7caf74b79 ("ASoC: SDCA: Add generic regmap SDCA helpers")
Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Message-ID: <20250820163717.1095846-2-ckeepax@opensource.cirrus.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sdca/sdca_regmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/sdca/sdca_regmap.c b/sound/soc/sdca/sdca_regmap.c
index c41c67c2204a4..ff1f8fe2a39bb 100644
--- a/sound/soc/sdca/sdca_regmap.c
+++ b/sound/soc/sdca/sdca_regmap.c
@@ -196,7 +196,7 @@ int sdca_regmap_mbq_size(struct sdca_function_data *function, unsigned int reg)
 
 	control = function_find_control(function, reg);
 	if (!control)
-		return false;
+		return -EINVAL;
 
 	return clamp_val(control->nbits / BITS_PER_BYTE, sizeof(u8), sizeof(u32));
 }
-- 
2.51.0



