Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81F3A37AA92;
	Sat, 12 Sep 2026 10:45:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789209940; cv=none; b=GSc8F1eAzw++i2F2xHYqF8ZIVxAFPT1f/SY070b7VlmMfFaoH31zWWVnAOGWEWyMRYSuGQvyWuisAOE98qe0cAKoKyrOpvWnZ05bp2DbJvCf4lxybb7QDMa526eURgx9zsAelt4x+ei89tYF0WZqUx2mT3sOoquDXblCQPiPHgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789209940; c=relaxed/simple;
	bh=TFzyHR2XYzUAx8g4WeMhkd9ZTEtd+WZ7a2FhoapachI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YxXovGnYtTE4qK66R1j50NuzvBITYHkpGdVa9rMuzvxrBMvGVUodYnw2Y+qIsebTQ6Mpq77xskJwjVV3OoNIQrf8ZntSf8ZQTjzvwSmhonQooy0SIFYw3F7IcSXzbjcLebEFq7mIzmZnNcgc9Ql3nQElttF55ozmnBtlsmjfS/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pB0zfGMV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pB0zfGMV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 866E81F000FF;
	Sat, 12 Sep 2026 10:45:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789209938;
	bh=mKpXqDoc2Bt0sgWH44F4AcYwyWAjJAKmrTbJpfGWooY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pB0zfGMV/gCofKhOsBVgg1SpXb2xZcsPIlorYHaUnW+b7YlvZ3KJ1unK20b1midrQ
	 Jc3CcxMt46GFRc/w6CkN/CPrliUPsPuXlPX4kGvXNst1oBe7PRvvxhKwkmgBRG35t9
	 0OCbgVWxzUqjUddToAuCbT0vLi4jxTKl5oQ3F0Bc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Alexandre Bounine <alex.bou9@gmail.com>,
	Matt Porter <mporter@kernel.crashing.org>,
	Yang yingliang <yangyingliang@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0872/1518] rapidio: clear mport->net when rio_add_net() fails
Date: Sat, 12 Sep 2026 08:50:41 +0200
Message-ID: <20260912065643.175183883@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Guangshuo Li <lgs201920130244@gmail.com>

[ Upstream commit b74030fbf187b43c1f85b66a7082e9946511cb5d ]

rio_alloc_net() stores the newly allocated rio_net in mport->net before
rio_scan_alloc_net() registers the device.

If rio_add_net() fails, rio_scan_alloc_net() drops the device reference
with put_device(), which releases the rio_net through the device release
callback.  However, mport->net is left pointing at the freed object.

A later mport unregister path can then dereference the dangling mport->net
pointer and may try to free the same rio_net again.

Clear mport->net in the rio_add_net() failure path, matching the cleanup
done for the destID table allocation failure path.

Link: https://lore.kernel.org/20260708070628.721010-1-lgs201920130244@gmail.com
Fixes: e842f9a1edf3 ("rapidio: add check for rio_add_net() in rio_scan_alloc_net()")
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Cc: Alexandre Bounine <alex.bou9@gmail.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Yang yingliang <yangyingliang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rapidio/rio-scan.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/rapidio/rio-scan.c b/drivers/rapidio/rio-scan.c
index dcd6619a4b027..3cc25d0534513 100644
--- a/drivers/rapidio/rio-scan.c
+++ b/drivers/rapidio/rio-scan.c
@@ -874,6 +874,7 @@ static struct rio_net *rio_scan_alloc_net(struct rio_mport *mport,
 		net->dev.release = rio_scan_release_dev;
 		if (rio_add_net(net)) {
 			put_device(&net->dev);
+			mport->net = NULL;
 			net = NULL;
 		}
 	}
-- 
2.53.0



