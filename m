Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2F6F320F;
	Tue, 14 May 2024 10:35:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715682912; cv=none; b=feSxWdhyj0nF0AkeCapxBj3KMW6fYe/8Cvj0/iw2McyENjavvNlLk8J9ds1E1prV34hKxFT0k1nPxQV3TVKCaHVEe5YzcLb5kM5vW2xi/0WRGY510hS/RRK4l9obru33fee7LN7L0eqje2i951DgE0tOYYRFpJT63LFj8sQY85E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715682912; c=relaxed/simple;
	bh=AB9iJeK8/8er4H2wZhMExfE9yF69IvChLvrg4DzCyBs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gnXBU+dUrkBIGbNg0+p3b/BXHbkqy9jO3MYADGdV8YL07O8y9rj1DpDX4NDNTRQTnmoSX46dY/cldLJghzKL4d1rcprWGk0sQoqpNjcEx4ZVhJ6xjw8mpiPDGo1r9OJ/4KuBaNFu/9YXRdSGW7RzKw+Yjan7oLLYYrXfMLdsWxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZY/rRARi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZY/rRARi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 261DDC2BD10;
	Tue, 14 May 2024 10:35:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715682911;
	bh=AB9iJeK8/8er4H2wZhMExfE9yF69IvChLvrg4DzCyBs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZY/rRARirID1GqoT7fqWPw17f1G3hpb4Xt/nGbuGIUXuaBxQdxc7pnPPKzuspbFcj
	 75w0hF7RXC6/qLqaocxQctlp+TIKdkC5/0IFhJLom1BoS/8CkMpcce7/LouRSXuDnk
	 5xsL7wcL2ntnf8o3WXQC7tOJj6osIlLNuchVqR18=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ni <nichen@iscas.ac.cn>,
	Damien Le Moal <dlemoal@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 132/336] ata: sata_gemini: Check clk_enable() result
Date: Tue, 14 May 2024 12:15:36 +0200
Message-ID: <20240514101043.584359035@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
index 400b22ee99c33..4c270999ba3cc 100644
--- a/drivers/ata/sata_gemini.c
+++ b/drivers/ata/sata_gemini.c
@@ -200,7 +200,10 @@ int gemini_sata_start_bridge(struct sata_gemini *sg, unsigned int bridge)
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



