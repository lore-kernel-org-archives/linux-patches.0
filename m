Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76C973FF1A0;
	Fri, 15 May 2026 15:52:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778860351; cv=none; b=UuufJIowqQev6vz2FuaBn6MWK92WddATnU25wGdDP9twuqmcQch6XIvmUelQrX0Pd2WGfEHFrBBwquh4855JvEn2yQy9X4Zf+804ziLcDnj/5hugxesz66pwn05QmyX07P65Kiuq1zQp/s0Nas1hq5wenMJ++8VJf54gu2Vf970=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778860351; c=relaxed/simple;
	bh=pPNSHpc9HOfh1G125Mznmh4b6AW+M3AgoTwQ1bw3Nzs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ixw5+Y34cJsFzJATfjT3pPK03Mrj7a9Wu7yzgzeuLlWOwBMkME5HVy/mR8CwGXnxIQgIYPOgNQ00QjDmz06xwbMyqTC26q0Vj5woSSNZu8+4wc7qameMu7fpITltyQ/a5DRFv+lBSG8IzO3UZiwQ/huXJKXbikpNuEwwFmcdTbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DbqHFqqp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DbqHFqqp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C911EC2BCB3;
	Fri, 15 May 2026 15:52:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778860351;
	bh=pPNSHpc9HOfh1G125Mznmh4b6AW+M3AgoTwQ1bw3Nzs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DbqHFqqpmFA2cCJzTPwZGhsXUoVEMeeurrGH5rhu34FrTIesGqLmYRvXLdYcNseY+
	 6jls2cgZR+EkaecbOaUCP2cItEB0teIc9HL87q7E/252imR64/NoW6LoEBMMKXzZIM
	 Fm9wx1OM6Hi9b7JbdzjrNuXdu5bnyk9LruOZ/KIE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Douglas Anderson <dianders@chromium.org>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.12 018/144] regulator: rk808: fix OF node reference imbalance
Date: Fri, 15 May 2026 17:47:24 +0200
Message-ID: <20260515154653.918283733@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154653.469907118@linuxfoundation.org>
References: <20260515154653.469907118@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 65290b24d8a5f0b8cd065201e653db824c4a4da6 upstream.

The driver reuses the OF node of the parent multi-function device but
fails to take another reference to balance the one dropped by the
platform bus code when unbinding the MFD and deregistering the child
devices.

Fix this by using the intended helper for reusing OF nodes.

Fixes: 647e57351f8e ("regulator: rk808: reduce 'struct rk808' usage")
Cc: stable@vger.kernel.org	# 6.2
Reviewed-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260408073055.5183-3-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/regulator/rk808-regulator.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/regulator/rk808-regulator.c
+++ b/drivers/regulator/rk808-regulator.c
@@ -1878,8 +1878,7 @@ static int rk808_regulator_probe(struct
 	struct regmap *regmap;
 	int ret, i, nregulators;
 
-	pdev->dev.of_node = pdev->dev.parent->of_node;
-	pdev->dev.of_node_reused = true;
+	device_set_of_node_from_dev(&pdev->dev, pdev->dev.parent);
 
 	regmap = dev_get_regmap(pdev->dev.parent, NULL);
 	if (!regmap)


