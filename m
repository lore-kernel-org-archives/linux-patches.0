Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E4421A3159;
	Tue, 27 May 2025 17:38:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367486; cv=none; b=PvE3k6+MAiuICHRWJ+oKXmRg37nCWqzd+pQXEqY9wNaY4FpNHeczbYBwC3dmFWgF5mX6dPDN4piKX11ItcRaniuZOUch9BH89onIUN63B4rwRsOYo8YkQfIkqDjmTjyXFV87Kn9ONy8fpybzNFGrFXV6LYQe0lWCDBDXfaMwClk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367486; c=relaxed/simple;
	bh=uiakvEDJhbeTcKr1DhogdbRIo4cjVjGS9A1vZP3GlJI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YC/byOghdb4i2ZYf3B1E8vCW6CTlJq5QYoESm/Ls291Jr8erJAWKaGWUD9f89EdatWZ57xOahbMaPE0UckmARIJx3qKiVPJFvhtrsQ0uWGaWQOMOhd3YBe6fsEabpgyrk3+4JIY0ViWHmwBGpAR6wIsCryn16iE9iBxSSPBE5aA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h5C6nFp4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h5C6nFp4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0D34C4CEE9;
	Tue, 27 May 2025 17:38:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367486;
	bh=uiakvEDJhbeTcKr1DhogdbRIo4cjVjGS9A1vZP3GlJI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h5C6nFp4xprTuju99bKv8Ma+T/QUnvVrrxUjx+W0Y9l6i9puYB0eVtqUtkHd3I2SM
	 Ad7YY+WcvkiK8uLJ0a6AFSzkU5o4DaQtn1ghya60omdjt78NKkRPyvf9SpIfDLI6jb
	 7fb0ThSPe7yEnno8swnC3ZKbpaety9hSo+9I9Lpg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 403/783] i3c: master: svc: Flush FIFO before sending Dynamic Address Assignment(DAA)
Date: Tue, 27 May 2025 18:23:20 +0200
Message-ID: <20250527162529.509004117@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frank Li <Frank.Li@nxp.com>

[ Upstream commit a892ee4cf22a50e1d6988d0464a9a421f3e5db2f ]

Ensure the FIFO is empty before issuing the DAA command to prevent
incorrect command data from being sent. Align with other data transfers,
such as svc_i3c_master_start_xfer_locked(), which flushes the FIFO before
sending a command.

Signed-off-by: Frank Li <Frank.Li@nxp.com>
Reviewed-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/r/20250129162250.3629189-1-Frank.Li@nxp.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master/svc-i3c-master.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/i3c/master/svc-i3c-master.c b/drivers/i3c/master/svc-i3c-master.c
index a18fe62962b0c..2cf2c567f8931 100644
--- a/drivers/i3c/master/svc-i3c-master.c
+++ b/drivers/i3c/master/svc-i3c-master.c
@@ -899,6 +899,8 @@ static int svc_i3c_master_do_daa_locked(struct svc_i3c_master *master,
 	u32 reg;
 	int ret, i;
 
+	svc_i3c_master_flush_fifo(master);
+
 	while (true) {
 		/* clean SVC_I3C_MINT_IBIWON w1c bits */
 		writel(SVC_I3C_MINT_IBIWON, master->regs + SVC_I3C_MSTATUS);
-- 
2.39.5



