Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F07C283C81;
	Wed, 23 Apr 2025 15:31:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745422270; cv=none; b=CSS9h40eN3iXN6S+eSYDON83je1mnyTQA8vJfVyouR5rZDPeXm4q3bnVz7lj2xL3xWSushVhFpr5FOj//f+wLvuFAPcWKhIhl7AuEhsN0PkJQdRjxlxmZPofuLYwKJ0TWk+Ws4H5yrOUwCcW+KEi1+th7QJ5GR08mMAFTDE5dhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745422270; c=relaxed/simple;
	bh=s+VlBeonnlrfrhrR83GXZ4Q244BSPZAInk+nvvto/Bo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SChO9jECJOAyNqlwiBgPpMkhM4uxyzcuPKQ7dIH07T6qKG5hkqTmIsubgtEcZyfkNO8HktxrZVTMLSzIOrhiJbS2m7st7NBebIqHOVyEb/IAEVlXTixKp0ONWGfGJyAQNyQfPhpB92CTWUCnLNQwBW5e7la0RJrcmW3vcUq2/SE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qkc2V4vF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qkc2V4vF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3BC1C4CEE2;
	Wed, 23 Apr 2025 15:31:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745422270;
	bh=s+VlBeonnlrfrhrR83GXZ4Q244BSPZAInk+nvvto/Bo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qkc2V4vF0MWnHQd0+PYGKI9jmELXwYl9+tqfs+EktVpdzNQ3s4KVP1GCe74k7Sg8t
	 2TxyCEgfpvZQ1UdrGSUe5xBoxPhjGQTBqraT7ZqvPa8jYI+hZi8sUMxnukjlw5Ghr4
	 qz8J6W4KOwDa/R5reQu7WW6PsduYFRJbsUeHGpNA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Kees Cook <kees@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.6 311/393] Bluetooth: vhci: Avoid needless snprintf() calls
Date: Wed, 23 Apr 2025 16:43:27 +0200
Message-ID: <20250423142656.173322289@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kees Cook <kees@kernel.org>

commit 875db86e1ec75fe633f1e85ed2f92c731cdbf760 upstream.

Avoid double-copying of string literals. Use a "const char *" for each
string instead of copying from .rodata into stack and then into the skb.
We can go directly from .rodata to the skb.

This also works around a Clang bug (that has since been fixed[1]).

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202401250927.1poZERd6-lkp@intel.com/
Fixes: ab4e4380d4e1 ("Bluetooth: Add vhci devcoredump support")
Link: https://github.com/llvm/llvm-project/commit/ea2e66aa8b6e363b89df66dc44275a0d7ecd70ce [1]
Cc: stable@vger.kernel.org
Signed-off-by: Kees Cook <kees@kernel.org>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bluetooth/hci_vhci.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/bluetooth/hci_vhci.c
+++ b/drivers/bluetooth/hci_vhci.c
@@ -289,18 +289,18 @@ static void vhci_coredump(struct hci_dev
 
 static void vhci_coredump_hdr(struct hci_dev *hdev, struct sk_buff *skb)
 {
-	char buf[80];
+	const char *buf;
 
-	snprintf(buf, sizeof(buf), "Controller Name: vhci_ctrl\n");
+	buf = "Controller Name: vhci_ctrl\n";
 	skb_put_data(skb, buf, strlen(buf));
 
-	snprintf(buf, sizeof(buf), "Firmware Version: vhci_fw\n");
+	buf = "Firmware Version: vhci_fw\n";
 	skb_put_data(skb, buf, strlen(buf));
 
-	snprintf(buf, sizeof(buf), "Driver: vhci_drv\n");
+	buf = "Driver: vhci_drv\n";
 	skb_put_data(skb, buf, strlen(buf));
 
-	snprintf(buf, sizeof(buf), "Vendor: vhci\n");
+	buf = "Vendor: vhci\n";
 	skb_put_data(skb, buf, strlen(buf));
 }
 


