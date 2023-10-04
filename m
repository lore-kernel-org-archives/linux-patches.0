Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 403C61D68D
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:18:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IdHVjcIv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB17AC433C9;
	Wed,  4 Oct 2023 18:18:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696443512;
	bh=cmS6dDQ85HCbi+EsXf/4AkY3pMA5OQm1u+oQQXDI/dc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IdHVjcIvP2DDg1xhkyh/UfZMFO83K9if+/BmHYnnsVxXuOMkWHkCEArgHLct7ekL8
	 anpwoS9yPLMBk/fO5ytGYGs31d4hU4b84GkuutbhCAKHHi0Tf/1GWZ55bA6iqPZ4m7
	 Dt9LJ1auC/srub2pur/JG1rWeOac+dqPt7N9MZ2s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Stefan Binding <sbinding@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 182/259] ASoC: cs42l42: Dont rely on GPIOD_OUT_LOW to set RESET initially low
Date: Wed,  4 Oct 2023 19:55:55 +0200
Message-ID: <20231004175225.649869872@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175217.404851126@linuxfoundation.org>
References: <20231004175217.404851126@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Richard Fitzgerald <rf@opensource.cirrus.com>

[ Upstream commit a479b44ac0a0ac25cd48e5356200078924d78022 ]

The ACPI setting for a GPIO default state has higher priority than the
flag passed to devm_gpiod_get_optional() so ACPI can override the
GPIOD_OUT_LOW. Explicitly set the GPIO low when hard resetting.

Although GPIOD_OUT_LOW can't be relied on this doesn't seem like a
reason to stop passing it to devm_gpiod_get_optional(). So we still pass
it to state our intent, but can deal with it having no effect.

Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Signed-off-by: Stefan Binding <sbinding@opensource.cirrus.com>
Link: https://lore.kernel.org/r/20230913150012.604775-3-sbinding@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/cs42l42.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/sound/soc/codecs/cs42l42.c b/sound/soc/codecs/cs42l42.c
index 914cdd737fa3b..735061690ded0 100644
--- a/sound/soc/codecs/cs42l42.c
+++ b/sound/soc/codecs/cs42l42.c
@@ -2281,6 +2281,12 @@ int cs42l42_common_probe(struct cs42l42_private *cs42l42,
 	if (cs42l42->reset_gpio) {
 		dev_dbg(cs42l42->dev, "Found reset GPIO\n");
 
+		/*
+		 * ACPI can override the default GPIO state we requested
+		 * so ensure that we start with RESET low.
+		 */
+		gpiod_set_value_cansleep(cs42l42->reset_gpio, 0);
+
 		/* Ensure minimum reset pulse width */
 		usleep_range(10, 500);
 
-- 
2.40.1



