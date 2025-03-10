Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B87A22FF40;
	Mon, 10 Mar 2025 17:28:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627706; cv=none; b=i5Uke7nBwuHKN8y6aQupKbeE3YF3A9MYM/STxl9t9JWPmLvW/wbiFt33rC6alEvYvCwwHkRLGdtRras0TU0m7D+hgokjviU+R0nL/b/9x12YCzQH1JQQ4Z3g2+3GI0HCFtZpjFkCs8c8JQ0d5QxvqoBvhBr63inmfKSQtleCeK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627706; c=relaxed/simple;
	bh=z5PrInUGLfASbmlLzdE14Mmlh4G+uoJmRhpV8Tpw0Pc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r9ep6hQx0uWQvIxY6xvjf8w86HF3RRIYCOqt4NG6sF60nBtScaYQOgXDuFNNiVZnMgJiBvyZSWXU4EzjVuJ1VvYbi8M4UArbDfLKoEbMPmXgR4wcDlCxU0bwZF80/fpDXeQXuA8NkG6GJgUlvq87XPZC46ermoSw2ypksFDEFMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x00ii5PU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x00ii5PU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9563C4CEE5;
	Mon, 10 Mar 2025 17:28:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627706;
	bh=z5PrInUGLfASbmlLzdE14Mmlh4G+uoJmRhpV8Tpw0Pc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x00ii5PUrjOvcyHweh8VFhmIB8D1bmjYeBSUO7sK0UUqNBQoqKIDoviRF38Mf5cYx
	 1j79WY97o8YTHqhGNICbLxTeFX2RF1JgYbNcl0XUaJcuczx5GU9KXxJn7i3OCdjo1d
	 xXbBJ7+NIU4zyLQQao0OyO8BBGiYRa41LvxsIJcM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Prashanth K <prashanth.k@oss.qualcomm.com>
Subject: [PATCH 6.12 214/269] usb: gadget: u_ether: Set is_suspend flag if remote wakeup fails
Date: Mon, 10 Mar 2025 18:06:07 +0100
Message-ID: <20250310170506.218744614@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170457.700086763@linuxfoundation.org>
References: <20250310170457.700086763@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Prashanth K <prashanth.k@oss.qualcomm.com>

commit 17c2c87c37862c3e95b55f660681cc6e8d66660e upstream.

Currently while UDC suspends, u_ether attempts to remote wakeup
the host if there are any pending transfers. However, if remote
wakeup fails, the UDC remains suspended but the is_suspend flag
is not set. And since is_suspend flag isn't set, the subsequent
eth_start_xmit() would queue USB requests to suspended UDC.

To fix this, bail out from gether_suspend() only if remote wakeup
operation is successful.

Cc: stable <stable@kernel.org>
Fixes: 0a1af6dfa077 ("usb: gadget: f_ecm: Add suspend/resume and remote wakeup support")
Signed-off-by: Prashanth K <prashanth.k@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20250212100840.3812153-1-prashanth.k@oss.qualcomm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/u_ether.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/usb/gadget/function/u_ether.c
+++ b/drivers/usb/gadget/function/u_ether.c
@@ -1052,8 +1052,8 @@ void gether_suspend(struct gether *link)
 		 * There is a transfer in progress. So we trigger a remote
 		 * wakeup to inform the host.
 		 */
-		ether_wakeup_host(dev->port_usb);
-		return;
+		if (!ether_wakeup_host(dev->port_usb))
+			return;
 	}
 	spin_lock_irqsave(&dev->lock, flags);
 	link->is_suspend = true;


