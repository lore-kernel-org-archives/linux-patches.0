Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CE05235362;
	Mon,  2 Jun 2025 15:06:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748876780; cv=none; b=LQY325XrLR+asEPIC5hj5f4eOzhwI52DwOrsGsdhMuw/VLz1r587srBceAehm6tLVMtWIk856lJ/fdimDERLYpS8EQVKJLtjVWIKKjhkepkKcuaaX9bIByoCqzmwxz1H9KKKjogwWmJz9fVAOTtAzk7xJOO2Nh8CtM0DliTdfwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748876780; c=relaxed/simple;
	bh=OiqZ19h9Ty7yW+bXGV3cqO3rVPXaKg4vfT9mRg80lAA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k8uLPvAM8Nyn/uWyDRYOo7u8j/4198dc8jM2A1pzrmmyKSzakIuQGowR9CMYbpZzBobePSfd7k5yCVApJfRzLBvhXC6ix7fuJtnGb5Xs5RRSbILIHE69MQmNLBjE8QuvkUAXhXEKtgAWNo2QkIUI8+PI0MHxN+mLrtKi57u3hfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ijmaRqJL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ijmaRqJL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32CB3C4CEEB;
	Mon,  2 Jun 2025 15:06:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748876776;
	bh=OiqZ19h9Ty7yW+bXGV3cqO3rVPXaKg4vfT9mRg80lAA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ijmaRqJLO9MLnsVorhrEnVpOI4zAzztjI5DzKfsErh7UWiqn+9JTXsk0H71WadEKU
	 /TkoIUoariEJ87u0zxJ/d98WxMRJoOManxXBp6IZpjNIezgdlJ41oKz1b5/nlp2w5T
	 iVNexxRucQPH3wlmYeLkra+9iHEjI03AfiR4xoe0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 069/325] thunderbolt: Do not add non-active NVM if NVM upgrade is disabled for retimer
Date: Mon,  2 Jun 2025 15:45:45 +0200
Message-ID: <20250602134322.590033999@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134319.723650984@linuxfoundation.org>
References: <20250602134319.723650984@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Mika Westerberg <mika.westerberg@linux.intel.com>

[ Upstream commit ad79c278e478ca8c1a3bf8e7a0afba8f862a48a1 ]

This is only used to write a new NVM in order to upgrade the retimer
firmware. It does not make sense to expose it if upgrade is disabled.
This also makes it consistent with the router NVM upgrade.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thunderbolt/retimer.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/thunderbolt/retimer.c b/drivers/thunderbolt/retimer.c
index 5bd5c22a5085d..d2038337ea03b 100644
--- a/drivers/thunderbolt/retimer.c
+++ b/drivers/thunderbolt/retimer.c
@@ -89,9 +89,11 @@ static int tb_retimer_nvm_add(struct tb_retimer *rt)
 	if (ret)
 		goto err_nvm;
 
-	ret = tb_nvm_add_non_active(nvm, nvm_write);
-	if (ret)
-		goto err_nvm;
+	if (!rt->no_nvm_upgrade) {
+		ret = tb_nvm_add_non_active(nvm, nvm_write);
+		if (ret)
+			goto err_nvm;
+	}
 
 	rt->nvm = nvm;
 	return 0;
-- 
2.39.5



