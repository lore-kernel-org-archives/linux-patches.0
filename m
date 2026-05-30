Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D460332EA7;
	Sat, 30 May 2026 17:17:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780161476; cv=none; b=Dy8hp7nFMJE4OxWDo1yy3kOALHq8ObtyhI5f1Mrr8FsEFU8ArgtMzt7pos9goHrvO3rTxijEDV+/gyKa5ACSQsb5rJeGqSHyeb64JK2aMawuPfNKwBPWzw8DJlKlZ7DP6cjGm2Lq199uIzwp1ay19hNLKWimNeAoaaJyYr81vJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780161476; c=relaxed/simple;
	bh=XDBQb/1++y83aiCduxrYngbxRw+/vzCoP/FGAC1UGHE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hkWtIAjTlqZpVjnWI/Aum6HkKNVI1UtIUVMDPBDCoedJteYZF9BwAt08C5Y5V2lgoMkIUXpFM0/xTQT/vkUUnwto0gjSkjSXYqyTFUvCdE08E+g4cY+ukjIiNQLcNeet6GonTgVgRno05Q+lE7RY5C77KIIhueIsyGLcIisicvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OMtzPNbE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OMtzPNbE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 717AB1F00893;
	Sat, 30 May 2026 17:17:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780161475;
	bh=WIP+4VuJlUQ5aDrhPuzTOAV/4dKEFRC4RY7gVMJcTyY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OMtzPNbEIo4ceWNrQWqF4o23JoUGtzuuS3g7MNthqtelgLN5ksveQ+srz6AabAB9q
	 kD6ctJgO3cqSjP1XbqHm9Kja8Ft+0HijQa+altgJQ4fBLXxSrHlnzdirPp4GGcLtAw
	 JLwT9TqInYbzdFzlTsj7DyQ5trZtGmHG9oiSScqo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haibo Chen <haibo.chen@nxp.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 604/969] mtd: spi-nor: core: correct the op.dummy.nbytes when check read operations
Date: Sat, 30 May 2026 18:02:08 +0200
Message-ID: <20260530160317.105214304@linuxfoundation.org>
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

From: Haibo Chen <haibo.chen@nxp.com>

[ Upstream commit 756564a536ecd8c9d33edd89f0647a91a0b03587 ]

When check read operation, need to setting the op.dummy.nbytes based
on current read operation rather than the nor->read_proto.

Fixes: 0e30f47232ab ("mtd: spi-nor: add support for DTR protocol")
Signed-off-by: Haibo Chen <haibo.chen@nxp.com>
Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/spi-nor/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/spi-nor/core.c b/drivers/mtd/spi-nor/core.c
index 91622d9c9b032..3f38d67e1a336 100644
--- a/drivers/mtd/spi-nor/core.c
+++ b/drivers/mtd/spi-nor/core.c
@@ -2061,7 +2061,7 @@ static int spi_nor_spimem_check_readop(struct spi_nor *nor,
 	/* convert the dummy cycles to the number of bytes */
 	op.dummy.nbytes = (read->num_mode_clocks + read->num_wait_states) *
 			  op.dummy.buswidth / 8;
-	if (spi_nor_protocol_is_dtr(nor->read_proto))
+	if (spi_nor_protocol_is_dtr(read->proto))
 		op.dummy.nbytes *= 2;
 
 	return spi_nor_spimem_check_op(nor, &op);
-- 
2.53.0



