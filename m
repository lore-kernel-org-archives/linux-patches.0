Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 704C22EAE5;
	Thu, 11 Apr 2024 10:52:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712832729; cv=none; b=q+JC0NZ1A5puhs+hlTZNel0wZvq5D9tERVo/2zu+jLeURNzJpYyL3D0xYgfNvYOC5K3Yqn1zX70xJ/Adr516P1xs4XAdYd1nRdWWEL+bvvCINPhlbUDYSl16vcxYdkdK/z3Pm2YJGmcbMZBup+oaKz0Yf1C3Mp+NPHVnCh+IWH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712832729; c=relaxed/simple;
	bh=B7ogOxla0UhrcmBEIFXnMPeMuaO4OTkFqP3SLZSl+X4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b/mk2vpVXLxO3+7mGMok8qAbW9TA1mSJoRIZw3BdhKj1nEqAsbXN1uPKFOgAa2QvkdPkBGderHW4ZO7sVs12Tt/XNi5aeCCxFDajFn7kFsP54EHBVnDaR3SxgxuFAfRVBl2g4NPWjA5uLSohD9qUw5jYOJgADTxiSwxuGPMTfu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tn17eIGx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tn17eIGx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA799C433C7;
	Thu, 11 Apr 2024 10:52:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712832729;
	bh=B7ogOxla0UhrcmBEIFXnMPeMuaO4OTkFqP3SLZSl+X4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tn17eIGxljdTd54hnv1ZHklVz1NmjxmIHk8yXSp7yvdkW9UpKvGfRs++qhA/1Xv7Y
	 P39+FPBmohJa0HRm2n8IoLakFg5gF4EpUZEHxFqzS4xy5WE3dirRvTCWJtAr2RAfTd
	 AQUmQsccvY53HnQyEBl2BvBhMpCJa3hb2YS+M3yk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 5.15 56/57] Bluetooth: btintel: Fixe build regression
Date: Thu, 11 Apr 2024 11:58:04 +0200
Message-ID: <20240411095409.683518103@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095407.982258070@linuxfoundation.org>
References: <20240411095407.982258070@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -405,13 +405,13 @@ int btintel_read_version(struct hci_dev
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


