Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5193B1DED64;
	Mon,  2 Jun 2025 14:15:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748873751; cv=none; b=VPgq96dBpz1PgKf/emFsqqxNjLbwHSiKY1JUECb5duX2wRWi4JOsmZOJIqvOd4bC0nvsfxDs+CARbpGpzuWPt4yQ2nSg64z2V43dgSBwIc9KEIYRS7oGpqAzF9E49E8EzTphT6Bh4qe9SeV+KrYayPC+5trMbM89i4zKXcoh+XQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748873751; c=relaxed/simple;
	bh=v5CfxUsdx38LDzk7aduxrJqUcybxde6lQ21G3P8ZVjM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EuT3fz5M+/HkEQtQ4uLpDetpN+uzpp22NrX0zHLMNWpSSZOhcUNXSgR6aSV9VVJ5Vvn7sEhSnbQgWbJCB+XEf4zvv9gPU6+U170GpdtiHl0ovTzK58piF6MEntj4kTa4EYJg6mvsn7L2dCYc4/pImYHVYHh4VTCMZiDn7uPsaZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OS1iV2Dd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OS1iV2Dd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5DCCC4CEEB;
	Mon,  2 Jun 2025 14:15:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748873751;
	bh=v5CfxUsdx38LDzk7aduxrJqUcybxde6lQ21G3P8ZVjM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OS1iV2Dd2/eM2H34UaFZ+AtjRgaaa5gRBLUQYu4cTmGHXCvL8GSU2gcu0lKOtOvN9
	 1r/EyuNx3ByCXbMOX6niP2BzF7QKBALODXNskuEjvhEz9ePey/BaUJulkdQdTcrpDK
	 YQKwnLKAgXWh/h2Xsph77uvMrSEgT08af4rNrPdc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 209/444] i3c: master: svc: Flush FIFO before sending Dynamic Address Assignment(DAA)
Date: Mon,  2 Jun 2025 15:44:33 +0200
Message-ID: <20250602134349.393376061@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 3cef3794f10d3..3d1734849e0d9 100644
--- a/drivers/i3c/master/svc-i3c-master.c
+++ b/drivers/i3c/master/svc-i3c-master.c
@@ -841,6 +841,8 @@ static int svc_i3c_master_do_daa_locked(struct svc_i3c_master *master,
 	u32 reg;
 	int ret, i;
 
+	svc_i3c_master_flush_fifo(master);
+
 	while (true) {
 		/* Enter/proceed with DAA */
 		writel(SVC_I3C_MCTRL_REQUEST_PROC_DAA |
-- 
2.39.5



