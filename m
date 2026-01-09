Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06C57359F9C;
	Fri,  9 Jan 2026 12:08:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960531; cv=none; b=IRigBVWqqEt3vUqJG5x6df50tUx6ErKupeG5JwITPalByxYoPxb6MuZVXbGs6X27Z3oKtmlnfyfFa0Z31r9LFyKDL0Swux7K42ASIb4s1QBNTbefyhxuoqfvvS2eMOjZbo3zGI1ywCqfjvs8LrqQNC3wZ3uGTpuy7VuTuih32T4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960531; c=relaxed/simple;
	bh=ycKm7fke58qLYEc/y7GlnH16a78s9+4oTIPnwx+lxu4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KyAp0tr6UVmAU6/YVZM6/jiZVIuuH39QnHOuQDiGpvxkUjGXNoaa5JQmMtOFYn7vPeASnUmfuZ6h04Jh71nuJQOP518wQXDd7eB5r6UP7Nhz3zoS98TXE0XqDxc0Ox+VMIijrNwzuoP+yLrlAJl5HBFEemVKEgptivBf4BHcqQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TqgeSeFc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TqgeSeFc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51AF1C4CEF1;
	Fri,  9 Jan 2026 12:08:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960530;
	bh=ycKm7fke58qLYEc/y7GlnH16a78s9+4oTIPnwx+lxu4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TqgeSeFcRgd7oXrbQ7yFRfVwI6lei6E1y6tDPD7f2SOAx0ZTwD+vnX9sSOOMvCrDX
	 dZ6swfP91XK1QoIKLGjotN61bQEefwm09hMUkVZKHppLT3Jg43259JVl9mc+JeQCa8
	 oY/u+ZupJj0awRKJuxnA8qG4WWrpM+ECm8/BlrTc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Johan Hovold <johan@kernel.org>,
	Vladimir Zapolskiy <vz@mleia.com>
Subject: [PATCH 6.6 437/737] usb: phy: isp1301: fix non-OF device reference imbalance
Date: Fri,  9 Jan 2026 12:39:36 +0100
Message-ID: <20260109112150.431061223@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

From: Johan Hovold <johan@kernel.org>

commit b4b64fda4d30a83a7f00e92a0c8a1d47699609f3 upstream.

A recent change fixing a device reference leak in a UDC driver
introduced a potential use-after-free in the non-OF case as the
isp1301_get_client() helper only increases the reference count for the
returned I2C device in the OF case.

Increment the reference count also for non-OF so that the caller can
decrement it unconditionally.

Note that this is inherently racy just as using the returned I2C device
is since nothing is preventing the PHY driver from being unbound while
in use.

Fixes: c84117912bdd ("USB: lpc32xx_udc: Fix error handling in probe")
Cc: stable@vger.kernel.org
Cc: Ma Ke <make24@iscas.ac.cn>
Signed-off-by: Johan Hovold <johan@kernel.org>
Reviewed-by: Vladimir Zapolskiy <vz@mleia.com>
Link: https://patch.msgid.link/20251218153519.19453-3-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/phy/phy-isp1301.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/usb/phy/phy-isp1301.c
+++ b/drivers/usb/phy/phy-isp1301.c
@@ -149,7 +149,12 @@ struct i2c_client *isp1301_get_client(st
 		return client;
 
 	/* non-DT: only one ISP1301 chip supported */
-	return isp1301_i2c_client;
+	if (isp1301_i2c_client) {
+		get_device(&isp1301_i2c_client->dev);
+		return isp1301_i2c_client;
+	}
+
+	return NULL;
 }
 EXPORT_SYMBOL_GPL(isp1301_get_client);
 


