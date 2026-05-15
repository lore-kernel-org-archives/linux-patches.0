Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F6C33F9272;
	Fri, 15 May 2026 16:18:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861895; cv=none; b=QxkaP3Ex2aMOZQi0FXv0E97Nq3fbLXkaSGnLZql8Np3+FQqKNb1L4tFnZnr8mV/WYLArKsLQeI1nKNeNj8MNEHX/FCUgk2cj8t0rzymtAoF7k5oW2A5BlhRkdm7rYtYCTEdce6qyvrgaTXqA5odmgEgzne5h5t0yMzy02FhmHP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861895; c=relaxed/simple;
	bh=6T4kRg2ocfyC0YjvOjSHuCbOaP6UuXuckBKOJUCoyDM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bthl/VAMCLCu7REMpwvoTAowNl0izYjFQ7qHUP1Hsqh9Ryzqry6TbdPGnSg2dfS4iO2OWvoFdHU2sV9JUvyl+HQbpDAZ/AOLkK4UqsOrScdGAClti1+f7znChNMIo0955fmQyoE5muiY8ht1NPMmLRiNH9YlDlvP2RISrLHCqv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pnu5xreI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pnu5xreI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C99C8C2BCB3;
	Fri, 15 May 2026 16:18:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861895;
	bh=6T4kRg2ocfyC0YjvOjSHuCbOaP6UuXuckBKOJUCoyDM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pnu5xreIDLwHlJk6s+OFDe1zwMktc2Z8OuQ8GRaveeweFXOWfymBwHLccdIHocJNK
	 bDzy1/Zjs1esZ27l8CqbXXUBskTurMcjGINx2Zus4AePS7+7ciX2rnGD5pPy876MPI
	 I50nlUAr3/TL6ZRUXuN9KkJworUUkHcQYDiqSyP8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Douglas Anderson <dianders@chromium.org>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.18 030/188] regulator: rk808: fix OF node reference imbalance
Date: Fri, 15 May 2026 17:47:27 +0200
Message-ID: <20260515154657.961075693@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154657.309489048@linuxfoundation.org>
References: <20260515154657.309489048@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1875,8 +1875,7 @@ static int rk808_regulator_probe(struct
 	struct regmap *regmap;
 	int ret, i, nregulators;
 
-	pdev->dev.of_node = pdev->dev.parent->of_node;
-	pdev->dev.of_node_reused = true;
+	device_set_of_node_from_dev(&pdev->dev, pdev->dev.parent);
 
 	regmap = dev_get_regmap(pdev->dev.parent, NULL);
 	if (!regmap)


