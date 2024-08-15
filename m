Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D44977DA9E;
	Thu, 15 Aug 2024 13:41:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729266; cv=none; b=L7YuOALTbuWFmvkEjk8U8ZByPvQF+Qxwb7L5GDM4mODbymegj5XhvvAcQIEM3pZlPfLEYrZHwML6SDTutkwu4eOEQspNl56VbSxHmwmTNyUZO7DDecM2Jfvh6GfYBfl4a+Pobq8qnPgSYv7TpX6IMjXFtduthLhSdgVsmctqQaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729266; c=relaxed/simple;
	bh=btCLhqanD33i1W3LS+OIp3KxnKQFTGbWHuqM9E7REi4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=g6UHOQSif0GTTD2LF0lN2rLS9BiecJHHCQLea56MUOeIsf299Zc7VQtbNMbjSV3LIPxXn8Et8RLzb8jiwivWmUuU2OE/JMiHl+5b51TrTH/dD4ZpRL2CEH1URcyFxHmRaewcmp4gKKQ25aCzR9nbpEM5Ee/kUJ3GGJnvRu5qeqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sTRvOb8Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sTRvOb8Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D471AC32786;
	Thu, 15 Aug 2024 13:41:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729266;
	bh=btCLhqanD33i1W3LS+OIp3KxnKQFTGbWHuqM9E7REi4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sTRvOb8QogS9AuJ7RL9GvWvM6gfSAbHeR7jS45w481TabMKyWDzID/kA8PiZDDAZ5
	 Bt9vauz4QCiFn7txXAQOI+KzqCt+YMOGWMNmAmIzZ+cbBsqJXjFvNM1iz7ao3kYrDA
	 SaEN86Wuh3bvdv44XFcxVmKMAzypgkoYyPVN1XeA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
	Andy Shevchenko <andy@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 044/484] firmware: turris-mox-rwtm: Initialize completion before mailbox
Date: Thu, 15 Aug 2024 15:18:22 +0200
Message-ID: <20240815131942.983716882@linuxfoundation.org>
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
index 98bdfadfa1d9e..c3d49fcc53305 100644
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



