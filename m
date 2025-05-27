Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 308501DB34C;
	Tue, 27 May 2025 17:15:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366148; cv=none; b=kb5yL+1frgvFsD7m7mdexfSadvLJMa/omD4iOm9vULbsMzTfrc70XADcnfi6/ok5GFXCjqOiPXEMVpjZekfmuBGJBPSQ3yCHjPyVfT/qOzGylns8+AAaTVgrmRrS9ksUSe1NKff3epSxlaMgMNELgvQ8hDbmb+0HpzmadNBuaCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366148; c=relaxed/simple;
	bh=aHtJGJqw/PutqnxWvbakEIabGoAmmK9YTCY2EVTsD+Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I5I3+4AL+nrmbfdPR4XfC0kHoX6M/t0nQUU9qnvW8pftljJfYRpDtoHbXU+qFUt8u9zdOtkjgGyNKrS2fKKyd+IEwHzxgtZGiKnajIX8lY2cI7gdk/R4Fet0e9FQrSN2dniFqHTDhJko3R3C1tGe7FBTWwhriLA8AlDIzBIT1Tw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e7U8D892; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e7U8D892"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4D5AC4CEE9;
	Tue, 27 May 2025 17:15:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366148;
	bh=aHtJGJqw/PutqnxWvbakEIabGoAmmK9YTCY2EVTsD+Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e7U8D892xdaWrXMtrAAzJBShly1Rz1xf0dF4FbrhIlDlurPDPUBTEW+GDnHGugSNJ
	 mcO2E/9YQnI9cLoLrIzc6DZxW/kZBTno3JU2/vHch9VFV1Qk+DnED0HL/L56hcjzRL
	 rr6NRgZFqVZyDFH89VMIvjrnXR+ABPXYOfsQcR6Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Lu <chris.lu@mediatek.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.12 605/626] Bluetooth: btmtksdio: Do close if SDIO card removed without close
Date: Tue, 27 May 2025 18:28:18 +0200
Message-ID: <20250527162509.577753257@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Chris Lu <chris.lu@mediatek.com>

commit 0b6d58bc6ea85e57de25c828444928e4a0aa79cb upstream.

To prevent Bluetooth SDIO card from be physically removed suddenly,
driver needs to ensure btmtksdio_close is called before
btmtksdio_remove to disable interrupts and txrx workqueue.

Fixes: 6ac4233afb9a ("Bluetooth: btmtksdio: Prevent enabling interrupts after IRQ handler removal")
Signed-off-by: Chris Lu <chris.lu@mediatek.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bluetooth/btmtksdio.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/bluetooth/btmtksdio.c
+++ b/drivers/bluetooth/btmtksdio.c
@@ -1434,11 +1434,15 @@ static void btmtksdio_remove(struct sdio
 	if (!bdev)
 		return;
 
+	hdev = bdev->hdev;
+
+	/* Make sure to call btmtksdio_close before removing sdio card */
+	if (test_bit(BTMTKSDIO_FUNC_ENABLED, &bdev->tx_state))
+		btmtksdio_close(hdev);
+
 	/* Be consistent the state in btmtksdio_probe */
 	pm_runtime_get_noresume(bdev->dev);
 
-	hdev = bdev->hdev;
-
 	sdio_set_drvdata(func, NULL);
 	hci_unregister_dev(hdev);
 	hci_free_dev(hdev);


