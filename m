Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF98F389116;
	Tue, 10 Mar 2026 11:14:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141244; cv=none; b=JtF+UEgZ8eKK0uGIiPnrDAIDXilOfOSswPUBI+Cgu53GnU6FHwrglPRWU2K2breJ8+q8QzAgd7CMfyWS0GTtnt85UI29XWVc5GZtGI9osMxJ6E2aflyLaRija4eeYcBW3yjkiuHxYouaf6QFzjy9ls+YRddvFhlldFF0FgLEoLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141244; c=relaxed/simple;
	bh=XNYEi+e57d56d3JlK3+55IH74EMwywpbD1g7e4tciaI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P54WBvKm9ziJ3VNmOMlnNAGuqed5jhPbu92qPBswj3jHjvTwoRhTkHTgb7SrwvOZVWTBIrJNuwENErZ5rOlmpmNYoDTqFX89nAa8I/sBki0ZHQlIYoXoRchSjcFg9Eyibm2ID9Xw/uoAeMO1o/4oT0KKeDHCvavwlz7e9yz6dYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aJ+VAp+r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aJ+VAp+r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BE6DC19423;
	Tue, 10 Mar 2026 11:14:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141243;
	bh=XNYEi+e57d56d3JlK3+55IH74EMwywpbD1g7e4tciaI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aJ+VAp+rnC5TzoDw6ct2qbMWQASswoKYLJL6sJiy371VJp9W3p3DW7p60ASsx6dss
	 q5yBCmY0lhobnpvbYAts7X6oHaDmsHHlZBheR3H8ddcidX9PNr+OeXJLKn7C8R+VJX
	 Wmjxkxgu21MGtpSrOQnWWzbkH0fO4Djq+5DJwrHoRpz/Usxmymj3I+PUef/TyvIq4N
	 okucRGygxpv2GIaQo94602gscb80g2ksTffgtU6P21W4XGPhPpwgrJtaBysMH671lJ
	 wJJDdXGLCgbx+idU0fE3gd+rhlsrSZ5koQn9ZMHyMSIDoTg4NyVcRzWbv+30XQphot
	 RZ6qYSLsH1LkA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 246/311] ASoC: SDCA: Add allocation failure check for Entity name
Date: Tue, 10 Mar 2026 07:04:53 -0400
Message-ID: <f4afc90a80b864b46191c1172444932d0785c20a.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Charles Keepax <ckeepax@opensource.cirrus.com>

[ Upstream commit 27990181031fdcdbe0f7c46011f6404e5d116386 ]

Currently find_sdca_entity_iot() can allocate a string for the
Entity name but it doesn't check if that allocation succeeded.
Add the missing NULL check after the allocation.

Fixes: 48fa77af2f4a ("ASoC: SDCA: Add terminal type into input/output widget name")
Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/20260303141707.3841635-1-ckeepax@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sdca/sdca_functions.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/sound/soc/sdca/sdca_functions.c b/sound/soc/sdca/sdca_functions.c
index e86004c9dea03..d2de9e81b4f9f 100644
--- a/sound/soc/sdca/sdca_functions.c
+++ b/sound/soc/sdca/sdca_functions.c
@@ -1120,9 +1120,12 @@ static int find_sdca_entity_iot(struct device *dev,
 	if (!terminal->is_dataport) {
 		const char *type_name = sdca_find_terminal_name(terminal->type);
 
-		if (type_name)
+		if (type_name) {
 			entity->label = devm_kasprintf(dev, GFP_KERNEL, "%s %s",
 						       entity->label, type_name);
+			if (!entity->label)
+				return -ENOMEM;
+		}
 	}
 
 	ret = fwnode_property_read_u32(entity_node,
-- 
2.51.0

