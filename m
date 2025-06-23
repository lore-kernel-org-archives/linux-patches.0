Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA2AD2566D3;
	Mon, 23 Jun 2025 13:29:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685382; cv=none; b=i1TKAZYHHo5oSMxLKscX5VwljtqXq9bw/RN8lQk9zTVeOKHrbtQGx+ZyEf8DXO34aVsrXTsxdOAG+DzKbtyJuqdsP25BW/E1jjGfatRvQMsw+Ge4gTF9gaZaxNqilXew9c+RMfJE8a2JWYYU1NFX9QcJeC0mSMzXPuCAqSgC5oo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685382; c=relaxed/simple;
	bh=yazUFsYRUGzmUuV5Xmwn0djRbxhdpVOwcxkDNQY7wAo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iFS1ugEWpxX/w1f9TLlDYmqvE4kGB/nPzvBYyU1Y7to60nKboI/6uzhvf417UUquZhhzQNGe3CXtEfRM+6C0YjCdO9+7bdk2Ygig7yLTbBuP/guqQCJ1x5vqWPhQoGvu8c7lm/k+1Haf6wObrAeX1/ZrgnWWkGqN1FHO6ppDiRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EgNe3vtr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EgNe3vtr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79162C4CEF0;
	Mon, 23 Jun 2025 13:29:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685381;
	bh=yazUFsYRUGzmUuV5Xmwn0djRbxhdpVOwcxkDNQY7wAo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EgNe3vtrpAz5sk5TFBmvoban67u2Kd81Vom3ghzkjUQyHpILfPf8d7fTRm36qV3pT
	 zdQl1SpSbacFdzpc5jjrwRlA8f/4LQq+iRTKG6cku8FuBuuhdCMlcYJPu8hM3YUbAV
	 ww9F7oF5ezC9EzOP11noOgRTUbdumMwY8DX6cUUM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.6 004/290] ASoC: qcom: sdm845: Add error handling in sdm845_slim_snd_hw_params()
Date: Mon, 23 Jun 2025 15:04:25 +0200
Message-ID: <20250623130627.071327261@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.910356556@linuxfoundation.org>
References: <20250623130626.910356556@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -90,6 +90,10 @@ static int sdm845_slim_snd_hw_params(str
 		else
 			ret = snd_soc_dai_set_channel_map(cpu_dai, tx_ch_cnt,
 							  tx_ch, 0, NULL);
+		if (ret != 0 && ret != -ENOTSUPP) {
+			dev_err(rtd->dev, "failed to set cpu chan map, err:%d\n", ret);
+			return ret;
+		}
 	}
 
 	return 0;


