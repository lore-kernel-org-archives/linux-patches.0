Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5C5437B40C;
	Tue, 21 Jul 2026 17:29:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654985; cv=none; b=YjNuGAjgJFZebnsZfvTJC5A/fJNmxxes/CZ4hgzJOlFbVsIbgKN2WrxsSRgeusXEnc+u/XOs+mZMDVsVNUwzB16h+hfI6mi+3Y6Jn/mjkYONSbykRp0zMLeGL2eAPRRXEUJHeTktA4Z//9ba2mwUW5oezLGFtTgtBe0+krQoAn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654985; c=relaxed/simple;
	bh=NvYwInlngOYBqLqXMKAGvGCLvjPi5HqdHAWPFd4PZGA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sod8ioaw2qjwsS+trnZJz7SP12a8OP14wdDifoA+vLtrB8Vc6VBp5tO5yxmB+loF0sWZKCkzW9IyXHegD0rC+bfR559+yz+VmUhhrLAoz0OiESe7L4+Mn4ZMBCAn1cMyp6fQvvxk7cOBB/T3dArFXjj7Eg1SWHenpJlhoFaAmSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hOEfE5u5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hOEfE5u5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D04C81F000E9;
	Tue, 21 Jul 2026 17:29:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654984;
	bh=wUzikWIxclOnXxxaJ+eVVZkYgzkP397iIw72/z7BYJ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hOEfE5u5dUHd4cGO+dWwDsrrw/B9bOPOmBuYDTjvNoo+fvjVr0GjsPACsvgN/Tz3k
	 e1pXQHrWMBUSNSUFMvnj04C9MCRXLfXMF6muG4aq3A9HB7/unoBRcMkB9lv27PCsNJ
	 liZ490wC51jMpJw0dHbdjwT8L0V4Ckuj0Ei3U6UQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Linus Walleij <linusw@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.1 1912/2077] net: ixp4xx_hss: fix duplicate HDLC netdev allocation
Date: Tue, 21 Jul 2026 17:26:25 +0200
Message-ID: <20260721152637.814974535@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haoxiang Li <haoxiang_li2024@163.com>

commit db818b0e8af7bac16860116a19c341a63d6677b4 upstream.

ixp4xx_hss_probe() allocates two HDLC netdevs. The first one is stored
in ndev, initialized, and registered with register_hdlc_device(). The
second one is stored in port->netdev and later used by the remove path
for unregister_hdlc_device() and free_netdev().

This means that the registered netdev is not the same object that is
unregistered and freed on remove. It also leaks the first allocation if
the second alloc_hdlcdev() call fails, and the first allocation is not
checked before ndev is used.

Older code allocated the HDLC netdev only once and stored the same object
in both the local variable and port->netdev. The buggy conversion split
this into two alloc_hdlcdev() calls. A later rename changed the local
variable name to ndev, but the underlying mismatch remained.

Fix this by allocating the HDLC netdev only once and assigning the same
object to port->netdev.

Fixes: 99ebe65eb9c0 ("net: ixp4xx_hss: move out assignment in if condition")
Cc: stable@vger.kernel.org
Signed-off-by: Haoxiang Li <haoxiang_li2024@163.com>
Reviewed-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/20260622043015.643637-1-haoxiang_li2024@163.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wan/ixp4xx_hss.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/wan/ixp4xx_hss.c
+++ b/drivers/net/wan/ixp4xx_hss.c
@@ -1487,11 +1487,11 @@ static int ixp4xx_hss_probe(struct platf
 				     "unable to get CLK internal GPIO\n");
 
 	ndev = alloc_hdlcdev(port);
-	port->netdev = alloc_hdlcdev(port);
-	if (!port->netdev) {
+	if (!ndev) {
 		err = -ENOMEM;
 		goto err_plat;
 	}
+	port->netdev = ndev;
 
 	SET_NETDEV_DEV(ndev, &pdev->dev);
 	hdlc = dev_to_hdlc(ndev);


