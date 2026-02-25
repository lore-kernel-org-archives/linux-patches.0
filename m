Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF879262FE7;
	Wed, 25 Feb 2026 01:37:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983466; cv=none; b=qPIAjciTKk7PTwXxjsmMh0JKV/oNJlKiPU+fRIAOXEGCyXrTG8i0FLyp3rxVBmwSnfBkf6+dR1lzNy2MTCIMcvVIaDO1etrTbfWLhzF+HzjT81UD+jZJHNsG3onz75n0ZiN3vYsqzePJVgeQt0HoDjXnAFhU47r2l50nmzuaY8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983466; c=relaxed/simple;
	bh=IBexiZH8Gj4BoMsIfNUUeRRN0RvP1vWsNPkT5iQlDGA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t0kiL1ZqFItBJlOPmuTti39Z7/W98mg+ER8YsOozR0zpq5f8L9jw8W1Iq0VKbvCQn3S4u1SA8w7iOKn/xi5QUXJUtZAB4MINAuczCzQ6hWrXQGzPXIAxwgiFrR6yaTnejaeq0kRUkDnl4V5rpAnoIAnaMJtGCFeEt6Sr8Dtf0Jg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sWFZ594f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sWFZ594f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DF41C116D0;
	Wed, 25 Feb 2026 01:37:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983466;
	bh=IBexiZH8Gj4BoMsIfNUUeRRN0RvP1vWsNPkT5iQlDGA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sWFZ594f/0gsn8FaFaVbPgid0Hy+BUucLrUj0jCIWsrax6IpHrMfDsffXfO+nenDK
	 qy4TnzjsgFP/6/dFM3kk11OYVaxz3xbKz2EqCx4nVQGu3z9gS9+EoPXNaYaC90cvWn
	 onOX4VcszP67+G4PGWLdiFLioiPLu36kl3uvglVo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Penkler <dpenkler@gmail.com>,
	Jianhao Xu <jianhao.xu@seu.edu.cn>,
	Zilin Guan <zilin@seu.edu.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 574/781] gpib: Fix memory leak in ni_usb_init()
Date: Tue, 24 Feb 2026 17:21:23 -0800
Message-ID: <20260225012413.879556991@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zilin Guan <zilin@seu.edu.cn>

[ Upstream commit b89921eed8cf2d97250bac4be38dbcfbf048b586 ]

In ni_usb_init(), if ni_usb_setup_init() fails, the function returns
-EFAULT without freeing the allocated writes buffer, leading to a
memory leak.

Additionally, ni_usb_setup_init() returns 0 on failure, which causes
ni_usb_init() to return -EFAULT, an inappropriate error code for this
situation.

Fix the leak by freeing writes in the error path. Modify
ni_usb_setup_init() to return -EINVAL on failure and propagate this
error code in ni_usb_init().

Fixes: 4e127de14fa7 ("staging: gpib: Add National Instruments USB GPIB driver")
Suggested-by: Greg KH <gregkh@linuxfoundation.org>
Suggested-by: Dave Penkler <dpenkler@gmail.com>
Co-developed-by: Jianhao Xu <jianhao.xu@seu.edu.cn>
Signed-off-by: Jianhao Xu <jianhao.xu@seu.edu.cn>
Signed-off-by: Zilin Guan <zilin@seu.edu.cn>
Link: https://patch.msgid.link/20251230034546.929452-1-zilin@seu.edu.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpib/ni_usb/ni_usb_gpib.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/gpib/ni_usb/ni_usb_gpib.c b/drivers/gpib/ni_usb/ni_usb_gpib.c
index fdcaa6c00bfea..b6fddb437f552 100644
--- a/drivers/gpib/ni_usb/ni_usb_gpib.c
+++ b/drivers/gpib/ni_usb/ni_usb_gpib.c
@@ -1780,7 +1780,7 @@ static int ni_usb_setup_init(struct gpib_board *board, struct ni_usb_register *w
 	i++;
 	if (i > NUM_INIT_WRITES) {
 		dev_err(&usb_dev->dev, "bug!, buffer overrun, i=%i\n", i);
-		return 0;
+		return -EINVAL;
 	}
 	return i;
 }
@@ -1799,10 +1799,12 @@ static int ni_usb_init(struct gpib_board *board)
 		return -ENOMEM;
 
 	writes_len = ni_usb_setup_init(board, writes);
-	if (writes_len)
-		retval = ni_usb_write_registers(ni_priv, writes, writes_len, &ibsta);
-	else
-		return -EFAULT;
+	if (writes_len < 0) {
+		kfree(writes);
+		return writes_len;
+	}
+
+	retval = ni_usb_write_registers(ni_priv, writes, writes_len, &ibsta);
 	kfree(writes);
 	if (retval) {
 		dev_err(&usb_dev->dev, "register write failed, retval=%i\n", retval);
-- 
2.51.0



