Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9501632D42B;
	Sat, 30 May 2026 16:54:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780160099; cv=none; b=IACILd/lGvRgzPdTxMuDCFNOWkt9n2dDWIUn6TC7hoh6r1GnITqt4go9rVWkC8NNBXsuzN2pGiPiNkvmtfGe9S95eHLXlGfFxLPF5ebKBBEoFMOtEe7Y2ycb45lD6v0xCkFmPF3NX0PDIw191RyIhTj3OP/lNJNb7iT7Ec293pc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780160099; c=relaxed/simple;
	bh=yLslDqGJZscVY50+pwe4CnUsWtn1Y8T6AZJ3V5CA81k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J5jxosk0k9x9tykMyBsS3sB7pdAqkcYRZ8EWdrsXalRXAL+oBguoLF7YrsuZep30d3GWiGquvbppiyGntqdtNBPlH05sVugg3hIgcyr/jl9UsVaqcSitpfOLzXKq79RT9EkZKxdnuJQ6uJOXUnb4FfAiFFZtzEki7ZDkkOKFpjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dgr3JAix; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dgr3JAix"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD0C21F00893;
	Sat, 30 May 2026 16:54:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780160098;
	bh=f0zvAF+Uehc2PkYMSQ+anEv4Ywu9inSi9PmAChjVFiw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Dgr3JAixjO5yt6GTzqkuMl/b2zXwWYfrGIGvTrGefPVAR0ybUOljgFxK65XbTRc/t
	 UNPygwu57PL4liNh9MsF6puh7bUn2UAFy0a0Gezdf58iG6gyoGwbHS+bftvdK+7l9D
	 OBDdLR/6jxiiZ8s0IhZIlbMn9ScLiJc2kzFWdwkI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Kim <james010kim@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 245/969] mtd: docg3: fix use-after-free in docg3_release()
Date: Sat, 30 May 2026 17:56:09 +0200
Message-ID: <20260530160307.226809428@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: James Kim <james010kim@gmail.com>

[ Upstream commit ca19808bc6fac7e29420d8508df569b346b3e339 ]

In docg3_release(), the docg3 pointer is obtained from
cascade->floors[0]->priv before the loop that calls
doc_release_device() on each floor. doc_release_device() frees the
docg3 struct via kfree(docg3) at line 1881. After the loop,
docg3->cascade->bch dereferences the already-freed pointer.

Fix this by accessing cascade->bch directly, which is equivalent
since docg3->cascade points back to the same cascade struct, and
is already available as a local variable. This also removes the
now-unused docg3 local variable.

Fixes: c8ae3f744ddc ("lib/bch: Rework a little bit the exported function names")
Cc: stable@vger.kernel.org
Signed-off-by: James Kim <james010kim@gmail.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/devices/docg3.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/mtd/devices/docg3.c b/drivers/mtd/devices/docg3.c
index 8cb25cfd9c10a..2f82bc7c07931 100644
--- a/drivers/mtd/devices/docg3.c
+++ b/drivers/mtd/devices/docg3.c
@@ -2049,7 +2049,6 @@ static int __init docg3_probe(struct platform_device *pdev)
 static void docg3_release(struct platform_device *pdev)
 {
 	struct docg3_cascade *cascade = platform_get_drvdata(pdev);
-	struct docg3 *docg3 = cascade->floors[0]->priv;
 	int floor;
 
 	doc_unregister_sysfs(pdev, cascade);
@@ -2057,7 +2056,7 @@ static void docg3_release(struct platform_device *pdev)
 		if (cascade->floors[floor])
 			doc_release_device(cascade->floors[floor]);
 
-	bch_free(docg3->cascade->bch);
+	bch_free(cascade->bch);
 }
 
 #ifdef CONFIG_OF
-- 
2.53.0



