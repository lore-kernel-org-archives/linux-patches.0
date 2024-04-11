Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 142CB6BB29;
	Thu, 11 Apr 2024 10:44:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712832278; cv=none; b=RjWQBtNiHEncGTf584qm/NTnOnzE6ZfAE3EYEzrVx5qsUNZPQd7pab1LTv8CNhdk4M2tEtxSnUfVujWk0bP6roL3ny2B1W0+fK/8EA6CBXLkM7JMbrZSuuJJOhAKLoeHLVT9thMz681yvw6p/ODctGY0k9f4rbhNPCBgrh5HT7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712832278; c=relaxed/simple;
	bh=gcSPnO4nKHSi2UEz5P4xswuvLmXg+YMonLBm46ZooEo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xv/UQh1dAuidY5DjyEZQPjiysScSoQbc6Fr28FZF3sgs3tCSBpgvB4r2+H7/c7PvTyioEvE2ufB4C7Vk6uB7j+zKJkl2OY1SyINHEi/uyV+hWjkE9f7USO8MANe4A/2ixK5RXyD3KJ8cLk0eObI85NgRt26GgaPpiAc/Sfup7+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ee5A9Rtt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ee5A9Rtt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89D00C433C7;
	Thu, 11 Apr 2024 10:44:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712832277;
	bh=gcSPnO4nKHSi2UEz5P4xswuvLmXg+YMonLBm46ZooEo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ee5A9RttvAk8KkYHYDoDBPqY/38SLo8VfzdT0M8kCHkRICUuwHcLF20SGrhU6pHuY
	 Y+E/w2atsIE3b/uWhmLpdNkAEfC5YLLTeBS7q3c1XMnNzHq2ksnpn0hIA22FK8/4ul
	 4CcVeNK8PxpmLlfm5Fejgqbl0xjfJIRUDpapbeJY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 5.10 289/294] Bluetooth: btintel: Fixe build regression
Date: Thu, 11 Apr 2024 11:57:32 +0200
Message-ID: <20240411095444.233823629@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095435.633465671@linuxfoundation.org>
References: <20240411095435.633465671@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -344,13 +344,13 @@ int btintel_read_version(struct hci_dev
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


