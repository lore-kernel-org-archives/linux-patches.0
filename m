Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FA2C2D0C94;
	Sat, 12 Sep 2026 19:34:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789241654; cv=none; b=MogiLwHFDj7fg+r6Sy10OQ5oK1ytu3iJ2Pz17LADxfR71atgR1Tpk2DpJrNRYPbls9LqiqGoR367sA3djVlT3N+KXp5bZ3YpG4dwKFl2C3O6YkcauidMNrx+EJmcDOXPditDCfwBvJ00OcZ8KbvWkOkGIzcEz48DFH5fN0XB64o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789241654; c=relaxed/simple;
	bh=Z8Ptzt2jAx/6+zfD9SIOAk9YgtyMUrzZHGEG92sJogg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o91BaVqkhkpV0s7ghAZdkQ898pFjg/Os+og2f64gtoWDUw67/5MjWOfiSpUJ+3nYUB6yPFyObiMIg8YQx8EoOtUepSwpnSldCJA0xpdufDnv+4NFs7WFo7++eXmwjMHD+MnQQIUV1Jh4mdA9aNWdBJs42aiCVuVV+Yqlqt8xsXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rW+FEZ9B; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rW+FEZ9B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98D071F000FF;
	Sat, 12 Sep 2026 19:34:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789241653;
	bh=jueoL3la29RUVb7YkALZmokqrlMHM7seQ084MqqzIDA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rW+FEZ9B35bUc96/3UDhBxzzwwcNXkT9NGpwGNGn07YkHaCIVVhvuGHW/aOxCl63/
	 LPfp0jDY4bONscGRdHsfF7AQt3R7aO29gmKuld4onJuoUZjCQRljXYK7K/X+tTSh/r
	 OJNURcLH/sHaTtVIpePzuBXlFB4GyY4c4AJHWPVc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Adrian Hunter <adrian.hunter@intel.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 5.10 179/798] i3c: master: Fix info leak and UAF in device unregister path
Date: Sat, 12 Sep 2026 08:56:47 +0200
Message-ID: <20260912065521.127877810@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adrian Hunter <adrian.hunter@intel.com>

commit d2c743efd2d1ee64e94324664808f623dd865872 upstream.

i3c_master_unregister_i3c_devs() clears i3cdev->dev->desc before
calling device_unregister().  During device_unregister(),
device_del() emits a KOBJ_REMOVE uevent and unbinds the driver while
the device descriptor is still expected to be valid.  As a result,
i3c_device_uevent() and a racing modalias_show() can observe a NULL
desc and fall back to an uninitialized stack struct i3c_device_info,
leaking kernel stack contents in the generated modalias.  Driver
.remove() callbacks may also encounter an unexpected NULL desc during
unbind.

Keep desc valid until device_unregister() has completed.  Since
device_unregister() drops the device reference and may free the device,
take an extra reference with get_device() before unregistering.  Clear
desc afterwards and release the extra reference with put_device().
This preserves the release-time invariant that desc must be NULL while
avoiding both the information leak and a potential use-after-free from
writing desc after the device has been released.

Reported-by: sashiko-bot@kernel.org
Link: https://lore.kernel.org/linux-i3c/20260702190003.8BF741F000E9@smtp.kernel.org/
Fixes: 3a379bbcea0a ("i3c: Add core I3C infrastructure")
Cc: stable@vger.kernel.org
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260723075747.34049-1-adrian.hunter@intel.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i3c/master.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/drivers/i3c/master.c
+++ b/drivers/i3c/master.c
@@ -2279,11 +2279,12 @@ static void i3c_master_unregister_i3c_de
 		if (!i3cdev->dev)
 			continue;
 
-		i3cdev->dev->desc = NULL;
-		if (device_is_registered(&i3cdev->dev->dev))
+		if (device_is_registered(&i3cdev->dev->dev)) {
+			get_device(&i3cdev->dev->dev);
 			device_unregister(&i3cdev->dev->dev);
-		else
-			put_device(&i3cdev->dev->dev);
+		}
+		i3cdev->dev->desc = NULL;
+		put_device(&i3cdev->dev->dev);
 		i3cdev->dev = NULL;
 	}
 }


