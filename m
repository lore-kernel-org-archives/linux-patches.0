Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 033132DF73;
	Mon,  8 Apr 2024 13:06:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712581601; cv=none; b=HYCVaj8iHXYrZVCTJuPEDk/oUNePf9YkbVuM9MyjUeVi/sW6PmA4Hu++eQhfpjuzKLAhywSAOz07fB+Kjkh0M95bbQXvAFCaiuGODMEVMKYikHFbfWIX3V98m/+MdVnu0NNzhzrZe5Povj1P7ITPa++lDiY75nY5IRl5wai59Mc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712581601; c=relaxed/simple;
	bh=x1orwebO4HkvMaaJg9wtz/ruKAM8p23WBBXp28qjyPM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kPxT/HDA8xc29EIKE+6G/A+zemum3Rb2anPN1bKJYMLBbqMNCr89qKo/wB7J9Nr+/WHPc0hJ1jrPCErpVYI9iK9Vw8gPTX1tezo95sYvMHSSp0sMwTJtf4780Ftx+6i+hZYFqjmjOyuMR7oqoXi/ErporOV25UXQNIymCbdetGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AcQT1Iga; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AcQT1Iga"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28D2DC433F1;
	Mon,  8 Apr 2024 13:06:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712581600;
	bh=x1orwebO4HkvMaaJg9wtz/ruKAM8p23WBBXp28qjyPM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AcQT1Iga6GBJnkbnrp8D6UTStSx7/t5uyrsG2yXNxPc++20XIPMOoyn6RyDq9kqde
	 U9dS2og2vM8ailfVUC2R/dg738PzicA3lj95swRZWVMx/63OdI8AJ4JgPxpxZqBEoi
	 rHggPsLz2UwFzqkSwyoMdVE5FDu91q3nky3B1dgo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Stevenson <dave.stevenson@raspberrypi.com>,
	Jose Ignacio Tornos Martinez <jtornosm@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 037/138] net: usb: ax88179_178a: avoid the interface always configured as random address
Date: Mon,  8 Apr 2024 14:57:31 +0200
Message-ID: <20240408125257.378387182@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125256.218368873@linuxfoundation.org>
References: <20240408125256.218368873@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>

commit 2e91bb99b9d4f756e92e83c4453f894dda220f09 upstream.

After the commit d2689b6a86b9 ("net: usb: ax88179_178a: avoid two
consecutive device resets"), reset is not executed from bind operation and
mac address is not read from the device registers or the devicetree at that
moment. Since the check to configure if the assigned mac address is random
or not for the interface, happens after the bind operation from
usbnet_probe, the interface keeps configured as random address, although the
address is correctly read and set during open operation (the only reset
now).

In order to keep only one reset for the device and to avoid the interface
always configured as random address, after reset, configure correctly the
suitable field from the driver, if the mac address is read successfully from
the device registers or the devicetree. Take into account if a locally
administered address (random) was previously stored.

cc: stable@vger.kernel.org # 6.6+
Fixes: d2689b6a86b9 ("net: usb: ax88179_178a: avoid two consecutive device resets")
Reported-by: Dave Stevenson  <dave.stevenson@raspberrypi.com>
Signed-off-by: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://lore.kernel.org/r/20240403132158.344838-1-jtornosm@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/ax88179_178a.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/usb/ax88179_178a.c
+++ b/drivers/net/usb/ax88179_178a.c
@@ -1273,6 +1273,8 @@ static void ax88179_get_mac_addr(struct
 
 	if (is_valid_ether_addr(mac)) {
 		eth_hw_addr_set(dev->net, mac);
+		if (!is_local_ether_addr(mac))
+			dev->net->addr_assign_type = NET_ADDR_PERM;
 	} else {
 		netdev_info(dev->net, "invalid MAC address, using random\n");
 		eth_hw_addr_random(dev->net);


