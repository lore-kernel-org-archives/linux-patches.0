Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2AA3176ADE;
	Wed, 19 Feb 2025 09:25:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739957103; cv=none; b=UGlcRCXswtv3/oHvH8yMPJdK+F5bE0fPSQXxbhYdv62bgKTa4NGZ/+g7BzTwAg6/veTAFou3RxAK/CyJCkffnIuXAnCp0liVVozVLOBkzqI5NJBcnzOqfW1kxYQwFNErj78DpGYU72ZIBJTgriFJoISdP04gaaQe8KCA2lcboeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739957103; c=relaxed/simple;
	bh=iVfiEs5XyMj6j/VTdP7r1KR2lq/sW6XeBu0/WQM86b0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Brb2RM9wWee5k9jsqrokqztJNHQhlcd5n+5HwooR2kGfzGXCXUwFl2KGGz8jzRFoUOJMJmkF9i3ElasqS64IPQ1WklRFCjlwcZqIdhjPv8t2HPvsQMTOXWjv2cVxo0/xDxqKPszHPofpdiGQuW+A5kXchzG5TsbN85hWJDnuC9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YD03G3Wz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YD03G3Wz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58393C4CED1;
	Wed, 19 Feb 2025 09:25:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739957103;
	bh=iVfiEs5XyMj6j/VTdP7r1KR2lq/sW6XeBu0/WQM86b0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YD03G3WzCPlwRhnLc9HrSb/62wbuFN5umwuPEhJkoFcc0S3lniRHNsqbimnRpcZIw
	 E1LbpH6kECkh7BdHYhYHVEeNijUji7/wvYW7eH4URt8/MQuUhQGz0ROhGNHbtsGrsw
	 CKMHssGASj4pYN26dzQzZyVrog4iaeInsLFB2l5c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.1 409/578] soc: qcom: smem_state: fix missing of_node_put in error path
Date: Wed, 19 Feb 2025 09:26:53 +0100
Message-ID: <20250219082709.112391132@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


