Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3AD1435A86;
	Tue, 21 Jul 2026 20:18:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665093; cv=none; b=fCQR8DW2Oa9z+XwScJWg+91fL4nds2ZUP0pH+bl5TDKJkvyHs+vRm7ZguybGSmTGm0oPJb5qcllw7vmG0MCVrhBwcHbhrR3jLWPHIAqGbBn1ZHVDy14lO9vJB44G0BVwXuS1gYgkhDJrfo1Jl3P5AylCeiq/V/e2m9XONWzMyFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665093; c=relaxed/simple;
	bh=qCKpYJDJeLhhCvI8OQOl08I8kP63XGsW69iQPhwIC+A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VQvo6R271ELR039u9C4d5+OgSZyNcrj+RMbeZi1fSZdDGvXybkU5w4nA6IhNizU0m49RnRyTM6GwQw+Pmm1bVYxGktMjvZCp3utsTe3UWxIL5HKVWKq0NODPVCCxLmqVyU5E2dwAPNXhY3GdOXXwCDpvuOlpH5oYqY0u7/ySIbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YVuvP3KM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YVuvP3KM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD1AC1F00A3A;
	Tue, 21 Jul 2026 20:18:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665090;
	bh=rXpGNjJp5d00vuuzsPfqRMqIl+hdiKvrhRa4j4GeVBQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YVuvP3KMI3talgdWPmyasKcLuxv7GsF4PkxKoaplAZa6CKRsmUUDaLifnC61dh9ai
	 v0X54atLU9au2sQieJZNIT0jz2jTAEVSIao8emTIraIVQ49O2qzy1OR+fU+Cy1031b
	 CdfnLJ9kfKLZxs9+1htAzqw/jEVnuPOKsd66LtbY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>,
	Maoyi Xie <maoyixie.tju@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.6 0172/1266] Bluetooth: btnxpuart: Fix out-of-bounds firmware read in nxp_recv_fw_req_v3()
Date: Tue, 21 Jul 2026 17:10:09 +0200
Message-ID: <20260721152445.655545384@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maoyi Xie <maoyixie.tju@gmail.com>

commit badff6c3bed8923a1257a853f137d447976eec30 upstream.

During the v3 firmware download the controller sends a v3_data_req with a
32 bit offset and a 16 bit len. nxp_recv_fw_req_v3() checks only the lower
bound of the offset and then sends firmware from that offset.

  nxpdev->fw_dnld_v3_offset = offset - nxpdev->fw_v3_offset_correction;
  serdev_device_write_buf(nxpdev->serdev, nxpdev->fw->data +
                          nxpdev->fw_dnld_v3_offset, len);

Nothing checks that fw_dnld_v3_offset + len stays within nxpdev->fw->size,
so a controller that asks for an offset or length past the firmware image
makes the driver read past the end of nxpdev->fw->data and send that
memory back over UART.

nxp_recv_fw_req_v1() already bounds the same write. Add the equivalent
check to the v3 path, reject the request when it falls outside the firmware
image, and zero len on the error path so the fw_v3_prev_sent bookkeeping at
free_skb stays consistent.

Fixes: 689ca16e5232 ("Bluetooth: NXP: Add protocol support for NXP Bluetooth chipsets")
Suggested-by: Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>
Reviewed-by: Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>
Cc: stable@vger.kernel.org
Signed-off-by: Maoyi Xie <maoyixie.tju@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bluetooth/btnxpuart.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/bluetooth/btnxpuart.c
+++ b/drivers/bluetooth/btnxpuart.c
@@ -1030,6 +1030,12 @@ static int nxp_recv_fw_req_v3(struct hci
 	}
 
 	nxpdev->fw_dnld_v3_offset = offset - nxpdev->fw_v3_offset_correction;
+	if (nxpdev->fw_dnld_v3_offset >= nxpdev->fw->size ||
+	    len > nxpdev->fw->size - nxpdev->fw_dnld_v3_offset) {
+		bt_dev_err(hdev, "FW download out of bounds, ignoring request");
+		len = 0;
+		goto free_skb;
+	}
 	serdev_device_write_buf(nxpdev->serdev, nxpdev->fw->data +
 				nxpdev->fw_dnld_v3_offset, len);
 


