Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F01D3090C9;
	Mon, 13 Oct 2025 14:49:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760366998; cv=none; b=m4c9lzqP9tWw7vHVkO7F3nCU4fNCX7Sem/goow4d6cZBHQELBQtHsHKVUYNpRMv+OwYVklw94sxf6F8Ftz0QHVSmedRfKGcG4ZlempsvzYJcufMJxZsG4Q7DGefzag3v41K+81ycDwAdNCPGiaj/ZZ4ucluOW6wWjlDCt/Z4kHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760366998; c=relaxed/simple;
	bh=+KQUGPDgpYt7MH4t3EpA/cqsnB0plJdYJGoHdQAS3hc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tfHnqNPbUdsM6y/7jFjCCNQFM+AmMLBsGyZZnH0JyDipVNhh9O25zVV++tpIw+qa8M3Tr/nVGd7mxj2OFF4puH/2TRJwsN6MvVAERdLzUaT0OuLdm6lvOB8UanlAhVqWZulFP68ePFAcMATbqzOON0mJt9Ht1IgsS1aOH9dst9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xX6brBNa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xX6brBNa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86084C4CEE7;
	Mon, 13 Oct 2025 14:49:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760366997;
	bh=+KQUGPDgpYt7MH4t3EpA/cqsnB0plJdYJGoHdQAS3hc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xX6brBNaxeEPVFs/FkuQH0qi/SgXxEw4ArWLYGdrKgMYGVrJk5mqIbc3ve76SEwAE
	 HcevDtj39ArgQlsZgTk0l95BTIb94NNHt83uT2Opi1tflDVaRct/pP+GEizJaxFCFZ
	 i8qFs156D3joR5li4clBihgmJvqKax1Gd5VjcnGE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Stable@vger.kernel.org,
	Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.1 014/196] ASoC: qcom: audioreach: fix potential null pointer dereference
Date: Mon, 13 Oct 2025 16:43:07 +0200
Message-ID: <20251013144315.080615514@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144314.549284796@linuxfoundation.org>
References: <20251013144314.549284796@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -504,8 +504,8 @@ static int audioreach_widget_load_module
 		return PTR_ERR(cont);
 
 	mod = audioreach_parse_common_tokens(apm, cont, &tplg_w->priv, w);
-	if (IS_ERR(mod))
-		return PTR_ERR(mod);
+	if (IS_ERR_OR_NULL(mod))
+		return mod ? PTR_ERR(mod) : -ENODEV;
 
 	dobj = &w->dobj;
 	dobj->private = mod;


