Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E9C71170E
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 13:57:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94262C433C9;
	Mon, 11 Sep 2023 13:57:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694440622;
	bh=NK/QM5sM0ggs4pavSzC804Gu1u/n8tTzrUWwDjjhmpA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BOiREtXtk0igz8bUx08VGQHwP73KRX2zXv+2w/9GlAexKN9G73eQr9W6SOhmk7xkr
	 3Da3FW8VABvPyfeGkLkQeZBqGn3eCaf04+ARzH0zq7Lp9QARdIqvKq9aK7jtIxm7hf
	 6pqluNphEY53FnefvBqngV1VwETbfyE3Z2gvr+To=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manish Mandlik <mmandlik@google.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 126/739] Bluetooth: hci_sync: Avoid use-after-free in dbg for hci_add_adv_monitor()
Date: Mon, 11 Sep 2023 15:38:45 +0200
Message-ID: <20230911134654.610734149@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Manish Mandlik <mmandlik@google.com>

[ Upstream commit a2bcd2b63271a93a695fabbfbf459c603d956d48 ]

KSAN reports use-after-free in hci_add_adv_monitor().

While adding an adv monitor,
    hci_add_adv_monitor() calls ->
    msft_add_monitor_pattern() calls ->
    msft_add_monitor_sync() calls ->
    msft_le_monitor_advertisement_cb() calls in an error case ->
    hci_free_adv_monitor() which frees the *moniter.

This is referenced by bt_dev_dbg() in hci_add_adv_monitor().

Fix the bt_dev_dbg() by using handle instead of monitor->handle.

Fixes: b747a83690c8 ("Bluetooth: hci_sync: Refactor add Adv Monitor")
Signed-off-by: Manish Mandlik <mmandlik@google.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index 04b51ffd946b7..2c845c9a26be0 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -1957,7 +1957,7 @@ int hci_add_adv_monitor(struct hci_dev *hdev, struct adv_monitor *monitor)
 	case HCI_ADV_MONITOR_EXT_MSFT:
 		status = msft_add_monitor_pattern(hdev, monitor);
 		bt_dev_dbg(hdev, "add monitor %d msft status %d",
-			   monitor->handle, status);
+			   handle, status);
 		break;
 	}
 
-- 
2.40.1



