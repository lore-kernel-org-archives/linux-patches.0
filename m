Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F079825DAFF;
	Tue, 11 Mar 2025 15:10:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741705811; cv=none; b=dEkacvaAmSkSOvhRz4Z7oyHbKdkjv1k1HGLIUT6usI2I3yK5GUBpH9Mqq4t4Gh0EIFQ4A/nGGj7r5pjzppr5RLRLHYOUNzE2VWbPMUArRUByXt3maBypOjrJlZL47faVKnffAdAapqcAq434USCbX4C8ZdCsbiW51QGK9A3TlqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741705811; c=relaxed/simple;
	bh=t5tcb/GTU8F4uxgWW8/6+xw8fDLHSDDBV60sS1wFmy0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aj7jmnJtLwIVI+H8dNjpVwdPJ+1b1oeE/bPYRubOyBHU3rX6FdKOcAYTwF9yEDWK3QaqfAoHAYHGV8TnbmyEfDTui7cqc3/mX/09bXxAjdek6H/WuzngiWZm0CZek1sxM2Zt7N3TzSwoDH7Qzw9s8K090EpF2PPnZ/3z2PyayF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VzcmVfEf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VzcmVfEf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73804C4CEE9;
	Tue, 11 Mar 2025 15:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741705810;
	bh=t5tcb/GTU8F4uxgWW8/6+xw8fDLHSDDBV60sS1wFmy0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VzcmVfEfHXaX/8nzYYXvqUp5bmF7KHz8X9u6btKTNS0UfcLRmrusvmDTjSaxAj+1R
	 /lAIJwcuwJCzmYTH5BHNo1LolwJsu2jel+woKNDOdoKtx9WKIWR9I6rsoPhNP+5Kd8
	 22/BW7nIyySnzRZPDnbEzJqzkQtz13qyU30qEiSQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 5.4 144/328] soc: qcom: smem_state: fix missing of_node_put in error path
Date: Tue, 11 Mar 2025 15:58:34 +0100
Message-ID: <20250311145720.632470462@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145714.865727435@linuxfoundation.org>
References: <20250311145714.865727435@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -116,7 +116,8 @@ struct qcom_smem_state *qcom_smem_state_
 
 	if (args.args_count != 1) {
 		dev_err(dev, "invalid #qcom,smem-state-cells\n");
-		return ERR_PTR(-EINVAL);
+		state = ERR_PTR(-EINVAL);
+		goto put;
 	}
 
 	state = of_node_to_state(args.np);


