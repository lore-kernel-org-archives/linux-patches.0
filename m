Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C8794779B0;
	Tue, 16 Jun 2026 18:33:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781634835; cv=none; b=m5sBTUxpUnRjufUR7SDySk7Uy78MwSX3zMYYEDR00aMGqXc/3QNDSj2A55R7BlYD7PURQa2QIPu78o8lJfy4Tswv6QzfoNwFuDzC8zYJfEO4dKOw1UNhn0nL9UTHuop/mGktMDLaMqxDxqjm5IJZ7DpSLtBEsR23uwGzTFhQKdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781634835; c=relaxed/simple;
	bh=x8Zaoi5E3XtgYfeP6u4lwq12UcoAlE/Oijr7tNXYEgk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MqT1eIA40NOY1tdhM2xCiJ1rxnBOB6jigxLupllISLhbVUF5TZRoSqtMm4qx0nrhcgGXh+zZBDT6JC7KDCVOzSWitXloHtHubgpf7kxnDjnDqO3aN4E+1a7ZcqTXDXG/g+Pm6TQpcKc2fF0rOyRzMECDjRamiPDk8J7WZSg6HCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2EGxiknK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2EGxiknK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DF631F000E9;
	Tue, 16 Jun 2026 18:33:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781634833;
	bh=NrWuLocZNUhD2KB36gt/OCGZ50KEYHtKgkqQqbr5sNQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2EGxiknKdzIw70Es9PvaxViG6DC5LM3VVbazk9x8CduFo0PU1ffzwk8UoHyn1uJ02
	 LNkm+5Nw9deVhhipV+ehMKFShbcnYCqvXa68qxZIwWKlVgHyLKq6PP9PBCcwIFj0JQ
	 8SwGmV81l2GsW962Eudex8kXUC2SJC0GtC7XkT8A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Marcel Holtmann <marcel@holtmann.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 341/411] Bluetooth: hci_sync: Make use of hci_cmd_sync_queue set 2
Date: Tue, 16 Jun 2026 20:29:39 +0530
Message-ID: <20260616145119.364314584@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145100.376842714@linuxfoundation.org>
References: <20260616145100.376842714@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit cba6b758711cab946c787f7c15be92cc749b8e1f ]

This make use of hci_cmd_sync_queue for the following MGMT commands:

Add Advertising
Remove Advertising
Add Extended Advertising Parameters
Add Extended Advertising Data

mgmt-tester -s "Add Advertising"

Test Summary
------------
Add Advertising - Failure: LE off                    Passed
Add Advertising - Invalid Params 1 (AD too long)     Passed
Add Advertising - Invalid Params 2 (Malformed len)   Passed
Add Advertising - Invalid Params 3 (Malformed len)   Passed
Add Advertising - Invalid Params 4 (Malformed len)   Passed
Add Advertising - Invalid Params 5 (AD too long)     Passed
Add Advertising - Invalid Params 6 (ScRsp too long)  Passed
Add Advertising - Invalid Params 7 (Malformed len)   Passed
Add Advertising - Invalid Params 8 (Malformed len)   Passed
Add Advertising - Invalid Params 9 (Malformed len)   Passed
Add Advertising - Invalid Params 10 (ScRsp too long) Passed
Add Advertising - Rejected (Timeout, !Powered)       Passed
Add Advertising - Success 1 (Powered, Add Adv Inst)  Passed
Add Advertising - Success 2 (!Powered, Add Adv Inst) Passed
Add Advertising - Success 3 (!Powered, Adv Enable)   Passed
Add Advertising - Success 4 (Set Adv on override)    Passed
Add Advertising - Success 5 (Set Adv off override)   Passed
Add Advertising - Success 6 (Scan Rsp Dta, Adv ok)   Passed
Add Advertising - Success 7 (Scan Rsp Dta, Scan ok)  Passed
Add Advertising - Success 8 (Connectable Flag)       Passed
Add Advertising - Success 9 (General Discov Flag)    Passed
Add Advertising - Success 10 (Limited Discov Flag)   Passed
Add Advertising - Success 11 (Managed Flags)         Passed
Add Advertising - Success 12 (TX Power Flag)         Passed
Add Advertising - Success 13 (ADV_SCAN_IND)          Passed
Add Advertising - Success 14 (ADV_NONCONN_IND)       Passed
Add Advertising - Success 15 (ADV_IND)               Passed
Add Advertising - Success 16 (Connectable -> on)     Passed
Add Advertising - Success 17 (Connectable -> off)    Passed
Add Advertising - Success 18 (Power -> off, Remove)  Passed
Add Advertising - Success 19 (Power -> off, Keep)    Passed
Add Advertising - Success 20 (Add Adv override)      Passed
Add Advertising - Success 21 (Timeout expires)       Passed
Add Advertising - Success 22 (LE -> off, Remove)     Passed
Add Advertising - Success (Empty ScRsp)              Passed
Add Advertising - Success (ScRsp only)               Passed
Add Advertising - Invalid Params (ScRsp too long)    Passed
Add Advertising - Success (ScRsp appear)             Passed
Add Advertising - Invalid Params (ScRsp appear long) Passed
Add Advertising - Success (Appear is null)           Passed
Add Advertising - Success (Name is null)             Passed
Add Advertising - Success (Complete name)            Passed
Add Advertising - Success (Shortened name)           Passed
Add Advertising - Success (Short name)               Passed
Add Advertising - Success (Name + data)              Passed
Add Advertising - Invalid Params (Name + data)       Passed
Add Advertising - Success (Name+data+appear)         Passed
Total: 47, Passed: 47 (100.0%), Failed: 0, Not Run: 0
Overall execution time: 2.17 seconds

mgmt-tester -s "Remove Advertising"

Test Summary
------------
Remove Advertising - Invalid Params 1                Passed
Remove Advertising - Success 1                       Passed
Remove Advertising - Success 2                       Passed
Total: 3, Passed: 3 (100.0%), Failed: 0, Not Run: 0
Overall execution time: 0.0585 seconds

mgmt-tester -s "Ext Adv MGMT Params"

Test Summary:
------------
Ext Adv MGMT Params - Unpowered                      Passed
Ext Adv MGMT Params - Invalid parameters             Passed
Ext Adv MGMT Params - Success                        Passed
Ext Adv MGMT Params - (5.0) Success                  Passed
Total: 4, Passed: 4 (100.0%), Failed: 0, Not Run: 0
Overall execution time: 0.0746 seconds

mgmt-tester -s "Ext Adv MGMT -"

Test Summary
------------
Ext Adv MGMT - Data set without Params               Passed
Ext Adv MGMT - AD Data (5.0) Invalid parameters      Passed
Ext Adv MGMT - AD Data (5.0) Success                 Passed
Ext Adv MGMT - AD Scan Response (5.0) Success        Passed
Total: 4, Passed: 4 (100.0%), Failed: 0, Not Run: 0
Overall execution time: 0.0805 seconds

Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Stable-dep-of: d3f7d17960ed ("Bluetooth: MGMT: validate Add Extended Advertising Data length")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/mgmt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -8078,12 +8078,12 @@ static int add_ext_adv_data(struct sock
 {
 	struct mgmt_cp_add_ext_adv_data *cp = data;
 	struct mgmt_rp_add_ext_adv_data rp;
+	struct hci_request req;
 	u8 schedule_instance = 0;
 	struct adv_info *next_instance;
 	struct adv_info *adv_instance;
 	int err = 0;
 	struct mgmt_pending_cmd *cmd;
-	struct hci_request req;
 
 	BT_DBG("%s", hdev->name);
 


