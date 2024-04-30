Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3830112C47F;
	Tue, 30 Apr 2024 11:29:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714476551; cv=none; b=fsXxLrYqeymGyuhFDVeERxG5qVp2Hii9/YhUoDMvppiIwGYz/WlRXOLwfXsaOc4l4j1njeaB18wOrTdCE54LJw1ICywqPoAfVO9PBbTqoU1wMJWeQkkbCWdkW36hFD5izTN/+ePIMZGVyYEmaHheKrYWh7BaO5CaOtSSWIhNnhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714476551; c=relaxed/simple;
	bh=PlW4O9Ce+KZthJAvitDmnPmF5aQMbr2LsybrXF1PzA0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kfKBIuTxlbpioFDfn3WwDC1wpJLXsq4yslv0L3HS+f0yM5hDmuLylfKoT+tiIUo4qlA3nk5GCNS3oUFUbrB7Xf8pq0kzA/m+3V5AP8yOVW6jwXSWRs+dgU/9auLk9+nTKrTSJBLXFIb9pSG1YhZi666Rjkat9RRBC/IeeR9TDpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Nk7FBTn2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nk7FBTn2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B65FC4AF1C;
	Tue, 30 Apr 2024 11:29:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714476551;
	bh=PlW4O9Ce+KZthJAvitDmnPmF5aQMbr2LsybrXF1PzA0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Nk7FBTn2j1AaHJxOqZbAbX1ojFU0ZJ2tNE0Ip4lRpAj3V5TBRXrq8/VN+35NUzSw1
	 MyySbINZgBSSsZDmVpPXFCiDyhWysVoxIe+xKjS2AwTegXwuvmBewBkq9BSR46Bqed
	 e1FgaZFUn4OuvDA1h9vytqmEtEzq4XviA553sBug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan+linaro@kernel.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.1 068/110] Bluetooth: qca: fix NULL-deref on non-serdev suspend
Date: Tue, 30 Apr 2024 12:40:37 +0200
Message-ID: <20240430103049.574739386@linuxfoundation.org>
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
@@ -1645,6 +1645,9 @@ static bool qca_wakeup(struct hci_dev *h
 	struct hci_uart *hu = hci_get_drvdata(hdev);
 	bool wakeup;
 
+	if (!hu->serdev)
+		return true;
+
 	/* BT SoC attached through the serial bus is handled by the serdev driver.
 	 * So we need to use the device handle of the serdev driver to get the
 	 * status of device may wakeup.


