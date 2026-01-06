Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B785E33993;
	Tue,  6 Jan 2026 17:33:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720823; cv=none; b=DJhY1g3XngkKR8UFoRT+T2rqv1QkhgoGJA7+Oo8xn5suz34ph8ivssneXikzYq4aOKrFq3+vosMhPvhbaKiqZtNzB8lt4WObqasYFlnBpJuBvbkr6rimZOZotLV9ouLMn0RVMEHlYDbmB1iQ7ssQqV3kGF1fCFpC5PsA1IIyFok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720823; c=relaxed/simple;
	bh=fMwuRpYVeD3m4B4AIhRDZgVH1FbTfrPQw7+3+Mh6wYA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LXjSX6L/npryZD4qc17CP2hFHdFZdBiuMowtoRhlPNeYqwmBrT8tdcQ/Gu5SwU8zRO6Zr/kSiqrWDfQKoDdpjp8PIXUfPqi0W8faqyK/h3n11wgtYqsrsDeETFZhfJejxyXaxqC5W89W2rvwVJUmPRcgPywJ6G/kPrWCpllPtzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x1nzlPEk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x1nzlPEk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42ECCC116C6;
	Tue,  6 Jan 2026 17:33:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720823;
	bh=fMwuRpYVeD3m4B4AIhRDZgVH1FbTfrPQw7+3+Mh6wYA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x1nzlPEkSeOqjjQdj2c5U56r97SUEFFjEq1w+iZOYYP7SD6MCYAtjLi2s3PGj0oVZ
	 p2ghy3vDjxktkQkwAY5e84CiqFzSK9qf4cenuvK3I6X07/589QBjgs+foEURBCAwYt
	 5LHyEMR7DMg+wxTAu2A2m5POEhGfycij4GbXy06g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+3d43c9066a5b54902232@syzkaller.appspotmail.com,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 320/567] net: usb: asix: validate PHY address before use
Date: Tue,  6 Jan 2026 18:01:42 +0100
Message-ID: <20260106170503.162887749@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 7fd763917ae2..6ab3486072cb 100644
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



