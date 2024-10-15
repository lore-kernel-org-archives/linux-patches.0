Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01D841AF0A9;
	Tue, 15 Oct 2024 13:06:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997590; cv=none; b=fdqxAaF69bVBBhpSVPN/i11DNFhNnw7B1yilSPGygdixsnUsP864Aw54WnKtNj786NwEgjMDHJgtoy73CCnfNAvpGA62NaH/oJ0538vaJxt058oou9itWO6hF+4Od8dSA/nP6WnFOeZpb3AUMUjl45uhnJHRDMbX3qgR6qyrBaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997590; c=relaxed/simple;
	bh=SmWxTgffQNBx/Hr8ZOJeyY2FbMLjgtSGP89fc0doGLM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KTUxe1IgPBpAHF6BtyeMn3UjUsFCBDuok6ZVaV4Bhm2hcXu3O0NdX3UxsjYi8OV/kBSXxfHAKEjD5l0dEp+uXplR5qiW9Pkk4XlmvekZmi8rQ7BTFk+PuqtTdiqMtnYqv885oKLMjdLvE5zSTZePHJP16EV1bCW/6cP+jz8EhIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bgxktVhj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bgxktVhj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71862C4CEC6;
	Tue, 15 Oct 2024 13:06:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997589;
	bh=SmWxTgffQNBx/Hr8ZOJeyY2FbMLjgtSGP89fc0doGLM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bgxktVhj07EhzUEmCWPh3jyAt88M1xLR/UixUj086yvioJuUwx7af5cvxRUvafRaa
	 B+TDiBmAGjqbIEAEwrm+IF9fGzOFL2H9p8PW7dCgyn5XkXtEMJ3WJLyrWfA36R7lhb
	 RP3zAmYpBiTGRpN/aGFdVnkGi6M3STbLe9JTDRxw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Liviu Dudau <liviu.dudau@arm.com>,
	Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 5.10 227/518] bus: integrator-lm: fix OF node leak in probe()
Date: Tue, 15 Oct 2024 14:42:11 +0200
Message-ID: <20241015123925.757709976@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -84,6 +84,7 @@ static int integrator_ap_lm_probe(struct
 		return -ENODEV;
 	}
 	map = syscon_node_to_regmap(syscon);
+	of_node_put(syscon);
 	if (IS_ERR(map)) {
 		dev_err(dev,
 			"could not find Integrator/AP system controller\n");


