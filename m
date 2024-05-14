Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E5C17FBD3;
	Tue, 14 May 2024 11:48:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687317; cv=none; b=NfU+D5uC6i30nM7rIQUNFDx2V8uKp5TjG2gbdKOdG4fOP/9doobki7Baldqdt1zGhtVmRrIVfM7UtttpX1i1Bfc9bmu2wSpxPDq6AU8yOAguQsNLehaO64UxpkyOpS20NbGfb0//1TSx2JVyoFXKdWzd+nIl2RLKu8598DfYXoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687317; c=relaxed/simple;
	bh=2aFs2ub9pUz+Ck+ohU33ectu2MJfopu4gboC+NPKaQs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IQev6ViQoUdiix06kj3m1O2uiKnnYGjxuVHWexGDqz7yNQp2vl4QvzP7Ztb3fxBEQ9LwtipP6A5NYW18FQOlE4+D+N0yyZfJOsx3ArT/A6zAP/uz3vfzXEGH2663CEOe4mnngSmFuCF+Wq9kzT//OJdMNszsJJw79ZhWv85Unio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OsnttwQS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OsnttwQS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A8DCC2BD10;
	Tue, 14 May 2024 11:48:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687316;
	bh=2aFs2ub9pUz+Ck+ohU33ectu2MJfopu4gboC+NPKaQs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OsnttwQSEGUOfgOgAKIkyi5FDoJ/Akf53nCWwUZS+ilGPx0Qg4QAzvnG8/3vc26N3
	 K6YenEBd197lgZeR2XP/zZBdWDe8B86L9T5fayMyh/BC+XxBnWwqltQJblxXYBOPIo
	 O7us6nF9NM7Z/FVvpV1QdeZ0XGi0yqgHJUKM7m2s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ni <nichen@iscas.ac.cn>,
	Damien Le Moal <dlemoal@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 053/111] ata: sata_gemini: Check clk_enable() result
Date: Tue, 14 May 2024 12:19:51 +0200
Message-ID: <20240514100959.149399342@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514100957.114746054@linuxfoundation.org>
References: <20240514100957.114746054@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 6fd54e968d10a..1564472fd5d50 100644
--- a/drivers/ata/sata_gemini.c
+++ b/drivers/ata/sata_gemini.c
@@ -201,7 +201,10 @@ int gemini_sata_start_bridge(struct sata_gemini *sg, unsigned int bridge)
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



