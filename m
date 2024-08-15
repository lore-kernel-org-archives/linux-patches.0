Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65F5D1714A8;
	Thu, 15 Aug 2024 13:41:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729260; cv=none; b=jlby88KOW+gvvulNxVlUt9uGMl4Mi5sLQpGEaJnfWVUYo6IKoNpsLhvPZc20txEnjv/3j92izvbfY6jpAwHPh7WhaIh7GbXC2uoLC92JhGXNiRaL7ljwNzeQ43DT9sngDeRa7M6HPVC2wOrc4K4I48qplqiTXhcQ98hvcNQsFpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729260; c=relaxed/simple;
	bh=DAZ7GcD7hBLkBkzjLkdf6HBLjpOcTiaOVhKYw8RAblU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LIcZhH1McNQoh005JN2d7SC/r5EllbwjCkwgYsDSOsu8v1SoZn2GDXwTYnSMI9L03mpttIAnBVJviedps5vtFNvFkXbwndteBpB69fk1ztLljcvv9aLs4KPl6gJnIAiMIoo6dE8QFqVRrb5gIgM4Ndn02h7b4Y82mRMiJtdRlNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y/cCkQXU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y/cCkQXU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83CACC32786;
	Thu, 15 Aug 2024 13:40:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729259;
	bh=DAZ7GcD7hBLkBkzjLkdf6HBLjpOcTiaOVhKYw8RAblU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y/cCkQXUg1yKP/8UXeZinEca6RAiVF0iBcAso77yK3Vq+X6pSiwFFqZCH/2QR2mZ7
	 gdoVIVlxWicGyzqF8JGLdtWgQIKPe2pbYVCLi7f5stiLnj5avf2l2JSG9QB24SDdny
	 fTGMOSg44PB5YD/r+dzdR9T4gA+eeIq4YVv3Tygo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
	Andy Shevchenko <andy@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 042/484] firmware: turris-mox-rwtm: Do not complete if there are no waiters
Date: Thu, 15 Aug 2024 15:18:20 +0200
Message-ID: <20240815131942.907087964@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Behún <kabel@kernel.org>

[ Upstream commit 0bafb172b111ab27251af0eb684e7bde9570ce4c ]

Do not complete the "command done" completion if there are no waiters.
This can happen if a wait_for_completion() timed out or was interrupted.

Fixes: 389711b37493 ("firmware: Add Turris Mox rWTM firmware driver")
Signed-off-by: Marek Behún <kabel@kernel.org>
Reviewed-by: Andy Shevchenko <andy@kernel.org>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/turris-mox-rwtm.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/firmware/turris-mox-rwtm.c b/drivers/firmware/turris-mox-rwtm.c
index c2d34dc8ba462..fa4b904d74df1 100644
--- a/drivers/firmware/turris-mox-rwtm.c
+++ b/drivers/firmware/turris-mox-rwtm.c
@@ -2,7 +2,7 @@
 /*
  * Turris Mox rWTM firmware driver
  *
- * Copyright (C) 2019 Marek Behún <kabel@kernel.org>
+ * Copyright (C) 2019, 2024 Marek Behún <kabel@kernel.org>
  */
 
 #include <linux/armada-37xx-rwtm-mailbox.h>
@@ -174,6 +174,9 @@ static void mox_rwtm_rx_callback(struct mbox_client *cl, void *data)
 	struct mox_rwtm *rwtm = dev_get_drvdata(cl->dev);
 	struct armada_37xx_rwtm_rx_msg *msg = data;
 
+	if (completion_done(&rwtm->cmd_done))
+		return;
+
 	rwtm->reply = *msg;
 	complete(&rwtm->cmd_done);
 }
-- 
2.43.0



