Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D7F7293B56;
	Wed, 23 Apr 2025 15:07:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420835; cv=none; b=O1vDKCJcBhltMr7o4GDiHZIghtJQSipwqFQgewllHsJv+JoUSrPRTB60u9/7nBC4tT1/m3HwRsylNcOn5xtdeAQXuiUZXVGj5iRfVVMlIiWglCP5lncA7HWjHhESNHV+qCmchthq7Gmqr06o4HKNWmwalJaA5I8ifbRHjy11kWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420835; c=relaxed/simple;
	bh=JjCV5CDo1B1PAc1LYJYaSXXLKLU9ichSN3WupyTSvjg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EXtois169jtopgSmG3v1yqCSsY1HfkdaXZMqjhANMFjCjIN3pFmeaz+XV0HpnM2cmOwa0bLWVh5Ur3bvRRUeU+5z96B9iXkX+miXU2tbgAO1AwGljTuk9Mcj6ppDXCxaxs7w6y2pN6TlcqhedReURSSOwt8rZ8IZfVPpUuBOYa0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aufDaAvB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aufDaAvB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5CB3C4CEE3;
	Wed, 23 Apr 2025 15:07:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420835;
	bh=JjCV5CDo1B1PAc1LYJYaSXXLKLU9ichSN3WupyTSvjg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aufDaAvBNs0KUQBDY9slb7YZAxBPbtB5o+NO9tzGQpcXH0RtOm2rVbfYZ08lGAWWo
	 K+x++BPO+mvKqS+XxMyxayijzEeS9EFYK4IG5u4HphTqzAOGcUebI+3ENclKKFvX0z
	 2BkBJbBugXEzwAJe/U8sWyC2w+Tk3KmSuv011CAY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Kees Cook <kees@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.14 126/241] Bluetooth: vhci: Avoid needless snprintf() calls
Date: Wed, 23 Apr 2025 16:43:10 +0200
Message-ID: <20250423142625.717732865@linuxfoundation.org>
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
 


