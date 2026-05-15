Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9E194BC030;
	Fri, 15 May 2026 16:26:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862403; cv=none; b=YO8qUy23RY4cZkf0ImOUOGbh1ZE8OE75q22ZUUiyS93328CeCmYJq8HISFx8D92dix9CR1p8CrAUm8PHId2zTQVUiwU+lcLiMwRl8pL13v3EU9rx/dKLNFXAbdtU4jvh7jK6Ejx9Jn2H37FUYKlH0sr9qEvkU8NwA93I22CO5AE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862403; c=relaxed/simple;
	bh=oPmqS/PKJqdXAD/wxKza3lFqD6G7BUiVOAsu7k1tkHI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sOSYcJap37JiNjPxms1LJWSJPG89cWFjM+2Q+8GtM3ZfZRLNlmD0Q7dU2yZJW5stT30oBI40Diow6UVFt3pQj1X6STwkLe1L4sqBtJbfSg5sRNgW50jZ/CdvlxYkNJoFyZRBPQlSlf0NNilbA2eH7n8QCThbQpasucoj0R1tuJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tihu5GTG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tihu5GTG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E0C0C2BCB3;
	Fri, 15 May 2026 16:26:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862403;
	bh=oPmqS/PKJqdXAD/wxKza3lFqD6G7BUiVOAsu7k1tkHI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tihu5GTGaHJ333gUrfSz2TaHr8zBFNmDsM3l8p25DKs91yNp8g27vqnrqSr3YsEAc
	 iECtH9aS+rtK5RxesKV3mmemdw147DQseF1L3Mg7aVB1xiXz98GifRO38ac+W57TRO
	 xtWCFU69u+fL8i4x/69A2ux1RpDF8GHmfl9LXAg4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 7.0 034/201] regulator: max77650: fix OF node reference imbalance
Date: Fri, 15 May 2026 17:47:32 +0200
Message-ID: <20260515154659.273318402@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154658.538039039@linuxfoundation.org>
References: <20260515154658.538039039@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 2edaf5f7ada0ab5c9ec1f0836bd19779a8d85262 upstream.

The driver reuses the OF node of the parent multi-function device but
fails to take another reference to balance the one dropped by the
platform bus code when unbinding the MFD and deregistering the child
devices.

Fix this by using the intended helper for reusing OF nodes.

Fixes: bcc61f1c44fd ("regulator: max77650: add regulator support")
Cc: stable@vger.kernel.org	# 5.1
Reviewed-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260408073055.5183-4-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/regulator/max77650-regulator.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/regulator/max77650-regulator.c
+++ b/drivers/regulator/max77650-regulator.c
@@ -337,7 +337,7 @@ static int max77650_regulator_probe(stru
 	parent = dev->parent;
 
 	if (!dev->of_node)
-		dev->of_node = parent->of_node;
+		device_set_of_node_from_dev(dev, parent);
 
 	rdescs = devm_kcalloc(dev, MAX77650_REGULATOR_NUM_REGULATORS,
 			      sizeof(*rdescs), GFP_KERNEL);


