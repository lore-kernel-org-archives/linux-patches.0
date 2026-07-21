Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B85045A299;
	Tue, 21 Jul 2026 21:05:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667912; cv=none; b=th4SZoV7AoHnCG1W+83fyX4dFqpNaOhlZXT6ADjhzSYEpEWSllyBAsoB4WvboqE0/ZPr70vOCe8RpYTZyUyLh8eyZF6yQBImYE21hi2AHGZblDfGo9CRWqkX3UvrqXY6fh97TvIjQir9haamWXpExa4PdwjP2/KwboooLyxLBus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667912; c=relaxed/simple;
	bh=bkjOGjQ5wnf+nvEiieInt+0SolWmoMiSUlws3MF9ENA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z1Tu8xZ/XQTuGUZkjVLgIlCoRqUAusRE8umc5X29x1GX1y1GFehAMv2w7HPNuPfMbZfYjaU77KfNVoI/8O8cuEvJGYejJ+XaYkYgcgtU8NMySs2zzk2V/yYxECdGzCxK/OS9eL0d+jBlnom7q2c6F7ZmmhBlO8HovSKnTlYw+LM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Too6MXrK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Too6MXrK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 465511F00A3A;
	Tue, 21 Jul 2026 21:05:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667906;
	bh=a5jZSKDaOsdVGZQ39O9cBjuWQ8ceflpc/08oymowhS8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Too6MXrK0Ws3grlOH06/Rl+6mkm8XjxuI0WMZbpCy6iqH5ISA3Gf5FClbts2SYJUo
	 ZHH7jJKvjLIS95oy5A7dvcuKy2pRuNYVXRkb2BMsC1frB4BxQSZXwUL0euaKEGun6/
	 0cmWi1ahVqkMSW1wjB3vlbZRnH9zH6F5zq5BcLqg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1236/1266] regulator: scmi: Simplify with scoped for each OF child loop
Date: Tue, 21 Jul 2026 17:27:53 +0200
Message-ID: <20260721152509.471825246@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -342,13 +342,11 @@ static int scmi_regulator_probe(struct s
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


