Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17CF7258EE0;
	Mon, 23 Mar 2026 15:04:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774278269; cv=none; b=WiTuMQaV74/TYGO8aav9bCAcNOWhEsybJ5PxiycleDlvqk9+ScM0HMqcMna+fvlGSndgAx8uRoY58dGFgXpV6B2aAvpjgeNb0hr0w8iHxxbFuHb7hIXQUraPXBg0s2kBGO2LCJhWWHDZGltJCo670bfEsPfpu5BZlIelnyTrdSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774278269; c=relaxed/simple;
	bh=Ua7LiQF35XUiOgiY4OwcY8t1AS9VbsSvAyZCz6UHzl0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pcM3EcwzXh9R/jyOBaCzRkk6wSUjNFTwLlhvMlE0oo1T6AI2MZb7oLrcUu1KQGXb77iMZHfqpvqQmqvut6+mcny2X16+so96FzFLRfl2LjxmeeJQtQsmbxMBQdbkg6KbKf/s6MFu/03TCJsaOC0ODjPIldRzDJocYQzJL2H98vo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kkZWMp74; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kkZWMp74"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 910C9C4CEF7;
	Mon, 23 Mar 2026 15:04:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774278269;
	bh=Ua7LiQF35XUiOgiY4OwcY8t1AS9VbsSvAyZCz6UHzl0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kkZWMp74OAX6qA/TU7165WNfUnHxO7uzNfCFVALlMjVl4142iwpB232GDmRJ8E8zc
	 RVBbfz7S6BoO0TqEtM7l3JhaIrybwX0rPWfmd17al1WQFQjfAthw6q3Jrdapr78Qzz
	 GCvGLny4uTNu38RKwzG3qD2WbtbcN44ki7/0ukTI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Casey Connolly <casey.connolly@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 254/567] ASoC: detect empty DMI strings
Date: Mon, 23 Mar 2026 14:42:54 +0100
Message-ID: <20260323134540.117586714@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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
index e2a4ff5414099..696f5501a27bc 100644
--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -1719,12 +1719,15 @@ static void cleanup_dmi_name(char *name)
 
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



