Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEB7B191F98;
	Tue, 12 Aug 2025 18:32:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023552; cv=none; b=ukyMnAQ10HK1ECEFowHPtl5tWon5R4X1sUIQZSqiv64KTjZToDeuY/YUmOxOINGwXWSVLea72N/+FSJme/rTFkhcAkWqJIKaKpu5WCWtS6ZWO6hZuz867nm7xhULI+9omQb/MYqpP57tOtNVn7Dhhgni1RKouDZT2rKMh1/pJX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023552; c=relaxed/simple;
	bh=fU6GiwitEVTLUzN6A+EhUntAqFHFiJkUrAKwlWNrux4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o+4EgG8vDNXrbtM1NSe29vYEDhqwwviA3pKf2MlM2DZgSMtGvlzYWSWjoAQmfNL0YaeqgcjeE61qn1iCk6oYZg77NCZJoVIQNqL9y814yrrWnT3z4XKz+CSQ4WAVhcQtiQoBpr3lKuStSB1+HVEbi5SRpmS63FPIS8AGMzr7R8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SCkPMuQr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SCkPMuQr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C55EC4CEF0;
	Tue, 12 Aug 2025 18:32:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023552;
	bh=fU6GiwitEVTLUzN6A+EhUntAqFHFiJkUrAKwlWNrux4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SCkPMuQr6qdoQlrJ3ndbRFX48Spa9KkbD5eevz8NaG9Jg5lulzrIAJTKuH6Pnv77N
	 IWKBMyIMmHwMQGQpASCOhXcCb31eyRr9o/leqiplSzkD3qhXp+X4yun6GrOMdupxed
	 sO2GxNJgl76YgCGayWSxwwbFA3txpdNW6tfnUAlk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.dev>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 114/627] ASoC: SDCA: Allow read-only controls to be deferrable
Date: Tue, 12 Aug 2025 19:26:49 +0200
Message-ID: <20250812173423.646678522@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

[ Upstream commit 4eb6ad5d2080681b531db2c1764246f9a868062f ]

The current SDCA Control parsing only checks the deferrable flag for
Read/Write and Dual Ranked controls. However, reads can defer as well as
writes so Read Only controls should also check for the deferrable flag.
Add the handling for this into find_sdca_entity_control().

Fixes: 42b144cb6a2d ("ASoC: SDCA: Add SDCA Control parsing")
Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.dev>
Link: https://patch.msgid.link/20250707124155.2596744-2-ckeepax@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sdca/sdca_functions.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/sound/soc/sdca/sdca_functions.c b/sound/soc/sdca/sdca_functions.c
index de213a69e0da..28e9e6de6d5d 100644
--- a/sound/soc/sdca/sdca_functions.c
+++ b/sound/soc/sdca/sdca_functions.c
@@ -880,7 +880,8 @@ static int find_sdca_entity_control(struct device *dev, struct sdca_entity *enti
 			control->value = tmp;
 			control->has_fixed = true;
 		}
-
+		fallthrough;
+	case SDCA_ACCESS_MODE_RO:
 		control->deferrable = fwnode_property_read_bool(control_node,
 								"mipi-sdca-control-deferrable");
 		break;
-- 
2.39.5



