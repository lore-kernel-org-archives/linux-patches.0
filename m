Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89FE733C53B;
	Fri,  9 Jan 2026 12:45:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962707; cv=none; b=KgnWyQrsKzRNmg4NW7lened1tF+NgmYT9oJrG7l7MOgIPvB6kJHoGlPnRhJXuz0StIyDv+4POoSXcMP5qXqjBJIi8NVYrYPPYaYIEAscLOv9ntpb5zntqoK/kSsbeO9m7r6z6TeZzHfr5WqKbwrje5OaVWUQ0xiUffsEtWcEbOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962707; c=relaxed/simple;
	bh=2R9cUBgTSekngyetQ6hDlpBnq7lCYwqoiH3IVZQPOBg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ubcGLp29WszCGkxeGA04uTwpGvPT61SXf1zQIrdrZ9R3Glwt9xk6wyqaoYPkiwDAYQEDHxWxKU109TVV885FT8cTH6JCtpdAidmJ8nclb9v+arh3ErxQv+VVaYDm+BrEdiu+rIV65mJjQ7z1R8mvAVVbau+XeBeTitY+IQ9t6zY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k7XE4oLv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k7XE4oLv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FE94C16AAE;
	Fri,  9 Jan 2026 12:45:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962707;
	bh=2R9cUBgTSekngyetQ6hDlpBnq7lCYwqoiH3IVZQPOBg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k7XE4oLvvUOFpW0zGgmbkr8hU8yI2GKuiFlSxEZ9czuPQ3HhuLHc87oqQun+aZPGH
	 KxdJa6vNHvLXfZ2ZC+UxGvVPbDcyEMDQ9U/HDx5rnsNb3HKsFa7yVP517NjyLjf9GO
	 Vrlvpzm5gaO59B2llfMath4+eFupjbne2sASZrko=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+3d43c9066a5b54902232@syzkaller.appspotmail.com,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 417/634] net: usb: asix: validate PHY address before use
Date: Fri,  9 Jan 2026 12:41:35 +0100
Message-ID: <20260109112133.228394007@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Deepanshu Kartikey <kartikey406@gmail.com>

[ Upstream commit a1e077a3f76eea0dc671ed6792e7d543946227e8 ]

The ASIX driver reads the PHY address from the USB device via
asix_read_phy_addr(). A malicious or faulty device can return an
invalid address (>= PHY_MAX_ADDR), which causes a warning in
mdiobus_get_phy():

  addr 207 out of range
  WARNING: drivers/net/phy/mdio_bus.c:76

Validate the PHY address in asix_read_phy_addr() and remove the
now-redundant check in ax88172a.c.

Reported-by: syzbot+3d43c9066a5b54902232@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=3d43c9066a5b54902232
Tested-by: syzbot+3d43c9066a5b54902232@syzkaller.appspotmail.com
Fixes: 7e88b11a862a ("net: usb: asix: refactor asix_read_phy_addr() and handle errors on return")
Link: https://lore.kernel.org/all/20251217085057.270704-1-kartikey406@gmail.com/T/ [v1]
Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20251218011156.276824-1-kartikey406@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/asix_common.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/usb/asix_common.c b/drivers/net/usb/asix_common.c
index 72ffc89b477a..9d6eb88083b6 100644
--- a/drivers/net/usb/asix_common.c
+++ b/drivers/net/usb/asix_common.c
@@ -335,6 +335,11 @@ int asix_read_phy_addr(struct usbnet *dev, bool internal)
 	offset = (internal ? 1 : 0);
 	ret = buf[offset];
 
+	if (ret >= PHY_MAX_ADDR) {
+		netdev_err(dev->net, "invalid PHY address: %d\n", ret);
+		return -ENODEV;
+	}
+
 	netdev_dbg(dev->net, "%s PHY address 0x%x\n",
 		   internal ? "internal" : "external", ret);
 
-- 
2.51.0



