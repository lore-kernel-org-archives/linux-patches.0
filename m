Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5721142624;
	Thu, 11 Apr 2024 10:10:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830208; cv=none; b=fOOyj3ZDIPqdNCWKwfudtkuP9xy6Cxbssf7it1uVw9UdK8sHDh7Ar5d2ea6agz6efURyCLWZ+3J6L/uGhEpIMLX7JXCCbV+fu/KfBZfU9/BTJH5yRm34nGO5bExj2tICEXNrP9wRcQX501lO2zWiDfbVo+AFUC4M8WR+MPbGGog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830208; c=relaxed/simple;
	bh=rNBjbtF/U7CqTyJLJcB1ScDBLv3NcSsmbiwqTgOnaWQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SBjpu/ayXxlCp8lilKxmMxpChXxwvXq7ZKDkQqCPcKNpkg88aFqM7X3gFsJP5MNXiauoP3CqFcR3MhBRzUzCH0Wtan5NuLEUMw0Gn16hfWtPGYJXilsFENUTZq7CqQBZyCiQj7PFtL7tjiD5v4cCwXXHzbl4s2b+zZFWX+NPMzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GXEo1aBR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GXEo1aBR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C356C433C7;
	Thu, 11 Apr 2024 10:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830207;
	bh=rNBjbtF/U7CqTyJLJcB1ScDBLv3NcSsmbiwqTgOnaWQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GXEo1aBR0KfG/9mBexbvc8rCNTctOVrs3l4oX+1Cvvixlay9TuoNuC3077k84PRvP
	 6O4BaLXySJfO4UFrMp70+Fglp6wuduXCXkDUCDE4pkZqWXoatin6t0Y0a1fEBRzuim
	 ujktUbiqgD9fe4AWdB2xfCGGdtQF0gZ0ijeWisLM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Edward Adam Davis <eadavis@qq.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	syzbot+830d9e3fa61968246abd@syzkaller.appspotmail.com
Subject: [PATCH 6.8 054/143] Bluetooth: btintel: Fix null ptr deref in btintel_read_version
Date: Thu, 11 Apr 2024 11:55:22 +0200
Message-ID: <20240411095422.542945911@linuxfoundation.org>
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

From: Edward Adam Davis <eadavis@qq.com>

[ Upstream commit b79e040910101b020931ba0c9a6b77e81ab7f645 ]

If hci_cmd_sync_complete() is triggered and skb is NULL, then
hdev->req_skb is NULL, which will cause this issue.

Reported-and-tested-by: syzbot+830d9e3fa61968246abd@syzkaller.appspotmail.com
Signed-off-by: Edward Adam Davis <eadavis@qq.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btintel.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/bluetooth/btintel.c b/drivers/bluetooth/btintel.c
index cdc5c08824a0a..e5b043d962073 100644
--- a/drivers/bluetooth/btintel.c
+++ b/drivers/bluetooth/btintel.c
@@ -435,7 +435,7 @@ int btintel_read_version(struct hci_dev *hdev, struct intel_version *ver)
 	struct sk_buff *skb;
 
 	skb = __hci_cmd_sync(hdev, 0xfc05, 0, NULL, HCI_CMD_TIMEOUT);
-	if (IS_ERR(skb)) {
+	if (IS_ERR_OR_NULL(skb)) {
 		bt_dev_err(hdev, "Reading Intel version information failed (%ld)",
 			   PTR_ERR(skb));
 		return PTR_ERR(skb);
-- 
2.43.0



