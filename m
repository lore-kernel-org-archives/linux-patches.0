Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8A0B46D0A8;
	Tue, 21 Jul 2026 17:47:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656063; cv=none; b=TFcMTPAlGFxApFG8lqMJBab/vW/BFM3eiLBPKKYnFA1R5+omMHYUwTi2pAcogXydToPrLVJV/YE3k/bGFTmBhuH3nyj5+2KSsnK/8YjHSYx3Zmwy5tAloFFK+8Ze2RMzq0AprjZxGLvVLq7BCFZc42M9A8RbogNgaL2u+Px2AM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656063; c=relaxed/simple;
	bh=LxhOr+YHcSnmuN033Oz+WS6BljG3ryqwWo6+REcGKR8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dS9vc+56H0TJvM3wHKKGfNBtlcTa5tLdg5FzED2MfE+W5sQ46PjGXX0NhVGVmCdlMASTMCHuewrWRwrVM34T9OiPZxaLMVkR3pgTZxapnTFAd3HGD8ovl0OAmQoZAGsuwuPtnF1Fm4rXVPAJqq9IVY7eMnlTnpHrMlaBV/mao7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GG7ni8MA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GG7ni8MA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E979D1F000E9;
	Tue, 21 Jul 2026 17:47:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656062;
	bh=KOBFbj5z+b9wyx95hVuQYgA/0rCoLeYsXQmMMOdpFZw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GG7ni8MAFG/N5LQ1e6wgKTE+i5N03Mbi8mYNvn3EUfpFEfquwUFb1YgDjilcgWGS/
	 T2yDtazuoVcisXOTXVkENK346hqB1PWqoy1PgTJ2SQQsg1cGybfi5UmjGu1uVZPkpT
	 Qna0qClGhrgfBO81VGGQ6Df/szsuce72pQGKgrTg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Svyatoslav Ryhel <clamor95@gmail.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0246/1611] drm/tegra: gr2d/gr3d: Initialize address register map before HOST1X client is registered
Date: Tue, 21 Jul 2026 17:06:02 +0200
Message-ID: <20260721152520.556587436@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Svyatoslav Ryhel <clamor95@gmail.com>

[ Upstream commit c4ef5ba1131346159e31f4ef858525cf377380a6 ]

The host1x_client_register() function is called just prior to register map
initialization loop, making the device available to userspace. This may
result in userspace attempting to submits a job before the register map is
initialized. Address this by moving register initialization before host1x
client registration.

Acked-by: Mikko Perttunen <mperttunen@nvidia.com>
Signed-off-by: Svyatoslav Ryhel <clamor95@gmail.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Link: https://patch.msgid.link/20260517091450.46728-2-clamor95@gmail.com
Stable-dep-of: ace01e2af387 ("drm/tegra: gr2d/gr3d: Contain PM in the gr*d_probe/gr*d_remove")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/tegra/gr2d.c | 8 ++++----
 drivers/gpu/drm/tegra/gr3d.c | 8 ++++----
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/tegra/gr2d.c b/drivers/gpu/drm/tegra/gr2d.c
index 21f4dd0fa6aff7..e4148b034af745 100644
--- a/drivers/gpu/drm/tegra/gr2d.c
+++ b/drivers/gpu/drm/tegra/gr2d.c
@@ -276,16 +276,16 @@ static int gr2d_probe(struct platform_device *pdev)
 	if (err)
 		return err;
 
+	/* initialize address register map */
+	for (i = 0; i < ARRAY_SIZE(gr2d_addr_regs); i++)
+		set_bit(gr2d_addr_regs[i], gr2d->addr_regs);
+
 	err = host1x_client_register(&gr2d->client.base);
 	if (err < 0) {
 		dev_err(dev, "failed to register host1x client: %d\n", err);
 		return err;
 	}
 
-	/* initialize address register map */
-	for (i = 0; i < ARRAY_SIZE(gr2d_addr_regs); i++)
-		set_bit(gr2d_addr_regs[i], gr2d->addr_regs);
-
 	return 0;
 }
 
diff --git a/drivers/gpu/drm/tegra/gr3d.c b/drivers/gpu/drm/tegra/gr3d.c
index 42e9656ab80c91..47b0c6c56bfd08 100644
--- a/drivers/gpu/drm/tegra/gr3d.c
+++ b/drivers/gpu/drm/tegra/gr3d.c
@@ -506,6 +506,10 @@ static int gr3d_probe(struct platform_device *pdev)
 	if (err)
 		return err;
 
+	/* initialize address register map */
+	for (i = 0; i < ARRAY_SIZE(gr3d_addr_regs); i++)
+		set_bit(gr3d_addr_regs[i], gr3d->addr_regs);
+
 	err = host1x_client_register(&gr3d->client.base);
 	if (err < 0) {
 		dev_err(&pdev->dev, "failed to register host1x client: %d\n",
@@ -513,10 +517,6 @@ static int gr3d_probe(struct platform_device *pdev)
 		return err;
 	}
 
-	/* initialize address register map */
-	for (i = 0; i < ARRAY_SIZE(gr3d_addr_regs); i++)
-		set_bit(gr3d_addr_regs[i], gr3d->addr_regs);
-
 	return 0;
 }
 
-- 
2.53.0



