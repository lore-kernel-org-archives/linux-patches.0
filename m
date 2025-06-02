Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B90D11EA65;
	Mon,  2 Jun 2025 14:38:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748875104; cv=none; b=diCkxd1rwhEJIxuSBWkfehNhyfECq6GvuF5ptmJsmbs1XmJecyo6BGIYR3k7oGX1SssjcElfCuh0uRqVPvzRvTMNcPSfaDTwDQsJE7a3BKwST1k97PQOVTuH2aGxaCBZbbzkuXJTD1ZGDbbuBP6Ke3nKYalIuweAEZkqY2zq0pU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748875104; c=relaxed/simple;
	bh=04rMup3j2LaCVUAfhSeo3lbGm2yG6I/qP0efXwJB3ds=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hi+IaXyY2MT+WsWnxC7Cupa2gqq1WK+5Y17TMufiggMio1NCtdTk9ZyNN9eFPwzQqAeIKizHbp8CsvVoTpcpTi+D/KIi2Rh7Ur0EFF4At0AF6KhivbeUlXIl9iphAfB845h3Qsqj3oLUI+nnXUoM6vJYyA8lm95ftzWqqHTG6R0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QzoX0wJL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QzoX0wJL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2948CC4CEEB;
	Mon,  2 Jun 2025 14:38:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748875104;
	bh=04rMup3j2LaCVUAfhSeo3lbGm2yG6I/qP0efXwJB3ds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QzoX0wJLxnHiVG2+LqwoaNv1xzMO/3d8Ibt4zU5WmuvJgzwXbQN9u+FEIjKt+Y+R2
	 TiThMw39ff9G/5owCq7v4W+bCWBES48oW6FfVFN/cRdruMIkOQNdWOe6BgEDcyPArm
	 neqeX5IbAarzo1JoFAnlRYO5INtMPKxT+4u0lZUE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Clark Wang <xiaoning.wang@nxp.com>,
	Carlos Song <carlos.song@nxp.com>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 5.10 005/270] i2c: imx-lpi2c: Fix clock count when probe defers
Date: Mon,  2 Jun 2025 15:44:50 +0200
Message-ID: <20250602134307.417809486@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134307.195171844@linuxfoundation.org>
References: <20250602134307.195171844@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Clark Wang <xiaoning.wang@nxp.com>

commit b1852c5de2f2a37dd4462f7837c9e3e678f9e546 upstream.

Deferred probe with pm_runtime_put() may delay clock disable, causing
incorrect clock usage count. Use pm_runtime_put_sync() to ensure the
clock is disabled immediately.

Fixes: 13d6eb20fc79 ("i2c: imx-lpi2c: add runtime pm support")
Signed-off-by: Clark Wang <xiaoning.wang@nxp.com>
Signed-off-by: Carlos Song <carlos.song@nxp.com>
Cc: <stable@vger.kernel.org> # v4.16+
Link: https://lore.kernel.org/r/20250421062341.2471922-1-carlos.song@nxp.com
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-imx-lpi2c.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/i2c/busses/i2c-imx-lpi2c.c
+++ b/drivers/i2c/busses/i2c-imx-lpi2c.c
@@ -616,9 +616,9 @@ static int lpi2c_imx_probe(struct platfo
 	return 0;
 
 rpm_disable:
-	pm_runtime_put(&pdev->dev);
-	pm_runtime_disable(&pdev->dev);
 	pm_runtime_dont_use_autosuspend(&pdev->dev);
+	pm_runtime_put_sync(&pdev->dev);
+	pm_runtime_disable(&pdev->dev);
 
 	return ret;
 }


