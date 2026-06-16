Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA9A747D94E;
	Tue, 16 Jun 2026 18:45:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781635544; cv=none; b=dMUB82DEz8kYaKV/q2/sLWVIN0yPr2fB2QJuiMSGyHG2y2CAD6FvujwDYZ8azKfobfAo+Wi7dUie15DwzgrIXMrflurBSW3HSq34tPzqPlm90wqlWKBlagXJnXh+hQFABzxisr7Ava1qVGIFH25RQ6J4kXtc2RBvewwKZXaoq5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781635544; c=relaxed/simple;
	bh=YdANP3iYPLk2i0id69ef8zB5JCe9AdgHnlwwP41sTVE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rvr24tHp7lHCfp1Zy0HiWX5YI7sOqAKTJ35BFAecjwOCDmDyuoiI+vAHuUWWT+TVAVdK52ZQ3fyivXpBGiRAchnv3xpTAi5Y21NXI4gUPeLQ95DFUJBVkmvy+G7r4rvBR+WzI5iDd9RdfVECWetXdcWr+lULpGT/RYr4GivwGB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XEJ+GP9E; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XEJ+GP9E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 313541F00A3D;
	Tue, 16 Jun 2026 18:45:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781635541;
	bh=a910AdEcpng2OgAkVCpkif15W4h28MdjV1QSWpAvCd0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XEJ+GP9E6dUQa/GOQGWaOw42ecYXtGJBcA6Gk5dxWIC+z9XOvv5TId9cVeUmcPd7s
	 ICYNRmQqdhLjwHT7glUUlhl5ZU6v3OENnKLk7eCl8plPgFLrpifvF+r9Wyws6c4BTT
	 gj4uFXyIkOR1CdHCt6hjp+QWmCnxkgpMNyQtXJUM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuai Zhang <shuai.zhang@oss.qualcomm.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 5.10 051/342] Bluetooth: btusb: Allow firmware re-download when version matches
Date: Tue, 16 Jun 2026 20:25:47 +0530
Message-ID: <20260616145050.628279770@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145048.348037099@linuxfoundation.org>
References: <20260616145048.348037099@linuxfoundation.org>
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

From: Shuai Zhang <shuai.zhang@oss.qualcomm.com>

commit 82855073c1081732656734b74d7d1d5e4cfd0da7 upstream.

The Bluetooth host decides whether to download firmware by reading the
controller firmware download completion flag and firmware version
information.

If a USB error occurs during the firmware download process (for example
due to a USB disconnect), the download is aborted immediately. An
incomplete firmware transfer does not cause the controller to set the
download completion flag, but the firmware version information may be
updated at an early stage of the download process.

In this case, after USB reconnection, the host attempts to re-download
the firmware because the download completion flag is not set. However,
since the controller reports the same firmware version as the target
firmware, the download is skipped. This ultimately results in the
firmware not being properly updated on the controller.

This change removes the restriction that skips firmware download when
the versions are equal. It covers scenarios where the USB connection
can be disconnected at any time and ensures that firmware download can
be retriggered after USB reconnection, allowing the Bluetooth firmware
to be correctly and completely updated.

Fixes: 3267c884cefa ("Bluetooth: btusb: Add support for QCA ROME chipset family")
Cc: stable@vger.kernel.org
Signed-off-by: Shuai Zhang <shuai.zhang@oss.qualcomm.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bluetooth/btusb.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -3744,7 +3744,13 @@ static int btusb_setup_qca_load_rampatch
 		    "firmware rome 0x%x build 0x%x",
 		    rver_rom, rver_patch, ver_rom, ver_patch);
 
-	if (rver_rom != ver_rom || rver_patch <= ver_patch) {
+	/* Allow rampatch when the patch version equals the firmware version.
+	 * A firmware download may be aborted by a transient USB error (e.g.
+	 * disconnect) after the controller updates version info but before
+	 * completion.
+	 * Allowing equal versions enables re-flashing during recovery.
+	 */
+	if (rver_rom != ver_rom || rver_patch < ver_patch) {
 		bt_dev_err(hdev, "rampatch file version did not match with firmware");
 		err = -EINVAL;
 		goto done;


