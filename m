Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3D9D205E3B;
	Tue, 30 Sep 2025 15:22:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759245760; cv=none; b=VVv/TJ8j/bFf9NliS+Ma1Zw1X/B2T2WHASyEzWvI32HDZ6cdo35updkCF8vu4iuN4m5uwuIzPwPiW4Flq1DW5gBForuT4h/6gj3+cEbPvsU/HWJapvnyWNpJzbP2WUWmvGSFueIGJwaim/R/C5Pd0pZbOk8bp/Dg4BoeCO1R8+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759245760; c=relaxed/simple;
	bh=E8OX3ozDvUSznXiYp8CRxd9yj/lk5Y72lEfIjE5vNEs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VfrpzhmLvacCl+ZHTL6YqlDBQx5AFvQSF6st+BuqGsL+IiYBLLOSdpFWzgz0ED1FZMef3NZzXDMBkWhBCxOOHzPhGH7v5Ze9j5A0irVCV6Uc/0zqeBJmpMp5YtZDZlW1jKnlbbAXcUK8ibhAXpGP4lXk/XC6v0nLkNep0Kd2W1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZJG1sFE3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZJG1sFE3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 627CCC4CEF0;
	Tue, 30 Sep 2025 15:22:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759245759;
	bh=E8OX3ozDvUSznXiYp8CRxd9yj/lk5Y72lEfIjE5vNEs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZJG1sFE3J0/j2YI2+bRbb9U9ercgU8euT9rcRtprG/+K/47JBlwj4+J/7wIEvCdPD
	 aNzq/gTV/eHnZkoevfZbyS8Lj0Hpl+w9HJ89P7x2AUYWG+kMoxgQNFxco+65Wr4Yn9
	 JzhSKjkAKwDZXZaiPlx0LZa9PzxkCZxPQQd3Xq+I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 41/91] Bluetooth: hci_sync: Fix hci_resume_advertising_sync
Date: Tue, 30 Sep 2025 16:47:40 +0200
Message-ID: <20250930143822.877157085@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143821.118938523@linuxfoundation.org>
References: <20250930143821.118938523@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit 1488af7b8b5f9896ea88ee35aa3301713f72737c ]

hci_resume_advertising_sync is suppose to resume all instance paused by
hci_pause_advertising_sync, this logic is used for procedures are only
allowed when not advertising, but instance 0x00 was not being
re-enabled.

Fixes: ad383c2c65a5 ("Bluetooth: hci_sync: Enable advertising when LL privacy is enabled")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_sync.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index 7f3f700faebc2..dc9209f9f1a6a 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -2639,6 +2639,13 @@ static int hci_resume_advertising_sync(struct hci_dev *hdev)
 			hci_remove_ext_adv_instance_sync(hdev, adv->instance,
 							 NULL);
 		}
+
+		/* If current advertising instance is set to instance 0x00
+		 * then we need to re-enable it.
+		 */
+		if (!hdev->cur_adv_instance)
+			err = hci_enable_ext_advertising_sync(hdev,
+							      hdev->cur_adv_instance);
 	} else {
 		/* Schedule for most recent instance to be restarted and begin
 		 * the software rotation loop
-- 
2.51.0



