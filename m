Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A8E829CE7;
	Wed,  2 Oct 2024 13:48:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876881; cv=none; b=CcFlM5ac8UpOo3fz4Fopx5+co4drC8kbLWky5ktF15b4S6VeEk4mmOpwOiqcwkm34/OKRXTAQJPDOe64G2/wbgTtkM7j/tuhK/ocfPsi0yhxYRXztclH5xiCxRygShc5qexaF4Reu508U7ySXnBjXMq9V52n+/Bc/sCWnmpo1hs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876881; c=relaxed/simple;
	bh=D4J3ZjHWqRqbGAj0p0KAjf3Kqt0nW778CampIwtcr58=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JjERepilJdXhSySDBlxBSbUe4pFAzbuN1IQu1XhNpk05Mnj/jccACwy7zjCBPFWwKgJXy0lqINvOHbD7lcxSjsCJosMwx8d2sT6NQZWDv0oXdZvkz1bgL1giKSkOt62izc6zmo0jBzFMVQ0g3zaKIMFuGlXJ+HqI7hMTHPkmDac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sFNOVSq2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sFNOVSq2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D264C4CEC2;
	Wed,  2 Oct 2024 13:48:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876880;
	bh=D4J3ZjHWqRqbGAj0p0KAjf3Kqt0nW778CampIwtcr58=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sFNOVSq2xyMGsvdZouqDs7GdvTgZEyxEUyRDD66MLyo2cGj1PKyvwdPRrsAv0lBaR
	 CrXdYPHibIbBtKXxmkf3xGF/DI0bKGKpQTBEYU3WRDz6DHFB50eaiKi+ESFGvG4eN/
	 kBgqv4dNHbhr7qgkUhc4UYngdZgvej53NZV0UdHs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Liviu Dudau <liviu.dudau@arm.com>,
	Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 6.11 590/695] bus: integrator-lm: fix OF node leak in probe()
Date: Wed,  2 Oct 2024 14:59:48 +0200
Message-ID: <20241002125846.061169061@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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


