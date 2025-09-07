Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37501126C02;
	Sun,  7 Sep 2025 20:45:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277928; cv=none; b=p2pWDeJNyOBjC4eMKxEaQNHbKIZVZm7MpuC5OXwDtcBJWTu33R2CPYO4DDviiQebEIoYURR+MBtw1EInP0Ycktpl4zU0PPnOgyIS0hEa0glhbOeBk9R7cXBMjsC7LcVlQBrDLi16KDVkVoGLxS1pXkuR0wIQM37BXT2t/KzSjOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277928; c=relaxed/simple;
	bh=fZ1V7vh0b+xPNMVevsa5aMvknp1IBbETDK7sdc6ScKw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SpNNOzb1W5PYrAU3p6BVMXZQ1iIZDyLIdQSpWDByWvhpxqmJQ05arYu4b7JXwdkLANNKEpyk6BeFVOmvVBRIJ8pSQ5rpdhfLCRJ+stjosWEYxwPY/A1cH8QaUajILfBInt3V9HOmOHxGE3KpNCZduCpof7LDHEL2la1ELzkNKVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ysaiw8nm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ysaiw8nm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B531BC4CEF0;
	Sun,  7 Sep 2025 20:45:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277928;
	bh=fZ1V7vh0b+xPNMVevsa5aMvknp1IBbETDK7sdc6ScKw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ysaiw8nmzEkoiBdnxV9o6KYLX3oRjJksB3DpAVMbOlgyQlmnHTDH6QVpZmotyC3pk
	 8/t8g7VaYSkYhW6uAC25D6d+lo2vbjSfHmPVRyhMR8sHro/0idpoYzkPCKetVJzaum
	 FAcAiNTqIvaKjLKOtrdxEClAL5O+EVNYdfJoR39w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Wahren <wahrenst@gmx.net>,
	stable@kernel.org,
	Andrew Lunn <andrew@lunn.ch>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.16 123/183] net: ethernet: oa_tc6: Handle failure of spi_setup
Date: Sun,  7 Sep 2025 21:59:10 +0200
Message-ID: <20250907195618.712886148@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195615.802693401@linuxfoundation.org>
References: <20250907195615.802693401@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Wahren <wahrenst@gmx.net>

commit b3852ae3105ec1048535707545d23c1e519c190f upstream.

There is no guarantee that spi_setup succeed, so properly handle
the error case.

Fixes: aa58bec064ab ("net: ethernet: oa_tc6: implement register write operation")
Signed-off-by: Stefan Wahren <wahrenst@gmx.net>
Cc: stable@kernel.org
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Link: https://patch.msgid.link/20250827115341.34608-2-wahrenst@gmx.net
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/oa_tc6.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/oa_tc6.c
+++ b/drivers/net/ethernet/oa_tc6.c
@@ -1249,7 +1249,8 @@ struct oa_tc6 *oa_tc6_init(struct spi_de
 
 	/* Set the SPI controller to pump at realtime priority */
 	tc6->spi->rt = true;
-	spi_setup(tc6->spi);
+	if (spi_setup(tc6->spi) < 0)
+		return NULL;
 
 	tc6->spi_ctrl_tx_buf = devm_kzalloc(&tc6->spi->dev,
 					    OA_TC6_CTRL_SPI_BUF_SIZE,


