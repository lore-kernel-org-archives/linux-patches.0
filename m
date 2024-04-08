Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A61EE7D3F8;
	Mon,  8 Apr 2024 13:22:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582579; cv=none; b=htHOE79c6w6nzN5zh2s5mVkiDIYNNg3E1gLvmGFK+WgT+EJJuYfscy0jqkErAil8viY6ppJFPetnk5NVnmuXzWBujYY7fkHkviziGl7AagiC5iCSc2I3cVac8qjK5TOYQ27c8XXHI/+RsPjLKgPZNSz/XFCjvbQF271/WGrhzgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582579; c=relaxed/simple;
	bh=8BdWP4hYjBWoC4tna54iMV7u8z9BpXF+4Qd/DWfoAMo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lzivj8Zg1sbVqgPbqaUO9z0vphGe+Qb+HH73J3Y4TiGB95LdEjnxAzCtpRVPnNDRnVXTBa2hx0FM/6S/50MLncOpuo77LYdSrdyCKuxpFyZy7IsS/vkc0SQP+pMBCLMCCUcPFY0VnrbMRfm12dKYSTDbnlNE62t75va9aCZoJUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R1y9XUH2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R1y9XUH2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E061C433F1;
	Mon,  8 Apr 2024 13:22:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582579;
	bh=8BdWP4hYjBWoC4tna54iMV7u8z9BpXF+4Qd/DWfoAMo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R1y9XUH2lUvul3OZKA7fjPSfKUkFTkOjQg1l9Rk8cej+OMNx2jmpj+A0+5fDmJL6Q
	 Cf55ZEms5YwyAzrEu8DBl4C2vO4emrudaGkz9IQNh1ITl8mkGDB1MkXUPiI2ZWaEgg
	 6s3cZkKjT6K8Jgqfe7DT50wxWad2XphIig1LWZXI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Douglas Anderson <dianders@chromium.org>,
	Johan Hovold <johan+linaro@kernel.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.8 076/273] Bluetooth: add quirk for broken address properties
Date: Mon,  8 Apr 2024 14:55:51 +0200
Message-ID: <20240408125311.665089217@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125309.280181634@linuxfoundation.org>
References: <20240408125309.280181634@linuxfoundation.org>
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

commit 39646f29b100566451d37abc4cc8cdd583756dfe upstream.

Some Bluetooth controllers lack persistent storage for the device
address and instead one can be provided by the boot firmware using the
'local-bd-address' devicetree property.

The Bluetooth devicetree bindings clearly states that the address should
be specified in little-endian order, but due to a long-standing bug in
the Qualcomm driver which reversed the address some boot firmware has
been providing the address in big-endian order instead.

Add a new quirk that can be set on platforms with broken firmware and
use it to reverse the address when parsing the property so that the
underlying driver bug can be fixed.

Fixes: 5c0a1001c8be ("Bluetooth: hci_qca: Add helper to set device address")
Cc: stable@vger.kernel.org      # 5.1
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/bluetooth/hci.h |    9 +++++++++
 net/bluetooth/hci_sync.c    |    5 ++++-
 2 files changed, 13 insertions(+), 1 deletion(-)

--- a/include/net/bluetooth/hci.h
+++ b/include/net/bluetooth/hci.h
@@ -176,6 +176,15 @@ enum {
 	 */
 	HCI_QUIRK_USE_BDADDR_PROPERTY,
 
+	/* When this quirk is set, the Bluetooth Device Address provided by
+	 * the 'local-bd-address' fwnode property is incorrectly specified in
+	 * big-endian order.
+	 *
+	 * This quirk can be set before hci_register_dev is called or
+	 * during the hdev->setup vendor callback.
+	 */
+	HCI_QUIRK_BDADDR_PROPERTY_BROKEN,
+
 	/* When this quirk is set, the duplicate filtering during
 	 * scanning is based on Bluetooth devices addresses. To allow
 	 * RSSI based updates, restart scanning if needed.
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -3224,7 +3224,10 @@ static void hci_dev_get_bd_addr_from_pro
 	if (ret < 0 || !bacmp(&ba, BDADDR_ANY))
 		return;
 
-	bacpy(&hdev->public_addr, &ba);
+	if (test_bit(HCI_QUIRK_BDADDR_PROPERTY_BROKEN, &hdev->quirks))
+		baswap(&hdev->public_addr, &ba);
+	else
+		bacpy(&hdev->public_addr, &ba);
 }
 
 struct hci_init_stage {


