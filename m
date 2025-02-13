Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3551E26B088;
	Thu, 13 Feb 2025 14:49:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739458163; cv=none; b=ZNLyG79fLncJmD417GXE18qXxQoVYAVukjoWvyii2sKoSaLOkdLtMpPZpmQ9WGZ80HigNVJxJsiWIgDp4lqehYp8MiWj7QRq/r/QtstP99TBOajc7fYJGSawFFFHQggcr46nfbjb80qGZ6TyQUr/Vlvcx25k9QNC+QE+wiPBU88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739458163; c=relaxed/simple;
	bh=UeH/PV/Ype/O/jQPpJ2QZabQY2W749p5N0FkX2ONqjs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WURBs3wyhJSuv6po1TnBJZDewRfujeBKNxszGEw/aCCeKBB/41DvaFlYZ3bmG6QQ2iyQkUz7xLvyV2/z3z8TrTVyGBerMSsrPn/T7XrZCDTWhdgxwS58eTKMSVKhdsqWyTpOoRA9wCCbpHr44rp85qMdKMfrjtPiEDctF1SaUN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J9r7ykap; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J9r7ykap"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 993AEC4CED1;
	Thu, 13 Feb 2025 14:49:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739458163;
	bh=UeH/PV/Ype/O/jQPpJ2QZabQY2W749p5N0FkX2ONqjs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J9r7ykap/61o+ekQQDnAhZNOujI9KLJeq4f6tWCdLW8HQ7ipf8piGiOC31HfN/qdG
	 mEkQ27qROqyEYN2aI5rgOpG58Ra3v16YpWvvwRNuFSN3JEWg/HVtENtpbi8aPLA93E
	 k7zhEjv7JMShuYKdnMCb5dofOP+Oa24pLlshFzjI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.12 320/422] soc: qcom: smem_state: fix missing of_node_put in error path
Date: Thu, 13 Feb 2025 15:27:49 +0100
Message-ID: <20250213142448.897000870@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
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


