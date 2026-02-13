Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E597935FF6F;
	Fri, 13 Feb 2026 13:54:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770990896; cv=none; b=OKAzIHFGRy18rkYDMvB6LB3uYDk2oINvJ4Mg9N4DyAolevdNKvIpWf0VNtpxbZeIPAsry7h3pVOLyTCXofenbds1ynKKT7Y3tTQCGstSt5wQzqqVsVnnM7eRMsLVsK5sSoiq5mNDHhhlBr/2yzteJqNOo6i6pJVgGje80Z1eBF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770990896; c=relaxed/simple;
	bh=3RwOY9270dEX6YnMAM9EIaOb0J7AXJ2zwi/00dtgR/k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OzDUPB0j0aKZp919/Q+rrctz7ng98aPgaQs58UvduZoqceVx2evDzUiAGH7xF9IJikf/lKzpa7B2EAE1YS6WOVrjgHV/nywlbyAkuUjTNHEWcDKegF88HlK5lhWDTkKGW7IqJkKcZOpIc4aS4hbPbEdn68Pu+v5SXnBqeNd8QXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pAQywNcn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pAQywNcn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 012EAC116C6;
	Fri, 13 Feb 2026 13:54:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770990895;
	bh=3RwOY9270dEX6YnMAM9EIaOb0J7AXJ2zwi/00dtgR/k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pAQywNcnR4/53/onoYsQsOk/p5Oqxxz1vFGvQRTLgZiLnCEOkXRegFIOVI5vWkNuj
	 9r2+Xvw8SwVXXMLoAjHfb1Zu3Gl2VioxmVrgrmoFPT52OLVpgTZVp43FIhlhigHhxn
	 tR2SVHPTxiSjU4ta5QZOeImb8bsNQv+jvuOiX6K0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gui-Dong Han <hanguidong02@gmail.com>,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
Subject: [PATCH 6.18 43/49] bus: fsl-mc: fix use-after-free in driver_override_show()
Date: Fri, 13 Feb 2026 14:48:27 +0100
Message-ID: <20260213134710.441517320@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260213134708.885500854@linuxfoundation.org>
References: <20260213134708.885500854@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gui-Dong Han <hanguidong02@gmail.com>

commit 148891e95014b5dc5878acefa57f1940c281c431 upstream.

The driver_override_show() function reads the driver_override string
without holding the device_lock. However, driver_override_store() uses
driver_set_override(), which modifies and frees the string while holding
the device_lock.

This can result in a concurrent use-after-free if the string is freed
by the store function while being read by the show function.

Fix this by holding the device_lock around the read operation.

Fixes: 1f86a00c1159 ("bus/fsl-mc: add support for 'driver_override' in the mc-bus")
Cc: stable@vger.kernel.org
Signed-off-by: Gui-Dong Han <hanguidong02@gmail.com>
Reviewed-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Link: https://lore.kernel.org/r/20251202174438.12658-1-hanguidong02@gmail.com
Signed-off-by: Christophe Leroy (CS GROUP) <chleroy@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bus/fsl-mc/fsl-mc-bus.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/bus/fsl-mc/fsl-mc-bus.c
+++ b/drivers/bus/fsl-mc/fsl-mc-bus.c
@@ -202,8 +202,12 @@ static ssize_t driver_override_show(stru
 				    struct device_attribute *attr, char *buf)
 {
 	struct fsl_mc_device *mc_dev = to_fsl_mc_device(dev);
+	ssize_t len;
 
-	return sysfs_emit(buf, "%s\n", mc_dev->driver_override);
+	device_lock(dev);
+	len = sysfs_emit(buf, "%s\n", mc_dev->driver_override);
+	device_unlock(dev);
+	return len;
 }
 static DEVICE_ATTR_RW(driver_override);
 


