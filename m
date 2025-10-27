Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55AC927FD62;
	Mon, 27 Oct 2025 19:23:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592999; cv=none; b=GcMLgMihHXuOX4USc5QaHK81vK5CSsOud3W4hGYMUI4/PS2R+vnYk1Rc/tcAuxaCjse+lj8n6/Fhk1XapqJYmEdTDouHZAvQGk60niuJS+GyhHiOEQOVm8TFS9L6tuk6ICITyHBiN5+d6ak1OAbNbVpdzCpUZDzWyaySXh91JRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592999; c=relaxed/simple;
	bh=efV2isxBffESxRyiJAP3FMGnhHIf4ks4vDMLPsaYuyk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KQL0B6ve4OPNGW1iZnWP0Tuj4FVHVHMHba78OlQJVXVPi5bnbdgJIO7LFh1xAqXQJrUBVu3I6g1sluZQJjs6pyGyhxGP0Kf9zenrld/UsF9aUnUSKk2nmxn9gLGof316ccU37aQgYLfwCKH9g5I8lXNJx47t6+qIsQAexXQpwFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P3wtiwZL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P3wtiwZL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDC3EC4CEF1;
	Mon, 27 Oct 2025 19:23:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592999;
	bh=efV2isxBffESxRyiJAP3FMGnhHIf4ks4vDMLPsaYuyk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P3wtiwZLX2Al6iz+V8zq+odG9MzxjsQ5zR6VzSjiNDlSzHQigquzFRaGp0LRduEDM
	 Yqc+zS9E4RkM8vYiaiwDsmN/M7232Q0mzfF58TXpfUW0psm/OOKIyYRBVzHvynkkOy
	 gJyCfituU2qkya/hicGEJRT5a+8/D8FFfGSYffXo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kiran K <kiran.k@intel.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Salvatore Bonaccorso <carnil@debian.org>,
	Guido Berhoerster <guido+debian@berhoerster.name>
Subject: [PATCH 6.12 092/117] Bluetooth: btintel: Add DSBR support for BlazarIW, BlazarU and GaP
Date: Mon, 27 Oct 2025 19:36:58 +0100
Message-ID: <20251027183456.508886839@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183453.919157109@linuxfoundation.org>
References: <20251027183453.919157109@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kiran K <kiran.k@intel.com>

commit d88a8bb8bbbec9d57b84232a2d6f8dab84221959 upstream.

Add DSBR support for BlazarIW, BlazarU and Gale Peak2 cores.

Refer commit eb9e749c0182 ("Bluetooth: btintel: Allow configuring drive
strength of BRI") for details about DSBR.

Signed-off-by: Kiran K <kiran.k@intel.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Cc: Salvatore Bonaccorso <carnil@debian.org>
Cc: Guido Berhoerster <guido+debian@berhoerster.name>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bluetooth/btintel.c |   28 ++++++++++++++++++++--------
 drivers/bluetooth/btintel.h |    3 +++
 2 files changed, 23 insertions(+), 8 deletions(-)

--- a/drivers/bluetooth/btintel.c
+++ b/drivers/bluetooth/btintel.c
@@ -2734,20 +2734,32 @@ static int btintel_set_dsbr(struct hci_d
 
 	struct btintel_dsbr_cmd cmd;
 	struct sk_buff *skb;
+	u32 dsbr, cnvi;
 	u8 status;
-	u32 dsbr;
-	bool apply_dsbr;
 	int err;
 
-	/* DSBR command needs to be sent for BlazarI + B0 step product after
-	 * downloading IML image.
+	cnvi = ver->cnvi_top & 0xfff;
+	/* DSBR command needs to be sent for,
+	 * 1. BlazarI or BlazarIW + B0 step product in IML image.
+	 * 2. Gale Peak2 or BlazarU in OP image.
 	 */
-	apply_dsbr = (ver->img_type == BTINTEL_IMG_IML &&
-		((ver->cnvi_top & 0xfff) == BTINTEL_CNVI_BLAZARI) &&
-		INTEL_CNVX_TOP_STEP(ver->cnvi_top) == 0x01);
 
-	if (!apply_dsbr)
+	switch (cnvi) {
+	case BTINTEL_CNVI_BLAZARI:
+	case BTINTEL_CNVI_BLAZARIW:
+		if (ver->img_type == BTINTEL_IMG_IML &&
+		    INTEL_CNVX_TOP_STEP(ver->cnvi_top) == 0x01)
+			break;
 		return 0;
+	case BTINTEL_CNVI_GAP:
+	case BTINTEL_CNVI_BLAZARU:
+		if (ver->img_type == BTINTEL_IMG_OP &&
+		    hdev->bus == HCI_USB)
+			break;
+		return 0;
+	default:
+		return 0;
+	}
 
 	dsbr = 0;
 	err = btintel_uefi_get_dsbr(&dsbr);
--- a/drivers/bluetooth/btintel.h
+++ b/drivers/bluetooth/btintel.h
@@ -53,6 +53,9 @@ struct intel_tlv {
 } __packed;
 
 #define BTINTEL_CNVI_BLAZARI		0x900
+#define BTINTEL_CNVI_BLAZARIW		0x901
+#define BTINTEL_CNVI_GAP		0x910
+#define BTINTEL_CNVI_BLAZARU		0x930
 
 #define BTINTEL_IMG_BOOTLOADER		0x01	/* Bootloader image */
 #define BTINTEL_IMG_IML			0x02	/* Intermediate image */


