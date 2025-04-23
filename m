Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C324B281507;
	Wed, 23 Apr 2025 14:56:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420189; cv=none; b=UFPxatsCfN3Wfn+gKeY63sSvMvo3+VqMBQ7ORuGVqlMrjP2FPaqrnY2aKmHSjNAotW5pJkONfVbMsuDo5MRanPpBJcO5P7d7/EeLjCZ2GlbHPE+mb3pNvsqvB1Cfy3zUPuJ0k0x6vX09dU+LcNW+erJiSC0FyWw1iPiQfuQKVyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420189; c=relaxed/simple;
	bh=vqPniA4RwBrC5u4M5W53TEEAIEszP/pophXU8zyqjRA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=StMRpB3LYPgh3r5ZCqiqvt33o7jy5wPThXpN1I4/YSOqyd2pf6svCN1CtJQ5oz4kD71wN6vMjUBwVwfQkdJwv37SqB/sM9dr5UrrZJvMGpNRSxG5kvGBJsExWGkX5D7I+KsE4Nx9aFx4I+SkYVAfb5Xzv/bR1OE467iKOqCWxJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BoDLZilT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BoDLZilT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CD69C4CEE2;
	Wed, 23 Apr 2025 14:56:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420189;
	bh=vqPniA4RwBrC5u4M5W53TEEAIEszP/pophXU8zyqjRA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BoDLZilTAU2nE+HW4b7w0BPSxBDrOiGes/QFBMii9cbdpeErwiT4VArbp4ZO8c9tA
	 E6p7pyOlpbzB82J48fgJ287/DY5wdw/R6qrGxSSeDA3yAOcvkfEuwHmbZkKPhF3pZf
	 uVBQ6Ou3aprqN+yN+FslhJp177jvcU8IoyyxrhUk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Kees Cook <kees@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.12 107/223] Bluetooth: vhci: Avoid needless snprintf() calls
Date: Wed, 23 Apr 2025 16:42:59 +0200
Message-ID: <20250423142621.470973616@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142617.120834124@linuxfoundation.org>
References: <20250423142617.120834124@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 


