Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E23F31576D;
	Tue,  2 Sep 2025 13:24:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756819496; cv=none; b=J2HsZk3lpFFgy1l4rdeAFjwMrirmxlLkb7KFyg6oKatrhMfMyGIMGODHUocntR6Q7eQvvw7kS78w0d+jz1zf/RWsKDFgJ29+HjxT5PSTY0N5DU2iOjso7EMcD88fiSbMmmPkJ5PVRZPLvbTbycmfzHYWkeBdFpTDk19N6xUFKOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756819496; c=relaxed/simple;
	bh=9BlOdNZ6lC0qQhXjo20ECvrRuOwfciUNRx0Ebh7j7e4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DIL9QPjf12QDgdWOuCjHt+Zljh8jmQ81Zqm4dUnTNltzHF7GVqpv18sUk5wmYtBiIfKScsyOXfczoQQOwDA6WTT7jUkUujHrZU7vNA4fuu/vYQUlgHrvtLZhWTCeB8uDU7PFoEGNsw0pJeqiSefpfAGmoyHUrKu00h3YsSLL6Ws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kUY3ACyZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kUY3ACyZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C94AC4CEF5;
	Tue,  2 Sep 2025 13:24:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756819496;
	bh=9BlOdNZ6lC0qQhXjo20ECvrRuOwfciUNRx0Ebh7j7e4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kUY3ACyZ8I0QayGOc4cDg4D3ne60zmPAj2JongFr66OGYKtk9A6448NTKIXS54At5
	 l1T4+BQZud5ImrA7ipTfTwvrmZohBXXQ1x8uz0oNuoBfAj2+WhO87YktNM85U1dSO+
	 y2ixtwZv83uImjItCiwylOJdMgNtluy+luLHre9c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Shpakovskiy <pashpakovskii@salutedevices.com>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 051/142] Bluetooth: hci_sync: fix set_local_name race condition
Date: Tue,  2 Sep 2025 15:19:13 +0200
Message-ID: <20250902131950.211373972@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131948.154194162@linuxfoundation.org>
References: <20250902131948.154194162@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Shpakovskiy <pashpakovskii@salutedevices.com>

[ Upstream commit 6bbd0d3f0c23fc53c17409dd7476f38ae0ff0cd9 ]

Function set_name_sync() uses hdev->dev_name field to send
HCI_OP_WRITE_LOCAL_NAME command, but copying from data to hdev->dev_name
is called after mgmt cmd was queued, so it is possible that function
set_name_sync() will read old name value.

This change adds name as a parameter for function hci_update_name_sync()
to avoid race condition.

Fixes: 6f6ff38a1e14 ("Bluetooth: hci_sync: Convert MGMT_OP_SET_LOCAL_NAME")
Signed-off-by: Pavel Shpakovskiy <pashpakovskii@salutedevices.com>
Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/bluetooth/hci_sync.h | 2 +-
 net/bluetooth/hci_sync.c         | 6 +++---
 net/bluetooth/mgmt.c             | 5 ++++-
 3 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/include/net/bluetooth/hci_sync.h b/include/net/bluetooth/hci_sync.h
index 5224f57f6af2c..e352a4e0ef8d7 100644
--- a/include/net/bluetooth/hci_sync.h
+++ b/include/net/bluetooth/hci_sync.h
@@ -93,7 +93,7 @@ int hci_update_class_sync(struct hci_dev *hdev);
 
 int hci_update_eir_sync(struct hci_dev *hdev);
 int hci_update_class_sync(struct hci_dev *hdev);
-int hci_update_name_sync(struct hci_dev *hdev);
+int hci_update_name_sync(struct hci_dev *hdev, const u8 *name);
 int hci_write_ssp_mode_sync(struct hci_dev *hdev, u8 mode);
 
 int hci_get_random_address(struct hci_dev *hdev, bool require_privacy,
diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index 115dc1cd99ce4..749bba1512eb1 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -3481,13 +3481,13 @@ int hci_update_scan_sync(struct hci_dev *hdev)
 	return hci_write_scan_enable_sync(hdev, scan);
 }
 
-int hci_update_name_sync(struct hci_dev *hdev)
+int hci_update_name_sync(struct hci_dev *hdev, const u8 *name)
 {
 	struct hci_cp_write_local_name cp;
 
 	memset(&cp, 0, sizeof(cp));
 
-	memcpy(cp.name, hdev->dev_name, sizeof(cp.name));
+	memcpy(cp.name, name, sizeof(cp.name));
 
 	return __hci_cmd_sync_status(hdev, HCI_OP_WRITE_LOCAL_NAME,
 					    sizeof(cp), &cp,
@@ -3540,7 +3540,7 @@ int hci_powered_update_sync(struct hci_dev *hdev)
 			hci_write_fast_connectable_sync(hdev, false);
 		hci_update_scan_sync(hdev);
 		hci_update_class_sync(hdev);
-		hci_update_name_sync(hdev);
+		hci_update_name_sync(hdev, hdev->dev_name);
 		hci_update_eir_sync(hdev);
 	}
 
diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index 90e37ff2c85db..50634ef5c8b70 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -3892,8 +3892,11 @@ static void set_name_complete(struct hci_dev *hdev, void *data, int err)
 
 static int set_name_sync(struct hci_dev *hdev, void *data)
 {
+	struct mgmt_pending_cmd *cmd = data;
+	struct mgmt_cp_set_local_name *cp = cmd->param;
+
 	if (lmp_bredr_capable(hdev)) {
-		hci_update_name_sync(hdev);
+		hci_update_name_sync(hdev, cp->name);
 		hci_update_eir_sync(hdev);
 	}
 
-- 
2.50.1



