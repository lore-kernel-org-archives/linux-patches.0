Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEFD91714A1;
	Thu, 15 Aug 2024 13:46:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729595; cv=none; b=fe1nKqwBBeJy6t5vjSXi8RWNZobNhO8d96ZI9I0VJR7ENwy7zp7aDVUG3/+y3fMqen0A4hPhUY13kS/Kx9+uih07syR/9KtQgEMueN1mSoMSovTpBq1ZCeI/fLE+g/n7mYJBIc9wMepF6Cup7nGQjCp3HKgMCfa6Ml1Zyh4sfFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729595; c=relaxed/simple;
	bh=u5gI8gMreWvgP3qorxeLseMXLKtrwTReW2XINq5bCAI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uRyVfwpAtHSDnCiG9B3EewfFg48DzEGd/FXlih0H+TXFotgq5oAfYTw3+z3X4eIf8yc8DfqjWB8xMAcRcIu/Ea8TBK4/a3T6VG2WAtSVQdpPyvQtSO9EBSKhsfblClO2XDxjIV2gEPiF7L2Q+Fl9Mget84BFfOQ8nxOsOwu+24A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SqaG/pzN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SqaG/pzN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51D6CC32786;
	Thu, 15 Aug 2024 13:46:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729594;
	bh=u5gI8gMreWvgP3qorxeLseMXLKtrwTReW2XINq5bCAI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SqaG/pzNFhMIUSTfIjNaFvQXuJURuM+hcPZf4jX/vXPzXgDa2H8FXiHMX6k/dI99f
	 jKhq4e4CR7MyCo320lQh6vODujWFq0NzHRoe3pk2ZWJSOUDOL8qL6j/Tzl42OBmm5j
	 4Kj3VLXjvbtDf60Zp6nDYCT/7AiF6QLYE3FPHzFo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ni <nichen@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 130/484] ASoC: max98088: Check for clk_prepare_enable() error
Date: Thu, 15 Aug 2024 15:19:48 +0200
Message-ID: <20240815131946.426808608@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index f8e49e45ce33f..a71fbfddc29a7 100644
--- a/sound/soc/codecs/max98088.c
+++ b/sound/soc/codecs/max98088.c
@@ -1319,6 +1319,7 @@ static int max98088_set_bias_level(struct snd_soc_component *component,
                                   enum snd_soc_bias_level level)
 {
 	struct max98088_priv *max98088 = snd_soc_component_get_drvdata(component);
+	int ret;
 
 	switch (level) {
 	case SND_SOC_BIAS_ON:
@@ -1334,10 +1335,13 @@ static int max98088_set_bias_level(struct snd_soc_component *component,
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



