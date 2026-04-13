Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F37423E342;
	Mon, 13 Apr 2026 16:46:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098784; cv=none; b=h5c1Wn7uLxYK0jzvJg7fNz8xoL5r+3LSlr//5a8BXpyHKxWFzef5I9VN0h0SvtbgaWsVNWd5XEUQkttZZrbXltCOPMddauDlA7H6EcO2A2n9mjDJVI/Gxx/aeClKUjXqp7iyA1Uf93PvDrIELCilzushNwi+mOn8SxF/ekNF3eQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098784; c=relaxed/simple;
	bh=Hv0b8slT6w0AXsEDnDJ3NDkR3S69w52lbx05KmZnmAs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fon1cfQ27ke5evolZfsn2d7afotP6KAjhYNDMSBnT5q6oHqIYdOx0rA9tgjKLkbv6eiYRasUMuLtfIP9w3vj8lkqD/c0e8TXMS1qmE2Igi/uHllZZzCPhtP8TOE4/y++xJeZ+Cq1f3anLz4m6WOLuYf94Lex1xqWqoVgF1WrDe0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VxXlPLJm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VxXlPLJm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2C79C2BCAF;
	Mon, 13 Apr 2026 16:46:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098784;
	bh=Hv0b8slT6w0AXsEDnDJ3NDkR3S69w52lbx05KmZnmAs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VxXlPLJmcwbyPopZVsNxCaSaKuWhf3gPRZCY181SjDX15X7XdFXZlRALA0LIg1Nud
	 CrKw3vdC9mBf0zdIRjAhlqNNHZth7LUHazqQe/862qh4/YR7WZMkP+0h/JD6B9Bfux
	 BAUMbUC1w7x3DR4e3b6kY5yaw9ooh3E2AJj+lCsk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Casey Connolly <casey.connolly@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 088/491] ASoC: detect empty DMI strings
Date: Mon, 13 Apr 2026 17:55:33 +0200
Message-ID: <20260413155822.339595298@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 7ecbea296e917..8ceffa6851bd0 100644
--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -1675,12 +1675,15 @@ static void cleanup_dmi_name(char *name)
 
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



