Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A9A0355031;
	Tue,  6 Jan 2026 17:48:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721735; cv=none; b=b2Nx7rQkU+5TXTxGQiygvZz5KBzTLzu1JeyVSqd1FRZnETlscgekVDG5zUrK+fwYL6/Zv3kbbPCvTfa55/RUc67FP5SucB4KnggIiEf/+7886AhlE8oVNYPRHnJQBnOEhD0kHnuzLcstsGaSqJBhqKPdvJtnSyyCgBD/RuDsLSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721735; c=relaxed/simple;
	bh=vYn3ynUR7in8BZNwQs5E0TPvx+FNugQLuNwAcYAx/Ro=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XjZeI5w7wbDypD3QOhm2I1P0Y1GD40TnrQitppecsUYBj2FwQfwCqi0cy0Q5JZjXLHDQTXoYO/d1o8bD/rPS5hjI5HGqYessmkVw6gd1nGMZ31JqOj2tkEbjnuhk8LXz8/qPLXW7ZQPJ9noEPygG3FjVnm8nzBMCirL8LE3yXJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LBmU0KnG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LBmU0KnG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DC60C116C6;
	Tue,  6 Jan 2026 17:48:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721734;
	bh=vYn3ynUR7in8BZNwQs5E0TPvx+FNugQLuNwAcYAx/Ro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LBmU0KnG4AWbCjlkaLmmlbx/wTOZZs1KH4bMMBExQBaAB4NdV01iEKbYXGv6jpsUV
	 nmT1T6jM+R0GnpBI/adMMqEd0O9TYRplZlN0GdosRksIHDApfIfdpGJxZUpBOvsk5z
	 m1OE9bDnWM94FFjWI25gsLgSfHjhlM7MQycy+vsE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 024/312] Bluetooth: MGMT: report BIS capability flags in supported settings
Date: Tue,  6 Jan 2026 18:01:38 +0100
Message-ID: <20260106170548.730768810@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pauli Virtanen <pav@iki.fi>

[ Upstream commit 348240e5fa901d3d4ba8dffa0e2ba9fc7aba93ab ]

MGMT_SETTING_ISO_BROADCASTER and MGMT_SETTING_ISO_RECEIVER flags are
missing from supported_settings although they are in current_settings.

Report them also in supported_settings to be consistent.

Fixes: ae7533613133 ("Bluetooth: Check for ISO support in controller")
Signed-off-by: Pauli Virtanen <pav@iki.fi>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/mgmt.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index 262bf984d2aa..211951eb832a 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -849,6 +849,12 @@ static u32 get_supported_settings(struct hci_dev *hdev)
 	if (cis_peripheral_capable(hdev))
 		settings |= MGMT_SETTING_CIS_PERIPHERAL;
 
+	if (bis_capable(hdev))
+		settings |= MGMT_SETTING_ISO_BROADCASTER;
+
+	if (sync_recv_capable(hdev))
+		settings |= MGMT_SETTING_ISO_SYNC_RECEIVER;
+
 	if (ll_privacy_capable(hdev))
 		settings |= MGMT_SETTING_LL_PRIVACY;
 
-- 
2.51.0



