Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D366281357;
	Wed, 23 Apr 2025 14:49:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745419766; cv=none; b=W/R8KtYxsyAOo6Mu2eN3r9A1mFRL5zdGsg0JoACwc5wzr+8PnmUfr58sU2ZyFOOxe84fiISSuRglP5Yp9GnMhamaye0iLbaxv/ysk5mG90HUO7bDkahR1LfcWgFtzGb33weXaG0sbjLzf6smWrSopb89s9OZUG3gtn0BCxms3kA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745419766; c=relaxed/simple;
	bh=J2RbSB0LfpZ/uP8o71SMzyQgpHP7MvZKwotVqIA2vgk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LQMjD3a5do1MFnNqe6913c+/9mU+yn83XB0HlLs6ro3imGNCkn9w0XkC3i/F3+A/aYgOYjVXyjEU46r7oeH9V25cI8VmU6Opq6gPzP+Iurj6zPK/R7GD0eGwIAzNciSSNGfuWffaoC8NM3ebA8Q47iXmzswg8Z5p2l2M3y9bJUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yLzJVEa1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yLzJVEa1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0487C4CEE2;
	Wed, 23 Apr 2025 14:49:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745419766;
	bh=J2RbSB0LfpZ/uP8o71SMzyQgpHP7MvZKwotVqIA2vgk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yLzJVEa1/vEPZeMUSAy8BYjWsDz16POUoT2d/9YH+AyE0WQcUDVB4Q3p5n8ABF6cA
	 NaXLUBaQQNUolUfQbpfM0JEL5SQP0/f5QVV+4iF3uiap+yJuqBT3wEvwNGRGIYEm7k
	 Sl28zNfNOpXIoIJnUfQRBXy959qdsje07PEEn/xs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 023/241] Bluetooth: hci_event: Fix sending MGMT_EV_DEVICE_FOUND for invalid address
Date: Wed, 23 Apr 2025 16:41:27 +0200
Message-ID: <20250423142621.466542907@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142620.525425242@linuxfoundation.org>
References: <20250423142620.525425242@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index e2bfbcee06a80..20d3cdcb14f6c 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -6153,11 +6153,12 @@ static void process_adv_report(struct hci_dev *hdev, u8 type, bdaddr_t *bdaddr,
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



