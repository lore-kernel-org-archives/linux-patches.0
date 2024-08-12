Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC6E1183CA6;
	Mon, 12 Aug 2024 16:12:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479152; cv=none; b=d3iiCrlfsi6WH7X2NsLs//DA64f32hSF+bbjUGTI+JE2h8Gxa3OfGpiFdm7mzmGrVBiON7rdnxB9vRrTAtbQvP2SH/+Jdma8zMR7wg1Y2MaZWpeMLmCPsazdFEWRdpa4L3BcDu8wRpXkZH8szZR+FjwqW7VWoKRlmgwZrZCdjD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479152; c=relaxed/simple;
	bh=5lbgN162dv0nfYhpDxBC4QgG8fDtzqOfJdGwNEc3Pk4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R5iPnyzMOTVqmK4c02WXcW7yecdPgv6s/zsOYTpVScTd9878y0QFsKXAg4DvHtE9IHfTcAfIXcNvkylCfJGPv+y28lAMhnQWJcQxdTTkK/HP7wmcnEf6X0/eXqkytF+9LKx+ykVbIHHIFIo7QZdMiufLdZTW9TY2x3J8EtZN7oI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bG4S93FK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bG4S93FK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 466DCC32782;
	Mon, 12 Aug 2024 16:12:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479152;
	bh=5lbgN162dv0nfYhpDxBC4QgG8fDtzqOfJdGwNEc3Pk4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bG4S93FKYCVq5LGm4re86faCu7duhUnMWmDxisMyav9bp6UULTGm25VSt5nSVbbcU
	 kIDuWDLLgaxiU1Ml+ZlyY50X9q7t2y7wXwjNQhWeECAHmEdv+ozKBKG63hiYNYLU9B
	 HjpOaI984OH2cg5Ru3kSIjMYNqs9vDaLidb7P8Oo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Wolfram Sang <wsa@kernel.org>
Subject: [PATCH 6.1 149/150] i2c: qcom-geni: fix missing clk_disable_unprepare() and geni_se_resources_off()
Date: Mon, 12 Aug 2024 18:03:50 +0200
Message-ID: <20240812160130.918897848@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160125.139701076@linuxfoundation.org>
References: <20240812160125.139701076@linuxfoundation.org>
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

From: Yang Yingliang <yangyingliang@huawei.com>

commit 043465b66506e8c647cdd38a2db1f2ee0f369a1b upstream.

Add missing clk_disable_unprepare() and geni_se_resources_off() in the error
path in geni_i2c_probe().

Fixes: 14d02fbadb5d ("i2c: qcom-geni: add desc struct to prepare support for I2C Master Hub variant")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Reviewed-by: Andi Shyti <andi.shyti@kernel.org>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-qcom-geni.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/i2c/busses/i2c-qcom-geni.c
+++ b/drivers/i2c/busses/i2c-qcom-geni.c
@@ -859,6 +859,7 @@ static int geni_i2c_probe(struct platfor
 	ret = geni_se_resources_on(&gi2c->se);
 	if (ret) {
 		dev_err(dev, "Error turning on resources %d\n", ret);
+		clk_disable_unprepare(gi2c->core_clk);
 		return ret;
 	}
 	proto = geni_se_read_proto(&gi2c->se);
@@ -878,8 +879,11 @@ static int geni_i2c_probe(struct platfor
 		/* FIFO is disabled, so we can only use GPI DMA */
 		gi2c->gpi_mode = true;
 		ret = setup_gpi_dma(gi2c);
-		if (ret)
+		if (ret) {
+			geni_se_resources_off(&gi2c->se);
+			clk_disable_unprepare(gi2c->core_clk);
 			return dev_err_probe(dev, ret, "Failed to setup GPI DMA mode\n");
+		}
 
 		dev_dbg(dev, "Using GPI DMA mode for I2C\n");
 	} else {
@@ -892,6 +896,8 @@ static int geni_i2c_probe(struct platfor
 
 		if (!tx_depth) {
 			dev_err(dev, "Invalid TX FIFO depth\n");
+			geni_se_resources_off(&gi2c->se);
+			clk_disable_unprepare(gi2c->core_clk);
 			return -EINVAL;
 		}
 


