Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54CDF3FF1D5;
	Fri, 15 May 2026 15:52:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778860379; cv=none; b=EvuZdULb+EmA6AYBCrQF0hf5GrC/0ud6LwZ0uH83/8SpSCtcXQ//y1ssb7z6qzRpbHSUFJWwm3zQudZ25SVC6j59btY6vSlWnS/HvD9qiPBXE912ahl1FFkgOQh1vVE1SEzk5WEy1g3U5rC3rD73hKz1LTBcc7z40/RMGy31C2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778860379; c=relaxed/simple;
	bh=8m6XXosSJI3OOqQpaiBXPD5x3GbkDMkLE2x08//EwFA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MO1z8rVw8u4UiyTdYEouIyj+6P8mGeYdjIiuP9koeNmFAXTZvXu5Ksp3lukOp60KfFCXduS7dlgPrTqzADxSr6CC3t3SIc+/uzn9OXLb6y1oxs1Px4Ud/SOtk8XtwR8XRpT0f7yRi03NUZzYxaBDItayMIyg3ekaZn0yIp87t6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nqmXy9Du; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nqmXy9Du"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF83CC2BCB0;
	Fri, 15 May 2026 15:52:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778860379;
	bh=8m6XXosSJI3OOqQpaiBXPD5x3GbkDMkLE2x08//EwFA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nqmXy9Duu71mIGTMKi8LDdAbGey4aiHaD727kG8nRussik7PHZYwykXcb1zQKVkL9
	 WOg6DercGQuvks6c8cBhGlwzSoIukyz026PBeBxFNULZndE20KvfXXdZzXqMp6TGZx
	 /PM+GzvMvGd4CA0wtmC78yB9S5obpeGlHPOuf+zY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.12 014/144] regulator: max77650: fix OF node reference imbalance
Date: Fri, 15 May 2026 17:47:20 +0200
Message-ID: <20260515154653.821553232@linuxfoundation.org>
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


