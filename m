Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 103C433EC
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 15:54:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A0EAC433D2;
	Mon, 16 Jan 2023 15:54:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673884476;
	bh=z4iyO4piXfHR860uL1CWtubebOroVttaghFPALSBrj0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PcRgjF6Gb7qbkpki2T1hV7tNIJPJYDIJecCZD/cdZOlPyRol4G1Kc36Rf412b+meq
	 M2QBKBb37XU8kVwZEIRK8O4J9Bjfboe/zOjcDEia4/ZoEQWmZem+wPqXdJhqCMxPSf
	 Y7FquHkcr0Al6foBFTPPiSU4FZ0FDgOUxgddq0Uc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian Norris <computersforpeace@gmail.com>,
	Stephan Gerhold <stephan@gerhold.net>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.1 021/183] ASoC: qcom: lpass-cpu: Fix fallback SD line index handling
Date: Mon, 16 Jan 2023 16:49:04 +0100
Message-Id: <20230116154804.291656162@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154803.321528435@linuxfoundation.org>
References: <20230116154803.321528435@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Brian Norris <computersforpeace@gmail.com>

commit 000bca8d706d1bf7cca01af75787247c5a2fdedf upstream.

These indices should reference the ID placed within the dai_driver
array, not the indices of the array itself.

This fixes commit 4ff028f6c108 ("ASoC: qcom: lpass-cpu: Make I2S SD
lines configurable"), which among others, broke IPQ8064 audio
(sound/soc/qcom/lpass-ipq806x.c) because it uses ID 4 but we'd stop
initializing the mi2s_playback_sd_mode and mi2s_capture_sd_mode arrays
at ID 0.

Fixes: 4ff028f6c108 ("ASoC: qcom: lpass-cpu: Make I2S SD lines configurable")
Cc: <stable@vger.kernel.org>
Signed-off-by: Brian Norris <computersforpeace@gmail.com>
Reviewed-by: Stephan Gerhold <stephan@gerhold.net>
Link: https://lore.kernel.org/r/20221231061545.2110253-1-computersforpeace@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/qcom/lpass-cpu.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/sound/soc/qcom/lpass-cpu.c
+++ b/sound/soc/qcom/lpass-cpu.c
@@ -1037,10 +1037,11 @@ static void of_lpass_cpu_parse_dai_data(
 					struct lpass_data *data)
 {
 	struct device_node *node;
-	int ret, id;
+	int ret, i, id;
 
 	/* Allow all channels by default for backwards compatibility */
-	for (id = 0; id < data->variant->num_dai; id++) {
+	for (i = 0; i < data->variant->num_dai; i++) {
+		id = data->variant->dai_driver[i].id;
 		data->mi2s_playback_sd_mode[id] = LPAIF_I2SCTL_MODE_8CH;
 		data->mi2s_capture_sd_mode[id] = LPAIF_I2SCTL_MODE_8CH;
 	}


