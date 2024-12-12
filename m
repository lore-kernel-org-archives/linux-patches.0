Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CCE0209695;
	Thu, 12 Dec 2024 17:49:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734025798; cv=none; b=B9Tgqh0BJLGXRFrb1seMLPYsDcy7sBGPxUYV2dT6cX48H18O4iP3C6gM24HqjbK5Hg1jCxBDShmrHqYO6/a3wHk0fh6woSONRykiN5Y5QBM38FWWIoGnrCcH5+c1GCHlYFQnSZm7/VMy4VC8VwaUDggXfgDVPUw5qM4e0NNDfus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734025798; c=relaxed/simple;
	bh=G3EeNrpolzR8vRMLL+m4x6Z3yaRs4rhYyVh/+ZG0aB0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GK1UpqX7Gmg+xUU1lWFTe3MIc5WhIFMVefcbl7eDeuaWlEDcPQW8eBzmVLrW06rMgm5zTTCicnvTfLHYehtsWioWB6m9Tjwfg1G6m6NSrliAMpFGlYW1NaAA36Q9Xi7dg6BAxzuKXr79UneraiGx7RrkjAaUrCmPBKPZT01slLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NlYrPww4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NlYrPww4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27615C4CECE;
	Thu, 12 Dec 2024 17:49:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734025798;
	bh=G3EeNrpolzR8vRMLL+m4x6Z3yaRs4rhYyVh/+ZG0aB0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NlYrPww42qR76EnMSvORpTM0+VuHK5/AsGGtduiROCLDHCZLh5ZBGpw5tZa3ohVGV
	 IFYRb5xwGMUAqwBot2CxNZdiL0ur4uxW/qGIGXU7TAMftRG9PKAPK13uAtVferGopT
	 IBgsdRI1OSqac+nTIByCsip3j1o/9jf2rqjl8bTA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Antipov <dmantipov@yandex.ru>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 291/321] rocker: fix link status detection in rocker_carrier_init()
Date: Thu, 12 Dec 2024 16:03:29 +0100
Message-ID: <20241212144241.476309588@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144229.291682835@linuxfoundation.org>
References: <20241212144229.291682835@linuxfoundation.org>
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
index 5abb3f9684ffd..6bee5055559fe 100644
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



