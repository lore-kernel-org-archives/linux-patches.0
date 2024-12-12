Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99C1714A82;
	Thu, 12 Dec 2024 15:47:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734018437; cv=none; b=AWzZrvAPMjWgL/FDkB2MH8f0BtG6AdmCxx80DW8RdRZi9ChXzxOavjVBEsdHxoKYEzDoHTlyaETbmZpUPp/MQ6GyphDCruwD3mBgiP0nVxxzzGe03xjiLTCKvdSOg1dQNo7etBc3ky03YdmbaZJSYdTsNyfLI/gVubG3ZxfmQW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734018437; c=relaxed/simple;
	bh=F7feWMxn04KGZ19NbihZtjq7aE3VA57RL6///siSXFk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CP56JTN/X58PYzldMEBAPRkUNU2R6cRW8s+CxmsaRwCowFur+eT2k/vDVUcyoFdHLithtmEoKSTKNcZ/WXdhRcEutheqzoo9K7ZHO3QZA5+Chx6vYTKYFiFsYzuk0lawIvptHdZULG9IuwtOJVmGhVB+RIC5ksFulPcrMH5VWU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qz9U1vVf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qz9U1vVf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05AACC4CECE;
	Thu, 12 Dec 2024 15:47:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734018437;
	bh=F7feWMxn04KGZ19NbihZtjq7aE3VA57RL6///siSXFk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qz9U1vVf/en/hEJmsC8DIa5DI4/CXQP89ka3vcaxzL8lgBZgY7ESVEpJ5gn0sjq4F
	 sVSIBFK7eOhKwbg5Gnl701p5rD1/kKRZwdDbzEB06p8brKG+o2Wm/TJh8gxTZ1IbbF
	 QnJJ6z8QQk9bmsJhepVt7/a8Lqtc2euygAv7Z+0g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Antipov <dmantipov@yandex.ru>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 262/356] rocker: fix link status detection in rocker_carrier_init()
Date: Thu, 12 Dec 2024 15:59:41 +0100
Message-ID: <20241212144254.945949231@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 9e59669a93dd3..2e2826c901fcc 100644
--- a/drivers/net/ethernet/rocker/rocker_main.c
+++ b/drivers/net/ethernet/rocker/rocker_main.c
@@ -2504,7 +2504,7 @@ static void rocker_carrier_init(const struct rocker_port *rocker_port)
 	u64 link_status = rocker_read64(rocker, PORT_PHYS_LINK_STATUS);
 	bool link_up;
 
-	link_up = link_status & (1 << rocker_port->pport);
+	link_up = link_status & (1ULL << rocker_port->pport);
 	if (link_up)
 		netif_carrier_on(rocker_port->dev);
 	else
-- 
2.43.0



