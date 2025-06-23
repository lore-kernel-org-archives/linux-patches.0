Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39451253F35;
	Mon, 23 Jun 2025 13:37:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685826; cv=none; b=eGtaz16iIFrMTIMWkW8TZHJEPn3ny95rUBT1N8coygftHrt4vtWDDXrBQKi7pn974urglXASghLn+XyPXou5mfxua16qY8JxibiLb/zONv8CGS/JOYJqdRymds3yNFC4AT4ajN6pE6UPjtMniCnIUJmGFF+j6bKcPZS0S+fwnVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685826; c=relaxed/simple;
	bh=wfIe7uJ28a/d4Ekngw8ppkrptrBaCvjWEHTnLx3ta7w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=poUWDQCztKbhmm3Np6b/3h+qbOcFdtXd00uU2JrcpeazHgRcwEnxnOs0TLCRpF8cGn2+EflgD/jtbkit7Z9C2Mb2aOTbSgQSWsGZWzXThfr94K7COAnPDbcsMLSezHW9isve36mVfg2WAD4ZlZ5qkzwTi1Npwv87d3fU2oIrj9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v0ksfsDf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v0ksfsDf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C192FC4CEF0;
	Mon, 23 Jun 2025 13:37:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685826;
	bh=wfIe7uJ28a/d4Ekngw8ppkrptrBaCvjWEHTnLx3ta7w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v0ksfsDf+q6e81wu68mjxRZMWh3AydqYBte1L6uMgipDYgycqjgfMLkYd7DK+D04V
	 DdtbySQJOzzLoLO04kFA34stWh+KOBfspiiJNMnd/a6EO5WPqTYqXb/YzTEhuynlop
	 BTWLpUD9VVfj8Z1p9diotueg8mkEorhz/Pw0uYk0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.12 009/414] ASoC: qcom: sdm845: Add error handling in sdm845_slim_snd_hw_params()
Date: Mon, 23 Jun 2025 15:02:26 +0200
Message-ID: <20250623130642.259589058@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

commit 688abe2860fd9c644705b9e11cb9649eb891b879 upstream.

The function sdm845_slim_snd_hw_params() calls the functuion
snd_soc_dai_set_channel_map() but does not check its return
value. A proper implementation can be found in msm_snd_hw_params().

Add error handling for snd_soc_dai_set_channel_map(). If the
function fails and it is not a unsupported error, return the
error code immediately.

Fixes: 5caf64c633a3 ("ASoC: qcom: sdm845: add support to DB845c and Lenovo Yoga")
Cc: stable@vger.kernel.org # v5.6
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://patch.msgid.link/20250519075739.1458-1-vulab@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/qcom/sdm845.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/sound/soc/qcom/sdm845.c
+++ b/sound/soc/qcom/sdm845.c
@@ -91,6 +91,10 @@ static int sdm845_slim_snd_hw_params(str
 		else
 			ret = snd_soc_dai_set_channel_map(cpu_dai, tx_ch_cnt,
 							  tx_ch, 0, NULL);
+		if (ret != 0 && ret != -ENOTSUPP) {
+			dev_err(rtd->dev, "failed to set cpu chan map, err:%d\n", ret);
+			return ret;
+		}
 	}
 
 	return 0;


