Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3242135C6B3;
	Tue, 21 Jul 2026 21:52:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670721; cv=none; b=GfKN4yWnFdjrcKT/C9c96ANOz1NAjj0ive/4mwhO05qVnArEnRxgq/6yY4i7dAGJbg+MiIjRfVDhIz7ixIlEVJcm1gDxlPJxJMrNQ0OfK3OBL+pFt2OCnJcMFSlRvZklDQqICRp7TujPmyUAVGJMabBvLdAPWKPW7Xlg438nFrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670721; c=relaxed/simple;
	bh=46n41bND9hXtbLi/CCFZYr0Vc6U2yzVWj0bM/NDNW/E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pYwMhmVwXfA2+bND6qWLXIyEjfy7/XaL5b43QhoMBL6LlGJw/GbIUHpuRwi4rtVsaGOYFEsCuWJqVrTIy7ZhBO+OdGQr3D7oQDhO7mQKpr7oUYrvIhUG01A6OGpP2IxH8JyxvdqCM5dvv7l3kROE6FrUR/p2C3Dtf43iBIn/syM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dT+ewcsf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dT+ewcsf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 926CF1F000E9;
	Tue, 21 Jul 2026 21:51:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670720;
	bh=TVO8Xh4wNu2mUxvGPMrSAjWCttqPmRN83QTm1CJDldU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dT+ewcsfWKYyfPDbowca1v93MLLTFYRYf2uliaIsQd+/GUlBtu6uq43BNUY7eUJJz
	 cFijNNEQL46Td2m2UxB+lO8qIAKZ6BWXjhhqdgIxHLR4opsQrm6P42BgEMl+4ij5ls
	 Vi/rGztFNkhilvMs0SVgRQXk9fUIcWI7a0qJ+Pb0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1040/1067] regulator: scmi: Simplify with scoped for each OF child loop
Date: Tue, 21 Jul 2026 17:27:21 +0200
Message-ID: <20260721152447.853877085@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit 99cf5db9cdd39136fd5dbd10bda833aa0f870452 ]

Use scoped for_each_available_child_of_node_scoped() when iterating over
device nodes to make code a bit simpler.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://patch.msgid.link/20240814-cleanup-h-of-node-put-regulator-v1-7-87151088b883@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: fa11039d6cdf ("regulator: scmi: fix of_node refcount leak in scmi_regulator_probe()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/regulator/scmi-regulator.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/drivers/regulator/scmi-regulator.c
+++ b/drivers/regulator/scmi-regulator.c
@@ -298,7 +298,7 @@ static int process_scmi_regulator_of_nod
 static int scmi_regulator_probe(struct scmi_device *sdev)
 {
 	int d, ret, num_doms;
-	struct device_node *np, *child;
+	struct device_node *np;
 	const struct scmi_handle *handle = sdev->handle;
 	struct scmi_regulator_info *rinfo;
 	struct scmi_protocol_handle *ph;
@@ -346,13 +346,11 @@ static int scmi_regulator_probe(struct s
 	 */
 	of_node_get(handle->dev->of_node);
 	np = of_find_node_by_name(handle->dev->of_node, "regulators");
-	for_each_child_of_node(np, child) {
+	for_each_child_of_node_scoped(np, child) {
 		ret = process_scmi_regulator_of_node(sdev, ph, child, rinfo);
 		/* abort on any mem issue */
-		if (ret == -ENOMEM) {
-			of_node_put(child);
+		if (ret == -ENOMEM)
 			return ret;
-		}
 	}
 	of_node_put(np);
 	/*


