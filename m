Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19A8A47A890;
	Sat, 12 Sep 2026 12:14:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789215252; cv=none; b=uPaEekWZU5JxQlcMdGatOdbAeMxKKDKxilTlC2SsM+2DuvuPpdlKx4J/V+BO0zJIZrPRBYTHbvjdUNrZl0lI9yDeRcOapni3VjhGiEyH7exKjF8/RgTtQfRakwelpNkj2GwDYveRb3TpAJ/4KcTd1ZKnXBsRxHi6846goyboUEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789215252; c=relaxed/simple;
	bh=UaCZuEb6MTj8YmuDNX+hlK6FICYcQNPW5nQ1LmYxH78=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hcyfHsMVt3O9cOji98e3N2LaI9IdwXAnbRAgX639YMthdKgrGvw9snYXLLjnEkV4p4SY4isuXxXBz2lX0OVhxyUC/yqJ6FfT3z3KDcM1AEvntyA+807f5XZRk3gEMbWtNfmWMZll3lYc3OI04q1o6xkACpcFQ7HQvptevm3SGUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qbPhf47U; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qbPhf47U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 107E01F000FF;
	Sat, 12 Sep 2026 12:14:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789215249;
	bh=jU9zM4sWcit+ooF0ZuudBQsfVBFHZLJ/Dl1fLi7dUJw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qbPhf47UmcMKYXEmLPLsmPKvm2gJdjt9AR7S8Bgl3B4JDKA6TG7rLkNtBLYHRDjNi
	 gjPjB9qINK2XnzNH/mJ278wGiwH5xbABOuGVE5IIj+P10DqxseSSSeC0y2z3mLoyUd
	 oA1WDDyItV2IG1w+CcUTt3SBn2h/z2E/xDJr98sc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fei Shao <fshao@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0493/1376] usb: mtu3: allow system suspend during active gadget connection
Date: Sat, 12 Sep 2026 08:48:39 +0200
Message-ID: <20260912065618.527316770@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

From: Fei Shao <fshao@chromium.org>

[ Upstream commit e69027c25361b6044c7928715667586cc5469063 ]

When operating in gadget mode connected to a USB host, system suspend
fails with -EBUSY because active peripheral connections block suspend
entry.

Fix this by restricting the -EBUSY check to runtime autosuspend
(PMSG_IS_AUTO). For system suspend (!PMSG_IS_AUTO), perform soft
disconnect to disconnect from the bus and allow MAC sleep.

Fixes: 427c66422e14 ("usb: mtu3: support suspend/resume for device mode")
Signed-off-by: Fei Shao <fshao@chromium.org>
Link: https://patch.msgid.link/20260626082218.2750459-2-fshao@chromium.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/mtu3/mtu3_core.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/mtu3/mtu3_core.c b/drivers/usb/mtu3/mtu3_core.c
index a3a6282893d09..ca8cb6c3a01bf 100644
--- a/drivers/usb/mtu3/mtu3_core.c
+++ b/drivers/usb/mtu3/mtu3_core.c
@@ -1037,9 +1037,14 @@ int ssusb_gadget_suspend(struct ssusb_mtk *ssusb, pm_message_t msg)
 	if (!mtu->gadget_driver)
 		return 0;
 
-	if (mtu->connected)
+	/* Prevent runtime suspend when active connection exists */
+	if (mtu->connected && PMSG_IS_AUTO(msg))
 		return -EBUSY;
 
+	/* Perform soft disconnect for system suspend */
+	if (mtu->softconnect && !PMSG_IS_AUTO(msg))
+		mtu3_dev_on_off(mtu, 0);
+
 	mtu3_dev_suspend(mtu);
 	synchronize_irq(mtu->irq);
 
@@ -1055,5 +1060,9 @@ int ssusb_gadget_resume(struct ssusb_mtk *ssusb, pm_message_t msg)
 
 	mtu3_dev_resume(mtu);
 
+	/* Restore soft connect for system resume */
+	if (mtu->softconnect && !PMSG_IS_AUTO(msg))
+		mtu3_dev_on_off(mtu, 1);
+
 	return 0;
 }
-- 
2.53.0



