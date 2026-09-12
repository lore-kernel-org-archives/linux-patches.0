Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDE4C331EC0;
	Sat, 12 Sep 2026 14:24:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789223060; cv=none; b=cb+quPizONmVywRAAiDMkQbWySktNOA31qV6UN6q8L3Btg+eDWkXSVmXPW9iw24vIi8cFdSTrOFG8rdC4DucY/NdpXVhfBbJBptPHr/8vAtsVeHl/g6ds04vUIpONuoJ0xfq2kL+hEE+C0yVWL6g4lEeipg/qbfBxRFOPuvYXL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789223060; c=relaxed/simple;
	bh=yhcyQD1HrLRFrKt7PdacqKrFu+Xjm8eTsY8FXO3O/WQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k7raM+1dvKjikevSf2mUyv7wAAtJzL4H+lCFYv26sHxE/nZmuwvj7+hq5YnESzdvEp3asVD5y8przkd+cEfqOa/XwR/8DDTRl/+ZOx5EsVbk6JqhiwnQweGLwA/RAMTZ3H5hCBl7dRYVJxprHnrn8kOVEQdd5iCg9l/OBjVT7vA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K+ydVR2D; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K+ydVR2D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCD3E1F000FF;
	Sat, 12 Sep 2026 14:24:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789223058;
	bh=UoHEyNWTMg96Tt9U7/BnmxaPTmyJJaklgeN/sLo4aEM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K+ydVR2Dvc263mYDZJwc5grC6nOCr9oIE1CqMTkLhxvLdT4o2BssRXgOvLy91JPE/
	 IMw334ogx4bWXca2jkODeM/b6tcanUeJPhWTsZX2UX/w2+tHOSg96mvO5EoJU7sGiz
	 MRkniLE6P6mstFgSHNTP19WhRblh1Pf/CDpXCD1I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fei Shao <fshao@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0711/1424] usb: mtu3: allow system suspend during active gadget connection
Date: Sat, 12 Sep 2026 08:52:23 +0200
Message-ID: <20260912065623.221088455@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



