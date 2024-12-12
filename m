Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E00E1487CD;
	Thu, 12 Dec 2024 15:23:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016993; cv=none; b=WjlwLyHqCGy+JcsSzGYN7j/vv0N6hITkGiX93GPc0yEUTeWgGIURsB1s0ez7RHQqnJuS9E/61mD/VfoopmhMUosYqC7phx3em+FBhlAPyMcPilrd4GVKAipALNcLZHZRWvUugEQTUrQgPIJGR2OsWId63iIRpcdlGZW/Z43d7Y4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016993; c=relaxed/simple;
	bh=3e930U/WATObH5v76rIA9t8VanjRCkPvH8YTL7M62Hk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UNBegDzcZL2AOYvdxtW+RkrzbiC6lLPKMjAH9SbXwPO0QkoIU4BL7pPUZZnXLYToW2iwUV5I506EjC/rLWZpkzK+6tcB5tvy6r5F5M2/nHCnW/XplxrCmDE0VFYpNELEqbGvoxCCJf0sLATbr0pOCSaPq6HimZ9niR51OfzYFTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U9dPHoEO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U9dPHoEO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E925C4CECE;
	Thu, 12 Dec 2024 15:23:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734016993;
	bh=3e930U/WATObH5v76rIA9t8VanjRCkPvH8YTL7M62Hk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U9dPHoEOb0BXQ7PypagSllmqVw8Jw0fiCRFlPXnMpB9BejwHCq2GyDL53VAHtaAAj
	 DQznTYmbl3Bd4GPXldigqDbj8iJI6j7T3/r375n7gls+XMe+uHNwi/Hp1uYsv6m+sc
	 IbfFiluYCz1l//FEFgfSyLx/5JOjEMhhWV+N6lLc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Antipov <dmantipov@yandex.ru>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 351/466] rocker: fix link status detection in rocker_carrier_init()
Date: Thu, 12 Dec 2024 15:58:40 +0100
Message-ID: <20241212144320.653592417@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 84fa911c78db5..fe0bf1d3217af 100644
--- a/drivers/net/ethernet/rocker/rocker_main.c
+++ b/drivers/net/ethernet/rocker/rocker_main.c
@@ -2502,7 +2502,7 @@ static void rocker_carrier_init(const struct rocker_port *rocker_port)
 	u64 link_status = rocker_read64(rocker, PORT_PHYS_LINK_STATUS);
 	bool link_up;
 
-	link_up = link_status & (1 << rocker_port->pport);
+	link_up = link_status & (1ULL << rocker_port->pport);
 	if (link_up)
 		netif_carrier_on(rocker_port->dev);
 	else
-- 
2.43.0



