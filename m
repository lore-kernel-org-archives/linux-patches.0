Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E7233F4831;
	Sat, 12 Sep 2026 13:18:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789219094; cv=none; b=iitRwNAemXEDYYQ2XUfn9AvNmg6acwJ0JeQz5GLRwlEchvApH5Gl13QfQevtFqtEDOJOJzHMo3bnHefGY9He5R8NnzlrvEaJyA2/CR++xTt6JXBFrVQGw3op8UOZstNlA1LNx1kSfW6DbpXt/qY4H2YdsIjAEi+tLizu5gMfR40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789219094; c=relaxed/simple;
	bh=OYiAmqEN96at8/NCd1T31iKL786xZGUgS9aWGEVqk3M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ahrfL3KPXYYY4ZMlXJKJnhvcT2cqMtvQ0cxW/MjevPd8DNTRi2rKZ9ad/YDKebJe7KR3n3A5CvwhNIJKghaoCF7JUwHvTqEklnunEQdtiB5VSAnD8GZOHMlzM0LZKUNxB+0w+CveJyLDTLaM5OdfQRE0BBG6ikEMQp6/7Xaeg0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mch9iTRz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mch9iTRz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2DBC1F000FF;
	Sat, 12 Sep 2026 13:18:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789219092;
	bh=rScGfOylyqhrmEygKBI3oLMyqE9OQC5hEDs1j3WeusY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Mch9iTRzB3BZ07Npsaze5AfB2QcQgLQ4YyPPam89pdug7OVu8cbfkfsHNUHlmhfyi
	 eoL3RdPNCPZteAekXcjAOOgZ3kohSPGNp8FBt9xF2AZCIP2ChZnI5/JyQqD3jQxMXI
	 UM2L19FDphxihA3HRgBpIhVjKJjspH7zKX3sbX4Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ismail Tarim <ismailtarim7@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1279/1376] Bluetooth: btmtk: Do not report success when subsys reset fails
Date: Sat, 12 Sep 2026 09:01:45 +0200
Message-ID: <20260912065636.046202205@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index bd6a10806aab7..9f35ca1c60d76 100644
--- a/drivers/bluetooth/btmtk.c
+++ b/drivers/bluetooth/btmtk.c
@@ -956,8 +956,10 @@ int btmtk_usb_subsys_reset(struct hci_dev *hdev, u32 dev_id)
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



