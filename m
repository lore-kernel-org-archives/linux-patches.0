Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC04A217722;
	Tue,  8 Jul 2025 16:26:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751991968; cv=none; b=V4oOrIMEHzKiLdEEX1OhR6+mLVIjWkX27a0mEe554y6uQcrpXlWyaCyMbKR3IA/1CeC3olyyZUF+CXWW1pVJIPLrn0WajER7SQzlO3Jffe3Fa9X8tZq65LkQgfs4QIOB1vMm1zrLo+TnTuOx09EzbWmkiK+tmofRA9JepD/CnMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751991968; c=relaxed/simple;
	bh=UibqEyeogtkArGDoBew0iofIXoAmV/OQ7V3qIGSdetw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HzMFzGs6/4G1p+xY6ZdDW6OxcWln8qzfbs0Y0pTSE/1Y3gqFPVWb+od1uUtPwDY/HDJYM00XPFbU0bX/YNv+AyY6AfguPBYfGqPsX3Py46qjHF1p2MGDQfr/IuSyC0L1MxgXtiZ+0lt92PZgmABzpx/BwuIf7gsHDT6AWok9UyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x9x29Hi0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x9x29Hi0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47384C4CEED;
	Tue,  8 Jul 2025 16:26:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751991968;
	bh=UibqEyeogtkArGDoBew0iofIXoAmV/OQ7V3qIGSdetw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x9x29Hi0EGCgx4mI5xUMYrySZP8eyFVMTReFXgqDaZObOfGtmpMbpwNB44eWxrFe+
	 XgdUy3r4RO7OfcvEHEz60LKdxcmxgyAusxDWBdMoJyqZ2Qvfx2nYpBCUoqO/NUdaNJ
	 VNX4MYOp+8v2A5dqOuNmgG0M7LWXF5u9maaGxoM4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Eggers <ceggers@arri.de>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.1 09/81] Bluetooth: MGMT: mesh_send: check instances prior disabling advertising
Date: Tue,  8 Jul 2025 18:23:01 +0200
Message-ID: <20250708162225.141727913@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162224.795155912@linuxfoundation.org>
References: <20250708162224.795155912@linuxfoundation.org>
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

From: Christian Eggers <ceggers@arri.de>

commit f3cb5676e5c11c896ba647ee309a993e73531588 upstream.

The unconditional call of hci_disable_advertising_sync() in
mesh_send_done_sync() also disables other LE advertisings (non mesh
related).

I am not sure whether this call is required at all, but checking the
adv_instances list (like done at other places) seems to solve the
problem.

Fixes: b338d91703fa ("Bluetooth: Implement support for Mesh")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Eggers <ceggers@arri.de>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/mgmt.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -1085,7 +1085,8 @@ static int mesh_send_done_sync(struct hc
 	struct mgmt_mesh_tx *mesh_tx;
 
 	hci_dev_clear_flag(hdev, HCI_MESH_SENDING);
-	hci_disable_advertising_sync(hdev);
+	if (list_empty(&hdev->adv_instances))
+		hci_disable_advertising_sync(hdev);
 	mesh_tx = mgmt_mesh_next(hdev, NULL);
 
 	if (mesh_tx)


