Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A8B086332;
	Mon,  6 Jan 2025 15:57:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736179030; cv=none; b=eTserXbK7eXifxnQSb3ogVyigN3h2fy7pQ4DIg3lM3V0Hxf4UWIwhW+ZqEjLErfpCQzzhaBtTWQBQWThrR80lSSFHfLKSObGsV5EjaljhhjAryESScSfhYZRIXtnwLbeneWLE56qotadkWNDTLKTouRqYgWtBPTi2SFyiOKjOOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736179030; c=relaxed/simple;
	bh=cq+4m9dGfsy4+z7xQeVrz2q527+V58LStslb3DvZ+64=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GOLZhb1eWrsj07vWJ7U4BQs6xc+IE09lydvuJmfoQzpd84WsbCkow4K0s6u3gPeFVV800L1lA8iIUnh4dbTxr1FbwjtSY6Ystd3S7H8gDhd7Nshy2nVeNPt7mbLuXZf2+u/VZanAr5s39iNiOUinT8lFSrKFNXlLBI20Y0aicoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iPj3buDV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iPj3buDV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21CAFC4CED2;
	Mon,  6 Jan 2025 15:57:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736179030;
	bh=cq+4m9dGfsy4+z7xQeVrz2q527+V58LStslb3DvZ+64=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iPj3buDV06tJvmZCn82N5yRRYHphb4QEs1ZBk7/HPZY3Mbv6zkON/EIUU78uYJ22L
	 7ChswObXQmE85/kCd103ock5SFE6Nik5TEM13gGsZX3k1lNvIwLXXf6KMT1ZN92PQ1
	 UyoU7JBo7YqWAXHSOpC+Rg0VaFuzZen/HL+vAyCc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Maciej S. Szmigiero" <mail@maciej.szmigiero.name>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 141/168] net: wwan: iosm: Properly check for valid exec stage in ipc_mmio_init()
Date: Mon,  6 Jan 2025 16:17:29 +0100
Message-ID: <20250106151143.761522213@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151138.451846855@linuxfoundation.org>
References: <20250106151138.451846855@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maciej S. Szmigiero <mail@maciej.szmigiero.name>

[ Upstream commit a7af435df0e04cfb4a4004136d597c42639a2ae7 ]

ipc_mmio_init() used the post-decrement operator in its loop continuing
condition of "retries" counter being "> 0", which meant that when this
condition caused loop exit "retries" counter reached -1.

But the later valid exec stage failure check only tests for "retries"
counter being exactly zero, so it didn't trigger in this case (but
would wrongly trigger if the code reaches a valid exec stage in the
very last loop iteration).

Fix this by using the pre-decrement operator instead, so the loop counter
is exactly zero on valid exec stage failure.

Fixes: dc0514f5d828 ("net: iosm: mmio scratchpad")
Signed-off-by: Maciej S. Szmigiero <mail@maciej.szmigiero.name>
Link: https://patch.msgid.link/8b19125a825f9dcdd81c667c1e5c48ba28d505a6.1735490770.git.mail@maciej.szmigiero.name
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wwan/iosm/iosm_ipc_mmio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wwan/iosm/iosm_ipc_mmio.c b/drivers/net/wwan/iosm/iosm_ipc_mmio.c
index 09f94c123531..b452ddf9ef06 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_mmio.c
+++ b/drivers/net/wwan/iosm/iosm_ipc_mmio.c
@@ -102,7 +102,7 @@ struct iosm_mmio *ipc_mmio_init(void __iomem *mmio, struct device *dev)
 			break;
 
 		msleep(20);
-	} while (retries-- > 0);
+	} while (--retries > 0);
 
 	if (!retries) {
 		dev_err(ipc_mmio->dev, "invalid exec stage %X", stage);
-- 
2.39.5



