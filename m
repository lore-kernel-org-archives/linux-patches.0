Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE82812C487;
	Tue, 30 Apr 2024 10:55:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474519; cv=none; b=U6IqwncAAmAnr/ufsSPYqQM/V6+q1IDnBQhBkkyMpBvcVUciqjgRfNMMxYjsKN7NAvjIO7Le9f34JmCLgKlr/uKkYti3W9XTIvu8vSOuef5oQqJ/n79HN9bdI9GHUdOFNyGD6BXJvlccOFD1WuFFvBpfosSXLnCINirijw/9Lig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474519; c=relaxed/simple;
	bh=29t/t/bMbzy9IVK9dMB6oct62xFBq9bZEnEiw+7HnSM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KZTri9ic89svV+ehYRrwvrO3rzao7zSC0Kn51u3c0kCVINJyj8QuJHaN0A7WdKAaZFyBoYnc7kqiGhjBbYbuicsHrK7PNNI1WbiYBLrvNKqTEZXYf1x1KFTBi3Za70ci+RxrouN9kA9JOdP6lytwXL6Pw/bzyJyvFUyFt/T/oBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dH35O5TT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dH35O5TT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30A00C2BBFC;
	Tue, 30 Apr 2024 10:55:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474519;
	bh=29t/t/bMbzy9IVK9dMB6oct62xFBq9bZEnEiw+7HnSM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dH35O5TT7l2xMiYdPp9b2b1Pb5tFLyuSTR7LrAputoJoFLt8NeVKiyRp214BKBLSl
	 fS8wfro7ciHgki2YvHKxYXNpJSq9h+PRXnBHWIMQ+pV1kGS260t0hIFdqQdNxHR4fb
	 EX2vLngI+mZKAuOsSOYf9YE/50SVdfRpE/CBUeBU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan+linaro@kernel.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.8 144/228] Bluetooth: qca: fix NULL-deref on non-serdev suspend
Date: Tue, 30 Apr 2024 12:38:42 +0200
Message-ID: <20240430103107.953680051@linuxfoundation.org>
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
@@ -1672,6 +1672,9 @@ static bool qca_wakeup(struct hci_dev *h
 	struct hci_uart *hu = hci_get_drvdata(hdev);
 	bool wakeup;
 
+	if (!hu->serdev)
+		return true;
+
 	/* BT SoC attached through the serial bus is handled by the serdev driver.
 	 * So we need to use the device handle of the serdev driver to get the
 	 * status of device may wakeup.


