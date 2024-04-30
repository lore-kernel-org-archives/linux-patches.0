Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B6D112C805;
	Tue, 30 Apr 2024 11:26:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714476368; cv=none; b=Kn4/WzISEWc+djJDfq+sZ130TUUsMvqMhSlvVtpMIPoVL6Lp0oO2xgxwnC93mPVAVoCEA12cUkNuY3JxlJqvMaQPD8a4YkPSXDMEy9joDYTHT00MXgS+uBIMrxRnp+aeIqGFuV9rrKD2A/joKpOdJvfmwn7lJm71X9FEBcLNJf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714476368; c=relaxed/simple;
	bh=3FXsPsC8ZC23ZVBAcxmX0xrFrrR6pGxGdKR95vZgAMU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bTalioMBWOcmWoTs4Wd182swQPun7EE9UZ/+Ll2H7Mbdlg+RmAobvQ8KWRIb5qIekq9PVplI0FysUuaPeT2TweNft8/8FmH/swjiM9kceyjCFpLkzI1RaVVHFkJ7Vc0QwfOCQjLsQl236FSI4nMDV/x4LATa9Zqg9/1yZUKlxJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U3U33GYj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U3U33GYj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7775C2BBFC;
	Tue, 30 Apr 2024 11:26:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714476368;
	bh=3FXsPsC8ZC23ZVBAcxmX0xrFrrR6pGxGdKR95vZgAMU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U3U33GYjp+CF+aF61qPHQ3LfHBOgNcadgtetihdDOnig/kYcrPRCg206H/gQMr6RH
	 j8i7mg/jeFToHDMaSXXzCRmGx8QCLJ5nWK/A2NxrMhZ8qe6SH3Y38iwWMMuy0H5w+o
	 Dlo80xZrERYNzP+7s/pz8mgxoE9kHvPDGxiRRM3U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Lixu <lixu.zhang@intel.com>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 003/110] HID: intel-ish-hid: ipc: Fix dev_err usage with uninitialized dev->devc
Date: Tue, 30 Apr 2024 12:39:32 +0200
Message-ID: <20240430103047.668980574@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103047.561802595@linuxfoundation.org>
References: <20240430103047.561802595@linuxfoundation.org>
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



