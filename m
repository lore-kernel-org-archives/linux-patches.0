Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C8F16BB39;
	Tue, 14 May 2024 11:32:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686361; cv=none; b=i+T5vdoDeptbBRv5Tmiigj3VHuRorqZenjpQndgjCyyrECYklVg4aDF5LBn7S4RpKS3YRG6wJaLR2cAwcGEWUPh0G97Jz4indr2lHhxAJNZGThgD4W9gqMy8wMbNoTnN/YVTAOXg1BUPNL7lF0iC0UbfoxQV/HRkkeeq/9UTS4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686361; c=relaxed/simple;
	bh=dNUVNrPSLOrSqrOq4FWJgD9OT3x9SfGwc2LTZE9G8PY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=negH4L5tnM6SGi+3Q1kXRvTXXjBk8Nx4HDZZ7DxvGR/5zOOFnGeuKOfVhz4QsiCCSGz79ek7wcN1pDZfzc1yt4qyeEccvEi1SFR/caFJRdNO7+MXw8JeUzpy5B+hgbmcXddjIVKFJGmB/Tp3XtSDjZv3h6hxD9MpzcPmyai1NbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fmESpVqg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fmESpVqg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23F2DC2BD10;
	Tue, 14 May 2024 11:32:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686361;
	bh=dNUVNrPSLOrSqrOq4FWJgD9OT3x9SfGwc2LTZE9G8PY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fmESpVqgmVNdrtSMWuP0H7DabbiWHSsV8ZrX6QSqu3dgAj3ZHTFYzRe2ZcAWu3c1l
	 Mg+a5LS+nTzGmb4aP419dAbB4mQVb6xgnermtTGuCh3ZRLs7au5xzoPg8E47qkNZf+
	 2wmseQcGqP+wOhznEtbxgCUptSpP22okDJwC1MJs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ni <nichen@iscas.ac.cn>,
	Damien Le Moal <dlemoal@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 110/236] ata: sata_gemini: Check clk_enable() result
Date: Tue, 14 May 2024 12:17:52 +0200
Message-ID: <20240514101024.548280673@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101020.320785513@linuxfoundation.org>
References: <20240514101020.320785513@linuxfoundation.org>
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

From: Chen Ni <nichen@iscas.ac.cn>

[ Upstream commit e85006ae7430aef780cc4f0849692e266a102ec0 ]

The call to clk_enable() in gemini_sata_start_bridge() can fail.
Add a check to detect such failure.

Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/sata_gemini.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/ata/sata_gemini.c b/drivers/ata/sata_gemini.c
index c96fcf9ee3c07..01f050b1bc93b 100644
--- a/drivers/ata/sata_gemini.c
+++ b/drivers/ata/sata_gemini.c
@@ -201,7 +201,10 @@ int gemini_sata_start_bridge(struct sata_gemini *sg, unsigned int bridge)
 		pclk = sg->sata0_pclk;
 	else
 		pclk = sg->sata1_pclk;
-	clk_enable(pclk);
+	ret = clk_enable(pclk);
+	if (ret)
+		return ret;
+
 	msleep(10);
 
 	/* Do not keep clocking a bridge that is not online */
-- 
2.43.0



