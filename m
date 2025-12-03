Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04AD425BEE5;
	Wed,  3 Dec 2025 15:41:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776481; cv=none; b=Gnh+1VgbI8/T523SbqsgcIfulSg7wJmme0m/MacsowvqFenE23lkkQ54s2KZ07Y+xTObydamm95bEDuzfy1s+ZOQbGrrjKrE/XW42DdErTkliqT2xdSIi+uDrGuFhyk2LmCOUn5yOTPOGLo+8a0dY5bbKExns+NBmi8XcUwC2/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776481; c=relaxed/simple;
	bh=r/ylaEfih19tEja713RcDp0snWaqsF8QzYrp5jXNxyk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jQNHVyDRZ1TbcARcOOaeoNrV35kHSdYibdM36it0iUI54XdBcL/eiUFTRkb5QrFs9iK2zmjbWtDruc6eKAQdc6dVZIb4y/q2zYlfFws4I8Eqgz8DP3aZWPZ7qnkqp0PAzLSxj+EIKgViIXngDc2m3hiKjU+0l/xqbq+9lTQ8zeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y33aEl4S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y33aEl4S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D34DC4CEF5;
	Wed,  3 Dec 2025 15:41:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764776480;
	bh=r/ylaEfih19tEja713RcDp0snWaqsF8QzYrp5jXNxyk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y33aEl4SURAPx6M3nelamgW3IckJi8KJqBiEk5UGfb8mUrEGSlt9XhygUAIYaWgAH
	 Cf7KTZyZTcku6XJyrURFhcJVUrg8kmKocFMWdq6x7olYH+FyMJsVYCpfHKjPZd4LJv
	 dxa0ouBhMt/k+6L9fPnMZQlbRWKmBRVKYu4zp5AI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Morgan <macromorgan@hotmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 195/300] regulator: fixed: use dev_err_probe for register
Date: Wed,  3 Dec 2025 16:26:39 +0100
Message-ID: <20251203152407.850150729@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152400.447697997@linuxfoundation.org>
References: <20251203152400.447697997@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Morgan <macromorgan@hotmail.com>

[ Upstream commit d0f95e6496a974a890df5eda65ffaee66ab0dc73 ]

Instead of returning error directly, use dev_err_probe. This avoids
messages in the dmesg log for devices which will be probed again later.

Signed-off-by: Chris Morgan <macromorgan@hotmail.com>
Link: https://lore.kernel.org/r/20210721165716.19915-1-macroalpha82@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 636f4618b1cd ("regulator: fixed: fix GPIO descriptor leak on register failure")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/fixed.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/fixed.c b/drivers/regulator/fixed.c
index 4acfff1908072..49e162b3cf42d 100644
--- a/drivers/regulator/fixed.c
+++ b/drivers/regulator/fixed.c
@@ -238,8 +238,9 @@ static int reg_fixed_voltage_probe(struct platform_device *pdev)
 	drvdata->dev = devm_regulator_register(&pdev->dev, &drvdata->desc,
 					       &cfg);
 	if (IS_ERR(drvdata->dev)) {
-		ret = PTR_ERR(drvdata->dev);
-		dev_err(&pdev->dev, "Failed to register regulator: %d\n", ret);
+		ret = dev_err_probe(&pdev->dev, PTR_ERR(drvdata->dev),
+				    "Failed to register regulator: %ld\n",
+				    PTR_ERR(drvdata->dev));
 		return ret;
 	}
 
-- 
2.51.0



