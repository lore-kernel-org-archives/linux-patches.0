Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7066205E13;
	Tue, 30 Jul 2024 16:01:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355280; cv=none; b=Bl9Oltz+z1dw2Qyfpdv2z3JrFf/MdvJfOssJqOJqYEK0PRs0hjYzdGv9kpObH1AZg33G7m4v3lqCSw0+26sanZqxrKKyOBDUsBJCtIakvm1gdjgPfaBxJfGEIJm+24m5hQ+JoTBZlP47ACMvg4N/q3KS2AYYOA5oBtgwyES/8FI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355280; c=relaxed/simple;
	bh=DXE7SjFNYQ9GFZ9dL27GVjPlW0LTWelPzGnQ8utgoO8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eSSqF9kspyacvVLTqCX03e69JaiFsd3cc2o85m2z2piv3xnB4G4MNdJUTS3qUIS8+h0FsEIoo305ecQe9vH9/1CUhHoJHgHqQzqr0MK3LIZeQIa/2q02JIxzSIbns1Me1tqsikCdgsynHqZH9nhilXw35mvAgpTODkiL4kvCjpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ug/DkQuV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ug/DkQuV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17CC6C32782;
	Tue, 30 Jul 2024 16:01:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355280;
	bh=DXE7SjFNYQ9GFZ9dL27GVjPlW0LTWelPzGnQ8utgoO8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ug/DkQuVLtY4hCwLOAZydeyDsxjRKOSM+3sgNGipTS5flq/zEBSjMcECRC2sPQUGl
	 1nVCz+B7r+aneANOXYmAc67BpM94/3XA+tM+bONJhyUsu6TJQ7XLcoDNBG4v6hPixU
	 f5VEXFGWzQuxT/a9knn74OP+JdGol0YgnoUiejWE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
	Andy Shevchenko <andy@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 079/440] firmware: turris-mox-rwtm: Do not complete if there are no waiters
Date: Tue, 30 Jul 2024 17:45:12 +0200
Message-ID: <20240730151618.846078078@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



