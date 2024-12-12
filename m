Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F71C2F44;
	Thu, 12 Dec 2024 17:05:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023152; cv=none; b=I3jDME8VgC8prX/Fv+pCutfMe7INljfFNtPTizbrAsrP++ZSoOvVpK8sk0MautMRqUOP0ELVIOhK1xBIiipPIvaI5HGy5lVwdnD5kj/qURDavegocFBViGisTGS4d/LpQVt+MDL+f/y9V7rw6+9/AFTJknbzL4VdN7srMepWKKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023152; c=relaxed/simple;
	bh=aWPkycsT/i/TEEyYJVnQaT40eNOotZ1gStlJRSFzTfY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=agYOstHoCxymmzwaacQThsEfuNDPwrW2RnyMTbBqDtYqEnLmv2CKk62RkuFH3x7NoaTpc2C07XNVn2WHPAoxyaZbpbDciGfVBDHYvycz2skSY01CGyKZkPFgVv70w+IWyAuHnXfjd4PR/CFaOYOuxb2+pFt4Plr93ZU97fI2cMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cmX0h+yg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cmX0h+yg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E252AC4CECE;
	Thu, 12 Dec 2024 17:05:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734023152;
	bh=aWPkycsT/i/TEEyYJVnQaT40eNOotZ1gStlJRSFzTfY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cmX0h+ygpmrZEhwBRGt73Jvk3T+MUKn2C0620unw3geq1w0GqryyapVQnS6s1PCJp
	 KR9Sw2hpM5Q710QIHNrv9HhTQblK/oTNevw81TaeQR4DcjSvr2b+gNO6RxpdKhPlMU
	 vnHg4yCP7V2jHZZY8p5GrybepWv4vFuZO9DbFj1A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pei Xiao <xiaopei01@kylinos.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 440/565] spi: mpc52xx: Add cancel_work_sync before module remove
Date: Thu, 12 Dec 2024 16:00:35 +0100
Message-ID: <20241212144329.078345336@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pei Xiao <xiaopei01@kylinos.cn>

[ Upstream commit 984836621aad98802d92c4a3047114cf518074c8 ]

If we remove the module which will call mpc52xx_spi_remove
it will free 'ms' through spi_unregister_controller.
while the work ms->work will be used. The sequence of operations
that may lead to a UAF bug.

Fix it by ensuring that the work is canceled before proceeding with
the cleanup in mpc52xx_spi_remove.

Fixes: ca632f556697 ("spi: reorganize drivers")
Signed-off-by: Pei Xiao <xiaopei01@kylinos.cn>
Link: https://patch.msgid.link/1f16f8ae0e50ca9adb1dc849bf2ac65a40c9ceb9.1732783000.git.xiaopei01@kylinos.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-mpc52xx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/spi/spi-mpc52xx.c b/drivers/spi/spi-mpc52xx.c
index 51041526546dd..fa49e899f2b2e 100644
--- a/drivers/spi/spi-mpc52xx.c
+++ b/drivers/spi/spi-mpc52xx.c
@@ -521,6 +521,7 @@ static int mpc52xx_spi_remove(struct platform_device *op)
 	struct mpc52xx_spi *ms = spi_master_get_devdata(master);
 	int i;
 
+	cancel_work_sync(&ms->work);
 	free_irq(ms->irq0, ms);
 	free_irq(ms->irq1, ms);
 
-- 
2.43.0



