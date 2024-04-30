Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A37E12C46D;
	Tue, 30 Apr 2024 10:45:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714473952; cv=none; b=NLQzB2DvZfsHc7fiBg+wTt4t5JsSUvuXClxrpXe08V2mzBIMOSLFbx7O1lUWYoaM45QkHyJXD77z1AhM3oXMFsrNEMdSew3zn/kJvKX07fgJ/+wiwcHUDbsdmTgm2+Zsz7jTDRR8iO1JV39WjPCi2naOHtgCBoph44gyBIE2m64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714473952; c=relaxed/simple;
	bh=FRSDJ4KnOT4qyqGpk1lbwGfKF2mag6B8pxj2kmHoLSY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZojbJFR5p/7WmU1A+NAsfkJIq4yQkvFszbKO8E1gPuEv7lfZCRB2hTTGADJ5ABwHvpvyMSqJq6rtgO/l3UUEQ6xdbdyYLmRW3jporzohNZLdhgSLcwGXq7QGnjPauTiXF9FEooigJfX712D4rWjemff7XDQrHT4UZO/zkIgoFNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sbA1PwYB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sbA1PwYB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8686C2BBFC;
	Tue, 30 Apr 2024 10:45:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714473952;
	bh=FRSDJ4KnOT4qyqGpk1lbwGfKF2mag6B8pxj2kmHoLSY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sbA1PwYBNTVy++KqiaKsu4+tCKbIhNgtWDmFg9plz04d2US4oPq1G7S5U8w6dCitN
	 LnHYADSRfCPLuGvzBlmlCeztciEkmRfQRQjBrVmzQSHXQxWwM5IAk9s8yXV0bvx60Z
	 JVv8mNMTy/EC//ALEb/JZJgFrvdb0bhPKlYUgzvM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Lixu <lixu.zhang@intel.com>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 004/228] HID: intel-ish-hid: ipc: Fix dev_err usage with uninitialized dev->devc
Date: Tue, 30 Apr 2024 12:36:22 +0200
Message-ID: <20240430103103.940343301@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103103.806426847@linuxfoundation.org>
References: <20240430103103.806426847@linuxfoundation.org>
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

From: Zhang Lixu <lixu.zhang@intel.com>

[ Upstream commit 92826905ae340b7f2b25759a06c8c60bfc476b9f ]

The variable dev->devc in ish_dev_init was utilized by dev_err before it
was properly assigned. To rectify this, the assignment of dev->devc has
been moved to immediately follow memory allocation.

Without this change "(NULL device *)" is printed for device information.

Fixes: 8ae2f2b0a284 ("HID: intel-ish-hid: ipc: Fix potential use-after-free in work function")
Fixes: ae02e5d40d5f ("HID: intel-ish-hid: ipc layer")
Signed-off-by: Zhang Lixu <lixu.zhang@intel.com>
Acked-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/intel-ish-hid/ipc/ipc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hid/intel-ish-hid/ipc/ipc.c b/drivers/hid/intel-ish-hid/ipc/ipc.c
index a49c6affd7c4c..dd5fc60874ba1 100644
--- a/drivers/hid/intel-ish-hid/ipc/ipc.c
+++ b/drivers/hid/intel-ish-hid/ipc/ipc.c
@@ -948,6 +948,7 @@ struct ishtp_device *ish_dev_init(struct pci_dev *pdev)
 	if (!dev)
 		return NULL;
 
+	dev->devc = &pdev->dev;
 	ishtp_device_init(dev);
 
 	init_waitqueue_head(&dev->wait_hw_ready);
@@ -983,7 +984,6 @@ struct ishtp_device *ish_dev_init(struct pci_dev *pdev)
 	}
 
 	dev->ops = &ish_hw_ops;
-	dev->devc = &pdev->dev;
 	dev->mtu = IPC_PAYLOAD_SIZE - sizeof(struct ishtp_msg_hdr);
 	return dev;
 }
-- 
2.43.0



