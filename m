Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCD6A311957;
	Mon, 13 Oct 2025 15:09:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368176; cv=none; b=LLtedKjxX50BFzBFbqiW4UuvLbnbg4j9Xq5j6LFMIEt0ExjCeS9Fdd53t6GpA+tEjIMr1YuvB4RpHvmeI1HuKdaPMeYD94z42SY21IQREaoGHYLKtv9ZjUjV/o9LQ6+M6xty0EKdYirLAwSnSoJyTcbWoX9Sc+RtMPNm5tTqlao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368176; c=relaxed/simple;
	bh=AlGXSfXk0hRNlNgMDH7ExD3E/qMqHN1mUAYEDBumZvE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nD4kXinq1pEwdc2C/PTuciGr31+phQ9u3GF0wDHR2rLyImYa/dmCl++iIX8rEEXc/90mQFHgyzrV1VIslrGcORns+K/e9Tb+N/+BBd3STfUvjqjK0JwUIT5da531nO07yyuL8SZoS4TRVe2PGcinqzHm8oi73CjaCF3JJ3HIcqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hD9/Fqgb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hD9/Fqgb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59003C4CEE7;
	Mon, 13 Oct 2025 15:09:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368176;
	bh=AlGXSfXk0hRNlNgMDH7ExD3E/qMqHN1mUAYEDBumZvE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hD9/Fqgb0BUDAwB7pCE995X3Rh61r00787e7H6o6+X3lHYbS620sYBZblOO4uQ03E
	 xaVU/gHZ1YkS06jTpVDC+NQOh/mAlu9WQE/s3lI1GIGJaSf1nd1R/JWIWv4q9/qZU3
	 i0eEMN7kOkOVAjv6M4qCU9LZnxdxDP7vjOr/2sNI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qianfeng Rong <rongqianfeng@vivo.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 037/262] regulator: scmi: Use int type to store negative error codes
Date: Mon, 13 Oct 2025 16:42:59 +0200
Message-ID: <20251013144327.468351503@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144326.116493600@linuxfoundation.org>
References: <20251013144326.116493600@linuxfoundation.org>
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

From: Qianfeng Rong <rongqianfeng@vivo.com>

[ Upstream commit 9d35d068fb138160709e04e3ee97fe29a6f8615b ]

Change the 'ret' variable from u32 to int to store negative error codes or
zero returned by of_property_read_u32().

Storing the negative error codes in unsigned type, doesn't cause an issue
at runtime but it's ugly as pants. Additionally, assigning negative error
codes to unsigned type may trigger a GCC warning when the -Wsign-conversion
flag is enabled.

No effect on runtime.

Signed-off-by: Qianfeng Rong <rongqianfeng@vivo.com>
Reviewed-by: Sudeep Holla <sudeep.holla@arm.com>
Fixes: 0fbeae70ee7c ("regulator: add SCMI driver")
Link: https://patch.msgid.link/20250829101411.625214-1-rongqianfeng@vivo.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/scmi-regulator.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/regulator/scmi-regulator.c b/drivers/regulator/scmi-regulator.c
index 9df726f10ad12..6d609c42e4793 100644
--- a/drivers/regulator/scmi-regulator.c
+++ b/drivers/regulator/scmi-regulator.c
@@ -257,7 +257,8 @@ static int process_scmi_regulator_of_node(struct scmi_device *sdev,
 					  struct device_node *np,
 					  struct scmi_regulator_info *rinfo)
 {
-	u32 dom, ret;
+	u32 dom;
+	int ret;
 
 	ret = of_property_read_u32(np, "reg", &dom);
 	if (ret)
-- 
2.51.0



