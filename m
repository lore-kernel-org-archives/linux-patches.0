Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CF82384CE2;
	Tue, 21 Jul 2026 15:41:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648480; cv=none; b=ddWQtEOAbw7oRpsypSjmICO4pyR7P2xGelV98MyPnmEOPYJQcPtzQ9FsMZ4/YPwo1jfhvErBsoAK1dIkgOw9RVfj+hJLKvZ2k9ig9QqQRrN5Z4duzunY1wQJfjUjpTymYGc7W4lHNCYKgJ2lRZmOjwSJGrDfRLUuu2hhc/801Ls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648480; c=relaxed/simple;
	bh=swekEPPk2FSbzq0pES7X8Oe+gst/SDQTJkCgnTViVwU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dR8ca0gPBfdIEA5REEXh6kPGTs7UIBZlgwOQwxkBUTiXpbu07f0KTSITFYm/KKqi9k+/AlnB/N+uBpqBc328FR4tjvwbB9wEWyEF6y8Ysu3VB/aQxFnEd3/2B8TypmvQvZAFIDYaJFlr52BreZJEZfqtpZ977OvDGnC5fYHTt10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=quMriYAo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="quMriYAo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68D141F00A3A;
	Tue, 21 Jul 2026 15:41:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648478;
	bh=Eq0sMaAkM3JUxnjxDCLY0xik/SQZdXsgfev8c5ZiDMM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=quMriYAooPDk9SkDcfxkjUmIOHhIuXePUDYKb/+U/ei9YtErXuqg4mH57ytmbldC2
	 IVixDXDAmpBM55uuRej7LT7mIYUN1O1LdScfbNlhuqeT2rrCG1uso3a3tgYSWlEDHJ
	 3dny+mzNlqzsufzBabK1z4u6O/lRrUeke6jd9gEQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Antoine Tenart <atenart@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0214/2077] crypto: safexcel - Fix potential memory leak in safexcel_pci_probe()
Date: Tue, 21 Jul 2026 16:58:07 +0200
Message-ID: <20260721152557.729521368@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abdun Nihaal <nihaal@cse.iitm.ac.in>

[ Upstream commit c36faca103a685590281412e47df74b550f71886 ]

The memory allocated for priv in safexcel_pci_probe() is not freed in the
error paths, as well as in the PCI remove function. Fix this by using
device managed allocation.

Fixes: 625f269a5a7a ("crypto: inside-secure - add support for PCI based FPGA development board")
Signed-off-by: Abdun Nihaal <nihaal@cse.iitm.ac.in>
Reviewed-by: Antoine Tenart <atenart@kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/inside-secure/safexcel.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/inside-secure/safexcel.c b/drivers/crypto/inside-secure/safexcel.c
index fb4936e7afa2dd..2bd8641a07b366 100644
--- a/drivers/crypto/inside-secure/safexcel.c
+++ b/drivers/crypto/inside-secure/safexcel.c
@@ -1893,7 +1893,7 @@ static int safexcel_pci_probe(struct pci_dev *pdev,
 		ent->vendor, ent->device, ent->subvendor,
 		ent->subdevice, ent->driver_data);
 
-	priv = kzalloc_obj(*priv);
+	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
 	if (!priv)
 		return -ENOMEM;
 
-- 
2.53.0



