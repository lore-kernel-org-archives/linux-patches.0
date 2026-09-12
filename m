Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14B2E32824B;
	Sat, 12 Sep 2026 16:40:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789231250; cv=none; b=AN7DHqK98AsZwKPqz72ohwAY01C/TZB62S64N2A1kHmRgRpYYg9UdTZzAkT06jEgqaeffW3O36qyd9SdMy4b4JGz/2m2cPq4xzmYW86kv4yxSV7cbZPlYbk9uiZvXtViV1NL86wNHbnkGZ2F7+hYT3UnyNGjM9T3FU0SY6tURfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789231250; c=relaxed/simple;
	bh=GLdqPFckQtZOD8fr16q/40WBontUUAmJlwjRehuasUA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rAQ9X7PWPo9ps1KoiwyXbM3wNHRQurf2Gxxixkf8zRXEnRrOIQ6+cLaD9iSmbj1un2AeRmJrhyBlLEq1HPffB9xT1fPl22gjE82oAP9kwdHtBkNQLAK9P9wSMaPrCiyd78SFM7kRZjnXf2evtPmVFgDdRCX4NKguWMbybn3aqkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bx5v8EvC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bx5v8EvC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA9D91F000FF;
	Sat, 12 Sep 2026 16:40:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789231249;
	bh=1hh1cL6FltJqTwJsCwCQTj+bMtIW8wGnzbSuJ+K0veU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bx5v8EvC4maCuDSSAaqs+XtS35ZvH93qHYLoOKElEQ2CvuP67lGDSRHpMAHU3ZF29
	 9QUmYtU+h/lOeB0jd2OKHrJ++gOOlIywTwXTLzzm+UAE+qsmM/XT1oqJtOUFSBwn2D
	 7ecYS/dkvAUYv1Kw5XRRpNwDE7ohi99pV27Owdqc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Zijun Hu <zijun.hu@oss.qualcomm.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0923/1191] Bluetooth: btqca: Fix qca_set_bdaddr() waiting for wrong HCI event
Date: Sat, 12 Sep 2026 09:00:51 +0200
Message-ID: <20260912065608.963745761@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

From: Zijun Hu <zijun.hu@oss.qualcomm.com>

[ Upstream commit cf81f0a3db2a5c34ee6e4ea379c631fab6d13e01 ]

qca_set_bdaddr() waits for HCI_EV_VENDOR when sending
EDL_WRITE_BD_ADDR_OPCODE (0xFC14), but the controller responds with
Command Complete event as confirmed by btmon on WCN7850:

  < HCI Command: Vendor (0x3f|0x0014) plen 6                    #3 [hci0]
          11 22 33 44 55 66
  > HCI Event: Command Complete (0x0e) plen 4                    #4 [hci0]
        Vendor (0x3f|0x0014) ncmd 1
          Status: Success (0x00)

Fix by passing 0 as the event parameter to __hci_cmd_sync_ev() to
wait for the command complete event instead.

Fixes: 5c0a1001c8be ("Bluetooth: hci_qca: Add helper to set device address")
Reviewed-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Zijun Hu <zijun.hu@oss.qualcomm.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btqca.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/bluetooth/btqca.c b/drivers/bluetooth/btqca.c
index 09ef7df5c231b..a5f80e4aa0e26 100644
--- a/drivers/bluetooth/btqca.c
+++ b/drivers/bluetooth/btqca.c
@@ -1018,8 +1018,7 @@ int qca_set_bdaddr(struct hci_dev *hdev, const bdaddr_t *bdaddr)
 	baswap(&bdaddr_swapped, bdaddr);
 
 	skb = __hci_cmd_sync_ev(hdev, EDL_WRITE_BD_ADDR_OPCODE, 6,
-				&bdaddr_swapped, HCI_EV_VENDOR,
-				HCI_INIT_TIMEOUT);
+				&bdaddr_swapped, 0, HCI_INIT_TIMEOUT);
 	if (IS_ERR(skb)) {
 		err = PTR_ERR(skb);
 		bt_dev_err(hdev, "QCA Change address cmd failed (%d)", err);
-- 
2.53.0



