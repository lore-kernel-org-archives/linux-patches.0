Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049851;
	b=5Tvbn2x9f2plvPzByR6IGkIm6h9kuOZg9FF0gtSdE5OpjcLqXME8x032T5TiPp3iDIS9
	 ejExRDz5fWPZaWyHbLMm0kRYSAQvJpzK3z/9/vDaK21fWng0U291/fLsXZKqYe+Gv7HGy
	 sIIwufX+forbbqXMPRo5rYeri+XEXzL9RaA+2nbtMfuZ6JKbf8552Gpw+I+rLQrMtLr6t
	 ejbxeUUdKOrDrjbXJacq7nooxz+AoiJDZPH4t9fKANenQ+BLApb1TsYeGGhMaeDV3cE10
	 K9mbCA3NnP5Htkyxv59oncRbNDONRSWXF0lqcvvCPtlEglvJphAy4CZMCrDvoJZBxFQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049851;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=V35nLuh9kyOHVniddIm5kmkaJK55Y9Q0tEltm1lnuOk=;
	b=rdFk7OHfGXBEP3daGvsZpfe0plcdQRTFxrPT98M8Mwi2w3fBylUnt8UJFcq1O7BUfqVA
	 oATPCWUH1BLAvi9IUD+ha6seNi/5/kneq/X6ahYnk2HzUrftESPaYbbvluKvkCz0ZIeyJ
	 boMbusFs/KNKzN8w+sXkBjtzhkN3AX91ue3UMQbcBMNHhCQQzYQpWglh/Wez5wUkJnw8Y
	 8tcG/SxWYjatOh+CxMbOfeMIaa5/i4XxO+ZWevv7UDymruo9izUNETyEOlojeMiwsNgVl
	 zYQxlP2EsQE4X8qJvQOgD76vAG0XRsU81BR5Yu6tY2KgiF7+x7Z0e9pNj3naPi7HAuw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oovDsFAA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F3BD606A325;
	Thu, 19 Nov 2026 00:57:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oovDsFAA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0EA41F000C4;
	Thu, 19 Nov 2026 00:57:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049851;
	bh=V35nLuh9kyOHVniddIm5kmkaJK55Y9Q0tEltm1lnuOk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oovDsFAA2f8IYnKFMtRN+oSAra2Ffp/QkgYkIG8YXiGkhlAObWiZOhooEeNOFk1mo
	 ievVmWyUWjbTnW2437fcGehGDccoPlAYyvOhQKzJVpDiQiaX6du6XDZx+O5/GFfNrz
	 xpaJMWKu3ov/3VDH/N1Q38BjOR8nWV/yzBqnjHhk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2492/2857] Bluetooth: MGMT: Fix pending state of instances added without HCI traffic
Date: Wed, 18 Nov 2026 15:58:46 +0100
Message-ID: <20261118150331.292721975@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit 5548fb51aa3cc24545029a286882d261a8e77d8a ]

When Add Advertising completes without HCI communication, e.g. when the
device is not powered or the instance is overridden by Global
Advertising, the instance is left marked as pending, so a subsequent
failure in add_adv_complete would remove it despite it having been
successfully added.

Fix this by clearing the pending state before completing the command.

Fixes: fffd38bca51c ("Bluetooth: mgmt/hci_core: multi-adv for add_advertising*()")
Assisted-by: OpenCode:claude-opus-5.5
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/mgmt.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index a36e04e553386..93728a13ce448 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -8896,6 +8896,12 @@ static int add_advertising(struct sock *sk, struct hci_dev *hdev,
 	if (!hdev_is_powered(hdev) ||
 	    adv_overridden_by_global(hdev, adv) ||
 	    !schedule_instance) {
+		/* Instance has been accepted so it shall no longer be
+		 * considered pending, otherwise a later failure in
+		 * add_adv_complete would remove it.
+		 */
+		adv->pending = false;
+
 		rp.instance = cp->instance;
 		err = mgmt_cmd_complete(sk, hdev->id, MGMT_OP_ADD_ADVERTISING,
 					MGMT_STATUS_SUCCESS, &rp, sizeof(rp));
-- 
2.53.0



