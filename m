Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 575DC13DBA0;
	Sun,  7 Jun 2026 10:26:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780827997; cv=none; b=mRNrstY5PFTDND2INT5kkpE6FN0jtVJoCAe5YVab8NpuC7M00aD06VSIETa4YJEaOewO04SsE4y5xEHw3pR2TqSZfvvtwPwZFrf5vT94LjU4fQ+i6JsbQm+H9jW1hbe8e0Ca4I3GZktGqltLjo8Mnmw0V6y9N7nBd8LkGmp8uAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780827997; c=relaxed/simple;
	bh=AZyFYhFsr88tWhVwk28FWE55zbbcuZA587ZvtDfQU+M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TutXKFgwTkmqxMTIBUH5zHJGygO0rt8KCdcfKVFq+d3IVIo70RQz2F4xZXn1FCBkR4/BWLFjtkRTbpV0PIZ1LuxNz/HDU6QLg5RPdfRs7eLSHFKXZ7GB0L1B1t+ItdVlqX6nPslXQGrt00wMm+aTud8jjQpeCri63fjEDQvWKdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Sywbt4iK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sywbt4iK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92DC31F00893;
	Sun,  7 Jun 2026 10:26:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780827996;
	bh=mAIVsR8StiQrknZd4YRb2UeoVnAUSU5Jp57g3TyvQhs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Sywbt4iKnxdr65uUz/s8epMJuwV4CpWk/Knk5pHWjfLkLYDO2nbHV7CpMRK/98Dsf
	 4wmTi1siatUTIQH+3lWGJlkFDwLTKmieliLPn2RpH8kF+zATH2Hy5fx096clb55e7R
	 SdBfREuKXElLCvJ/dIHOM3ENDbzTeCZrzz/kmCMM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuai Zhang <shuai.zhang@oss.qualcomm.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.18 119/315] Bluetooth: btusb: Allow firmware re-download when version matches
Date: Sun,  7 Jun 2026 11:58:26 +0200
Message-ID: <20260607095731.998927346@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.528828913@linuxfoundation.org>
References: <20260607095727.528828913@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3478,7 +3478,13 @@ static int btusb_setup_qca_load_rampatch
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


