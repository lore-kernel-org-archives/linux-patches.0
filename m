Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F2368801;
	Tue, 30 Apr 2024 11:18:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714475908; cv=none; b=agPYYAI97EtQ0A4Pe6lqwP/GU45u8EbnJRYN7RSXSjAowQVXB5XelayJ4HKAMzGKO9DIu10nTXcdh+u5eSwA53OHB626IrKcU+NXLwAX61QlcqBFEbroD9BipVTnBz2DXlNoluE8hc0ST82ydK1QlY/lKaDSLRRyzBC+yQJIdTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714475908; c=relaxed/simple;
	bh=riJhKuYXH5o2Anxuoq2eneR+f5R00GQKc2Pxtkt/9Vc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BmWHwKjR+1pMEY87mHJWtgQoCn008ZtNYgyWz81fq6kRn+jLw7CEQbp0b3HFR5owJltaM/+iE1z1MaikYN1v5txF6De+8OQ+DqWDtQEVfj8219HIHVq+N1TYWAUuO5bt4Phied6XF5UnB9LG1FPtdRS4kZRs2V/sAxocKkKzsGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cvqVqVmQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cvqVqVmQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4D14C2BBFC;
	Tue, 30 Apr 2024 11:18:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714475908;
	bh=riJhKuYXH5o2Anxuoq2eneR+f5R00GQKc2Pxtkt/9Vc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cvqVqVmQMKErvMr6MkZaOKxJdAhB2OMxrg2BC0bHF0xkG3CC0/g01B1vC5jJVlD06
	 wiGRWI3vIZYRsLvriPWIbpVVsdX5KxAcYZgqkl43e8Zm5Zug1slYd/JNIdu+oL4KeC
	 VluVeXsdrzbgJFt2niuW3XsIR3bxawNWW9l4dloQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan+linaro@kernel.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 5.15 55/80] Bluetooth: qca: fix NULL-deref on non-serdev suspend
Date: Tue, 30 Apr 2024 12:40:27 +0200
Message-ID: <20240430103045.043135354@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103043.397234724@linuxfoundation.org>
References: <20240430103043.397234724@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan+linaro@kernel.org>

commit 73e87c0a49fda31d7b589edccf4c72e924411371 upstream.

Qualcomm ROME controllers can be registered from the Bluetooth line
discipline and in this case the HCI UART serdev pointer is NULL.

Add the missing sanity check to prevent a NULL-pointer dereference when
wakeup() is called for a non-serdev controller during suspend.

Just return true for now to restore the original behaviour and address
the crash with pre-6.2 kernels, which do not have commit e9b3e5b8c657
("Bluetooth: hci_qca: only assign wakeup with serial port support") that
causes the crash to happen already at setup() time.

Fixes: c1a74160eaf1 ("Bluetooth: hci_qca: Add device_may_wakeup support")
Cc: stable@vger.kernel.org      # 5.13
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bluetooth/hci_qca.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/bluetooth/hci_qca.c
+++ b/drivers/bluetooth/hci_qca.c
@@ -1590,6 +1590,9 @@ static bool qca_prevent_wake(struct hci_
 	struct hci_uart *hu = hci_get_drvdata(hdev);
 	bool wakeup;
 
+	if (!hu->serdev)
+		return true;
+
 	/* BT SoC attached through the serial bus is handled by the serdev driver.
 	 * So we need to use the device handle of the serdev driver to get the
 	 * status of device may wakeup.


