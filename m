Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 081541ADC83;
	Mon,  4 May 2026 14:10:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903825; cv=none; b=QT75Gq2hTBnzr4R1qvIXz4dEDZ7/rvzP6CRSoauETIvPT5/8XJSv4xfvZWR7WsM/lfoF0RneJLIgwdTJMPWsmFYiaKhO9izkZotRIzV83VCT5gT15CePxIQXTX2Ds7fRmR6ztbtsB4F7Jup6WNA9u/aom6S93h041QSTxXXDCwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903825; c=relaxed/simple;
	bh=KpcqcBzSp+/l3c7hrPOCdXcCTxHnx3jF/LfkpO9TZco=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=abpDXuzA46mgbGBpoj93ioMSRj5dXd1tZ2FnL9akshl7r9mrJ4Sk11K5s7WVBnvassuKQ5jKdi4Q9vVM0hTL5sxhheaaRIm3G+dYAFnC2886vwocxZsk/04apCKhnoKkGHTNtkY6iqItDptCjxtVRmqRJk6AL8yeSY27Xj33RQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1RhUxtdY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1RhUxtdY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FD0CC2BCB8;
	Mon,  4 May 2026 14:10:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903824;
	bh=KpcqcBzSp+/l3c7hrPOCdXcCTxHnx3jF/LfkpO9TZco=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1RhUxtdYMU7BaeP5C3B4Q1eXfxYlx9Z0gxByicqlKdmc/DempcLzTkGoReRZjO03i
	 Gr28lwwGiAZHdjoARRnnN+vI/lTSWTgNdJnhY1jXrhMCFLTH7uAeHwK2UJBlQH4XJI
	 iEnEvsZ9rXAPXuCR/2MAGV4pnZTVEt72dhECljJ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Kim <james010kim@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 6.18 076/275] mtd: docg3: fix use-after-free in docg3_release()
Date: Mon,  4 May 2026 15:50:16 +0200
Message-ID: <20260504135145.749981577@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.929052779@linuxfoundation.org>
References: <20260504135142.929052779@linuxfoundation.org>
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

From: James Kim <james010kim@gmail.com>

commit ca19808bc6fac7e29420d8508df569b346b3e339 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/devices/docg3.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/mtd/devices/docg3.c
+++ b/drivers/mtd/devices/docg3.c
@@ -2049,7 +2049,6 @@ err_probe:
 static void docg3_release(struct platform_device *pdev)
 {
 	struct docg3_cascade *cascade = platform_get_drvdata(pdev);
-	struct docg3 *docg3 = cascade->floors[0]->priv;
 	int floor;
 
 	doc_unregister_sysfs(pdev, cascade);
@@ -2057,7 +2056,7 @@ static void docg3_release(struct platfor
 		if (cascade->floors[floor])
 			doc_release_device(cascade->floors[floor]);
 
-	bch_free(docg3->cascade->bch);
+	bch_free(cascade->bch);
 }
 
 #ifdef CONFIG_OF


