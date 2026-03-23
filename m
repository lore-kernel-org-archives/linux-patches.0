Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70D0E38C41E;
	Mon, 23 Mar 2026 14:16:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774275383; cv=none; b=GBSssw9qxXkSw5eGQPiD4lW9Atw+hu4D91Ftr1AeZ/lwixzjz5xk9O1bqbAF76VyCcwvczRcKIEkeD0NdyRA1dclnKuAQYaWILcl5yC4DJsesyGBGmpM0b9WYJ7kgu63warlaoqkxej6QakAaPMjT5I42MTvIxbVpawWzSt2Ymo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774275383; c=relaxed/simple;
	bh=VDM7DQQh7Ci5V99dVqnDpFXGC9QgS5ZxMP7XJc5Wq6E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pRPIg8ojtADfuEzOH9x9vmXYVq35YxTJ2hMyHeDgT8yNOzSh+e98HhkCtqr7Ep6OxhzyFRkIUe6C//WYVIfwQpOlslCAM4Z9rFbfg2MQ0ybrTSyRW1YU/ZhT4yXEYBa80bR+LZ7ps/LJEJpFBC/4+j3SjieK8Dr5XOLWVs91Lyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VCm8/6Zo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VCm8/6Zo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CB88C4CEF7;
	Mon, 23 Mar 2026 14:16:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774275383;
	bh=VDM7DQQh7Ci5V99dVqnDpFXGC9QgS5ZxMP7XJc5Wq6E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VCm8/6ZoUEAt0H8phtejMdCFIQhsSeWNGU4Z/ykRwn5AbjRlTl6F3AraP9oh3Jy+Z
	 Km0AII96DQSoP6FFe8JAFYPaDYLnTMbF37Ee1oVA693OqL7KfLqTZ7udwPW4+iLFJY
	 Uk53xUuy/djqb7FY6hhUh2cYiN348znNTKB8Jhhw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Casey Connolly <casey.connolly@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 079/460] ASoC: detect empty DMI strings
Date: Mon, 23 Mar 2026 14:41:15 +0100
Message-ID: <20260323134528.623603579@linuxfoundation.org>
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
index ea6b39003461f..a1e3829914268 100644
--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -1837,12 +1837,15 @@ static void cleanup_dmi_name(char *name)
 
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



