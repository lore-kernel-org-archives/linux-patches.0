Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BF9419B3FF;
	Tue, 15 Oct 2024 11:52:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993143; cv=none; b=m8YncLsbgfF37AInKNvF4++BoCtPAmKIccbxWdqYGdAt275lCFUft9Y329PUfbdyHD4cMfkj4NFvWBPZf45QebxRgr76EFH/Ik7bPv9PXnBxe2Rp4u968ET9rMEUGyPnAHt3mqj5GiUSKDadzFj5agISQn/JtlrKCIzmQq1YHUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993143; c=relaxed/simple;
	bh=/f4j18Lclc8Cmv8Zz2qIjvLmyqilAV9buBZrOgFj7lw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gecNF5p/DAb2nonUoKQpzuSJs8HYKqKxubW1EHHgNeZY5Me9mtIeZzqeZAWss5i1QgjWTGbjsdJmtqX+R0vq6ooOQdoQi4hf+WX2ThJVg2EV2d2KbSFrCwW92AGIa1+p+Q26C6HU6QSJDpG754fhkCDpKcZ1ME4nxpq/tJxye64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DPw3fukL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DPw3fukL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DF91C4CEC6;
	Tue, 15 Oct 2024 11:52:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728993142;
	bh=/f4j18Lclc8Cmv8Zz2qIjvLmyqilAV9buBZrOgFj7lw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DPw3fukLHvciQZs91+yemdA4GQjPPImyEQDr++SUMVgF9plwFnx/7B5HwHZ3Ef23n
	 PKd0MWagPVFpaTXJAPco/8SSSEfZV0Vq6Usfu6d9J8hJUQT9jH0/HJK/VD7vToCz/8
	 7dJQv0Vmp6DDdx6ipUNL9Ub/NuViptxtRAlNU6eg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Liviu Dudau <liviu.dudau@arm.com>,
	Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 5.15 324/691] bus: integrator-lm: fix OF node leak in probe()
Date: Tue, 15 Oct 2024 13:24:32 +0200
Message-ID: <20241015112453.196977173@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


