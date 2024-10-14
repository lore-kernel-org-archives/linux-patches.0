Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35AE015D5C5;
	Mon, 14 Oct 2024 15:23:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919433; cv=none; b=joDALT9YN36AYvEe/rfhe4sml31F2BTZ+/tA3xCEdi1Z0TGaxwjZK+r8hUhCPKFPxuCdwfLokBdx1hFlMCBEj5FF/3UliTLhcReLziGg4rYp1Yv0hM/xYDE2PVlb0muYao+vqMH/DWOkTmIxO90gXVaJ8AXe/YRUG9RSCwGlYSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919433; c=relaxed/simple;
	bh=VRMnyVQQuKg4u0hkUVe1uuLmttL43SlnURJdILL/EBo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kyET9fz7rpFkPdSlKhBYjdU9WAYGBh4eAzMMI6Xo4FTP382QbxM368IokEM7o9HtcU8PwBe+mC/L9U/ko/1hm9Pn5NNS6xtRWyQKSoVsxVDDRrpsrGeSoHt7vKlpk4oF1uFMaQLI7NyM0pKPnHHHA6PJsCwshtiNCXA2037KtvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oK/dPzme; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oK/dPzme"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A0D2C4CEC3;
	Mon, 14 Oct 2024 15:23:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919433;
	bh=VRMnyVQQuKg4u0hkUVe1uuLmttL43SlnURJdILL/EBo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oK/dPzmekqPHz1K1nf/Iu9Y2E7NYbm64c7s2DRJkPKt365TwLSjuj4BhFthJVWWCT
	 WyHZPa/ycdNb3atgQY/3OAXgWPauICu8KUHphYj7qM5Y2JY32xKwzzS4d72ciEe0e5
	 cL9k1HMGqaamtzIC/jwV+mgsVVG7UN3zMEVbMhqk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Kiran K <kiran.k@intel.com>
Subject: [PATCH 6.1 608/798] Bluetooth: hci_event: Align BR/EDR JUST_WORKS paring with LE
Date: Mon, 14 Oct 2024 16:19:22 +0200
Message-ID: <20241014141241.906193535@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

commit b25e11f978b63cb7857890edb3a698599cddb10e upstream.

This aligned BR/EDR JUST_WORKS method with LE which since 92516cd97fd4
("Bluetooth: Always request for user confirmation for Just Works")
always request user confirmation with confirm_hint set since the
likes of bluetoothd have dedicated policy around JUST_WORKS method
(e.g. main.conf:JustWorksRepairing).

CVE: CVE-2024-8805
Cc: stable@vger.kernel.org
Fixes: ba15a58b179e ("Bluetooth: Fix SSP acceptor just-works confirmation without MITM")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Tested-by: Kiran K <kiran.k@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/hci_event.c |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -5422,19 +5422,16 @@ static void hci_user_confirm_request_evt
 		goto unlock;
 	}
 
-	/* If no side requires MITM protection; auto-accept */
+	/* If no side requires MITM protection; use JUST_CFM method */
 	if ((!loc_mitm || conn->remote_cap == HCI_IO_NO_INPUT_OUTPUT) &&
 	    (!rem_mitm || conn->io_capability == HCI_IO_NO_INPUT_OUTPUT)) {
 
-		/* If we're not the initiators request authorization to
-		 * proceed from user space (mgmt_user_confirm with
-		 * confirm_hint set to 1). The exception is if neither
-		 * side had MITM or if the local IO capability is
-		 * NoInputNoOutput, in which case we do auto-accept
+		/* If we're not the initiator of request authorization and the
+		 * local IO capability is not NoInputNoOutput, use JUST_WORKS
+		 * method (mgmt_user_confirm with confirm_hint set to 1).
 		 */
 		if (!test_bit(HCI_CONN_AUTH_PEND, &conn->flags) &&
-		    conn->io_capability != HCI_IO_NO_INPUT_OUTPUT &&
-		    (loc_mitm || rem_mitm)) {
+		    conn->io_capability != HCI_IO_NO_INPUT_OUTPUT) {
 			bt_dev_dbg(hdev, "Confirming auto-accept as acceptor");
 			confirm_hint = 1;
 			goto confirm;


