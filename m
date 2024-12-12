Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27E94223E7D;
	Thu, 12 Dec 2024 17:09:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023365; cv=none; b=krdKSe5UAmtOK0aX6GsisDhtkqAGmwZ7UDWMcU+Ks5zgUcNGaf0K9+R/jk4JKJdHugNZIHporDLnZ6j+kUCiqJyGVmqlGz/JixdBLZZopBq62S6xiyun58Q27x3AId6RjKYBtp6sJk6v6VMZwpS/N3EE3oUq6Q0KJ0lBX+75JTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023365; c=relaxed/simple;
	bh=FjTrg7NMfg3O7yR47/SNaOtkPh/en7ZZFzvDUfZNB3U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QpQe5C8KLqOt3gEq2RxxHXc2/3HvaEBf0+oMc4hNV+Df4T5kNSzu2zzcJH6W4HGQT1JQLFF2rwTxIkNBwRo9zT2vGkMbhZcRPi2xJ+hiyqjUmAQLLMj08DxmhcnWAQiIxbKzpLHsyMVD6ScXCXrQcDTRDmRCrWnwweOF3lwIowI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1ttmzyDo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1ttmzyDo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DE56C4CED4;
	Thu, 12 Dec 2024 17:09:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734023364;
	bh=FjTrg7NMfg3O7yR47/SNaOtkPh/en7ZZFzvDUfZNB3U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1ttmzyDoQw5eStYNBjhTv7TM72gaqIA63GVVfRM0KTFt3zpPQJI8Wl3vTImBM/RBb
	 xS1AbHsaHBg7xGXxCv+6woAQYbWPUvtTY5baNAkoqEebr+FJBCsfafKxXjQxJGWn6q
	 JmPU7Z5xy8DMifeRuotC2mHi26zMdbxZoNZkz8A0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Antipov <dmantipov@yandex.ru>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 509/565] rocker: fix link status detection in rocker_carrier_init()
Date: Thu, 12 Dec 2024 16:01:44 +0100
Message-ID: <20241212144331.889511391@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 3364b6a56bd1e..e1509becb7536 100644
--- a/drivers/net/ethernet/rocker/rocker_main.c
+++ b/drivers/net/ethernet/rocker/rocker_main.c
@@ -2516,7 +2516,7 @@ static void rocker_carrier_init(const struct rocker_port *rocker_port)
 	u64 link_status = rocker_read64(rocker, PORT_PHYS_LINK_STATUS);
 	bool link_up;
 
-	link_up = link_status & (1 << rocker_port->pport);
+	link_up = link_status & (1ULL << rocker_port->pport);
 	if (link_up)
 		netif_carrier_on(rocker_port->dev);
 	else
-- 
2.43.0



