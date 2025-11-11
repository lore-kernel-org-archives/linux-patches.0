Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DCAC298CDE;
	Tue, 11 Nov 2025 01:45:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825555; cv=none; b=SL3X+RE1diR0rWP+A6qGINYmAir7i8BaZ6kLpi4UAVoO3rKjQeWtfRhJubAicX/YBispkGae2u6whUPZWs2apbYdw1nYLXzGvw41YXYHFI1VG91SF8N3ao0sx4+Jsdnx2xmnLWztnMVbY/kGhfZV23yE+eoOF9t/d7VLaQI8++k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825555; c=relaxed/simple;
	bh=Sh4hyQBcmIyGsCnVZRsWJXcAILxxntlZyllwpR4CyLI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=keM4xyUYM/Gb1ajJWflpU6sADdj3klyn6SAVHIqkpD8iU8UlULKnw1PsgpcGo01krOD70ZzKUhWPFJhXDhMHi3LMou2MmfJWZZt6nK4w/JdcVWkBabHzlmWoDaMoo6HSBolA3FUHczU1exmZpJXBLsnj+xZKSbJxUE0pTLSA7Hs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZZ6ArYXP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZZ6ArYXP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AD8EC4CEFB;
	Tue, 11 Nov 2025 01:45:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825554;
	bh=Sh4hyQBcmIyGsCnVZRsWJXcAILxxntlZyllwpR4CyLI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZZ6ArYXPDFcx1MV9yerfdwlBSopUFStGts13xA4xAsxBpujOagrllZEvdLE7HC6QM
	 ReclI+0Nd9hM274JBBdKDr+4vq4krYPABsR+4NZ+ONKu4tdlWHmawI13NjMo9uUOrW
	 jFYKHQUQzr19TaIoF2RdfBwBFzvXXfpVlkjGIzp4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilia Gavrilov <Ilia.Gavrilov@infotecs.ru>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.17 809/849] Bluetooth: MGMT: Fix OOB access in parse_adv_monitor_pattern()
Date: Tue, 11 Nov 2025 09:46:19 +0900
Message-ID: <20251111004555.985044226@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilia Gavrilov <Ilia.Gavrilov@infotecs.ru>

commit 8d59fba49362c65332395789fd82771f1028d87e upstream.

In the parse_adv_monitor_pattern() function, the value of
the 'length' variable is currently limited to HCI_MAX_EXT_AD_LENGTH(251).
The size of the 'value' array in the mgmt_adv_pattern structure is 31.
If the value of 'pattern[i].length' is set in the user space
and exceeds 31, the 'patterns[i].value' array can be accessed
out of bound when copied.

Increasing the size of the 'value' array in
the 'mgmt_adv_pattern' structure will break the userspace.
Considering this, and to avoid OOB access revert the limits for 'offset'
and 'length' back to the value of HCI_MAX_AD_LENGTH.

Found by InfoTeCS on behalf of Linux Verification Center
(linuxtesting.org) with SVACE.

Fixes: db08722fc7d4 ("Bluetooth: hci_core: Fix missing instances using HCI_MAX_AD_LENGTH")
Cc: stable@vger.kernel.org
Signed-off-by: Ilia Gavrilov <Ilia.Gavrilov@infotecs.ru>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/bluetooth/mgmt.h |    2 +-
 net/bluetooth/mgmt.c         |    6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

--- a/include/net/bluetooth/mgmt.h
+++ b/include/net/bluetooth/mgmt.h
@@ -775,7 +775,7 @@ struct mgmt_adv_pattern {
 	__u8 ad_type;
 	__u8 offset;
 	__u8 length;
-	__u8 value[31];
+	__u8 value[HCI_MAX_AD_LENGTH];
 } __packed;
 
 #define MGMT_OP_ADD_ADV_PATTERNS_MONITOR	0x0052
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -5395,9 +5395,9 @@ static u8 parse_adv_monitor_pattern(stru
 	for (i = 0; i < pattern_count; i++) {
 		offset = patterns[i].offset;
 		length = patterns[i].length;
-		if (offset >= HCI_MAX_EXT_AD_LENGTH ||
-		    length > HCI_MAX_EXT_AD_LENGTH ||
-		    (offset + length) > HCI_MAX_EXT_AD_LENGTH)
+		if (offset >= HCI_MAX_AD_LENGTH ||
+		    length > HCI_MAX_AD_LENGTH ||
+		    (offset + length) > HCI_MAX_AD_LENGTH)
 			return MGMT_STATUS_INVALID_PARAMS;
 
 		p = kmalloc(sizeof(*p), GFP_KERNEL);


