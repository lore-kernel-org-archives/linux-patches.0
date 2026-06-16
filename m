Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF9333D47CE;
	Tue, 16 Jun 2026 18:09:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781633347; cv=none; b=kaB1YCzM/QXcmq3svxcFGBLSCoVPrD6gTVdIxbYeCXCq5+362WNt6ztCJarsJ37PQlnDYBlvgmESo+A8cW3JsWmSJwqe8yufgWXDy6r3NmFRUipNyHEtDfgOW8KylKvLKaQTP/Uh2Ffwa3vF+qBQ9jzyS5nDP2tNzwXO2nzh/hk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781633347; c=relaxed/simple;
	bh=ENivjcUkGRtCPldZ2bBF4tHDEVY7O2RffE3Ghfj62Xw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uKNYBiEufHFFJgXMFTmO4DzQfg1UH/9FjtmEXOZux5NzczrGB9pF2HVuH7r7sVzU0rKjDAcGDALsNibFybwr2+fnv1bSx+vpDNAbUjRv/+5Ppwo7Zz74M4LZzeASPSs7aBfmUVx1gu2n+cv2/Klln2ktliPuQwJiadXMbKTlC2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ufMS91tJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ufMS91tJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F32DB1F000E9;
	Tue, 16 Jun 2026 18:09:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781633345;
	bh=jT5bmEKJk32z/dMO4b5cq/TzoSfeRx49iNuD9CJSt9U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ufMS91tJAaIO6WSltL6pi1gOfiLY570R/bQmh/Ak/vcC+Jcs0CK/kJIq5NUkxioNS
	 yMkNXktwQNeBou5z+BV5OTI81xvANL1Q7b8dZ3uehEizEJrm3wZkGTdGY8YnVoSFr+
	 uDFrxaAWcpcNpFReNAP9tS8VThYhonxqSc7oaQvk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuai Zhang <shuai.zhang@oss.qualcomm.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 5.15 062/411] Bluetooth: btusb: Allow firmware re-download when version matches
Date: Tue, 16 Jun 2026 20:25:00 +0530
Message-ID: <20260616145103.576670765@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145100.376842714@linuxfoundation.org>
References: <20260616145100.376842714@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3448,7 +3448,13 @@ static int btusb_setup_qca_load_rampatch
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


