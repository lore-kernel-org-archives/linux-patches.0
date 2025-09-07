Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A621B1DE8AF;
	Sun,  7 Sep 2025 20:33:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277239; cv=none; b=uAaNAA4zTBKGQqDmbbjxCM2B5iN15voTTOlNXK22XrLEnyl1PEVYA9Ea6+ExSPuqsZ1ZT+SjwXWN8TMWrVqKZOeN+sStOZIMdrDZ69JVYIIBRdOz6cXeT/joY5pZ0yu3tJAISkfH83Kgy7tzcjQsgU5qWDsBfMeKY1HOkR09nyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277239; c=relaxed/simple;
	bh=X81WQiruJ6F5Ul5JT0EjDe8FvzoMesGZLx/a0C4WtoU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Yd5qG4jE2TBvTsHQrl1DoT1EMhEX8LtE4p9hionWpBWm9j4VfVm3Ay8sUJy7mTNppYWn71oRbK0NCZDLzGNbI3CdGLOAkDzMut+gfDkVlwsZOrk/urZOaCBIM+gUrCSg6edmRBmHkDSEB6NAfY0ZHb9jGtzl+4GUYIf6nvKMBKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hKQap7Wa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hKQap7Wa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BA02C4CEF0;
	Sun,  7 Sep 2025 20:33:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277239;
	bh=X81WQiruJ6F5Ul5JT0EjDe8FvzoMesGZLx/a0C4WtoU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hKQap7Wa8lR0ZY5LGdzxYT+9X1hrpdRcsy9PdgYH1zllE9TcDi7IpzL2s2Ne9/vAn
	 Z3HVLx/5sSGg5XsnS6aHjG4DywgZb+gIXxMINs79+L3BkczGmt5eJ3I+KcHLKlHdL3
	 AuoL3nFzqu0xeCS2MXwTsi7WsRhJe/73+KEw7E1g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	=?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= <noltari@gmail.com>,
	Jonas Gorski <jonas.gorski@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: [PATCH 6.12 127/175] net: dsa: b53: do not enable EEE on bcm63xx
Date: Sun,  7 Sep 2025 21:58:42 +0200
Message-ID: <20250907195617.858902660@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195614.892725141@linuxfoundation.org>
References: <20250907195614.892725141@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonas Gorski <jonas.gorski@gmail.com>

commit 1237c2d4a8db79dfd4369bff6930b0e385ed7d5c upstream.

BCM63xx internal switches do not support EEE, but provide multiple RGMII
ports where external PHYs may be connected. If one of these PHYs are EEE
capable, we may try to enable EEE for the MACs, which then hangs the
system on access of the (non-existent) EEE registers.

Fix this by checking if the switch actually supports EEE before
attempting to configure it.

Fixes: 22256b0afb12 ("net: dsa: b53: Move EEE functions to b53")
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Tested-by: Álvaro Fernández Rojas <noltari@gmail.com>
Signed-off-by: Jonas Gorski <jonas.gorski@gmail.com>
Link: https://patch.msgid.link/20250602193953.1010487-2-jonas.gorski@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/b53/b53_common.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -2378,6 +2378,9 @@ int b53_eee_init(struct dsa_switch *ds,
 {
 	int ret;
 
+	if (!b53_support_eee(ds, port))
+		return 0;
+
 	ret = phy_init_eee(phy, false);
 	if (ret)
 		return 0;
@@ -2392,7 +2395,7 @@ bool b53_support_eee(struct dsa_switch *
 {
 	struct b53_device *dev = ds->priv;
 
-	return !is5325(dev) && !is5365(dev);
+	return !is5325(dev) && !is5365(dev) && !is63xx(dev);
 }
 EXPORT_SYMBOL(b53_support_eee);
 


