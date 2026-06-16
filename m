Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B5624779B9;
	Tue, 16 Jun 2026 17:36:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781631419; cv=none; b=tzvH7SgZ6y5f7KC2vGCA8ILbSXQg5KI8/Y/xYilM9sks9o7Z/RdePNieLojB+3sixF9NSNPwSdCDyynCNhCtwWXUeZP61Po+pCk24QCCE0tLhBo0DUYwpig+VLd9Ti/wKAMNlQEX4JABTj73yfGGwSPLagImb/408K8pB5kVMEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781631419; c=relaxed/simple;
	bh=KuGtjVjLcjgVYnbQ3TbgIjT6f85pr8IO3eGK8SDl4qY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GEOc3rJVFxMI4pnmJgDV+BeUOSEU8+5EmtnBd8bamNbceqDL+c1fMwGivQK3Wsm07sdJsteq60uWHwlzHeh9BOk4jIsCRkayg+5UVs3O1JmG+/oSo5xOoXcd+wB/IxntpcSW7USd8QnpY0Tq3oLemnXZSwXYV5vnW0cTn0pPpZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dLwPKRpR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dLwPKRpR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48E901F000E9;
	Tue, 16 Jun 2026 17:36:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781631418;
	bh=zpWGFtg7S5KJ2XqMGT2ktiym4YvEbcfGSBSnfADVf70=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dLwPKRpRoUGrbtWbpUMcKSoAE5CNS85IhMHXozZv+kAFX5navq189snRsk+qrxcOU
	 61FhUWsWTD4BOYC+3ZwUswiqfzXT3N/tPMg/89V4Mip1AO0Ls/GWDlwh2zBe6MXNmF
	 vIcwg4m1dG6Pst+Ry//8GsUcDMPf7t8piW7YFcN0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 218/522] Bluetooth: MGMT: Fix backward compatibility with userspace
Date: Tue, 16 Jun 2026 20:26:05 +0530
Message-ID: <20260616145136.230886800@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit 149324fc762c2a7acef9c26790566f81f475e51f ]

bluetoothd has a bug with makes it send extra bytes as part of
MGMT_OP_ADD_EXT_ADV_DATA which are now being checked to be the
exact the expected length, relax this so only when the expected
length is greater than the data length to cause an error since
that would result in accessing invalid memory, otherwise just
ignore the extra bytes.

Link: https://lore.kernel.org/linux-bluetooth/20260602204749.210857-1-luiz.dentz@gmail.com/T/#u
Fixes: d3f7d17960ed ("Bluetooth: MGMT: validate Add Extended Advertising Data length")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/mgmt.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index cc058c77d2e252..cd494f5ebb4dba 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -9079,8 +9079,9 @@ static int add_ext_adv_data(struct sock *sk, struct hci_dev *hdev, void *data,
 
 	BT_DBG("%s", hdev->name);
 
-	expected_len = struct_size(cp, data, cp->adv_data_len + cp->scan_rsp_len);
-	if (expected_len != data_len)
+	expected_len = struct_size(cp, data, cp->adv_data_len +
+				   cp->scan_rsp_len);
+	if (expected_len > data_len)
 		return mgmt_cmd_status(sk, hdev->id, MGMT_OP_ADD_EXT_ADV_DATA,
 				       MGMT_STATUS_INVALID_PARAMS);
 
-- 
2.53.0



