Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA7601A2389;
	Sun,  7 Sep 2025 20:15:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757276137; cv=none; b=Rzyf2Y9NE/xmhxowLBYSvo2C3Oa1ghwAkj5gYe/bnZ5d7A0QIPIf7OBEsCONiX49M/P0BSxU6fpyhlid+aUhKKf+9zB98uA5eHLG+GLUjRC8hUKmDyIN4eZMi/ekGH8vCfIFC5TjM4AZcCGFy8wH1/3oIf5nBJMDZ0aba/8SK4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757276137; c=relaxed/simple;
	bh=eOixkJ6nJJLywTkv/LM32m98FbEmOd8Oq1qZ3MTjM+I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LemW5QicDxvcgU0AMXTeYssk4iCQu9vV/on+lKMat9vGb9N9GXUAUc9ZeMrzunHSN8gwiOR0qOMl799NWfEzHHQdQ0T3179nynKuVXWvPVO4clydaaC3YIg32LWcRlg3MJqQbomN9DIS6gntf7wxGDywC3cJXF0uoS0pYh6U1c4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2mJEy5Po; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2mJEy5Po"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64593C4CEF0;
	Sun,  7 Sep 2025 20:15:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757276137;
	bh=eOixkJ6nJJLywTkv/LM32m98FbEmOd8Oq1qZ3MTjM+I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2mJEy5PoGY5YFJikP6iaSonVbOvOtU0Wnprz3aLAStPSFU8f+UW7J8k7DpZsVaI5o
	 pQKaWE+mZnykE+f5CTYiS/9AufkB7yuvpgzx6TuQrKbhPTdnPAN9qroigQE++lV/MB
	 DxIlGGUZhmQfQ2GrWyQY/s5KGcedXDdiqQrRCR+c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Li <yang.li@amlogic.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 010/104] Bluetooth: hci_sync: Avoid adding default advertising on startup
Date: Sun,  7 Sep 2025 21:57:27 +0200
Message-ID: <20250907195607.942416826@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195607.664912704@linuxfoundation.org>
References: <20250907195607.664912704@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yang Li <yang.li@amlogic.com>

[ Upstream commit de5d7d3f27ddd4046736f558a40e252ddda82013 ]

list_empty(&hdev->adv_instances) is always true during startup,
so an advertising instance is added by default.

Call trace:
  dump_backtrace+0x94/0xec
  show_stack+0x18/0x24
  dump_stack_lvl+0x48/0x60
  dump_stack+0x18/0x24
  hci_setup_ext_adv_instance_sync+0x17c/0x328
  hci_powered_update_adv_sync+0xb4/0x12c
  hci_powered_update_sync+0x54/0x70
  hci_power_on_sync+0xe4/0x278
  hci_set_powered_sync+0x28/0x34
  set_powered_sync+0x40/0x58
  hci_cmd_sync_work+0x94/0x100
  process_one_work+0x168/0x444
  worker_thread+0x378/0x3f4
  kthread+0x108/0x10c
  ret_from_fork+0x10/0x20

Link: https://github.com/bluez/bluez/issues/1442
Signed-off-by: Yang Li <yang.li@amlogic.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_sync.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index 965b0f2b43a72..a2c3b58db54c2 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -3287,7 +3287,7 @@ static int hci_powered_update_adv_sync(struct hci_dev *hdev)
 	 * advertising data. This also applies to the case
 	 * where BR/EDR was toggled during the AUTO_OFF phase.
 	 */
-	if (hci_dev_test_flag(hdev, HCI_ADVERTISING) ||
+	if (hci_dev_test_flag(hdev, HCI_ADVERTISING) &&
 	    list_empty(&hdev->adv_instances)) {
 		if (ext_adv_capable(hdev)) {
 			err = hci_setup_ext_adv_instance_sync(hdev, 0x00);
-- 
2.50.1



