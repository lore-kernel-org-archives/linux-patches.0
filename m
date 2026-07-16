Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 423194229A6;
	Thu, 16 Jul 2026 13:50:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209812; cv=none; b=gGyhSwxWUwi3J/QBOKCsUzuKHkM+cEy0MCGa7wdJai6C1TrhbUCwfxLJIZByfjsI7zeFUjdrFDCjkNnP+QlJSZQtGYbuR4Aryf0PL3U1k8jaUwDawqhFBDoTvr/yAhhx68BR9hyQTnkBV//Sk3yOOdc0HjGfXmb72+Rz6dvfwl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209812; c=relaxed/simple;
	bh=9G92QlbPuXNP5h6/e2FDM4l0cEfcAAu3wrnttE2p0kk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JE/ye9w6iBi+n3QvAwe95CWqX8NHkCP22qGv85y1dBJAf9rH4/HOSPbQ/c2TYCqLv9q1VODZGO5XTvVwHOg7B/5CXw2enHcR9dGfV+UxIglvhSusHF3Sj6szZ0YlQPLFfnCHuXjXLot3qb5arLHOBEZQAxc228VJqhZ+MV7rFMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v8qwyMl/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v8qwyMl/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C0D21F00A3D;
	Thu, 16 Jul 2026 13:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209810;
	bh=HTc80Dg6x2gGB6rokYdTYAkQCZOQuqZtE6eMcor2aMg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v8qwyMl/NZLQQdQTNBC0l7UuIMPkBlC+ZKUu8CYigb12J39a7Z0ygPLOcJG0luPYI
	 wPlsExWBawcQzJPRZEAZNaV2M1f75FxzpG1L/pOSdFfyYGVYeaH+AMCsyCuK6OFpuO
	 CwELCCQpI0qLQR/TCibxFt7lZ42weCHneahBdwF8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 7.1 327/518] usb: typec: anx7411: use devm_pm_runtime_enable()
Date: Thu, 16 Jul 2026 15:29:55 +0200
Message-ID: <20260716133054.969165051@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

From: Myeonghun Pak <mhun512@gmail.com>

commit 0ef7cc27da8b9e315a4a5a665c68c44206f5e559 upstream.

anx7411_i2c_probe() enables runtime PM before returning successfully, but
anx7411_i2c_remove() tears down the Type-C partner state, workqueue, dummy
I2C device, mux, switch and port without disabling runtime PM.

Use devm_pm_runtime_enable() so runtime PM is disabled automatically on
driver detach. Since devres action registration can fail, route that
failure through the existing probe unwind path.

This issue was identified during our ongoing static-analysis research while
reviewing kernel code.

Fixes: fe6d8a9c8e64 ("usb: typec: anx7411: Add Analogix PD ANX7411 support")
Cc: stable <stable@kernel.org>
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://patch.msgid.link/20260701114006.75738-1-mhun512@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/anx7411.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/usb/typec/anx7411.c
+++ b/drivers/usb/typec/anx7411.c
@@ -1537,7 +1537,9 @@ static int anx7411_i2c_probe(struct i2c_
 	if (anx7411_typec_check_connection(plat))
 		dev_err(dev, "check status\n");
 
-	pm_runtime_enable(dev);
+	ret = devm_pm_runtime_enable(dev);
+	if (ret)
+		goto free_wq;
 
 	return 0;
 


