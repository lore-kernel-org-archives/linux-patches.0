Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EF6D35962;
	Fri,  3 Oct 2025 16:08:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759507697; cv=none; b=asNHNL5E/KpVErkNvfHRVg7cSmtxMdRsptNmrfq/Tm9N8enV6mJNX4kKiEzinrglWoeJJ8vp8pw69g2p0li5Nl8QlpnW4QczcLaEVO+AAS9lxOhGKBckp2IZxUdQhKGCcStSW9RzIZFuWdopYL1NTSCexGSBeM9glB+LSfdodvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759507697; c=relaxed/simple;
	bh=UkLAhO4tHT/8KG+iyMhRMPIPjMrq7C4M9yBXwFGq0uk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TDd4lheHSVUpWBNGVNT6UZmwDxhF0wjXVkwLB0V00hwGS+ONpkXvnFIAXEoYPvzaGW455XTlDX1sbQiJTiU3sQa+FekEe8c6Jm7tcp6Td+RqChP8qIF6BhYvS9FmilhTqQRkbRnyoiE8PnLHOT4+i/s3mI8OfhG2uQtWcE+G1zQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cqTcwQoi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cqTcwQoi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7184C4CEF5;
	Fri,  3 Oct 2025 16:08:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759507697;
	bh=UkLAhO4tHT/8KG+iyMhRMPIPjMrq7C4M9yBXwFGq0uk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cqTcwQoi8B1S1rV3F4sKDS9AEMRn8lMl8Twboi+bkj3O7pogol+EmWRNXDvIMi5pP
	 umM11m1laENY24TpwwzI7ExFqoOttU8D67ywm5Znh1OG2tVD6MstiiHYuU+mbMHnYP
	 XtJUn+J2PJumOTqGeDs7fh0t2gWESllKG9a7b7vM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Stable@vger.kernel.org,
	Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.12 10/10] ASoC: qcom: audioreach: fix potential null pointer dereference
Date: Fri,  3 Oct 2025 18:05:57 +0200
Message-ID: <20251003160338.756682185@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251003160338.463688162@linuxfoundation.org>
References: <20251003160338.463688162@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>

commit 8318e04ab2526b155773313b66a1542476ce1106 upstream.

It is possible that the topology parsing function
audioreach_widget_load_module_common() could return NULL or an error
pointer. Add missing NULL check so that we do not dereference it.

Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Stable@vger.kernel.org
Fixes: 36ad9bf1d93d ("ASoC: qdsp6: audioreach: add topology support")
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>
Link: https://patch.msgid.link/20250825101247.152619-2-srinivas.kandagatla@oss.qualcomm.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/qcom/qdsp6/topology.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/sound/soc/qcom/qdsp6/topology.c
+++ b/sound/soc/qcom/qdsp6/topology.c
@@ -587,8 +587,8 @@ static int audioreach_widget_load_module
 		return PTR_ERR(cont);
 
 	mod = audioreach_parse_common_tokens(apm, cont, &tplg_w->priv, w);
-	if (IS_ERR(mod))
-		return PTR_ERR(mod);
+	if (IS_ERR_OR_NULL(mod))
+		return mod ? PTR_ERR(mod) : -ENODEV;
 
 	dobj = &w->dobj;
 	dobj->private = mod;


