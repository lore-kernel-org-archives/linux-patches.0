Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C35513C1406;
	Mon, 23 Mar 2026 16:17:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774282644; cv=none; b=nQ7C7vBGZYKfTSihgZ7vsfaOyCN5fzIc1C0eEFqVlko2NxslkPBEuVk1grlyZuiHDkcEd9mpNDtvQB45ETpAIQaEEYBONuT+iwLjUy1GJKlk913bLYkReddbpaqUjaUL+EXNYBA94H9HKQvt2OSN5SI0t9hWUHJOFHi9QOX0qP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774282644; c=relaxed/simple;
	bh=8wEYV7JCyx0NTWCAx0AWLMatTG+rB1oXssybI5bvXc0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=igUbikIDrtejfS3/wjgYyU6ZNg8kU0IWI3caeTSxjVkibcRFcFWUkNME0z3aXT+wfCTWBLHXuOJYWD02S5tDflMOorhDKP9wh8lyIEEKFl4dAXBpybXOKHDNj35vyLE3eSxeHx5WGiMmmtTNUtIFO7+EEutMbZsQKw2yMtf5Wck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=omhzLnRy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="omhzLnRy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0BC6C4CEF7;
	Mon, 23 Mar 2026 16:17:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774282644;
	bh=8wEYV7JCyx0NTWCAx0AWLMatTG+rB1oXssybI5bvXc0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=omhzLnRyL/mB9pmVTdoL+MKVUiwIj9WuMvIQsZFVl2BiZ9+sz6P6s9shtJ2MjdC9o
	 rnuHB9quV5te8R2xCqNGig6MTbMOiNPFMc6sfKmQ498LtUaM9tyyDtYOzPSGIeNybo
	 EKxHUIt39kSvHYCJ3BWLxMVqGe7NRChHgRG0mgIc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Casey Connolly <casey.connolly@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 190/481] ASoC: detect empty DMI strings
Date: Mon, 23 Mar 2026 14:42:52 +0100
Message-ID: <20260323134529.827825674@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index c673453e8a747..dfd58d9db7c1f 100644
--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -1628,12 +1628,15 @@ static void cleanup_dmi_name(char *name)
 
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



