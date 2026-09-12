Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DE49374A12;
	Sat, 12 Sep 2026 09:22:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789204956; cv=none; b=B393OeBN2j/w+Bqn0amUXUbNhlmKuV4h6C1UdW0QHaiNnNTjJD0Gg2k3HFjtIHr0h/xVet8OnGeGw+pi8G7NF4vwTUlWUo/Ade9SOPWq1ORvd5TFlKxOsnXKqpCQFkUCvl9he93fGusnp+XSmv20/VBxFwyLP+PdhkAevix6Dok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789204956; c=relaxed/simple;
	bh=3lt30+SfAsN9+twTa2G97dgfEMDbd/kjZkLUnrZJlzY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JA9C8osv+XFFhvF1xDJgp3HcnXoG0TtKmP6c6EUMSowxYZUaum/MHx8IxiA18vRFndRnS76Dc2qgp8cAOTqQk5XL/ueCiMSiVAbaCDnjIJHV2HqXMQ3VvT6BiDWWY5nvqwB5ntOKQ4/akdtiQ+EQ8G9tNaRCoquQ7RTtoC6P8p0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HepC/DPo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HepC/DPo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C7C11F000FF;
	Sat, 12 Sep 2026 09:22:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789204954;
	bh=PTw6vV2bjt1dShlwtv13+YsqmauC+WSpQJrcCwBt7x8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HepC/DPoPU0bvYApbsoiQnaYixITbFPkbKjUWpeXJPfzsKLMO5pMP9AdHue2hQm0H
	 ODbRvTUFSUZx/h/+nsTXCXCjZ1id4gTegEW2Qo++fQO6jVMTkjfRROa9/kKFTpKjiw
	 8AfpG9+2WqFzwBCMjFiXw6Wdjl1F/xDX7hG/r7qo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ismail Tarim <ismailtarim7@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1719/1815] Bluetooth: btmtk: Do not report success when subsys reset fails
Date: Sat, 12 Sep 2026 08:57:49 +0200
Message-ID: <20260912065729.329269884@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ismail Tarim <ismailtarim7@gmail.com>

[ Upstream commit 59c3ee19ca88210bfc0e22ce59218091cb1a3c48 ]

btmtk_usb_subsys_reset() validates the subsystem reset by reading the
chip id back. When that read succeeds at the bus level but yields an id
of zero, the reset has demonstrably not taken effect: the function logs
"Can't get device id, subsys reset fail." and then returns the return
value of btmtk_usb_id_get(), which in that case is zero, i.e. success.

btusb_mtk_reset() returns that value unchanged, so its caller cannot
tell a completed reset from a failed one.

Return -ENODEV when the chip id reads back as zero, leaving the existing
MT6639 exemption intact.

Observed on an MT7902 [13d3:3579]. The path can be reached on demand by
asking the controller for a coredump, since btmtk requests a reset once
the dump completes:

  # echo 1 > /sys/class/bluetooth/hci0/device/coredump

  Bluetooth: hci0: Mediatek coredump end
  Bluetooth: hci0: Can't get device id, subsys reset fail.
  usb 3-10: reset high-speed USB device number 5 using xhci_hcd
  usb 3-10: device descriptor read/64, error -110
  usb usb3-port10: attempt power cycle
  usb usb3-port10: unable to enumerate USB device

The same sequence occurs unprompted when the controller firmware asserts
on its own.

Note that this corrects the error reporting only; it does not by itself
make the controller recoverable in the case above.

Fixes: 25b6d7593a3a ("Bluetooth: btmtk: introduce btmtk reset work")
Signed-off-by: Ismail Tarim <ismailtarim7@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btmtk.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/bluetooth/btmtk.c b/drivers/bluetooth/btmtk.c
index 66b3467610436..dc702c0a6034d 100644
--- a/drivers/bluetooth/btmtk.c
+++ b/drivers/bluetooth/btmtk.c
@@ -968,8 +968,10 @@ int btmtk_usb_subsys_reset(struct hci_dev *hdev, u32 dev_id)
 	}
 
 	err = btmtk_usb_id_get(hdev, 0x70010200, &val);
-	if (err || (!val && dev_id != 0x6639))
+	if (err || (!val && dev_id != 0x6639)) {
 		bt_dev_err(hdev, "Can't get device id, subsys reset fail.");
+		return err ? err : -ENODEV;
+	}
 
 	return err;
 }
-- 
2.53.0



