Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4078229BDB5;
	Fri,  3 Oct 2025 16:09:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759507748; cv=none; b=Cl+IvgIedygraHfLg2LcMoDLTpbD17fCzcUMtC1WhGU6fx2IdZkpK918zLsqTWwgmJnM3Te4sVS3r6ifEmCL3nqvecPwrEUO2iB/jO2rEMSvMuNi6oGekS4IX3ByGY21zzdNGZRl0UsbfYKEwcxkqtyu14XDDlPM9pkK+7xunrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759507748; c=relaxed/simple;
	bh=EgAdY2kiz8z+ol55KksXmbvWn42ZxDF5BJhj7zpkgDU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=moYhwETMGoGI0l+nvLcMcfdtQ0nefTXJ6Xvv9an2XKK0ridX3+2gfaNk4lCq35TTs5OZIFvbnOC9WFOLgYp0pbQ2peB3fJPcXi4SPqxKjJW/FS43hRCXO02P7C+JyLQa6RuJJTEfBxNRgO153KJ/uk3MN7En6yvhY+ANMAJY9gk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UplVZfCN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UplVZfCN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6180DC4CEF5;
	Fri,  3 Oct 2025 16:09:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759507747;
	bh=EgAdY2kiz8z+ol55KksXmbvWn42ZxDF5BJhj7zpkgDU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UplVZfCN6O01JN+OMOLJBdupDsdIONZEmRwBJ3bFK4EAj8JGmfYdJC8Xdr9wViZzF
	 h32TqMgRhWbaDdSeNBDRYc5yU3EBwX6m/kIGIJzz5x7ci8ijA94+XB1gtaqZB0dTPX
	 V4WSyQlc0YI9IggSJhzohr8QRonfCFpJAf+e1M34=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Stable@vger.kernel.org,
	Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.6 7/7] ASoC: qcom: audioreach: fix potential null pointer dereference
Date: Fri,  3 Oct 2025 18:06:15 +0200
Message-ID: <20251003160331.706703325@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251003160331.487313415@linuxfoundation.org>
References: <20251003160331.487313415@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -586,8 +586,8 @@ static int audioreach_widget_load_module
 		return PTR_ERR(cont);
 
 	mod = audioreach_parse_common_tokens(apm, cont, &tplg_w->priv, w);
-	if (IS_ERR(mod))
-		return PTR_ERR(mod);
+	if (IS_ERR_OR_NULL(mod))
+		return mod ? PTR_ERR(mod) : -ENODEV;
 
 	dobj = &w->dobj;
 	dobj->private = mod;


