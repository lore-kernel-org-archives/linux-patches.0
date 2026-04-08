Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64A363D4129;
	Wed,  8 Apr 2026 18:20:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775672406; cv=none; b=piWoFUB3nXaD1VP/Jbj3PljVz85g/FIQtoKl/MIpOiDDBBF54mKkWXpqeRvga4folmT+6vu0v1aIUM0gCZhopSK4H7XtxGnPmPGNzmKNZgN0Ao4WVsZIrkrUgi2RnqGzlpiU4uE42kEU4t2C4KZIsdRGI+OkAJfc5YmhmlClZQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775672406; c=relaxed/simple;
	bh=4Bw99cI7wEvXEaUoi4HWlQcw8eKulXrWXlJL2cvuDd0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N39g1hhNqgXVVwE5Bljkci08p9ByHTGHArOyzm1L1kAJPn1oHkjIEwIBUsscqBffKpkHykEzvQm6Rz5DQ7CYSNcndeorBF/2m1GVLISNAtwWtlibF7BoiyauirZCEL9E+ONovzrQ/VjM11ertsqlQiXS0GC7PDl/34ICKK81SGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tTULp3qQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tTULp3qQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4E94C19421;
	Wed,  8 Apr 2026 18:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775672406;
	bh=4Bw99cI7wEvXEaUoi4HWlQcw8eKulXrWXlJL2cvuDd0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tTULp3qQOW6a20Inw1P4hzwd9P6iTsZuDYQq6qSWrIr7BdlknliaIZk7XdIn3zsVt
	 YAm2S+d3/WquZMfYeKcOCF+pSY25WOWOOm9rt8YUMODvsrHk/AZv498qCbRpK3ZWQH
	 9iR0A/HF/7iIOY7s37ewFLbdyarKHqm6amu26p/8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org,
	"stable@vger.kernel.org, Luiz Augusto von Dentz" <luiz.von.dentz@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robert Garcia <rob_garcia@163.com>
Subject: [PATCH 6.1 308/312] Bluetooth: eir: Fix possible crashes on eir_create_adv_data
Date: Wed,  8 Apr 2026 20:03:45 +0200
Message-ID: <20260408175945.279025812@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.715315542@linuxfoundation.org>
References: <20260408175933.715315542@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit 47c03902269aff377f959dc3fd94a9733aa31d6e ]

eir_create_adv_data may attempt to add EIR_FLAGS and EIR_TX_POWER
without checking if that would fit.

Link: https://github.com/bluez/bluez/issues/1117#issuecomment-2958244066
Fixes: 01ce70b0a274 ("Bluetooth: eir: Move EIR/Adv Data functions to its own file")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
[ Use pdu.data instead of pdu->data in hci_set_ext_adv_data_sync()
 to keep context consistency. ]
Signed-off-by: Robert Garcia <rob_garcia@163.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/eir.c      |    7 ++++---
 net/bluetooth/eir.h      |    2 +-
 net/bluetooth/hci_sync.c |    5 +++--
 3 files changed, 8 insertions(+), 6 deletions(-)

--- a/net/bluetooth/eir.c
+++ b/net/bluetooth/eir.c
@@ -242,7 +242,7 @@ u8 eir_create_per_adv_data(struct hci_de
 	return ad_len;
 }
 
-u8 eir_create_adv_data(struct hci_dev *hdev, u8 instance, u8 *ptr)
+u8 eir_create_adv_data(struct hci_dev *hdev, u8 instance, u8 *ptr, u8 size)
 {
 	struct adv_info *adv = NULL;
 	u8 ad_len = 0, flags = 0;
@@ -286,7 +286,7 @@ u8 eir_create_adv_data(struct hci_dev *h
 		/* If flags would still be empty, then there is no need to
 		 * include the "Flags" AD field".
 		 */
-		if (flags) {
+		if (flags && (ad_len + eir_precalc_len(1) <= size)) {
 			ptr[0] = 0x02;
 			ptr[1] = EIR_FLAGS;
 			ptr[2] = flags;
@@ -316,7 +316,8 @@ skip_flags:
 		}
 
 		/* Provide Tx Power only if we can provide a valid value for it */
-		if (adv_tx_power != HCI_TX_POWER_INVALID) {
+		if (adv_tx_power != HCI_TX_POWER_INVALID &&
+		    (ad_len + eir_precalc_len(1) <= size)) {
 			ptr[0] = 0x02;
 			ptr[1] = EIR_TX_POWER;
 			ptr[2] = (u8)adv_tx_power;
--- a/net/bluetooth/eir.h
+++ b/net/bluetooth/eir.h
@@ -9,7 +9,7 @@
 
 void eir_create(struct hci_dev *hdev, u8 *data);
 
-u8 eir_create_adv_data(struct hci_dev *hdev, u8 instance, u8 *ptr);
+u8 eir_create_adv_data(struct hci_dev *hdev, u8 instance, u8 *ptr, u8 size);
 u8 eir_create_scan_rsp(struct hci_dev *hdev, u8 instance, u8 *ptr);
 u8 eir_create_per_adv_data(struct hci_dev *hdev, u8 instance, u8 *ptr);
 
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -1248,7 +1248,8 @@ static int hci_set_ext_adv_data_sync(str
 			return 0;
 	}
 
-	len = eir_create_adv_data(hdev, instance, pdu.data);
+	len = eir_create_adv_data(hdev, instance, pdu.data,
+				  HCI_MAX_EXT_AD_LENGTH);
 
 	pdu.cp.length = len;
 	pdu.cp.handle = instance;
@@ -1279,7 +1280,7 @@ static int hci_set_adv_data_sync(struct
 
 	memset(&cp, 0, sizeof(cp));
 
-	len = eir_create_adv_data(hdev, instance, cp.data);
+	len = eir_create_adv_data(hdev, instance, cp.data, sizeof(cp.data));
 
 	/* There's nothing to do if the data hasn't changed */
 	if (hdev->adv_data_len == len &&


