Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 564CA2FE056;
	Mon, 13 Apr 2026 16:24:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097497; cv=none; b=Q0o4fo7h4pbmoujYlTqgITTO2GHJ9izoP8tXklcn1596VKvuMGwCSn9AeWqPSsnk5u8i3vRA0dKHqo4HbsvudNtXhosH4uOPbsziTohLV8apJlmC5sry2V3XNJpEssLrzTJhDGqeygqJP3BfHnIwW8/bz3j4GmDqMmQGWOvBDqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097497; c=relaxed/simple;
	bh=byshTumN3VAZty13dbfoa9Skz8S/JIz40EFjizIhz1o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mdwx7tNarAientOPlq4iALGECQ++GZcCsrRsbW0A8+l50CGze1u3yJMn3lGUxMyCvBH1MmovQ0xLY0y1dBJxAPxJLxkrbnjLviBAl0mHP0xP5pb7/AijmIHY8j0+d5l+vN9/X6T0ctlMCAM/UGJ5texRM24ovskJjatakq0UHiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XgckuaFy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XgckuaFy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9DDEC2BCAF;
	Mon, 13 Apr 2026 16:24:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097497;
	bh=byshTumN3VAZty13dbfoa9Skz8S/JIz40EFjizIhz1o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XgckuaFyZykfa7FrvYjCcdQudgt+idgZfbtt4ef3tSsjCncAPiMWFrIiwCGAeIZ3e
	 bwZMQXk1610jb9/HBEQZ4atKsYeN4Ldcf3My6Y7FtP7LOPy4alfPqv0q3Pni/fqR7k
	 O4gJRREN6AXr+XqqC9Fodq7GymaPxX0wTJDdyVNE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Casey Connolly <casey.connolly@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 126/570] ASoC: detect empty DMI strings
Date: Mon, 13 Apr 2026 17:54:17 +0200
Message-ID: <20260413155835.163178470@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index e406c896a511a..af8554e96035f 100644
--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -1665,12 +1665,15 @@ static void cleanup_dmi_name(char *name)
 
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



