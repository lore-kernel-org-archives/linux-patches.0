Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E0AAF510;
	Wed,  5 Feb 2025 14:07:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764450; cv=none; b=bakQTeE6YOYclJvM7xrzHge7Wcx11yPqGseCrYR21MfKu9vh/uQnMNd17GUhodr57UuCVpXwgJmSo6RAvr498G/0pp6hlzltORX4tk1obYfy0x10+so6bPv7fVHH/Ci229L9WykAoSIZUpmCMC7q1x/7pDXAPCrR3DIkp56vyZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764450; c=relaxed/simple;
	bh=ojB36FLa+3Vhxp5CqE+p7CMYS3Igzi0GuXgFU6jVOsA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Qjh4nJvZ2W0PPq64/8TFeUo91nGOYcZbLCL9mXoVrBupSXRfRPskeHwLAcQAOO16YY95+FX0+qjWvVndkyhoOhiCN2L4mpZ6IBHEttyaGBPHfR2zkHoT3nIMd5c/QY2k0kO8DrhifTpjpGOOyGCDgnaFpSPO/kFvFPAmpEZQs6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HOH18ugN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HOH18ugN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FE73C4CED1;
	Wed,  5 Feb 2025 14:07:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764450;
	bh=ojB36FLa+3Vhxp5CqE+p7CMYS3Igzi0GuXgFU6jVOsA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HOH18ugNvsVApcIRH4HJ2xcXkMnm+7FNFGep3d2hmTu/dTjnSnAM1Tttb2YabcB94
	 amPJ9CVUyFdLrAbK32GhPWSIZydlkkcAMqnJ5HbZRDbVefvwKDsYRlaUCniWEIRFSN
	 F23gX8g1dfNj2ssIGJ8D5o+PWcMAZpJds+Ix3HG0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 173/393] padata: fix sysfs store callback check
Date: Wed,  5 Feb 2025 14:41:32 +0100
Message-ID: <20250205134426.912380315@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <linux@weissschuh.net>

[ Upstream commit 9ff6e943bce67d125781fe4780a5d6f072dc44c0 ]

padata_sysfs_store() was copied from padata_sysfs_show() but this check
was not adapted. Today there is no attribute which can fail this
check, but if there is one it may as well be correct.

Fixes: 5e017dc3f8bc ("padata: Added sysfs primitives to padata subsystem")
Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/padata.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/padata.c b/kernel/padata.c
index 9bf77b58ee08d..427f28db6b259 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -967,7 +967,7 @@ static ssize_t padata_sysfs_store(struct kobject *kobj, struct attribute *attr,
 
 	pinst = kobj2pinst(kobj);
 	pentry = attr2pentry(attr);
-	if (pentry->show)
+	if (pentry->store)
 		ret = pentry->store(pinst, attr, buf, count);
 
 	return ret;
-- 
2.39.5



