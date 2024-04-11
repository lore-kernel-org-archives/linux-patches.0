Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E4A2147C77;
	Thu, 11 Apr 2024 10:30:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712831430; cv=none; b=e3+5OCJcS47HK8Gzf407tG1Qu/ZYenJdMCdQyO5UDNMwHMzHLWSDWy4MXLjKHKbyMLdy8XFb7jOD75oor6LaNr6HpWHKqL63MKL3pfGalX62b9+VYODxroy0hOiSo8TD7HedFmfwWCoFTjqzJJSgFyMJxTSdSCiQGL/obtvuC/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712831430; c=relaxed/simple;
	bh=441TlOwP+2Eb9xQ6Quhqo3bdeZMmYfi2av9gJgqy8MI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aKP3xuP6SzmIclrAtoiOtg165eZl/DqX4sY+09YLqgyuUWz3RgVIIokhZ3qE7ZWP6ExlS1TiLv/ORxmOM7eE1WdyLs2sWQLJVzc11kdU2OX9FGnLi4bxc7ooib2AojzNjCSEWYFI58MxNjPfDqsMgBTakjmjfkQMbPWTWJbqkNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y0hGIYDj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y0hGIYDj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E56E2C43399;
	Thu, 11 Apr 2024 10:30:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712831430;
	bh=441TlOwP+2Eb9xQ6Quhqo3bdeZMmYfi2av9gJgqy8MI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y0hGIYDj+NHkHbjuGxAJUcOfoyRxn7xAJNe8oEVXcqJe1LOAaB/2bOA/2kntQvFoV
	 ouQDU7FyjuTEN8D+XnNu6ANa/ebjiN97DwEwtTZHLbqmVMI5Xu5Bar3hUAJfxAncd1
	 2jwheSkf3cnlkZJnK4f43TokcYJVjeStvbJRVW4U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.6 111/114] Bluetooth: btintel: Fixe build regression
Date: Thu, 11 Apr 2024 11:57:18 +0200
Message-ID: <20240411095420.243128633@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095416.853744210@linuxfoundation.org>
References: <20240411095416.853744210@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


