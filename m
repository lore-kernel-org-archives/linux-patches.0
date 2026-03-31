Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 448341C861A;
	Tue, 31 Mar 2026 16:42:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975342; cv=none; b=EBtWPTJsvYV6/xgGdlKIvbACXmocryKijD88MRS3tY+rnv0qe7/90ctUQS3A6ANiB8vI5TGwF7/45tetPGRYq5JKgYoZhuPrq3CLYfgIcZTqMRwueDPsMngJpJok4pg1yZOvPxoKtibjdxC6AERQIH5OqdS5D0M2iDTlMsxUBao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975342; c=relaxed/simple;
	bh=ZIK4vX7gJ4nlz/JyaHEqXYasogU2FlmmT9mrVd6YUlA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CcK+QVA49lz/U3rMfTFeOx/Ts5f1ui5nvnf7WI048HJTSN3ENoFPUWOlLxpPe58kU+fQbUdCKJgjamIjGoy3JRZGca6kz3BNlECCdQCddT068iDag5nSIgroV5F8V99gGMR7hy9X9j5NwP/oDcmgKNu5XTanlK65DObmQJ/2a7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BLbQ3Tyt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BLbQ3Tyt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95471C19423;
	Tue, 31 Mar 2026 16:42:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975341;
	bh=ZIK4vX7gJ4nlz/JyaHEqXYasogU2FlmmT9mrVd6YUlA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BLbQ3TytOUPDScT4Zjn8PyWq3E7myyq1yHoB1xuzlNy62Boj2hcJrfVNKHUDRJjX3
	 W9fxl2dL11Mnf9TYu83wy2jS6uBXEnGQr4ogk4fKoVFStIp4zLn+Sx7g7bQpiTjrn5
	 WbqFw9cOgb+kW7aK4a9WAY2UQ0U3Qc48VHzSIjUE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Eichenberger <stefan.eichenberger@toradex.com>,
	Frank Li <Frank.Li@nxp.com>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 6.19 257/342] i2c: imx: fix i2c issue when reading multiple messages
Date: Tue, 31 Mar 2026 18:21:30 +0200
Message-ID: <20260331161808.411268368@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>
References: <20260331161758.909578033@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Eichenberger <stefan.eichenberger@toradex.com>

commit f88e2e748a1fc3cb4b8d163a9be790812f578850 upstream.

When reading multiple messages, meaning a repeated start is required,
polling the bus busy bit must be avoided. This must only be done for
the last message. Otherwise, the driver will timeout.

Here an example of such a sequence that fails with an error:
i2ctransfer -y -a 0 w1@0x00 0x02 r1 w1@0x00 0x02 r1
Error: Sending messages failed: Connection timed out

Fixes: 5f5c2d4579ca ("i2c: imx: prevent rescheduling in non dma mode")
Cc: stable@vger.kernel.org # v6.13+
Signed-off-by: Stefan Eichenberger <stefan.eichenberger@toradex.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://lore.kernel.org/r/20260218150940.131354-2-eichest@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-imx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/i2c/busses/i2c-imx.c
+++ b/drivers/i2c/busses/i2c-imx.c
@@ -1522,7 +1522,7 @@ static int i2c_imx_read(struct imx_i2c_s
 		dev_err(&i2c_imx->adapter.dev, "<%s> read timedout\n", __func__);
 		return -ETIMEDOUT;
 	}
-	if (!i2c_imx->stopped)
+	if (i2c_imx->is_lastmsg && !i2c_imx->stopped)
 		return i2c_imx_bus_busy(i2c_imx, 0, false);
 
 	return 0;


