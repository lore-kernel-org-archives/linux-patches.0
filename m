Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C28410A35;
	Mon,  4 Mar 2024 21:27:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709587641; cv=none; b=DazmNJXck6RzMvgSLJOuzrxT+6p67CABkRd3nGN/e3vI5olFFo10O7CC0c1l2fHX6zFj9scSFcfhMlHY9WvXs1c1ULiSsupBB11yUhfSPbp4lxDn6jsND26uIJzROQNlt8gee55ztzWRtTLxZUD3WkzLQn9jYxyw5SaK4yyYCAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709587641; c=relaxed/simple;
	bh=TQWVPc+zWRH/ZUHlYBN+o8e/SHHChwHXvLlUrRI8A4Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DSi6SfuINXkSj5NMUY0BuHvcMhYF/pwPJUxx+hA8NWIWtRtUO86GdkXtg1+XqMNUodM8yQcFXTvHXX4I2gSs1Otn6Q+ikSDV0bsK4UYSAC6MfkGlyuhRDjvB74jTtTY1eD9CV/VB+1kYkI4m+p+vjL2HIVQkSh8c0D/VE59WOLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yJ5ZUaYe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yJ5ZUaYe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEE60C433C7;
	Mon,  4 Mar 2024 21:27:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709587641;
	bh=TQWVPc+zWRH/ZUHlYBN+o8e/SHHChwHXvLlUrRI8A4Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yJ5ZUaYemfD+uhx5WVlWEpOSy2bDvgndlcKC2T37LPp7YwN9NUKRLPgZiDiyEVN/L
	 9kHiUnikKWKtlPUej+fLN0sIWMHjGV1cEUB/waQrWZ0F5dXML3vnpctb8hdMv1lzZa
	 mfLWRg8BW2Ph/gs8OEPJUSCP4Gdw06ctjN/waHIU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 033/162] Bluetooth: qca: Fix triggering coredump implementation
Date: Mon,  4 Mar 2024 21:21:38 +0000
Message-ID: <20240304211552.890704158@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211551.833500257@linuxfoundation.org>
References: <20240304211551.833500257@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zijun Hu <quic_zijuhu@quicinc.com>

[ Upstream commit 6abf9dd26bb1699c17d601b9a292577d01827c0e ]

hci_coredump_qca() uses __hci_cmd_sync() to send a vendor-specific command
to trigger firmware coredump, but the command does not have any event as
its sync response, so it is not suitable to use __hci_cmd_sync(), fixed by
using __hci_cmd_send().

Fixes: 06d3fdfcdf5c ("Bluetooth: hci_qca: Add qcom devcoredump support")
Signed-off-by: Zijun Hu <quic_zijuhu@quicinc.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/hci_qca.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/bluetooth/hci_qca.c b/drivers/bluetooth/hci_qca.c
index cc6dabf6884d7..a65de7309da4c 100644
--- a/drivers/bluetooth/hci_qca.c
+++ b/drivers/bluetooth/hci_qca.c
@@ -1807,13 +1807,12 @@ static int qca_power_on(struct hci_dev *hdev)
 
 static void hci_coredump_qca(struct hci_dev *hdev)
 {
+	int err;
 	static const u8 param[] = { 0x26 };
-	struct sk_buff *skb;
 
-	skb = __hci_cmd_sync(hdev, 0xfc0c, 1, param, HCI_CMD_TIMEOUT);
-	if (IS_ERR(skb))
-		bt_dev_err(hdev, "%s: trigger crash failed (%ld)", __func__, PTR_ERR(skb));
-	kfree_skb(skb);
+	err = __hci_cmd_send(hdev, 0xfc0c, 1, param);
+	if (err < 0)
+		bt_dev_err(hdev, "%s: trigger crash failed (%d)", __func__, err);
 }
 
 static int qca_setup(struct hci_uart *hu)
-- 
2.43.0



