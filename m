Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BD8E15820C;
	Tue, 11 Mar 2025 15:28:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706892; cv=none; b=WHgPHU0XIDypkY7IUa8uyBPf+ewhP0Wmkib0v+ud26JXr/ffQUOBuAUO1eAAhVGLo6xwO10c14a/7Ja9JHGolld1JR4QbiSdEGAWH26kcdlEh5iWiUe2yFPkg9dM3aVTRgVviB0ZPfxG1LaIyEi9HDAnIaevz578WFHKDGNRCn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706892; c=relaxed/simple;
	bh=DnlB87Dw2bI0FZtpGf1Hn41Slz5S7enWzBU7xNwHgPc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QFr0bkDXGQuFNaJJZdjWozu6ep3XDSCRLDXNVSSZSZ8WdxQyOhshNd2eT3fB5yuowPx5eJZwoIRFuagGDvMAORvE/RiNeEOdb4v2Ly1+61qT9YAuJ939daoYMgyicrIfQm6pH+y/dvsMfHPS+Yn0ISwsJyg/20E3ddk+tutNkNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H9lESnde; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H9lESnde"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22B2AC4CEE9;
	Tue, 11 Mar 2025 15:28:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706892;
	bh=DnlB87Dw2bI0FZtpGf1Hn41Slz5S7enWzBU7xNwHgPc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H9lESndexUN0+R7njpYhf0/7BF/gHrd2q3aCo/HL/StaVfEQrjmtm3YtwGKH7u7n/
	 ZDkfa9d24X9nXPKkRJO7pjuyJtoE7x/HJG5vj6Ju4Y3XZw7ghTBVi6K65nyuJ+S7MY
	 kEUJkgJ/efzfKJrSTym9qTeiHd9NUW/1aPg4jpeY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 5.10 203/462] soc: qcom: smem_state: fix missing of_node_put in error path
Date: Tue, 11 Mar 2025 15:57:49 +0100
Message-ID: <20250311145806.373977080@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


