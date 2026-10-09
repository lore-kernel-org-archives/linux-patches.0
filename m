Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B56F4ED19D;
	Fri,  9 Oct 2026 14:46:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557177; cv=none; b=tPe/Y7+aTlljuNaU1S6+BGJmc6S4YU4ydV9qIRG8T+VRRrnt3S/5d8zdaltqf0hLzPbI2DeXyTRPsGH2jQFk2XNlBP1i6pjvYvU/sE0KepZlrJhy2YAN+5zXON1lJnw0Unov++rHhNnQTDH7eWBgNETEiEG/ajID6jhTpgccYIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557177; c=relaxed/simple;
	bh=DQKZ9pMSdeydel4HBg12tykEt+tulIjGJNWhiLb55Xg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Y6wBX8CwxfOsfWHMdDWgSHxT/71W+S6dIdzTTVMEjnDKTr4TTKNhycYHuNFs/Go7UUc3z84VnvxccSb8YjyjGJp8ykkFZcNBR8XaAjnBqYxb5zRYLL4tVbL1xOSWVAV0CQz6Y+pE8USc091FkD6phofu/nu+x+d/mo6gvA037fc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R38cRfLV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R38cRfLV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 414E41F000FF;
	Fri,  9 Oct 2026 14:46:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791557175;
	bh=lbvB6hIskX1xBw8JNtF9ArLPI/VFBRGdsbrsP5QOLCY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R38cRfLVsJ8PGTI+L22b+WJWYBPaCdObK2MQxK0uQSeMZJH8VqwurolkoyhbOhW/v
	 cIFI0yNXQyv0b4ot57bguhIXVlnHIn6mdbX6n+DVi2g1Z46uq/ZXwI4cygbN6JBVoQ
	 nnIP/Zh4Rf94mDf1NEg1Y184Zv588c8pr02ede4s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 359/403] mtd: spinand: fix NULL pointer dereference with no ECC engine
Date: Fri,  9 Oct 2026 16:12:00 +0200
Message-ID: <20261009141000.679750061@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nuno Sá <nuno.sa@analog.com>

[ Upstream commit b890e6163761ddb580cc74f43e15f8bbde15647e ]

When "nand-no-ecc-engine" is set in DT, nanddev_get_ecc_engine() takes
the NAND_ECC_ENGINE_TYPE_NONE path and returns success while leaving
nand->ecc.engine NULL. The SPI-NAND code nevertheless dereferences it
unconditionally to test for a pipelined engine, so probing such a
device oopses immediately.

Rather than open-coding the test three times, add a
nand_ecc_is_pipelined() helper to the NAND core that folds the NULL
check into the integration comparison, and use it everywhere. Future
callers then cannot reintroduce the problem.

Fixes: f9d7c7265bcf ("mtd: spinand: Create direct mapping descriptors for ECC operations")
Cc: stable@vger.kernel.org
Signed-off-by: Nuno Sá <nuno.sa@analog.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
[ sashal: Replaced upstream helper-based checks with a single inline check in spinand_create_dirmap() for the prebuilt descriptor design. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/nand/spi/core.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/mtd/nand/spi/core.c
+++ b/drivers/mtd/nand/spi/core.c
@@ -1186,7 +1186,8 @@ static int spinand_create_dirmap(struct
 
 	spinand->dirmaps[plane].rdesc = desc;
 
-	if (nand->ecc.engine->integration != NAND_ECC_ENGINE_INTEGRATION_PIPELINED) {
+	if (!nand->ecc.engine ||
+	    nand->ecc.engine->integration != NAND_ECC_ENGINE_INTEGRATION_PIPELINED) {
 		spinand->dirmaps[plane].wdesc_ecc = spinand->dirmaps[plane].wdesc;
 		spinand->dirmaps[plane].rdesc_ecc = spinand->dirmaps[plane].rdesc;
 


