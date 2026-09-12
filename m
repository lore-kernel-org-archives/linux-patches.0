Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 089DB2D8364;
	Sat, 12 Sep 2026 16:10:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789229425; cv=none; b=aOvlpe31ProX0Ba35czvsMSQE/yHvSRjyLqmKLTLxpMJW/S7LJfbxVxtXVWsHn3Vx/hBr2sPTs4tDLNGLapkpeTzP3M+RBZ/mVKiedP0bx4udh7p9GnIwciBVHEua7yAd37CkuY+/4+rKG3WiuS1X20GIQCv8pqxQjueFnCMXaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789229425; c=relaxed/simple;
	bh=VkWJihGkZG3woIPMMC97ojouTigVu8oS66w2HrDitjU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=enQ9IeObR8VxdbMvGbKJ7shmCs1Fi5dnZRuoxTYHo/V5qsz4qzD3q5jNJGhif1vmzRq5ugKn5Hj2kmJODTupHQuyjnOycUkSwYWmmkc4CzwdPFMBvfDC4aN7375wIMkFJENUxQoWruc1iWS+0RFTWlrxkLeKwNSym58E1/R9LqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xArKRRwe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xArKRRwe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07F1B1F000FF;
	Sat, 12 Sep 2026 16:10:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789229423;
	bh=4b2jk77Hclx5rrxUJKIi6t7C7bqiy7V8eavw941Cf0c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xArKRRweA7RWYDCuFXE8Z+dm/EzwNkxQt0QhVO3QGvH1Uwag+c6Lr2+wAIt3ZAXjB
	 2ius81b/W4Kpt8BXLA6l3vIMauStZQQ/fra+hfZSSPn9NWm/3wuaWNgaWTh5hHHMEm
	 atidRq5CvCNNxEQlHaUiqeP9Q28dOEcQK28/pMcc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fei Shao <fshao@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0586/1191] usb: mtu3: allow system suspend during active gadget connection
Date: Sat, 12 Sep 2026 08:55:14 +0200
Message-ID: <20260912065601.409107627@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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



