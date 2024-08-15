Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDB4B17C9B6;
	Thu, 15 Aug 2024 14:14:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731256; cv=none; b=Z5IHd+lydn+mNMRPwihPVFlu86L020xytVddWdASPKjeZdWz17qdOyDyx4qUhGFQBM6E1cH19n6p6lqWXrNMqgzVfm3mL555NWR2Int0W92I5yXWyNqNkg0xJqbdusALDZ/Z/9WkNNycz4G3y+oFWhdyiVHXPChCHicKvpZFw1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731256; c=relaxed/simple;
	bh=GkUz54racOx8g1XbqJB0LRhXqGW2hZbfGHmaRJCKlk8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LYVcWZHXjf+SIox1InsiJ+THXuC/MIPtlJ96Ml3N+pbvfkEmblYpXtoHFbACCzoJVzbewWYgoRD7lFrXnwYm+pMU1908sUALVzB8qjpnh2zExEo5jcvxhT9oU9Eox/LRNjH/SINwqI38MccCwXO7Lq3TjLtYXcBh6sv1H5C96Yw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DEOzS9fc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DEOzS9fc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62FF5C32786;
	Thu, 15 Aug 2024 14:14:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723731255;
	bh=GkUz54racOx8g1XbqJB0LRhXqGW2hZbfGHmaRJCKlk8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DEOzS9fc4aIE33hdQUXF+EjNZ0RQTAhvbGYxlPMSNLGK0AjCikhn0x8CPokWAiG7V
	 S5U4C7rmDofakK38ZgkytNzdsOF70SZgiuQ1s071ceDOaZgnFsBC5oaamoZ0uswBRv
	 4sMCHIkdQTRCMkqRI4/szy/OiSu8i7KkDslEvvb0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ni <nichen@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 072/259] ASoC: max98088: Check for clk_prepare_enable() error
Date: Thu, 15 Aug 2024 15:23:25 +0200
Message-ID: <20240815131905.583814101@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131902.779125794@linuxfoundation.org>
References: <20240815131902.779125794@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Ni <nichen@iscas.ac.cn>

[ Upstream commit 1a70579723fde3624a72dfea6e79e55be6e36659 ]

clk_prepare_enable() may fail, so we should better check its return
value and propagate it in the case of error.

Fixes: 62a7fc32a628 ("ASoC: max98088: Add master clock handling")
Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
Link: https://patch.msgid.link/20240628080534.843815-1-nichen@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/max98088.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/sound/soc/codecs/max98088.c b/sound/soc/codecs/max98088.c
index fa4cdbfd0b80d..678b209d0bce0 100644
--- a/sound/soc/codecs/max98088.c
+++ b/sound/soc/codecs/max98088.c
@@ -1317,6 +1317,7 @@ static int max98088_set_bias_level(struct snd_soc_component *component,
                                   enum snd_soc_bias_level level)
 {
 	struct max98088_priv *max98088 = snd_soc_component_get_drvdata(component);
+	int ret;
 
 	switch (level) {
 	case SND_SOC_BIAS_ON:
@@ -1332,10 +1333,13 @@ static int max98088_set_bias_level(struct snd_soc_component *component,
 		 */
 		if (!IS_ERR(max98088->mclk)) {
 			if (snd_soc_component_get_bias_level(component) ==
-			    SND_SOC_BIAS_ON)
+			    SND_SOC_BIAS_ON) {
 				clk_disable_unprepare(max98088->mclk);
-			else
-				clk_prepare_enable(max98088->mclk);
+			} else {
+				ret = clk_prepare_enable(max98088->mclk);
+				if (ret)
+					return ret;
+			}
 		}
 		break;
 
-- 
2.43.0



