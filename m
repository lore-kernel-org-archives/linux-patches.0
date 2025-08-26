Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19472FBF0;
	Tue, 26 Aug 2025 13:06:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213615; cv=none; b=djeYLyCOyK6d4pkXEVlonGdY/iiQJ8U5jhW72QsfHQ0Gd+yUDnTokBLeBVwd+T2DelafcNFNi7A14jyJgmsWGASJkMSn+0G2yiVG1BgnAJN5HXnMgGPGr4L58RmbMSabMgHqsEzGZUG5S0yM9qRuLCe/lvWJtmjpM3xT5NkmOks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213615; c=relaxed/simple;
	bh=yH2aV1pZ8jqEkvHLFK3/+qSHqBy1lnJ1mIsB3iDuL1A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mmmTHYRCyIbKWgO6y//I7zLW5t61FW+7Ss1e2XRCKDsBbF9JRTR6tuogEkWR2GSom1EupBDxnaH5U15iROd4Z5J26+DB+76pxwmrerRxtnXJjMMepZnv5X9LWD4mflqU13oYK3vvUbyG/zHT4i3QPAzCBiNxVbKuUplwhlyrJrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J8LdNSCO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J8LdNSCO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1EEEC4CEF1;
	Tue, 26 Aug 2025 13:06:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213615;
	bh=yH2aV1pZ8jqEkvHLFK3/+qSHqBy1lnJ1mIsB3iDuL1A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J8LdNSCOStg0fDjvOjFUwPoh7fGl3SgIJFtJ80s81Rw1rNo1xT6R/8O1sZff5Igq3
	 HicauSLStkdsXBZYohEpL8c5t49qPJkjat0jud5q60Jaa5bljO+6pXidu8XnZlhgx2
	 +/sI7IdgBeG8L8gfZ7fMmE98Q+RH4aLKYyeWi184=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabor Juhos <j4g8y7@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 6.6 381/587] mtd: spinand: propagate spinand_wait() errors from spinand_write_page()
Date: Tue, 26 Aug 2025 13:08:50 +0200
Message-ID: <20250826111002.598256405@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gabor Juhos <j4g8y7@gmail.com>

commit 091d9e35b85b0f8f7e1c73535299f91364a5c73a upstream.

Since commit 3d1f08b032dc ("mtd: spinand: Use the external ECC engine
logic") the spinand_write_page() function ignores the errors returned
by spinand_wait(). Change the code to propagate those up to the stack
as it was done before the offending change.

Cc: stable@vger.kernel.org
Fixes: 3d1f08b032dc ("mtd: spinand: Use the external ECC engine logic")
Signed-off-by: Gabor Juhos <j4g8y7@gmail.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/nand/spi/core.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/mtd/nand/spi/core.c
+++ b/drivers/mtd/nand/spi/core.c
@@ -624,7 +624,10 @@ static int spinand_write_page(struct spi
 			   SPINAND_WRITE_INITIAL_DELAY_US,
 			   SPINAND_WRITE_POLL_DELAY_US,
 			   &status);
-	if (!ret && (status & STATUS_PROG_FAILED))
+	if (ret)
+		return ret;
+
+	if (status & STATUS_PROG_FAILED)
 		return -EIO;
 
 	return nand_ecc_finish_io_req(nand, (struct nand_page_io_req *)req);


