Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 161EE7A124;
	Mon,  4 Mar 2024 21:26:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709587610; cv=none; b=qKIhE0CZLSleZm5y6CE80ltoYvcmZ/VgCd5Mm9vI/PTtG4PdVIiyUqidenZuL/xNa+nN0QxvufO3yDLBYazdCVJiN3L/x9mK6rg/j3ivWX6O+qO7X8otxyGdA8pldR7EXtKHsG01fOuLjgGnYASRwi0ACnA4WBO2VwIerf2T+DU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709587610; c=relaxed/simple;
	bh=ApLvzvvlDkvIkumfw+29NxJpI1MkyhODOO4YdWsSEak=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PRtQVFyspP9JrKuBv/GTyeTVeXyzpwsIuCFCX05WahmkeBft/mTc0EyprPdRfksQ1Pz1BPUbkL8o0swX4o2aIlcT9G5jlFmBN+KRE15rLD4IumNp7iM/8t5CcVIzLBlXehu1Cmv2EmSCa2upaAzvCvjkVJkFljiovVP0TNUkAu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AAyUGe+z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AAyUGe+z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C51FC433F1;
	Mon,  4 Mar 2024 21:26:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709587610;
	bh=ApLvzvvlDkvIkumfw+29NxJpI1MkyhODOO4YdWsSEak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AAyUGe+ztm7/77E6V8DfTp0jl/g4z3uBU1BLt5xpwvgte2QJrTxSFnI7aTX+lIzmn
	 I+XlFczHgJAWIaBrKzhjWq7mnjBezDHytpP5rrLZT7ft2iBOjLOyTClKjFZHELbZFG
	 MzBnawgcAFb9m5MQ9ZFDeVKk3IhjpGHddxNg6BcY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 022/162] net: lan78xx: fix "softirq work is pending" error
Date: Mon,  4 Mar 2024 21:21:27 +0000
Message-ID: <20240304211552.541138802@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211551.833500257@linuxfoundation.org>
References: <20240304211551.833500257@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oleksij Rempel <o.rempel@pengutronix.de>

[ Upstream commit e3d5d70cb483df8296dd44e9ae3b6355ef86494c ]

Disable BH around the call to napi_schedule() to avoid following
error:
NOHZ tick-stop error: local softirq work is pending, handler #08!!!

Fixes: ec4c7e12396b ("lan78xx: Introduce NAPI polling support")
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Link: https://lore.kernel.org/r/20240226110820.2113584-1-o.rempel@pengutronix.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/lan78xx.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/usb/lan78xx.c b/drivers/net/usb/lan78xx.c
index 2e6d423f3a016..a2dde84499fdd 100644
--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -1501,7 +1501,9 @@ static int lan78xx_link_reset(struct lan78xx_net *dev)
 
 		lan78xx_rx_urb_submit_all(dev);
 
+		local_bh_disable();
 		napi_schedule(&dev->napi);
+		local_bh_enable();
 	}
 
 	return 0;
-- 
2.43.0



