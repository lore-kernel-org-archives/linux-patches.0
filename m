Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6F101DA60C;
	Tue,  8 Oct 2024 12:40:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391229; cv=none; b=N6mYnmauoiqXztjjd2yWdzX1KeHBs4zJOKj66b5xIR8tua8gDVkB2o97d4k3P2bhWbfMszqFDT/K9Fs8r8P6EePj/h+1H/kf5oOjLObjCi3GLu9BEBNVNye05GkKK+yM9Sn8WOX05HDUSfyBq/fj2s2QT1V3KbaCu5DuiXuZQuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391229; c=relaxed/simple;
	bh=+bUgJT24KUAuYtPVxZxrg+YEXnkEm7O8det3n077/IU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A1Qqc6/rPn9wYREOh5d8lUa7n/sn5lSjKBlSEL4gzrAGSx2t07VW+wyO0W5AP1JvQWzLrwKFo4OwtwG3vvbdHKYF5GSmpTBaQe1GxWiUbEex51dl4R8QgFfN2vVZb/9DeFhAiJeA8NFeA/JcrjpTpouqVljO8CQohAYVCAmAJkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uYxhrSOl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uYxhrSOl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33294C4CED4;
	Tue,  8 Oct 2024 12:40:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391229;
	bh=+bUgJT24KUAuYtPVxZxrg+YEXnkEm7O8det3n077/IU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uYxhrSOlj1HivL9Z4dK3bcLYiiPKh9kjYJWc0I97s7SztAmD3pQgRVdeDToK7Rp+A
	 DPq91FH9aQPDGjk2LWB7IryScilUJSRmweeg9/uz7oW4pI7FUNtXZQO635R545P6K2
	 90O/zVcHOo4Rn1jn9FH1op3lkDBGau52gTNh/Kr8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hui Wang <hui.wang@canonical.com>,
	Marek Vasut <marex@denx.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 049/558] net: phy: realtek: Check the index value in led_hw_control_get
Date: Tue,  8 Oct 2024 14:01:19 +0200
Message-ID: <20241008115704.151688631@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hui Wang <hui.wang@canonical.com>

[ Upstream commit c283782fc5d60c4d8169137c6f955aa3553d3b3d ]

Just like rtl8211f_led_hw_is_supported() and
rtl8211f_led_hw_control_set(), the rtl8211f_led_hw_control_get() also
needs to check the index value, otherwise the caller is likely to get
an incorrect rules.

Fixes: 17784801d888 ("net: phy: realtek: Add support for PHY LEDs on RTL8211F")
Signed-off-by: Hui Wang <hui.wang@canonical.com>
Reviewed-by: Marek Vasut <marex@denx.de>
Link: https://patch.msgid.link/20240927114610.1278935-1-hui.wang@canonical.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/realtek.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/phy/realtek.c b/drivers/net/phy/realtek.c
index 25e5bfbb6f89b..c15d2f66ef0dc 100644
--- a/drivers/net/phy/realtek.c
+++ b/drivers/net/phy/realtek.c
@@ -527,6 +527,9 @@ static int rtl8211f_led_hw_control_get(struct phy_device *phydev, u8 index,
 {
 	int val;
 
+	if (index >= RTL8211F_LED_COUNT)
+		return -EINVAL;
+
 	val = phy_read_paged(phydev, 0xd04, RTL8211F_LEDCR);
 	if (val < 0)
 		return val;
-- 
2.43.0



