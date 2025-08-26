Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 208A52F9C23;
	Tue, 26 Aug 2025 11:32:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207944; cv=none; b=siMaFa9X8y6iVce73oW+zUF04/nNIqjJqxvqaljJ3+ckjZHmH4dP8gl+V5KlRW3pauPHvnnw4NpicVCHyHYuN1CsglzlNqqHmYlbdP9gfvPTWseNmWa40M2iNjbNmPndFJWNWDon2bETqZzchJ+awSZ/lygYaCd76VSqK6V5/m8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207944; c=relaxed/simple;
	bh=4P1SBD4A/b15JK6ihwThcF0mrZyMYxpHc50Tfwe3PCE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DQHWT91LoX0NyoXpgxbtADiTJCZ+augdFbQDSJ+xkiUjn8uaapx7igffXf+7Fp8pfbdUfp5wYFjdywI8U/1Qohm7hSdcQabrJGU63+9sUFP/yT1rvbywSLqWLNYqfT/STSEXVevycxYrFOG+LfaNTR/1PUmTLtv5GllvIr0x+ZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XDiE/Rxb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XDiE/Rxb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B02FC4CEF1;
	Tue, 26 Aug 2025 11:32:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207943;
	bh=4P1SBD4A/b15JK6ihwThcF0mrZyMYxpHc50Tfwe3PCE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XDiE/RxbVN1xLVRENtwfwrHtj1YUYwrHXD1c6Ecyl0zPDrB8YwSyFtnYU/9eEazxU
	 DKh/spQmhOUvSelw2jGH8jNISvC3YBshhvsPBrZfhiELfygC3vXomux/QV/SAFpjCt
	 3a0L4oM/f5/JITzcZ3JV9a/8Axk3Y2/M7HUWJysY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 376/457] Bluetooth: hci_core: Fix using ll_privacy_capable for current settings
Date: Tue, 26 Aug 2025 13:11:00 +0200
Message-ID: <20250826110946.588893764@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit 3dcf7175f2c04bd3a7d50db3fa42a0bd933b6e23 ]

ll_privacy_capable only indicates that the controller supports the
feature but it doesnt' check that LE is enabled so it end up being
marked as active in the current settings when it shouldn't.

Fixes: ad383c2c65a5 ("Bluetooth: hci_sync: Enable advertising when LL privacy is enabled")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/bluetooth/hci_core.h | 1 +
 net/bluetooth/mgmt.c             | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index e77cb840deee..2fcd62fdbc87 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -1951,6 +1951,7 @@ void hci_conn_del_sysfs(struct hci_conn *conn);
 			 ((dev)->le_rx_def_phys & HCI_LE_SET_PHY_CODED))
 
 #define ll_privacy_capable(dev) ((dev)->le_features[0] & HCI_LE_LL_PRIVACY)
+#define ll_privacy_enabled(dev) (le_enabled(dev) && ll_privacy_capable(dev))
 
 #define privacy_mode_capable(dev) (ll_privacy_capable(dev) && \
 				   ((dev)->commands[39] & 0x04))
diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index 7a75309e6fd4..d4405d3d9bc1 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -934,7 +934,7 @@ static u32 get_current_settings(struct hci_dev *hdev)
 	if (sync_recv_enabled(hdev))
 		settings |= MGMT_SETTING_ISO_SYNC_RECEIVER;
 
-	if (ll_privacy_capable(hdev))
+	if (ll_privacy_enabled(hdev))
 		settings |= MGMT_SETTING_LL_PRIVACY;
 
 	return settings;
-- 
2.50.1



