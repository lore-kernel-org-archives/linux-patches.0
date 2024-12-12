Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3635A22CBDE;
	Thu, 12 Dec 2024 16:28:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734020899; cv=none; b=FbFiYILjM1J00/8ipJfg8o6mvEmqPk/9XfPVV+42IcTBYWXlWjMmerROjzYtHO4uVXnu9adg/7//hE/mpHN29+pp8N4MlGdq2Fni9P2iUMhlO/7eZnPLHzpsMI/OLn2rKQCV5LAqtT15CQ2i2jxdTuJsJRZMbtd3OV4zpYlLf4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734020899; c=relaxed/simple;
	bh=RmwSVbv998pelcNgtNTf+vZA7tMucM21zzOp+N9WzTY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O8Z9lJPQ9H59d2Kf1x8SHffvg1PZVjNdcd6xnOBiTOQ26DJzzk8hKqPzUeZQliet676wL0+HHmFw87TuELIv0gxzLJatGF43g4S+3JibxNZ5dsYxWgyOeFIpA8ZrNIgOJ3z5otAgd2bQrKLMbPBnEwxT5no4Ae/O1pdsfqNZfEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B9DKub+w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B9DKub+w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AFF8C4CED4;
	Thu, 12 Dec 2024 16:28:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734020899;
	bh=RmwSVbv998pelcNgtNTf+vZA7tMucM21zzOp+N9WzTY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B9DKub+wtOcrc01cYeCcckTnRiSkHRz/wNJFtHKqnCaS0Rki8m/+ZD48ukgAfKWqu
	 nS2C/2/ZO4TIwnC/7v0yPDP0xW/Wf5q4vOOZPhKwtV0uUbTPd6s28l/V7Bhm3WQgVx
	 qcIJWeHe/3DQDYPSuEGd7dSeMbpTTxQYM7Tyh0VM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pei Xiao <xiaopei01@kylinos.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 592/772] spi: mpc52xx: Add cancel_work_sync before module remove
Date: Thu, 12 Dec 2024 15:58:57 +0100
Message-ID: <20241212144414.394398079@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 7b64e64c65cfe..2badf6535b306 100644
--- a/drivers/spi/spi-mpc52xx.c
+++ b/drivers/spi/spi-mpc52xx.c
@@ -519,6 +519,7 @@ static int mpc52xx_spi_remove(struct platform_device *op)
 	struct mpc52xx_spi *ms = spi_master_get_devdata(master);
 	int i;
 
+	cancel_work_sync(&ms->work);
 	free_irq(ms->irq0, ms);
 	free_irq(ms->irq1, ms);
 
-- 
2.43.0



