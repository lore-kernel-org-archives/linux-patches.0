Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F16746F49C;
	Tue, 21 Jul 2026 19:39:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662791; cv=none; b=MYptXIoHCJkB7tD4mMIRntzLriqxxgqHZOIrTU8Db/334N4yqF3qjGnFxqNpVG78KqkBCIaDDvYKAQAiSGVYFn+KCzJx/2jkJztuPr7LDDfgKVUW8C8z62KkLFAe4tiO4l7Q5bjQqhZzJB9LXg3WjHISHJch5OpleVHQunKuJHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662791; c=relaxed/simple;
	bh=/mopUl5XrNcNDNH7Ibl6ePwU+8zC8J4GCVcBnQCRTBA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ubS1Psyu1PWwL5SCYC0cMhPLeX/dOjbWeU7U9nzK4YddtLdXaU2Ni2BLpn/6QDgKd4mbk6BPYrJLEk4Pk6KkC1NLJlRB2CFqF9/dcN2QD8OdUk5rP2WkTWdnbypD/9/SJMj+bpjqGQgsjen/JGjJ/SVITvBNSpV3uvwwI84+i6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JbWraFls; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JbWraFls"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E49611F000E9;
	Tue, 21 Jul 2026 19:39:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662790;
	bh=K7kx78IVrOBUIyorPQrEz0rOl1QZ5qnSXHZ58c6ouFA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JbWraFlsX5ABzom6XzuwaPpDaja9sCqWtC6Dsu5g04b68Xd4U8EIQPCL20tR32frY
	 Rcxfvsr5EBLl01wJolt1qfrRCI/jBdsE5wsuZ6I1mYXQc7CGtreCXU3LYYcUMcBWAh
	 xu75HCZlFmHawgjlT8FvZ8pXaSyKS4ErQeePzvfk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quang Nguyen <quang.nguyen.wx@renesas.com>,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0578/1276] spi: rpc-if: Use correct device for hardware reinitialization on resume
Date: Tue, 21 Jul 2026 17:17:01 +0200
Message-ID: <20260721152459.048435888@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Quang Nguyen <quang.nguyen.wx@renesas.com>

[ Upstream commit 7b25dbafa2fce50b1a48c1d057adb35da3563f9b ]

rpcif_spi_resume() currently passes the SPI controller device to
rpcif_hw_init(), but the function should be called with the RPC
interface device.

Retrieve the rpcif private data from the SPI controller and pass
rpc->dev instead. Also propagate the return value of rpcif_hw_init() so
that a failure during resume is properly reported rather than silently
ignored.

Fixes: ad4728740bd6 ("spi: rpc-if: Add resume support for RZ/G3E")
Signed-off-by: Quang Nguyen <quang.nguyen.wx@renesas.com>
Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://patch.msgid.link/20260618081932.172168-1-biju.das.jz@bp.renesas.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-rpc-if.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-rpc-if.c b/drivers/spi/spi-rpc-if.c
index 43e829251af591..e49a04ae32cf73 100644
--- a/drivers/spi/spi-rpc-if.c
+++ b/drivers/spi/spi-rpc-if.c
@@ -192,8 +192,12 @@ static int __maybe_unused rpcif_spi_suspend(struct device *dev)
 static int __maybe_unused rpcif_spi_resume(struct device *dev)
 {
 	struct spi_controller *ctlr = dev_get_drvdata(dev);
+	struct rpcif *rpc = spi_controller_get_devdata(ctlr);
+	int ret;
 
-	rpcif_hw_init(dev, false);
+	ret = rpcif_hw_init(rpc->dev, false);
+	if (ret)
+		return ret;
 
 	return spi_controller_resume(ctlr);
 }
-- 
2.53.0



