Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E686F13CF82;
	Sat, 12 Sep 2026 08:44:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789202663; cv=none; b=kZpbs1KvsL7aUn6xzS9GG2s+5j0WVBCQoII3//S598F7NbKLqckdOE3Sd9FFOkedJ1aWgr/cyCekb09L4tauOYqcHiAop7fcjAGy+Kg40PkNt5zv5VowFJ1mXONI5gLy2jNpfzpI4lxDa6SovYaHMsg5MIUWPgqotkhHpg/ns8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789202663; c=relaxed/simple;
	bh=9dSbg0JzMcoSjHpmzZue/X76ZZXtwaVP8eD6YB6zl4U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rC5fCjCgf4c8kb57YQ/9erWD5ps0GK4Mz8ggXGWhVDGmxovxL4ZHz6dLKnnoeOMxzCuwxrbdsncMG1sg+k2TIHlDsmHasunPJCDy4pL8xLZQTJAiMgUTDGGKuc1D4mOZw1gQj/4iLuBU5sX7KgLPUZpUk+uFXFEEBW1fASLCOUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sUwArn6m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sUwArn6m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 295311F000FF;
	Sat, 12 Sep 2026 08:44:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789202661;
	bh=ZyDAR1kAYa9CEcCtYQvlD1QIW8Av0ZXL0+pLUzlybVs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sUwArn6m0QjFptxr0twkQbKK9Wczcq6qstCq4Wo3EfZrMlwzTMIgGlF1yRCmv3LXL
	 4DyewNuMmYRGVUHlLzTMwAovY7b9laluS/n3gXjjhwnMaoXS5gLAcdOzWPwn8q/1na
	 bwg410B5rIvG+YAVqw648NU1ff6OX+RCWyHtzpFQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <zijun.hu@oss.qualcomm.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1250/1815] Bluetooth: btintel: Fix diagnostics event detection
Date: Sat, 12 Sep 2026 08:50:00 +0200
Message-ID: <20260912065718.358570967@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zijun Hu <zijun.hu@oss.qualcomm.com>

[ Upstream commit ad0e7ac7da9a9a0095570bd6add3e27f259de104 ]

For a diagnostics VSE, diagnostics_hdr[] sits at the start of the event
payload, skb->data[2], but btintel_recv_event() wrongly guards its
memcmp with @len, which is measured from skb->data[3] for the earlier
INTEL_BOOTLOADER check.

Fix by using (@len + 1) instead, which ==
(skb->len - HCI_EVENT_HDR_SIZE) exactly.

Fixes: af395330abed ("Bluetooth: btintel: Add Intel devcoredump support")
Signed-off-by: Zijun Hu <zijun.hu@oss.qualcomm.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btintel.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/bluetooth/btintel.c b/drivers/bluetooth/btintel.c
index bf567b7c5f00b..cc2234470960a 100644
--- a/drivers/bluetooth/btintel.c
+++ b/drivers/bluetooth/btintel.c
@@ -3834,7 +3834,7 @@ int btintel_recv_event(struct hci_dev *hdev, struct sk_buff *skb)
 		/* Handle all diagnostics events separately. May still call
 		 * hci_recv_frame.
 		 */
-		if (len >= sizeof(diagnostics_hdr) &&
+		if (len + 1 >= sizeof(diagnostics_hdr) &&
 		    memcmp(&skb->data[2], diagnostics_hdr,
 			   sizeof(diagnostics_hdr)) == 0) {
 			return btintel_diagnostics(hdev, skb);
-- 
2.53.0



