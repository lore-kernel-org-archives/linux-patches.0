Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7E20223DC0;
	Mon,  2 Jun 2025 15:10:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748877045; cv=none; b=ehORj4+utEPoVVI7RG3/e0sBNQES/MLAg+vn3swzOxQ39SBHUQId+ggy85XJCpjg1nCFc95XanzTSdKgWo3mLxZ/8LfodSIVGl4L2IBU0xy7WzByGK0s0syTIhBId5loh/u1/C5f2DjZpziL39Ea6IVpQgG9K1nN3sVmoOYw2j4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748877045; c=relaxed/simple;
	bh=+PCNIdUm+7mmRdG8CVYJK65PdyNBdknkBgzQgLoXkok=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iIaEwsPqWu/qEpAZWcNIfaVd9Pm1AjN+UGtBc1EmSmArDhXwpti8CixdhWr+x2tLxCKKeCSx8epYPA95whGF4TdEmkze+QfoT7Uh+PLRxepq8jc7Q0j29ooZXtMui6AGnYF0ntB23jnWaBjW9IsvP3flZGUdwbBPCYyY3yToocI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ygH88uQD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ygH88uQD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EFD5C4CEEB;
	Mon,  2 Jun 2025 15:10:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748877045;
	bh=+PCNIdUm+7mmRdG8CVYJK65PdyNBdknkBgzQgLoXkok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ygH88uQDBnK/aSMYRe+XKCs+DEV0WYv0ja5dOtLcjaTzHbN2DMPCavaCz2V1z5WGR
	 0dcOKPDKJ0jQzMiIc3EDTWViIM1j/74f1/TDPYa83ic8BqiMC4+BsCHAt6/PVcm63x
	 aMJDi60maiZMJUND4pMBgiOgIpXnr2gpQOl8XRlM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 155/325] i3c: master: svc: Flush FIFO before sending Dynamic Address Assignment(DAA)
Date: Mon,  2 Jun 2025 15:47:11 +0200
Message-ID: <20250602134326.111563529@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134319.723650984@linuxfoundation.org>
References: <20250602134319.723650984@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index cf0550c6e95f0..8cf3aa800d89d 100644
--- a/drivers/i3c/master/svc-i3c-master.c
+++ b/drivers/i3c/master/svc-i3c-master.c
@@ -833,6 +833,8 @@ static int svc_i3c_master_do_daa_locked(struct svc_i3c_master *master,
 	u32 reg;
 	int ret, i;
 
+	svc_i3c_master_flush_fifo(master);
+
 	while (true) {
 		/* Enter/proceed with DAA */
 		writel(SVC_I3C_MCTRL_REQUEST_PROC_DAA |
-- 
2.39.5



