Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D6291DF27B;
	Tue,  8 Oct 2024 12:55:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392103; cv=none; b=YuE+/6aLAig3D31CpVZNMHmrbBo/1KgCF5nFc6b5HH1c+Vku5fY0R5+zOPB/hsjzVMVmsaY0XaYl/3WbyDv2DbZovBbVKEHU+hw+M+9uqko/gKwDf8tx/oOSWGk4h2lopWa6tWkOegnraEQabSUqAGcJDS2ust2QJgx/GlKxCKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392103; c=relaxed/simple;
	bh=LSpRK4M054cG9nYMblyfK8btZqPZYtv2roWPVXSv41o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kYmMiytpJIIHQdvps1C5NEshb/m67wew9TsuJPEyhMSD5znlnB5XdEDl7OJ3q+oQ0OUhbSsmk326KBtKavUdM76M6vh8e7LG4V8AUMCxn4NhK1Z3dStI38ZqPvTAFHqN8UpJTdCKbht6zvMfzPaAJyYsN5x+/katH2s8N5kL6Ac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XYGE0wQ/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XYGE0wQ/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56CBAC4CECC;
	Tue,  8 Oct 2024 12:55:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392103;
	bh=LSpRK4M054cG9nYMblyfK8btZqPZYtv2roWPVXSv41o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XYGE0wQ/naCcd+AUlyr44ARItTQg+8Uunogv7JVMiID3lJVRNlbZBPB3XWrpmAOJj
	 yVD0/WlL3yQ9iOBUaLAD2z3HHi62w3gBXd9xHtNPQ/Nq9yp0YedTdoVNcq0zg+94WJ
	 qVd3kexAOSqwyt5Bd2wjoWFFxtgCvM3ePrnLfQvc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 317/558] spi: spi-cadence: Fix missing spi_controller_is_target() check
Date: Tue,  8 Oct 2024 14:05:47 +0200
Message-ID: <20241008115714.783557935@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jinjie Ruan <ruanjinjie@huawei.com>

[ Upstream commit 3eae4a916fc0eb6f85b5d399e10335dbd24dd765 ]

The spi_controller_is_target() check is missing for pm_runtime_disable()
in cdns_spi_remove(), add it.

Fixes: b1b90514eaa3 ("spi: spi-cadence: Add support for Slave mode")
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Link: https://patch.msgid.link/20240923040015.3009329-4-ruanjinjie@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-cadence.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/spi-cadence.c b/drivers/spi/spi-cadence.c
index 087e748d9cc95..3c87d2bf786a9 100644
--- a/drivers/spi/spi-cadence.c
+++ b/drivers/spi/spi-cadence.c
@@ -701,8 +701,10 @@ static void cdns_spi_remove(struct platform_device *pdev)
 
 	cdns_spi_write(xspi, CDNS_SPI_ER, CDNS_SPI_ER_DISABLE);
 
-	pm_runtime_disable(&pdev->dev);
-	pm_runtime_set_suspended(&pdev->dev);
+	if (!spi_controller_is_target(ctlr)) {
+		pm_runtime_disable(&pdev->dev);
+		pm_runtime_set_suspended(&pdev->dev);
+	}
 
 	spi_unregister_controller(ctlr);
 }
-- 
2.43.0



