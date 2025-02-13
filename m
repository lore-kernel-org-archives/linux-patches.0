Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF41826B0A5;
	Thu, 13 Feb 2025 15:15:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459753; cv=none; b=MdjqgudX5T99FJldnCqauDFQFVi/cO7C9A4Qd7J/55jMjcfYktHhZWtIqHUyGyb3TT2M25vl9Sdm7N6qyYxftA4UbSz3XYcuo5aM6Q3m0iSbBnLiyKiEq5ShD1GLBBh03QoHGydF3Tlk4vXrSD3T7KBYqsePBJmQAjTKcSfhQiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459753; c=relaxed/simple;
	bh=rrUuk48hz0JXIYqyLMGSrQnALRO757OxU2NdZH9TOqY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L0nLCMo+hKgXZO1ZPVYfMuP8WnIlvE1m7Bxe+7k+oZpj1n1VnaXwX+tZLMPMkdLJS6ytVCHRJ6ksQ3Q/YRLY1zrK2DS1LdWIiwlr9mNxA8rN3Bt/lzaHxeRCgOdHkt0Qa1PSlDylRrqv71Qq30TIMe4/7uoIyNjrFyFto4AITww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tx0pTtDq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tx0pTtDq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28DDCC4CED1;
	Thu, 13 Feb 2025 15:15:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459753;
	bh=rrUuk48hz0JXIYqyLMGSrQnALRO757OxU2NdZH9TOqY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tx0pTtDqSxxVgkdSUCX6oD91ri8vlVAILUOKLtuPziwLP0qUK3VLoxJGdklnve5wj
	 B3KeEqZSSLA+MTgs0+Xvb0MGKyDF3HYO8BeRQ1YtZ34Y+DXU0dBJO5uBE6jQRO/JAZ
	 ag7F7xLYShH8FgEA2dZUmTW3DlIHYw4xK/WHASRw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.13 355/443] soc: qcom: smem_state: fix missing of_node_put in error path
Date: Thu, 13 Feb 2025 15:28:40 +0100
Message-ID: <20250213142454.314293063@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

commit 70096b4990848229d0784c5e51dc3c7c072f1111 upstream.

If of_parse_phandle_with_args() succeeds, the OF node reference should
be dropped, regardless of number of phandle arguments.

Cc: stable@vger.kernel.org
Fixes: 9460ae2ff308 ("soc: qcom: Introduce common SMEM state machine code")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20240822164853.231087-2-krzysztof.kozlowski@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/soc/qcom/smem_state.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/soc/qcom/smem_state.c
+++ b/drivers/soc/qcom/smem_state.c
@@ -112,7 +112,8 @@ struct qcom_smem_state *qcom_smem_state_
 
 	if (args.args_count != 1) {
 		dev_err(dev, "invalid #qcom,smem-state-cells\n");
-		return ERR_PTR(-EINVAL);
+		state = ERR_PTR(-EINVAL);
+		goto put;
 	}
 
 	state = of_node_to_state(args.np);


