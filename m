Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F3D31EE7C6;
	Mon, 23 Jun 2025 21:35:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714556; cv=none; b=WrnLYlmYFdevFm0HEEGD9SgaqYbj/f4km+Ci4e9SOMytjLEBefkbe9qnn9Ke2CL2gqv6keJsZlKk2cGeCVQyoVX9tKVYIb54uq1mlW4lmHs9jvVQeUuR0M+ZuSuE3kM8JOIn/bStvYokS+Knle8llRKp+AGVWHnnj0WjjkMGo3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714556; c=relaxed/simple;
	bh=KjW7HDVjkekRnZYbxVFDyr2P9YmtiGQCBwx+HII5Z/U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fwtSgqRmsmL0mQfkTGOMNvPb2Dk/J/n98CSUNOWL17L22v/tssO7MObZrRCNL+TiJoB5EC0Lot8TdxelH5ZUmL0oRqjA0npUaUkL25W7Tv28lo9rSjy+R481vXq15h+dQVcghV1LsGYWLsy5iVdT+SnwMOTKFMmq0PkQRcjhrgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wDU9hNCr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wDU9hNCr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8DDBC4CEED;
	Mon, 23 Jun 2025 21:35:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714556;
	bh=KjW7HDVjkekRnZYbxVFDyr2P9YmtiGQCBwx+HII5Z/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wDU9hNCrvZ38FdJQIGHsSmjBL4TMDr8Q6oSPJMcYFQFGoRSeIC0YxZ1GvBg8xwTVQ
	 3pM8JPrcMi6FTUKVNBv5lo/1DOEghqaSK7ECV90jTmqHPB1t1WTux3uu3bEZ8W8xC7
	 D53/gB8qocw1eQSd+76aljkFsSRvRlqgQObNEgAg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.15 195/411] ASoC: qcom: sdm845: Add error handling in sdm845_slim_snd_hw_params()
Date: Mon, 23 Jun 2025 15:05:39 +0200
Message-ID: <20250623130638.585650374@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -78,6 +78,10 @@ static int sdm845_slim_snd_hw_params(str
 		else
 			ret = snd_soc_dai_set_channel_map(cpu_dai, tx_ch_cnt,
 							  tx_ch, 0, NULL);
+		if (ret != 0 && ret != -ENOTSUPP) {
+			dev_err(rtd->dev, "failed to set cpu chan map, err:%d\n", ret);
+			return ret;
+		}
 	}
 
 	return 0;


