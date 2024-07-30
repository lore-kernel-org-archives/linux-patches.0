Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F74C18952F;
	Tue, 30 Jul 2024 16:20:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356408; cv=none; b=XHwgQssH6EyCNYzA0Ek2NVvBi9H7xqtmZTuRccmm2Qg+LtfkpVX8zBrfWAA1wMpUtkHEKKhueD68Lv3cicEf6OIahTn/u9IkQqZUgXOqeOKqOfbHJEpqifxqlL3P7SFiuTNlBLUPXx2MRzoCEDs+s4tB8VH3kfKrnf/s57OfY20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356408; c=relaxed/simple;
	bh=V3pxTe/Vt/wShbdUTWEbAem5A3o8eOmEkMH7wWtakD8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fMT17Bqir+07znBO2s+1aBiABR5oEfYiGViqX6ZLSit6LRJqqUaUE9/d8F8SHy5y5NBNEC9dkXvBH05BZ7slwN4VLIKJD6hMbeQ+7ERqBfw+WCUO/3kE/furMsBqh098iN13kGV8GZQZYq+TeByZvL+TVR36aVTD6uYruxcugGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BIhiVND7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BIhiVND7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E07F2C4AF0C;
	Tue, 30 Jul 2024 16:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356408;
	bh=V3pxTe/Vt/wShbdUTWEbAem5A3o8eOmEkMH7wWtakD8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BIhiVND7KhscToCi1GP0YAAATK7w4fdqyFM6q9my4dEi0ajNJed0rWpISwuyPJtq4
	 Vtft0wYmv/MaZ7qI9eRahgFJ2qkul1gxC/Lge02ZP0j0d880DmU8OJYIAg3hrASpXc
	 3HazF20ZS7xmpi15VagVZLZhcJ22/9OCLB/16YzI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
	Andy Shevchenko <andy@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 147/809] firmware: turris-mox-rwtm: Initialize completion before mailbox
Date: Tue, 30 Jul 2024 17:40:23 +0200
Message-ID: <20240730151730.412042274@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index 3f4758e03c818..3e7f186d239a2 100644
--- a/drivers/firmware/turris-mox-rwtm.c
+++ b/drivers/firmware/turris-mox-rwtm.c
@@ -499,6 +499,7 @@ static int turris_mox_rwtm_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, rwtm);
 
 	mutex_init(&rwtm->busy);
+	init_completion(&rwtm->cmd_done);
 
 	rwtm->mbox_client.dev = dev;
 	rwtm->mbox_client.rx_callback = mox_rwtm_rx_callback;
@@ -512,8 +513,6 @@ static int turris_mox_rwtm_probe(struct platform_device *pdev)
 		goto remove_files;
 	}
 
-	init_completion(&rwtm->cmd_done);
-
 	ret = mox_get_board_info(rwtm);
 	if (ret < 0)
 		dev_warn(dev, "Cannot read board information: %i\n", ret);
-- 
2.43.0



