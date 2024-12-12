Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7218226542;
	Thu, 12 Dec 2024 16:34:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734021283; cv=none; b=btH/SYyoa7oYPYTuE5j122xKg1cMuELedqlmXzEjFg9NxU+kSVlMqhsBrFVFS7SnGAgNF+h+KJEDkr/QDhJPgYzqwUYGqQut46L+kFDJHsfGR+RNTCYB7HYAHMqGGrlNLY8YEKhgsYADNwk7vRSeyV52m6/c+rQWPofWztixssE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734021283; c=relaxed/simple;
	bh=qmZg6E1n6p8wyf4Amg9GGSFok4AT0jCnu1zCzkFeQ0U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SridjSlF1dY6aNKn9gLKA/qOYW7et9NwGgcbWZ1+OPLAQuBY4tdsTfPYNThd6WMHiN8DkN24IKKxrsenPdN29jg2xW8YEmdAj2cHU4B0bpuXmQxkzwn5sdLK0Wu4i7tyogXduVuS4enEQZbX2M3nMebtShZmfahP8udwkV4YpG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JMGFkrY7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JMGFkrY7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D269EC4CECE;
	Thu, 12 Dec 2024 16:34:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734021283;
	bh=qmZg6E1n6p8wyf4Amg9GGSFok4AT0jCnu1zCzkFeQ0U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JMGFkrY7ymSqJTPbDy/ujEa98GdSNUJwPqglbQFCSNIYVXlVl77racErBne/u6M5X
	 R7b2eG3847CUEhjWb9CZ5j4sB6il76mH2Ias8I8ni6ko8iJnfua61ymrozSuzIGdSR
	 yM3ShZ4haMMnjGgXVOAenowU3/w4zOKcro2W4twc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Antipov <dmantipov@yandex.ru>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 696/772] rocker: fix link status detection in rocker_carrier_init()
Date: Thu, 12 Dec 2024 16:00:41 +0100
Message-ID: <20241212144418.665729808@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



