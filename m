Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2523A2253E7;
	Thu, 12 Dec 2024 17:34:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734024885; cv=none; b=bfUJZc2pCviXuE+c/P0YiGycGVLT8vS+UGVAR6nX2CQ66QZsVSYWok0k7zlo+iCBwma42ZPsqacBM9kdDOUCUliC8eT13SKOhIn4rJTNYAGh7PrCVBxZejMQ0FxW9V5TlhJlA5ZL/qwbNo3fNwYG4QRA/51PVKLGFKeKLsa323Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734024885; c=relaxed/simple;
	bh=PstpwE0Ilz9pvGvFVDg/IHL++GWnZBu169W0Gl1g/TA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m0NUcP5EelnFbwn9IR/nu98nVSMGEcnKIQFAG1jkASVsx7vwI+K+Y5TsZbI1lpf/vr310xxKvtfaaDsNYEpqJrzEDLBbKTq7L2n+KUtTO+1Bllq7qyaOS0F/SOiKUmTQq3GBn+1w61LgijiAlfmD0yme011siuDySZ7qeiKNXsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G4nXh6l8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G4nXh6l8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C593C4CED0;
	Thu, 12 Dec 2024 17:34:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734024885;
	bh=PstpwE0Ilz9pvGvFVDg/IHL++GWnZBu169W0Gl1g/TA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G4nXh6l8QYyJukva2sNp+LSwwXBBIGVykbPtzmJJ4jwFrwCWodaZJ2OsHoYIMqXzq
	 thVyunWxBoLzXJIy1k27qZvl+PeuMPRE5ejr/NHtg+f+wgNIJYcz60k8hjvaSUIzsg
	 YAvQ95KkRupsZYluENjq1h3c7T5J8/tmaYhaD45Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Antipov <dmantipov@yandex.ru>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 414/459] rocker: fix link status detection in rocker_carrier_init()
Date: Thu, 12 Dec 2024 16:02:32 +0100
Message-ID: <20241212144310.113984279@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
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

From: Dmitry Antipov <dmantipov@yandex.ru>

[ Upstream commit e64285ff41bb7a934bd815bd38f31119be62ac37 ]

Since '1 << rocker_port->pport' may be undefined for port >= 32,
cast the left operand to 'unsigned long long' like it's done in
'rocker_port_set_enable()' above. Compile tested only.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
Link: https://patch.msgid.link/20241114151946.519047-1-dmantipov@yandex.ru
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/rocker/rocker_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/rocker/rocker_main.c b/drivers/net/ethernet/rocker/rocker_main.c
index dd0bc7f0aaeee..ec90f75289dbe 100644
--- a/drivers/net/ethernet/rocker/rocker_main.c
+++ b/drivers/net/ethernet/rocker/rocker_main.c
@@ -2542,7 +2542,7 @@ static void rocker_carrier_init(const struct rocker_port *rocker_port)
 	u64 link_status = rocker_read64(rocker, PORT_PHYS_LINK_STATUS);
 	bool link_up;
 
-	link_up = link_status & (1 << rocker_port->pport);
+	link_up = link_status & (1ULL << rocker_port->pport);
 	if (link_up)
 		netif_carrier_on(rocker_port->dev);
 	else
-- 
2.43.0



