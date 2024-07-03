Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AA24183076;
	Wed,  3 Jul 2024 11:30:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720006241; cv=none; b=KhaAHEEZtH4ial5ck+qm+Xb4f53HuLpvbj164gn0DHySDWm2jrJWMaHFbkPoyQKRFzZ+G+baYme9FJUTfw5462yRSLWBAJm0KQvO6aj4m6PVsIlvAOh5y8/eUPp2TuS9NlHN1UV7niO28LHVyAWwVSugon8InLE0BOcggO2Z/IQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720006241; c=relaxed/simple;
	bh=hj9+RgJqKZcZaXd30CWq1q7WpLdKu6L2QNT+QXfMzxw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h0o5T2qZZF5hSGi4rH45dbN87vVxjSk4JTgDmHHdu2o7b7Rd7OgkzxAfRkFH5OaLj7YrZEljuYUCe7Fb12a/wdgha4F+wukKFwshXCWy0EGbq89Ns3CLB36vSnRt8JTet1ntZbJtMCn29cs1mYem3kvEHlkRaGkRhRFcle1H5to=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EQBUJnj0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EQBUJnj0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94B63C2BD10;
	Wed,  3 Jul 2024 11:30:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720006241;
	bh=hj9+RgJqKZcZaXd30CWq1q7WpLdKu6L2QNT+QXfMzxw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EQBUJnj0N3Lakj0h+cP4tBGsSHglwVhlgpoHJSKU+tF9ktNxewAWcM230k8pw2QVv
	 XXZvqMfweXFJhauIfHCm0bVUuGXUbBOIpjJ25oC+0WJVt4UwXAb5g+seXjOcShChyN
	 Zg1bktH3YEd7nMwAGT05/klgJGF3P8ilNoyW7bhk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jose Ignacio Tornos Martinez <jtornosm@redhat.com>,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.15 316/356] net: usb: ax88179_178a: improve link status logs
Date: Wed,  3 Jul 2024 12:40:52 +0200
Message-ID: <20240703102925.071562001@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>

commit 058722ee350c0bdd664e467156feb2bf5d9cc271 upstream.

Avoid spurious link status logs that may ultimately be wrong; for example,
if the link is set to down with the cable plugged, then the cable is
unplugged and after this the link is set to up, the last new log that is
appearing is incorrectly telling that the link is up.

In order to avoid errors, show link status logs after link_reset
processing, and in order to avoid spurious as much as possible, only show
the link loss when some link status change is detected.

cc: stable@vger.kernel.org
Fixes: e2ca90c276e1 ("ax88179_178a: ASIX AX88179_178A USB 3.0/2.0 to gigabit ethernet adapter driver")
Signed-off-by: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/ax88179_178a.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/net/usb/ax88179_178a.c
+++ b/drivers/net/usb/ax88179_178a.c
@@ -326,7 +326,8 @@ static void ax88179_status(struct usbnet
 
 	if (netif_carrier_ok(dev->net) != link) {
 		usbnet_link_change(dev, link, 1);
-		netdev_info(dev->net, "ax88179 - Link status is: %d\n", link);
+		if (!link)
+			netdev_info(dev->net, "ax88179 - Link status is: 0\n");
 	}
 }
 
@@ -1558,6 +1559,7 @@ static int ax88179_link_reset(struct usb
 			 GMII_PHY_PHYSR, 2, &tmp16);
 
 	if (!(tmp16 & GMII_PHY_PHYSR_LINK)) {
+		netdev_info(dev->net, "ax88179 - Link status is: 0\n");
 		return 0;
 	} else if (GMII_PHY_PHYSR_GIGA == (tmp16 & GMII_PHY_PHYSR_SMASK)) {
 		mode |= AX_MEDIUM_GIGAMODE | AX_MEDIUM_EN_125MHZ;
@@ -1595,6 +1597,8 @@ static int ax88179_link_reset(struct usb
 
 	netif_carrier_on(dev->net);
 
+	netdev_info(dev->net, "ax88179 - Link status is: 1\n");
+
 	return 0;
 }
 


