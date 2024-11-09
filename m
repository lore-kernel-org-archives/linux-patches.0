Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFA10CA6B;
	Sat,  9 Nov 2024 00:28:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731112111; cv=none; b=vC56IqRl1+H6wOfCvseQzPR35f+DQVCte6B9XNV4qwdZqoqqX8+Fq7gdezha/FZw5laY6ja5DeR06Fk53DszbKBna0wqIXt4Qc8K4MI2VscoaDb9B+2lWLHhKGkfLL7jeyQFAQUnlhGc4eULBTCj7N+gbdo5Qh8fNFeaSL/pOr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731112111; c=relaxed/simple;
	bh=C7SFj4q4lLbVbx3tVScA0zWrHnfokGjWtxuW3ZW984w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h8NKfiYcmXOky89JJcGVzodaPEzMP0qYb1c7euqHNNQ/YjvsRscyYqDuyGdBtl/fKj86SSu+ikPWKNN8+shGd0qrcwfvt+tsJ/U/MuHuEPc/X7oWvtJFFFeoQpXQh8qDTlvSOasS4jORJMag4Fj89nAg+Er8FFjSPCOpFdR1elM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ejaddrhx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ejaddrhx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4544C4CED2;
	Sat,  9 Nov 2024 00:28:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731112111;
	bh=C7SFj4q4lLbVbx3tVScA0zWrHnfokGjWtxuW3ZW984w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ejaddrhxiuI6LbManrPYzvNdJtUX5+WsYnFFqOdK2SzvKPBiuK15KyZpBSYXDuRHo
	 dEBJflmyG5Im66K/Qd/fLtM90rWjEYxX28uLULVzb04PlS4h0yN9XnKyJtKR5cuk4i
	 ut5PuNMJ0OhQiKePYM6PTDEdI77j9hopNaQYbx83oTpw0tjgR3RaYtuctcBNwErlXM
	 L84FHUN+zOE8Up3ioQ04CCDdDzELSO8NpQZXpFrC+4QS/M5yJaG4IPqLcepXQ65q7J
	 7K0IYHy0IXVPOXw4bkUYdeJHobcRTxELnxNrmjG+zGY/fQWR6IU8+clPgd6jlbU3mF
	 fiiWEzVaJDLZQ==
From: Stephen Boyd <sboyd@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	stable@vger.kernel.org,
	Neil Armstrong <neil.armstrong@linaro.org>
Subject: [PATCH 1/3] spmi: pmic-arb: fix return path in for_each_available_child_of_node()
Date: Fri,  8 Nov 2024 16:28:26 -0800
Message-ID: <20241109002829.160973-2-sboyd@kernel.org>
X-Mailer: git-send-email 2.47.0.277.g8800431eea-goog
In-Reply-To: <20241109002829.160973-1-sboyd@kernel.org>
References: <20241109002829.160973-1-sboyd@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Javier Carrasco <javier.carrasco.cruz@gmail.com>

This loop requires explicit calls to of_node_put() upon early exits
(break, goto, return) to decrement the child refcounter and avoid memory
leaks if the child is not required out of the loop.

A more robust solution is using the scoped variant of the macro, which
automatically calls of_node_put() when the child goes out of scope.

Cc: stable@vger.kernel.org
Fixes: 979987371739 ("spmi: pmic-arb: Add multi bus support")
Signed-off-by: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Link: https://lore.kernel.org/r/20241001-spmi-pmic-arb-scoped-v1-1-5872bab34ed6@gmail.com
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
---
 drivers/spmi/spmi-pmic-arb.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/spmi/spmi-pmic-arb.c b/drivers/spmi/spmi-pmic-arb.c
index 9ba9495fcc4b..ea843159b745 100644
--- a/drivers/spmi/spmi-pmic-arb.c
+++ b/drivers/spmi/spmi-pmic-arb.c
@@ -1763,14 +1763,13 @@ static int spmi_pmic_arb_register_buses(struct spmi_pmic_arb *pmic_arb,
 {
 	struct device *dev = &pdev->dev;
 	struct device_node *node = dev->of_node;
-	struct device_node *child;
 	int ret;
 
 	/* legacy mode doesn't provide child node for the bus */
 	if (of_device_is_compatible(node, "qcom,spmi-pmic-arb"))
 		return spmi_pmic_arb_bus_init(pdev, node, pmic_arb);
 
-	for_each_available_child_of_node(node, child) {
+	for_each_available_child_of_node_scoped(node, child) {
 		if (of_node_name_eq(child, "spmi")) {
 			ret = spmi_pmic_arb_bus_init(pdev, child, pmic_arb);
 			if (ret)
-- 
https://git.kernel.org/pub/scm/linux/kernel/git/clk/linux.git/
https://git.kernel.org/pub/scm/linux/kernel/git/sboyd/spmi.git

