Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B62317D3E5;
	Mon,  8 Apr 2024 13:22:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582535; cv=none; b=sji7VJgfHpCHQ6/+XGyGAUDxHTwlGXGH1N3iyZs/GYoaPDxADGS23QAvTuHw+KYksxXEAm0Wrl0JFzDQgOpm6Ct7azVsGXapHh58lvbCb8eNv1Ap6k367ftQ0jztnFbw2wDb8n2j0xbSXe4UQlxXSU9TwPS6xm/GrTxQcqLM0pU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582535; c=relaxed/simple;
	bh=4y1F6vR+bMp4qayeMuBXMyDF9E+v6tBmqLCGAV2T0RY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nYEis10+XLzh1R6m3gdRJ/DbNkLtxodNILRLvIyvkL5cdsPKZV891vmiV54sTcLDAJqUH8RAheb1llNXRAFR6d8equOv0kb39O/EJ/+mHwoyZdujFSzuyCRMfUfQnYFxG6rOIEieI/t1YmvKt9njgGKk0XId6Rz0bdL+z7JmPLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z4Ik5OXD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z4Ik5OXD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D6EBC433C7;
	Mon,  8 Apr 2024 13:22:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582535;
	bh=4y1F6vR+bMp4qayeMuBXMyDF9E+v6tBmqLCGAV2T0RY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z4Ik5OXDMDi/+aXnZ9nd/n7zNI1nyBT7pZ864tPsAkbCjKW05R2AAb7sSut4iEP+f
	 omctMLNmoiAHSO3kbnV3t7dxjeYnMfn36jvzjNWXE2pwNwOM/xTAp7qQH/n/h80ffh
	 UisOZBYOqXtRf/nGeahDbuF+2ChKeofd+43dVW3w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Stevenson <dave.stevenson@raspberrypi.com>,
	Jose Ignacio Tornos Martinez <jtornosm@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.8 084/273] net: usb: ax88179_178a: avoid the interface always configured as random address
Date: Mon,  8 Apr 2024 14:55:59 +0200
Message-ID: <20240408125311.908763957@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125309.280181634@linuxfoundation.org>
References: <20240408125309.280181634@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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


