Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A5A514B084;
	Fri,  6 Dec 2024 14:42:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496122; cv=none; b=LLtJqhL+oNaUdKDMNVitJl5aYYxRcLn7AChIsRGw05ETFquvJYmzAWINQvMOZK9vwyBKGCEvYs63BPZki3NAXsuXTETSEOclOZzIBOtiUtbCCJRQDykyJtceNqKtg95oWw5FMM9x2+64ePPNQhGEu4zAY/vnFXmgUwKC1emUmuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496122; c=relaxed/simple;
	bh=CcsaJwcPwyGQF6Th8/R/50wComTvj4gj/lm8IUpcV+E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OS+yf2O1DWHwmoKzpxYU0aQpTWB5XpFSTnM+GpSPoAYPgl4yLkUi++uYuLeR/UxKyNzFu2XI4B0GuEQ0c1vEHtAMhwbJ8eTV7XckwGPzS53+HDBATD33tJ4Oa5lJLd9wDPEivDtC2gqzkicQAL6R5ebdHxVE9/U+WmOHM+r59AE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TXimZ7SJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TXimZ7SJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F1A1C4CED1;
	Fri,  6 Dec 2024 14:42:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496122;
	bh=CcsaJwcPwyGQF6Th8/R/50wComTvj4gj/lm8IUpcV+E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TXimZ7SJl3ed+Ew68BnBRFS/POjf0MtiScLuPXUduiYnP2rg2fKdazp4xw7OL1ldk
	 Ch6fnIZRi0ZEn04m6D7jvjPzkap4v25LcEbVkseCeNJpLCV+kasxxgtuTLw5xZL3mX
	 2GqjG6M2fmH9WbUhhodOocxaChTv6FJldlMsrKiA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Stephen Boyd <sboyd@kernel.org>
Subject: [PATCH 6.12 058/146] spmi: pmic-arb: fix return path in for_each_available_child_of_node()
Date: Fri,  6 Dec 2024 15:36:29 +0100
Message-ID: <20241206143529.895782363@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143527.654980698@linuxfoundation.org>
References: <20241206143527.654980698@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Javier Carrasco <javier.carrasco.cruz@gmail.com>

commit 77adf4b1f3e1fdb319f7ee515e5924bb77df3916 upstream.

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
Link: https://lore.kernel.org/r/20241109002829.160973-2-sboyd@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spmi/spmi-pmic-arb.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/spmi/spmi-pmic-arb.c
+++ b/drivers/spmi/spmi-pmic-arb.c
@@ -1763,14 +1763,13 @@ static int spmi_pmic_arb_register_buses(
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


