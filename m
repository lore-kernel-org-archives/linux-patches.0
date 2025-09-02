Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9352D2DAFCA;
	Tue,  2 Sep 2025 13:33:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756820007; cv=none; b=eeRQ066RhSnaCXHxmEq25JPY8iGvxalLJUXwqbEjyKzKTwhbjNYztlifkZoQsly6utEV64SFxvaY3amZFy2WczVpjVoJT8KFZQdPGk9GKCRLxVSmu4UIps3RjXmEqlRivunfgGiFKEADXqiYxDBXFE7udoAAOAZleh+lQgRG5cY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756820007; c=relaxed/simple;
	bh=qSSNuJP/d6Ii2XWooMNPm3yX5FhMnaZ2vurWa7KHN2c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k97LmPKFSwvHT4qNuvdENctK0RUSjpzIp8HZzA+apftZ/tpzr2k9U/YdRiSWXKrGZ1v4Ppuvv/rSMPnSeQ8N7G4EgBcc7gL4C/QfWkYjw9T7FXAug5VVJANRJdR5ogMZ7ZA03z30pwXpNngbfFKlJz0M09J2lZ7WYCoJiEzAskU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iWAXkUnS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iWAXkUnS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DE19C4CEED;
	Tue,  2 Sep 2025 13:33:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756820007;
	bh=qSSNuJP/d6Ii2XWooMNPm3yX5FhMnaZ2vurWa7KHN2c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iWAXkUnSMGomP7Emcr1XhST56nojFF99e3aO0gLNOoo3pJKt9/RzyLjqunbMPnxt6
	 qU3i7BLUKHzGp9GB+czKKRugF3BY3oDMH7xoriy0HqXdDO3tbi6eXdu2LnuaKzuyoN
	 6dY+/19/xDWsWE0JE8BBN5yU88PnEPEB4URBkozE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Shpakovskiy <pashpakovskii@salutedevices.com>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 32/95] Bluetooth: hci_sync: fix set_local_name race condition
Date: Tue,  2 Sep 2025 15:20:08 +0200
Message-ID: <20250902131940.844686328@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131939.601201881@linuxfoundation.org>
References: <20250902131939.601201881@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index dbabc17b30cdf..17e5112f7840e 100644
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
index af86df9de941d..bc2aa514b8c5d 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -3491,13 +3491,13 @@ int hci_update_scan_sync(struct hci_dev *hdev)
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
@@ -3550,7 +3550,7 @@ int hci_powered_update_sync(struct hci_dev *hdev)
 			hci_write_fast_connectable_sync(hdev, false);
 		hci_update_scan_sync(hdev);
 		hci_update_class_sync(hdev);
-		hci_update_name_sync(hdev);
+		hci_update_name_sync(hdev, hdev->dev_name);
 		hci_update_eir_sync(hdev);
 	}
 
diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index ade93532db34b..8b75647076bae 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -3826,8 +3826,11 @@ static void set_name_complete(struct hci_dev *hdev, void *data, int err)
 
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



