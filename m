Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AEA1274B3A;
	Mon, 13 Oct 2025 14:56:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367377; cv=none; b=XDWRrMZMaEpngjPKwm5kRcrcI07zIJWni9cXzNGVgcWO2XN4VtSemXKSyMjUZj/fXGEhc59azOEKwWSUHKNsm4tWBuCLoFsliM7qLEXET65XuIjQpXpUQVlGBf072YKyllyhLDgUaYDIy++9caNhtk1NVMK5XEuHbJGuuxgYd5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367377; c=relaxed/simple;
	bh=zlRivWcastJA2kNX65gFrtLUQHc+0Xj3MBy5TAHQ8Lo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kMi6110v/8+xgbUDCgGGRyNx0Fy2o+tW/DTOZ9BiJwDwnALZVhkmFYzUoy1Q3L1zypq9kUe4Rt0zmJ7EZ3TRjC3+IF4wqaR/A0HyFCm4oP39WNll7fwYzLggyhMMcehaECqm68xQTgvGV0byEZ/jWRT84jmExQ3Q9w5dVBWG1i8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SWIq8Dj6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SWIq8Dj6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FE16C4CEE7;
	Mon, 13 Oct 2025 14:56:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367377;
	bh=zlRivWcastJA2kNX65gFrtLUQHc+0Xj3MBy5TAHQ8Lo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SWIq8Dj67D3t7u5caCiS3FacfojJrgB1/ol1tYQRhOXwnx7frVudDvxEVszVp5MwL
	 8xbIJHpubtess28NMjWY8yu8Is3twPHVuiW5A04kwY1vrGl/W/tjKDffpuFFHL6UDT
	 0EkAcy0c4OZvXXtYGVZYaUsNetFhc92GQFew+mWo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 160/196] Bluetooth: hci_sync: Fix using random address for BIG/PA advertisements
Date: Mon, 13 Oct 2025 16:45:33 +0200
Message-ID: <20251013144320.487115632@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144314.549284796@linuxfoundation.org>
References: <20251013144314.549284796@linuxfoundation.org>
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

[ Upstream commit 03ddb4ac251463ec5b7b069395d9ab89163dd56c ]

When creating an advertisement for BIG the address shall not be
non-resolvable since in case of acting as BASS/Broadcast Assistant the
address must be the same as the connection in order to use the PAST
method and even when PAST/BASS are not in the picture a Periodic
Advertisement can still be synchronized thus the same argument as to
connectable advertisements still stand.

Fixes: eca0ae4aea66 ("Bluetooth: Add initial implementation of BIS connections")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_sync.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index 4c1b2468989a8..851a43a5aee0c 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -1304,7 +1304,7 @@ int hci_setup_ext_adv_instance_sync(struct hci_dev *hdev, u8 instance)
 {
 	struct hci_cp_le_set_ext_adv_params cp;
 	struct hci_rp_le_set_ext_adv_params rp;
-	bool connectable;
+	bool connectable, require_privacy;
 	u32 flags;
 	bdaddr_t random_addr;
 	u8 own_addr_type;
@@ -1342,10 +1342,12 @@ int hci_setup_ext_adv_instance_sync(struct hci_dev *hdev, u8 instance)
 		return -EPERM;
 
 	/* Set require_privacy to true only when non-connectable
-	 * advertising is used. In that case it is fine to use a
-	 * non-resolvable private address.
+	 * advertising is used and it is not periodic.
+	 * In that case it is fine to use a non-resolvable private address.
 	 */
-	err = hci_get_random_address(hdev, !connectable,
+	require_privacy = !connectable && !(adv && adv->periodic);
+
+	err = hci_get_random_address(hdev, require_privacy,
 				     adv_use_rpa(hdev, flags), adv,
 				     &own_addr_type, &random_addr);
 	if (err < 0)
-- 
2.51.0



