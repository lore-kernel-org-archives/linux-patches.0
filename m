Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B21D61BFDFC;
	Mon, 14 Oct 2024 14:52:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917578; cv=none; b=pWn4Du+FEGwA0ciz9f9SUyW5EMOEF+Hvs86Sv6+lQW8iR4FH1ajG01EkQ54WFoPFMVQkCqYElPbYP0oLVCm5mCP0dw6/usH4XZQqTYwRohFRzoxMzpHF+HFDE2v5Gy6E/NzxYTAONFzb9RM/2Q4HIhLbTXgCKmIgFR87jKTRxdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917578; c=relaxed/simple;
	bh=Gwt0RXJRwdslSWSDrGS8e2dYyjg1wO1bW2yTdPUEvB0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L8QfGyWLQ2ODzkgRc+UjZscYpGLyntKvYSJDRg+S92brM2KmwXq7gaXSRPYdcMnBXj4Yk9gxOFAHNa8M6fRcbnkeU4Dl7u71q0zIdjTth4jMl+0fmxmBgGd+hyQ0XYKNCetaSYghF0bQAOjdekkrxHnf8vMwWnDSdDx7/yzpJp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nRk8leZ+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nRk8leZ+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35018C4CEC3;
	Mon, 14 Oct 2024 14:52:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917578;
	bh=Gwt0RXJRwdslSWSDrGS8e2dYyjg1wO1bW2yTdPUEvB0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nRk8leZ+5YcEC8ltGoNgQ7CoQxFeqCmhxMaUrkUMmRs6Z5r+LMlTdLgNNU+ZWxpjM
	 3UT9sD7LxjRRy9WHiZ44h9kAIlD1xwsVdApghPGU7c3Kn8Q0OMT7phyCoXxlZ5Ie72
	 bEW5rfcMhK68vwYaUOBbCYHHqTOQ06Tku7MaRdU4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen-Yu Tsai <wenst@chromium.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 072/798] regulator: Return actual error in of_regulator_bulk_get_all()
Date: Mon, 14 Oct 2024 16:10:26 +0200
Message-ID: <20241014141220.767948979@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen-Yu Tsai <wenst@chromium.org>

[ Upstream commit 395a41a1d3e377462f3eea8a205ee72be8885ff6 ]

If regulator_get() in of_regulator_bulk_get_all() returns an error, that
error gets overridden and -EINVAL is always passed out. This masks probe
deferral requests and likely won't work properly in all cases.

Fix this by letting of_regulator_bulk_get_all() return the original
error code.

Fixes: 27b9ecc7a9ba ("regulator: Add of_regulator_bulk_get_all")
Signed-off-by: Chen-Yu Tsai <wenst@chromium.org>
Link: https://patch.msgid.link/20240822072047.3097740-3-wenst@chromium.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/of_regulator.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/of_regulator.c b/drivers/regulator/of_regulator.c
index 1b65e5e4e40ff..59e71fd0db439 100644
--- a/drivers/regulator/of_regulator.c
+++ b/drivers/regulator/of_regulator.c
@@ -768,7 +768,7 @@ int of_regulator_bulk_get_all(struct device *dev, struct device_node *np,
 			name[i] = '\0';
 			tmp = regulator_get(dev, name);
 			if (IS_ERR(tmp)) {
-				ret = -EINVAL;
+				ret = PTR_ERR(tmp);
 				goto error;
 			}
 			(*consumers)[n].consumer = tmp;
-- 
2.43.0



