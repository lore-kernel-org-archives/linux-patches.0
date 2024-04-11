Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D14413FD94;
	Thu, 11 Apr 2024 10:26:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712831205; cv=none; b=RTHT5N6ijKIV8DPMSLPRI9y3AIOy0OZdyjT6Cx14pwxTuMhAPfnWGOYZhsYrGXNXI+H2EuGJqogOkaJSvYQ3mcFIP58I4yO2R0hBdKCBvCs+V2AQy6rQKzJInah05CetlrZxSHE+s0AbA9148wSvFdHUp0E6+GOrusX0Kunftkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712831205; c=relaxed/simple;
	bh=FSiRYzmeuU3hh4HArW/RmAhxJ7xEQEYBuFYNXJ4sCUs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KBMg/4CA1K56+71uDwpZg5j3GmZWGiRrxuvau79pi8+MbRgbHtlgwZ3V3qzmFEFhwaEYesQLtWBRHu33SoITZe3BVGILqIwgd5PI/AfVWJ41hZGj/y6IHl9UxuOUewWBRcp2ZQvSdcMPg9Js/K7oMyUFoNDDY2UknOBsKghJfkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gi4FyvRn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gi4FyvRn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AE92C433C7;
	Thu, 11 Apr 2024 10:26:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712831205;
	bh=FSiRYzmeuU3hh4HArW/RmAhxJ7xEQEYBuFYNXJ4sCUs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gi4FyvRnDFNHpkRNasZrVWWxH6dlHymM2C2Wl/xvXqZcVN+RiOaD+sTdbEkOeS/GN
	 yX8Y7HN0crJTv5pxIhWOLMZnsDnPnev1DMN1XkkTQDkoPFZKRg87XZoXhRE7CMg7aA
	 jlkT2pG79AlT/6Q+bpn+4ziOkPNZII4+mQOMUPdM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Edward Adam Davis <eadavis@qq.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	syzbot+830d9e3fa61968246abd@syzkaller.appspotmail.com
Subject: [PATCH 6.6 043/114] Bluetooth: btintel: Fix null ptr deref in btintel_read_version
Date: Thu, 11 Apr 2024 11:56:10 +0200
Message-ID: <20240411095418.181923090@linuxfoundation.org>
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
index 2462796a512a5..b396b0b1d6cc2 100644
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



