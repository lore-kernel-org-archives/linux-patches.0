Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7250324A056;
	Tue, 20 May 2025 14:10:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750203; cv=none; b=FePxfZ7EZn0vuRzTWs2yL+cQeRZGCMJeGRhqLrVUzRKgV82TniKBXD5VEj8/izkal8JLua0+le2PXze5S2tdYOhBGfbXotllD2om3Jk4FlG0izJLB6p6zUexs3TNEzOi9gCrl7mWpKMbHpYH36ZzAH4+MKwAh27OakQIPJCH5pg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750203; c=relaxed/simple;
	bh=zZpZOGbMIF+oACTValDPLTlyiSFTyZnZpAxoRWPQOeo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RSNixcbG1N+TVqgaEfHfYpoMy2j4dlYube/UtlNJfiwv5S7XgywSfeIlokQprvZbyJnMdRzej9MM5lDksjTq1RMDG+4zoSXB4eK0IaEa2pMXWHbyHYSSMh8sHyggEJxzfupMV1NGEUDcNkSyYUQQFIuXsYth5IXX/StkDeiFdxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vwa5uuQV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vwa5uuQV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7FF3C4CEE9;
	Tue, 20 May 2025 14:10:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750203;
	bh=zZpZOGbMIF+oACTValDPLTlyiSFTyZnZpAxoRWPQOeo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vwa5uuQVTSdkUrBplQjbYQhWowyg3C+/ULht7LQFxFWsuENjuxsmntYwlk2n+aryJ
	 dN/GIJvXD1+/prd0G0EdhN26KMx19JOv01DBdbbhHIABNcV28KfNjLGlQNdoLiQ8mL
	 fC2FDdweF4RIWKt/zG3IFODO4TQHKYo/yd+amY/I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeremy Kerr <jk@codeconstruct.com.au>,
	Andrew Jeffery <andrew@codeconstruct.com.au>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 044/143] net: mctp: Ensure keys maintain only one ref to corresponding dev
Date: Tue, 20 May 2025 15:49:59 +0200
Message-ID: <20250520125811.784838851@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125810.036375422@linuxfoundation.org>
References: <20250520125810.036375422@linuxfoundation.org>
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

From: Andrew Jeffery <andrew@codeconstruct.com.au>

[ Upstream commit e4f349bd6e58051df698b82f94721f18a02a293d ]

mctp_flow_prepare_output() is called in mctp_route_output(), which
places outbound packets onto a given interface. The packet may represent
a message fragment, in which case we provoke an unbalanced reference
count to the underlying device. This causes trouble if we ever attempt
to remove the interface:

    [   48.702195] usb 1-1: USB disconnect, device number 2
    [   58.883056] unregister_netdevice: waiting for mctpusb0 to become free. Usage count = 2
    [   69.022548] unregister_netdevice: waiting for mctpusb0 to become free. Usage count = 2
    [   79.172568] unregister_netdevice: waiting for mctpusb0 to become free. Usage count = 2
    ...

Predicate the invocation of mctp_dev_set_key() in
mctp_flow_prepare_output() on not already having associated the device
with the key. It's not yet realistic to uphold the property that the key
maintains only one device reference earlier in the transmission sequence
as the route (and therefore the device) may not be known at the time the
key is associated with the socket.

Fixes: 67737c457281 ("mctp: Pass flow data & flow release events to drivers")
Acked-by: Jeremy Kerr <jk@codeconstruct.com.au>
Signed-off-by: Andrew Jeffery <andrew@codeconstruct.com.au>
Link: https://patch.msgid.link/20250508-mctp-dev-refcount-v1-1-d4f965c67bb5@codeconstruct.com.au
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mctp/route.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/mctp/route.c b/net/mctp/route.c
index 4c460160914f0..d9c8e5a5f9ce9 100644
--- a/net/mctp/route.c
+++ b/net/mctp/route.c
@@ -313,8 +313,10 @@ static void mctp_flow_prepare_output(struct sk_buff *skb, struct mctp_dev *dev)
 
 	key = flow->key;
 
-	if (WARN_ON(key->dev && key->dev != dev))
+	if (key->dev) {
+		WARN_ON(key->dev != dev);
 		return;
+	}
 
 	mctp_dev_set_key(dev, key);
 }
-- 
2.39.5



