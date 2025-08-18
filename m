Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9469B321F20;
	Mon, 18 Aug 2025 13:23:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523402; cv=none; b=Pio5KT3UPzNbpQ7H16wr8Ay5xy5IvMbOmY7V2X7TQzuj4HcmIjhqsw+586Cpn038jkHDWwnktuFrH3/WFmCC7tW5aEtU/TlwbfQuePhmPQZIc9eo/KqNJXxVsY9hr7J05i0c/L9XkBBrOaqplK0/Lh+P1TSRay9B5O2lPs54A9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523402; c=relaxed/simple;
	bh=el5m8y5mGmFYQO+MCZxIVeV1qFSeVQfC+scHDlPW6KA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=igEgX2rCQnKMFpfjbsgrWbwCM4858BtBpZylG0kZA/vY5so1nbcDMtm/hIqR2Zx8mocyM23j3o+2a9bjMkDOnbBuBTXxcPF6T9PaYjc8GbU+eYOqN3XROljt2IWUDZekKDFnj8sVR+LfHyxYQeM7ejEVN2HkRJWVnCA20nkwZ1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AVHiYqdp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AVHiYqdp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05521C4CEEB;
	Mon, 18 Aug 2025 13:23:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523402;
	bh=el5m8y5mGmFYQO+MCZxIVeV1qFSeVQfC+scHDlPW6KA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AVHiYqdp1kPAGRvagKE6nkGngwLFhDVEUcYnsy6bltNM0jrBR+2qP/ZvZh96EU1xm
	 mkvzfDz+FO74sTYCCwB9DwiDf21SGMrtZBTY4aiPLFUsbFwo/5li1NyeiGW2MpK6hl
	 vLVL/idocKY+IwoQAM9vDLZqlVSpJE9YOznAvz9Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.dev>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 161/515] ASoC: SDCA: Add flag for unused IRQs
Date: Mon, 18 Aug 2025 14:42:27 +0200
Message-ID: <20250818124504.581377603@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Charles Keepax <ckeepax@opensource.cirrus.com>

[ Upstream commit 775f5729b47d8737f4f98e0141f61b3358245398 ]

Zero is a valid SDCA IRQ interrupt position so add a special value to
indicate that the IRQ is not used.

Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.dev>
Link: https://patch.msgid.link/20250624122844.2761627-6-ckeepax@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/sound/sdca_function.h   | 2 ++
 sound/soc/sdca/sdca_functions.c | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/include/sound/sdca_function.h b/include/sound/sdca_function.h
index 253654568a41..1403a9f46976 100644
--- a/include/sound/sdca_function.h
+++ b/include/sound/sdca_function.h
@@ -16,6 +16,8 @@ struct device;
 struct sdca_entity;
 struct sdca_function_desc;
 
+#define SDCA_NO_INTERRUPT -1
+
 /*
  * The addressing space for SDCA relies on 7 bits for Entities, so a
  * maximum of 128 Entities per function can be represented.
diff --git a/sound/soc/sdca/sdca_functions.c b/sound/soc/sdca/sdca_functions.c
index 15aa57a07c73..e1803f0dc590 100644
--- a/sound/soc/sdca/sdca_functions.c
+++ b/sound/soc/sdca/sdca_functions.c
@@ -912,6 +912,8 @@ static int find_sdca_entity_control(struct device *dev, struct sdca_entity *enti
 				       &tmp);
 	if (!ret)
 		control->interrupt_position = tmp;
+	else
+		control->interrupt_position = SDCA_NO_INTERRUPT;
 
 	control->label = find_sdca_control_label(dev, entity, control);
 	if (!control->label)
-- 
2.39.5



