Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77AA3139599;
	Tue, 14 May 2024 11:43:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687030; cv=none; b=lVUw4Bk2opmuVnpddJfklMAVb0HIbp7EoN4wnW4JVP7ZTA9EMPgwhjydpLOdXwKWhUYDPcOqaMwQWr9OI8EHzqpxkXA1auY+dGj7ZoMyX7VC9a4fuyJKF9wPvXGDWMcH6tjha0veBx8Iuw4lZUqmG61cslYXrILpNL4aNrwDMps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687030; c=relaxed/simple;
	bh=iXOj0Zary+hfmKxC7UTpZNrmquIS7nPVDoxDzvQZeeo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cEvf4hChp+Yd96GItC/6SQkKiadMtUnLYZyS67+V33XUFBKFB0CStwpnvTNqD9IcQR/y7eHW0zUIu9COsdUzfIfChcZ3YiOly76FCu85PXVCxyiXtYTUGQ1Ec7lnT+nS0lcWkL6BRrh46L2dkqzKkxvoANTAI0qPsCUeoGCnCk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x5xXiMRB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x5xXiMRB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F218CC2BD10;
	Tue, 14 May 2024 11:43:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687030;
	bh=iXOj0Zary+hfmKxC7UTpZNrmquIS7nPVDoxDzvQZeeo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x5xXiMRBdam2Y8k7xC/wbCvx+FT3iKQaUnto0m0MlIWWVZyXG7Jo2Kd0/sefp6Bx0
	 QNgsL1oAC7kGFnKZ4GCSfvLPOany5Vt/JSAVo3uC33Z3y0v3MwM5Hn/vU1VpNSmMb8
	 usMHxEp8TqnfGuqnzKnVQy8Hw2xZtYYy/oysqlYI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ni <nichen@iscas.ac.cn>,
	Damien Le Moal <dlemoal@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 41/84] ata: sata_gemini: Check clk_enable() result
Date: Tue, 14 May 2024 12:19:52 +0200
Message-ID: <20240514100953.237047001@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514100951.686412426@linuxfoundation.org>
References: <20240514100951.686412426@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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



