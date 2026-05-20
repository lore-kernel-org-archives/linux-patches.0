Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E32F73FBEDF;
	Wed, 20 May 2026 18:38:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302329; cv=none; b=NZxGLDqAlJjJ/JPYSEUhSyVLr1fP9rhth33dUavMfJKNHMUfeX1Lt8budMd3nNyjdMm7S2/xTVkc0PpRW2jYVE4D57+PETGuuKJ2dF6vOmejihMnHwjEn6X24lU4wqmi4OhQVqKl/iuYYyMfuTrjZ5uH0wHuJqzfk5mCVvSo4mQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302329; c=relaxed/simple;
	bh=7boeJI1hfTIqG6q1LRMsZbyBJQ/MtUG/j+h2sO6Trp8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mhdGnQjEHBghiiBWaHFKJLM1bT9O5EcHwhLsgYIlPDtpBjOStat4mf/pPx/Hm/O9K0a0RJiGOcZsqUqXHm9Zzboim5ZwTMUse+L3sJc0McBaXTfccwPq57WiEYZHipVpH80/4qYIGSiGyih59L1hMI7kMtPu0MDv4Z6RDHIdYOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JnZ0j0xp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JnZ0j0xp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6C691F0089B;
	Wed, 20 May 2026 18:38:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302327;
	bh=YADtLVU+V2zhNSqZUQvC4XMiR74Rwi+hav5TNrjjl1k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JnZ0j0xpstwKxYUVANqVMT956CCqw4F3N6Nv7I3LS36DqVVss4Cg6avEcwX5qtizp
	 Mc6KhevEbhxeBMDRMmkG+YHjPoAPhR/XQ2hbkCu2N/8spIGkh1Ar2MHEXEYJ1APfmM
	 qJ1erjaJte8h/ppOJzdhUCcKyyQ8ezm9kZSmPD+I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haibo Chen <haibo.chen@nxp.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 226/508] mtd: spi-nor: core: correct the op.dummy.nbytes when check read operations
Date: Wed, 20 May 2026 18:20:49 +0200
Message-ID: <20260520162103.545325106@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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
index 6e135581ec62a..6f8a9c6253205 100644
--- a/drivers/mtd/spi-nor/core.c
+++ b/drivers/mtd/spi-nor/core.c
@@ -2477,7 +2477,7 @@ static int spi_nor_spimem_check_readop(struct spi_nor *nor,
 	/* convert the dummy cycles to the number of bytes */
 	op.dummy.nbytes = (read->num_mode_clocks + read->num_wait_states) *
 			  op.dummy.buswidth / 8;
-	if (spi_nor_protocol_is_dtr(nor->read_proto))
+	if (spi_nor_protocol_is_dtr(read->proto))
 		op.dummy.nbytes *= 2;
 
 	return spi_nor_spimem_check_op(nor, &op);
-- 
2.53.0



