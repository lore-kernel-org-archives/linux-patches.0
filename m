Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25B6C8801;
	Tue, 30 Apr 2024 11:13:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714475636; cv=none; b=Q6py5dXai6HNr0DQUEPxN79bYiZxO8OGkijsGP21V9pZZBxEl0TdUBdDwhjKWSwJ8x9wiDG9TAAYCq0/Cf1JbxWz0taTbnfPb0BV71VTLsq9CHC8TfdyB7JXBL4ILeEB8btDG+GCqmJbL2yWTwWfT3BFL42aSwJSCetjINcvPzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714475636; c=relaxed/simple;
	bh=wykQgcUw1u6O5u6y2p0wqZkpyyLpkqZL32y9Xjbv2RI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RfSOGfALym9lssLwr1OonCPBTIu/lo3evSUopA4L+2LqHizWKavHpSvVTEcfBFxPlsKsADM1kVfYPNxrM1kmF+IH22KWxrHZlvF9NyWfg44EabYvUgUcaeBWSVhBDrKf1LkOBK6hI9m/vXAJLw44sYetwI7ejHG1vWPWpQKNAp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AvZ306Sj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AvZ306Sj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CA74C2BBFC;
	Tue, 30 Apr 2024 11:13:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714475636;
	bh=wykQgcUw1u6O5u6y2p0wqZkpyyLpkqZL32y9Xjbv2RI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AvZ306SjxBfDs1kXNHX9aMghQ9m/2kzszA7jIFr7fcOe+yekj9e8D1MVDquiqXuTP
	 RUe/i/x6JMKhO9DtfdX9hxODKCD8025UCgHYbiCO1qneiSsrCwn4Gj3dGW/ZIRDO4G
	 7oVWuSniiFVAsZeW/6H+bNZ7ajv++WktgTRD0IB0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan+linaro@kernel.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.6 120/186] Bluetooth: qca: fix NULL-deref on non-serdev suspend
Date: Tue, 30 Apr 2024 12:39:32 +0200
Message-ID: <20240430103101.515975686@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103058.010791820@linuxfoundation.org>
References: <20240430103058.010791820@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


