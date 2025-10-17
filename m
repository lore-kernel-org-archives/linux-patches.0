Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CA062F12D2;
	Fri, 17 Oct 2025 15:33:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715193; cv=none; b=d/f18cDmKpDEGzEY0u3gtSPnodIxJEXc9LOvXk9bHS22ISui4F2aikvCbOqQvsgvYcXgHMnSKEBbmUr1i5h1YiR/2+bxpkVG1BYOGkosEqocNzsWJdIUj/dNmA345Ew5bxYUJnlUADvf15htT4G8DFsPM8dssIS8dySDlJPQDP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715193; c=relaxed/simple;
	bh=prZ+SxKAALX0E7j5/RDaUmxdKGieSF4xl9NMJd+Wwcc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RtqRSY+7HjUeGaNdYxVOkgU3sHTE2I+muxw6hHaba81fyU2EE2cRUtRY21GIm2rRkU00ab0MbYz2wN3X+JPMvU/YE0VSUhK97BVYmFtrIULLwO9Y39P9i9tQPgz36i1Cjt0dkJC6+pfWgj9e3ywkLg9gHSoBysxtmh/UXAn6Qjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ANaiT67Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ANaiT67Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0D2CC4CEE7;
	Fri, 17 Oct 2025 15:33:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715193;
	bh=prZ+SxKAALX0E7j5/RDaUmxdKGieSF4xl9NMJd+Wwcc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ANaiT67YXMcFTEJVSAxtoZBbH9gNo/5z2cE9ZuwsYTtYC+E38F2wC1hbQ+c8/jkOP
	 NMqH4eIc03xjmG2iOhjmTJNj5jkygD9UGyCHl1bSB2jQQidNkE8rS+CihJbZHjtAXK
	 zIsoXr6D8KRJrHEWQPDjqXMF3KY4Xx/1iJRcDZX4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harini T <harini.t@amd.com>,
	Peng Fan <peng.fan@nxp.com>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 098/371] mailbox: zynqmp-ipi: Remove redundant mbox_controller_unregister() call
Date: Fri, 17 Oct 2025 16:51:13 +0200
Message-ID: <20251017145205.487641679@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Harini T <harini.t@amd.com>

[ Upstream commit 341867f730d3d3bb54491ee64e8b1a0c446656e7 ]

The controller is registered using the device-managed function
'devm_mbox_controller_register()'. As documented in mailbox.c, this
ensures the devres framework automatically calls
mbox_controller_unregister() when device_unregister() is invoked, making
the explicit call unnecessary.

Remove redundant mbox_controller_unregister() call as
device_unregister() handles controller cleanup.

Fixes: 4981b82ba2ff ("mailbox: ZynqMP IPI mailbox controller")
Signed-off-by: Harini T <harini.t@amd.com>
Reviewed-by: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Jassi Brar <jassisinghbrar@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/zynqmp-ipi-mailbox.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/mailbox/zynqmp-ipi-mailbox.c b/drivers/mailbox/zynqmp-ipi-mailbox.c
index 0c143beaafda6..263a3413a8c7f 100644
--- a/drivers/mailbox/zynqmp-ipi-mailbox.c
+++ b/drivers/mailbox/zynqmp-ipi-mailbox.c
@@ -894,7 +894,6 @@ static void zynqmp_ipi_free_mboxes(struct zynqmp_ipi_pdata *pdata)
 	for (; i >= 0; i--) {
 		ipi_mbox = &pdata->ipi_mboxes[i];
 		if (ipi_mbox->dev.parent) {
-			mbox_controller_unregister(&ipi_mbox->mbox);
 			if (device_is_registered(&ipi_mbox->dev))
 				device_unregister(&ipi_mbox->dev);
 		}
-- 
2.51.0



