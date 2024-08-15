Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 793C41B32CD;
	Thu, 15 Aug 2024 14:12:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731173; cv=none; b=FMsodcFqgsGbSVwMDSN66XEvpmqFODmpywZXtU9H6t+IkCJP72PQm1K4WqdjtxFAGPYBOTcCzmT4IWIv9q+knLFcZI5Vvg2UgxXqlqtbCRiCvIWU08u0Jx2XXUEkGyN6y5Df9nI8Pz5+n0xBF2JJC+67QW+ze28s8378h/m1ejw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731173; c=relaxed/simple;
	bh=EGM5VYOwPMWl291bCBpPPDcDlfPi/s/i1ubBxqQfxzE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dXTyq0OxngyLSzV6vQwrqvb7jrRft0TnUmVPurFP9hunGAAMeeM3KS0jwQgOCMGizp2bAOfsv4SKKSyPFYSuyqnUxYuJUqheZ2s+fpeTZqm+iLaYIeObPKQy8YZ5RuRFY+uU8e3VmOVloP+GwKDtR2ra3nMeN+k6Ua4hKn45YDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g6v7Vuu1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g6v7Vuu1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A509FC4AF0C;
	Thu, 15 Aug 2024 14:12:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723731173;
	bh=EGM5VYOwPMWl291bCBpPPDcDlfPi/s/i1ubBxqQfxzE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g6v7Vuu1rvkejgGT4WuMYq+9vp+Q3gKFJ1gQHS9Yd40SLJtX2X1ix4zMFAKPfO5Lw
	 uyaZbqYZyfBAqSULYteLEGnTxfKySX6K/7bETw/GIX8lhWX0Ic8q6MNvUYoDDir1Sg
	 uTe18Ht8BqjUQVSnkLU7tDwGpp5SIoqWQvVv9Kzk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
	Andy Shevchenko <andy@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 028/259] firmware: turris-mox-rwtm: Initialize completion before mailbox
Date: Thu, 15 Aug 2024 15:22:41 +0200
Message-ID: <20240815131903.886227177@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131902.779125794@linuxfoundation.org>
References: <20240815131902.779125794@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Behún <kabel@kernel.org>

[ Upstream commit 49e24c80d3c81c43e2a56101449e1eea32fcf292 ]

Initialize the completion before the mailbox channel is requested.

Fixes: 389711b37493 ("firmware: Add Turris Mox rWTM firmware driver")
Signed-off-by: Marek Behún <kabel@kernel.org>
Reviewed-by: Andy Shevchenko <andy@kernel.org>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/turris-mox-rwtm.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/firmware/turris-mox-rwtm.c b/drivers/firmware/turris-mox-rwtm.c
index 852d911c78f6b..212a463973737 100644
--- a/drivers/firmware/turris-mox-rwtm.c
+++ b/drivers/firmware/turris-mox-rwtm.c
@@ -337,6 +337,7 @@ static int turris_mox_rwtm_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, rwtm);
 
 	mutex_init(&rwtm->busy);
+	init_completion(&rwtm->cmd_done);
 
 	rwtm->mbox_client.dev = dev;
 	rwtm->mbox_client.rx_callback = mox_rwtm_rx_callback;
@@ -350,8 +351,6 @@ static int turris_mox_rwtm_probe(struct platform_device *pdev)
 		goto remove_files;
 	}
 
-	init_completion(&rwtm->cmd_done);
-
 	ret = mox_get_board_info(rwtm);
 	if (ret < 0)
 		dev_warn(dev, "Cannot read board information: %i\n", ret);
-- 
2.43.0



