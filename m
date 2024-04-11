Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00824145B28;
	Thu, 11 Apr 2024 10:13:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830440; cv=none; b=IBIM+PI/IRtWKzv/FQSwAJkx1j1X3XTVEG+REyIFMu31LDQyGSksKvEkAWNcl9hbBt7kiG8zZWhNeMgk73zlMuO6IYQIPZeM3WdUHItlRyFs0fIGhJecUwGTWzdaGBRhFy7ISyST/f1KU3ojGflbiGkjz+YrMcazlJ/O3mKDEGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830440; c=relaxed/simple;
	bh=GZq4rqym54EtBSV+8bz2DQxfuoWQ1JV86bmH3jgYm9Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sAHlzTL/UVzMLzJ6Gba7vhO+F8SOxGHc/gzOWuy5qJOcwL11IZC2pMJUD1/atzPWRkfws7jDupeUjYoPuwwt0WerYf0MInENRdBpWkBIr73BWH89voFo6Ptp9AjwiqL+oKzG85YddZOnjATAh093ykahv9LG0z+K2RtU4+z9T+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QopCVghZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QopCVghZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D5AFC433C7;
	Thu, 11 Apr 2024 10:13:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830439;
	bh=GZq4rqym54EtBSV+8bz2DQxfuoWQ1JV86bmH3jgYm9Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QopCVghZMojqyRkzAdHHG12DTMr33pvP5uT42P5e1REYfqWBRB7gb3YVzCVAXlMeh
	 chp5WzxojymKYWAh8M+JXCW+v6ZS0jFFSIZpk2gYSsuA8zXp04VWHYCd4H6GSP5OPE
	 BN+eud/1iOwRTD4ErO9NkqskOjUHR8v94MiR589M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.8 139/143] Bluetooth: btintel: Fixe build regression
Date: Thu, 11 Apr 2024 11:56:47 +0200
Message-ID: <20240411095425.083974307@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095420.903937140@linuxfoundation.org>
References: <20240411095420.903937140@linuxfoundation.org>
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

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

commit 6e62ebfb49eb65bdcbfc5797db55e0ce7f79c3dd upstream.

This fixes the following build regression:

drivers-bluetooth-btintel.c-btintel_read_version()-warn:
passing-zero-to-PTR_ERR

Fixes: b79e04091010 ("Bluetooth: btintel: Fix null ptr deref in btintel_read_version")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bluetooth/btintel.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/bluetooth/btintel.c
+++ b/drivers/bluetooth/btintel.c
@@ -435,13 +435,13 @@ int btintel_read_version(struct hci_dev
 	struct sk_buff *skb;
 
 	skb = __hci_cmd_sync(hdev, 0xfc05, 0, NULL, HCI_CMD_TIMEOUT);
-	if (IS_ERR_OR_NULL(skb)) {
+	if (IS_ERR(skb)) {
 		bt_dev_err(hdev, "Reading Intel version information failed (%ld)",
 			   PTR_ERR(skb));
 		return PTR_ERR(skb);
 	}
 
-	if (skb->len != sizeof(*ver)) {
+	if (!skb || skb->len != sizeof(*ver)) {
 		bt_dev_err(hdev, "Intel version event size mismatch");
 		kfree_skb(skb);
 		return -EILSEQ;


