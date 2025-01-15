Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92C43156644;
	Wed, 15 Jan 2025 10:45:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736937954; cv=none; b=nTK7n/tt/ntij1Fx82Efm1+K3Fltx3FdP9C2aB5jn0SuK17/diyBCCyZIGNH0K2VgE2bE5Ra8p1fL5vyxNQNgZhgMAycoXpgo8wSMLSrxnqoNwIiyRMriz7OiRWaVM7tuDJ2UVVGOAcZWGnLpkI3D1q9Dko3XsRpga5c3aPLc/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736937954; c=relaxed/simple;
	bh=jjH1kyC/ETnT7xqB65rpjjhvzk69qRUNeZfq3fLpDi0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hzzcu/JFrYic+zUbTXNEJj53HmxYVj4s6Lx9LZR4flJG6rq/HgJLLM0SZVOWUV+cVG2o9t5GjKg0hX5f4IjwaW+doIjZmEqEWICjJ/uBalaef2iR3kZl0Gy7Ja9H163PhakbTNVanFW79tzi/KaeQnDi/gJ7fCuWxsgxV9yREqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V58K7kRW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V58K7kRW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA416C4CEE4;
	Wed, 15 Jan 2025 10:45:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736937954;
	bh=jjH1kyC/ETnT7xqB65rpjjhvzk69qRUNeZfq3fLpDi0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V58K7kRWoXWh5iti1qV0+dmiYU2lHhZ6KrTvSqTkqkE68fVTNyWHNy1HU2v4C0ixg
	 DWep8Iuo99KEMz7c4frxijWI6jAFfDnSzZPdxv8Yx7pObFjDxvMB4n5xqe59M1qzfj
	 cpnmz4NcV83uWTQyTgXjI2Qg3tee6onOU0Hwy81E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 041/189] Bluetooth: hci_sync: Fix not setting Random Address when required
Date: Wed, 15 Jan 2025 11:35:37 +0100
Message-ID: <20250115103607.998812701@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103606.357764746@linuxfoundation.org>
References: <20250115103606.357764746@linuxfoundation.org>
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

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit c2994b008492db033d40bd767be1620229a3035e ]

This fixes errors such as the following when Own address type is set to
Random Address but it has not been programmed yet due to either be
advertising or connecting:

< HCI Command: LE Set Exte.. (0x08|0x0041) plen 13
        Own address type: Random (0x03)
        Filter policy: Ignore not in accept list (0x01)
        PHYs: 0x05
        Entry 0: LE 1M
          Type: Passive (0x00)
          Interval: 60.000 msec (0x0060)
          Window: 30.000 msec (0x0030)
        Entry 1: LE Coded
          Type: Passive (0x00)
          Interval: 180.000 msec (0x0120)
          Window: 90.000 msec (0x0090)
> HCI Event: Command Complete (0x0e) plen 4
      LE Set Extended Scan Parameters (0x08|0x0041) ncmd 1
        Status: Success (0x00)
< HCI Command: LE Set Exten.. (0x08|0x0042) plen 6
        Extended scan: Enabled (0x01)
        Filter duplicates: Enabled (0x01)
        Duration: 0 msec (0x0000)
        Period: 0.00 sec (0x0000)
> HCI Event: Command Complete (0x0e) plen 4
      LE Set Extended Scan Enable (0x08|0x0042) ncmd 1
        Status: Invalid HCI Command Parameters (0x12)

Fixes: c45074d68a9b ("Bluetooth: Fix not generating RPA when required")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_sync.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index c86f4e42e69c..7b2b04d6b856 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -1031,9 +1031,9 @@ static bool adv_use_rpa(struct hci_dev *hdev, uint32_t flags)
 
 static int hci_set_random_addr_sync(struct hci_dev *hdev, bdaddr_t *rpa)
 {
-	/* If we're advertising or initiating an LE connection we can't
-	 * go ahead and change the random address at this time. This is
-	 * because the eventual initiator address used for the
+	/* If a random_addr has been set we're advertising or initiating an LE
+	 * connection we can't go ahead and change the random address at this
+	 * time. This is because the eventual initiator address used for the
 	 * subsequently created connection will be undefined (some
 	 * controllers use the new address and others the one we had
 	 * when the operation started).
@@ -1041,8 +1041,9 @@ static int hci_set_random_addr_sync(struct hci_dev *hdev, bdaddr_t *rpa)
 	 * In this kind of scenario skip the update and let the random
 	 * address be updated at the next cycle.
 	 */
-	if (hci_dev_test_flag(hdev, HCI_LE_ADV) ||
-	    hci_lookup_le_connect(hdev)) {
+	if (bacmp(&hdev->random_addr, BDADDR_ANY) &&
+	    (hci_dev_test_flag(hdev, HCI_LE_ADV) ||
+	    hci_lookup_le_connect(hdev))) {
 		bt_dev_dbg(hdev, "Deferring random address update");
 		hci_dev_set_flag(hdev, HCI_RPA_EXPIRED);
 		return 0;
-- 
2.39.5



