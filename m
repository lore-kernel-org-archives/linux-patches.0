Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0145A6E619;
	Tue, 14 May 2024 11:11:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715685089; cv=none; b=N9XiVgAumpzPnZ2e1bX9KguAKJBk9gDUfGVayX/H8pGOHOYXKTrik6MzOm/qLVx1iQa0+Qo1ATTj0yBhh983mi/6j73D9u3S5GJge9Lw82UEpMpQAzs1upJuVaHtOpKuZMCa7ktOkgYnDLXmeMXcA+0FWFUhleuQdsDHg3XF7VA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715685089; c=relaxed/simple;
	bh=t1iETI7c+Gu1Lb/jMKfM1mtzxT8boiGWPpiEcx4vQsM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PCblYmvRUxrPQIUsWn8e1t5VfRAiZ+LgqQm+0TAOiZyhkkJpysn+KDu4FgUdFI/XKv0DtbQJYP1gmF2rjZj9blb+3nom0a19qrzu4eYpH9VrdYKjVIUF03BinukIhLAKrrsushpApOQ680tJkuYpk4vBkTfbQkqDscZ6XeLmbDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qo4+EsJT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qo4+EsJT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9734EC2BD10;
	Tue, 14 May 2024 11:11:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715685088;
	bh=t1iETI7c+Gu1Lb/jMKfM1mtzxT8boiGWPpiEcx4vQsM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qo4+EsJTKfYwmQif7Z0jNZqOVTeZN/TnhbMRD9L+qlRdA4qiuOrozUCqi5yP2nO0I
	 4esOs/4QfeZoOVT6MaGxrHwBbV6Fec8wdV5aUPvj+zxZ9o58fWmUnzIjjQF9U1IlCy
	 UiCiNZ3Teg2EsObRM7yrq3mDBLWdK13XdO86coNo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ni <nichen@iscas.ac.cn>,
	Damien Le Moal <dlemoal@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 127/301] ata: sata_gemini: Check clk_enable() result
Date: Tue, 14 May 2024 12:16:38 +0200
Message-ID: <20240514101037.043916050@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101032.219857983@linuxfoundation.org>
References: <20240514101032.219857983@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Ni <nichen@iscas.ac.cn>

[ Upstream commit e85006ae7430aef780cc4f0849692e266a102ec0 ]

The call to clk_enable() in gemini_sata_start_bridge() can fail.
Add a check to detect such failure.

Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/sata_gemini.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/ata/sata_gemini.c b/drivers/ata/sata_gemini.c
index 400b22ee99c33..4c270999ba3cc 100644
--- a/drivers/ata/sata_gemini.c
+++ b/drivers/ata/sata_gemini.c
@@ -200,7 +200,10 @@ int gemini_sata_start_bridge(struct sata_gemini *sg, unsigned int bridge)
 		pclk = sg->sata0_pclk;
 	else
 		pclk = sg->sata1_pclk;
-	clk_enable(pclk);
+	ret = clk_enable(pclk);
+	if (ret)
+		return ret;
+
 	msleep(10);
 
 	/* Do not keep clocking a bridge that is not online */
-- 
2.43.0



