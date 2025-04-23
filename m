Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6E75298CC0;
	Wed, 23 Apr 2025 15:22:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421765; cv=none; b=VF8j8Q2TL29wBUSBUmeXHJFvN/jO8AFFXqCwjij63mo2JKAY687x609Zy2Xu2OZjohoNNuKk9eu09yvAccsfRcUmEh1DH7wHeDqnoJ7PsXMuKx6/w8RwXuMCKqjQHgkhdfCC+yCIVO4N/GC0VPdtk3xsWYnc0mChvrIsOEfgJb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421765; c=relaxed/simple;
	bh=4lujKTjKb9iO54phXhr04nqR/msjYvcLF7VMxTub53s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g35nzxScEn8XZ1DP0PO21etswdfNXbfCToQ9z8YM5GhnV0dSL+YPHE4mUjSKroVlGU1EUJTQevMWAfg4UMJS6uN6rus48aR1eHSEd8t5GPjmdsBh0+pJ0ovGv+XfJaiE0Ix+3pQcPsVSi/tlqebKAXjqei55zJsQhSiq6g5hxF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k+u4BNzc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k+u4BNzc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67571C4CEE2;
	Wed, 23 Apr 2025 15:22:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421765;
	bh=4lujKTjKb9iO54phXhr04nqR/msjYvcLF7VMxTub53s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k+u4BNzcBS2+Kx4tP6Gmw6RzYggOPKZiZx2yl7wdM8YnSHny4EOCBs40VL9L+Xpyt
	 IKYsgFcxA3ha0J2eX9IPOk6Yi/xwwpITx4uAQ7DYt0bkU3msg2m3BX62EcXhxf1RQY
	 EXlNlJgrsOCW6Dbb/2F8YsZ4nFeHGgvFxOjGxxOA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 176/291] Bluetooth: hci_event: Fix sending MGMT_EV_DEVICE_FOUND for invalid address
Date: Wed, 23 Apr 2025 16:42:45 +0200
Message-ID: <20250423142631.575003073@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142624.409452181@linuxfoundation.org>
References: <20250423142624.409452181@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit eb73b5a9157221f405b4fe32751da84ee46b7a25 ]

This fixes sending MGMT_EV_DEVICE_FOUND for invalid address
(00:00:00:00:00:00) which is a regression introduced by
a2ec905d1e16 ("Bluetooth: fix kernel oops in store_pending_adv_report")
since in the attempt to skip storing data for extended advertisement it
actually made the code to skip the entire if statement supposed to send
MGMT_EV_DEVICE_FOUND without attempting to use the last_addr_adv which
is garanteed to be invalid for extended advertisement since we never
store anything on it.

Link: https://github.com/bluez/bluez/issues/1157
Link: https://github.com/bluez/bluez/issues/1149#issuecomment-2767215658
Fixes: a2ec905d1e16 ("Bluetooth: fix kernel oops in store_pending_adv_report")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_event.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 6cfd61628cd78..8667723d4e969 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -6248,11 +6248,12 @@ static void process_adv_report(struct hci_dev *hdev, u8 type, bdaddr_t *bdaddr,
 	 * event or send an immediate device found event if the data
 	 * should not be stored for later.
 	 */
-	if (!ext_adv &&	!has_pending_adv_report(hdev)) {
+	if (!has_pending_adv_report(hdev)) {
 		/* If the report will trigger a SCAN_REQ store it for
 		 * later merging.
 		 */
-		if (type == LE_ADV_IND || type == LE_ADV_SCAN_IND) {
+		if (!ext_adv && (type == LE_ADV_IND ||
+				 type == LE_ADV_SCAN_IND)) {
 			store_pending_adv_report(hdev, bdaddr, bdaddr_type,
 						 rssi, flags, data, len);
 			return;
-- 
2.39.5



