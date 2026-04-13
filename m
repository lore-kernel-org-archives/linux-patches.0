Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34CA2314D26;
	Mon, 13 Apr 2026 16:47:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098877; cv=none; b=UrtnJLyCZnBOZpf93h8K3nn8Y3QS8eD0lvJfQ+qV9yCU0cGoWrd7tZopYwZcCaxa+r0UDJiHTWeixG/agsYWn5/XiYfG1lmIAAjOOkzXmo4RQBCHVGECGynqJZGHsNGLXwsNIQJByBUsKCyEGgcDfS0GOJ4VB+GTU5CD2ZGoa50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098877; c=relaxed/simple;
	bh=QsyZX2gdVnVpAK2VuxYyvGTOvN35q4ULlIAd1JjlMQs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HBzBb9kw6rwFgRchj5uP98tSis9g5Uoj407KVKAfRtv+iTioULsgY3fcqhW+KHgNYUiJzpel5sKqtwmDp2Gm8bb/0A6Fdw2Z0tyE7RkVLs+PEbXTF/8EtmEAgalhsz66cUYL+SWO5rV+9pWeZwdor91CNlxKJZSOFqbWZS3NtQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Shsrp4Bq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Shsrp4Bq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D18FC2BCAF;
	Mon, 13 Apr 2026 16:47:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098876;
	bh=QsyZX2gdVnVpAK2VuxYyvGTOvN35q4ULlIAd1JjlMQs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Shsrp4Bq1HtwvsKWxOMpdQd9nTwvk/NZpO/xBRF1PmRwR/M4MY3dgz67EK6fPhgKP
	 vIMKVm2vqnkcB0XrFRADuHFEoabg9bXE9WtuuXBr/FnXfjq/2IPIqkNEZlfA+DauDR
	 Aqyv0HNyzIM2BExKrlqv8dQYEmdr28QzJ01YA6ks=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <gu_0233@qq.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.10 106/491] mmc: mmci: Fix device_node reference leak in of_get_dml_pipe_index()
Date: Mon, 13 Apr 2026 17:55:51 +0200
Message-ID: <20260413155823.011755814@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Gu <ustc.gu@gmail.com>

commit af12e64ae0661546e8b4f5d30d55c5f53a11efe7 upstream.

When calling of_parse_phandle_with_args(), the caller is responsible
to call of_node_put() to release the reference of device node.
In of_get_dml_pipe_index(), it does not release the reference.

Fixes: 9cb15142d0e3 ("mmc: mmci: Add qcom dml support to the driver.")
Signed-off-by: Felix Gu <gu_0233@qq.com>
Cc: stable@vger.kernel.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/mmci_qcom_dml.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/mmc/host/mmci_qcom_dml.c
+++ b/drivers/mmc/host/mmci_qcom_dml.c
@@ -109,6 +109,7 @@ static int of_get_dml_pipe_index(struct
 				       &dma_spec))
 		return -ENODEV;
 
+	of_node_put(dma_spec.np);
 	if (dma_spec.args_count)
 		return dma_spec.args[0];
 


