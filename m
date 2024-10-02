Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 360051EB21;
	Wed,  2 Oct 2024 14:47:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727880475; cv=none; b=HdqFxUsxzj8uj14S3ZOl6t1UC7Phvfd1W3dyjO4FeiZTsoc2FxHVpciNrfA0DA64W901JUMycodQ9JnZYU2IincinqgtF1d5axzGqrhq7C8f5cxXj2eKOGPIodisA5VgkLEHec10Pw/yJ9FMufKLBhzuBKbWO1l5D8n2DiYRGHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727880475; c=relaxed/simple;
	bh=ClrtcBi4srdSPLcpbSoejTMO6luHopHRCOgvzGFy3RU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AsbeDFR1RztIzBPHXXrOJ4mzjlogn3hMjOOXQlNnKlTF2KPL6gA9C3/c61TKSDnm9/13WWHExGGPYvhKb8m0AkZ7JFgmbO7jfQEP+awDbxNnQ7HOMN3jOqGC83nPlND1ErQI6QPmd5XEH9usOlBovrjTiGEnpBFvoOt1b/mrvsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i1nmqTRa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i1nmqTRa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C546C4CEC2;
	Wed,  2 Oct 2024 14:47:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727880474;
	bh=ClrtcBi4srdSPLcpbSoejTMO6luHopHRCOgvzGFy3RU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i1nmqTRaHRCtultj0EDZFuEGKpggQ2/wzVWXPD9dhUvZzWX4xqiKuR1JI7T/OBbPy
	 1qEb7gCnJXEZ5Bdsfko79k4OOwaozaoGmf4OOXROhlyCZqkP51XSvyy0fq2Lt+5jBg
	 QaHm92rzVq8SqWDvwf6AEw7zDn8dD1l+DL2VuECI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Liviu Dudau <liviu.dudau@arm.com>,
	Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 6.6 439/538] bus: integrator-lm: fix OF node leak in probe()
Date: Wed,  2 Oct 2024 15:01:18 +0200
Message-ID: <20241002125809.766790770@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

commit 15a62b81175885b5adfcaf49870466e3603f06c7 upstream.

Driver code is leaking OF node reference from of_find_matching_node() in
probe().

Fixes: ccea5e8a5918 ("bus: Add driver for Integrator/AP logic modules")
Cc: stable@vger.kernel.org
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Acked-by: Liviu Dudau <liviu.dudau@arm.com>
Link: https://lore.kernel.org/20240826054934.10724-2-krzysztof.kozlowski@linaro.org
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bus/arm-integrator-lm.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/bus/arm-integrator-lm.c
+++ b/drivers/bus/arm-integrator-lm.c
@@ -85,6 +85,7 @@ static int integrator_ap_lm_probe(struct
 		return -ENODEV;
 	}
 	map = syscon_node_to_regmap(syscon);
+	of_node_put(syscon);
 	if (IS_ERR(map)) {
 		dev_err(dev,
 			"could not find Integrator/AP system controller\n");


