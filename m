Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 622D830DD1D;
	Fri, 15 May 2026 16:01:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778860872; cv=none; b=sOko4B+7WHAHSJm6NE4J9rE7Vh/ksjFtCM3P/AdsWYtk6v0RAJm0omni0HP6yVieSChALOOTcx65sMKl+lNe/obDS4tlYaI+1Ugf18Brx/EbFQGknj+CvCelsWFyeG+gjejRDEn3GQ56pr08nMqlaI7G9VRJrSkfpL/jEZT1GSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778860872; c=relaxed/simple;
	bh=MKn6DrEHbHbhJ089RqJE8vgRi7xiuDKgNbVl10CWgkk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CLSH0GpVgjdrjvGxQpLlRIrJf19huf5KWN5qYr0nU61JFm+fqr9emVnSCd2W80v1cB0wOBrH/OSCZIN4+RTp+1nasHrkabQZ0lrfZ3tTmpEKRnAL2fDlo7stPVaqESwEDzHmUsHCKkOGUum5FxigI4A8+o3IkC6Fp0/c8x5ffg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0Gfk0BYa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0Gfk0BYa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC480C2BCB0;
	Fri, 15 May 2026 16:01:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778860872;
	bh=MKn6DrEHbHbhJ089RqJE8vgRi7xiuDKgNbVl10CWgkk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0Gfk0BYaWiOslYZG99xtZ4l308SPZ1s27v6uMs/1RAcVIZki/7+c+AHx8BhLCplj4
	 bM8bXwAryEnQMjiBVt1SdU1/FBkvJ+Utoc1xHWypuqq9T/zgRcN6GsQXYMcXIXgGu5
	 /OhgOGXvO721RZp82gYZIQ+TRs6fKN/jf510YdCQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Kim <james010kim@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 109/474] mtd: docg3: fix use-after-free in docg3_release()
Date: Fri, 15 May 2026 17:43:38 +0200
Message-ID: <20260515154717.394305771@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index a2b643af70194..e37fb11556479 100644
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



