Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 759541E4B1;
	Mon, 15 Apr 2024 14:36:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191791; cv=none; b=SS8s+3Z3hhXZygQIyK+vcOdhc1Tk7PIA1CVE4o9IIXlOJm/RKfq363z4XSSw9bVEQn+m3mQtO+3Q+X+91flYUlaIECcrUM71OOT1ZV8b9iQH6dZinr0PLtZRZeLc/d4uksuwv83CC7gEDcK0hlubohn2bSZi9d0XiHRa3cs0qJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191791; c=relaxed/simple;
	bh=LQj7z7i/PDxDsOBdcJs5Xayy7eWgu6qEcOKfavqY1gU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r8zgJir28wbOiEs+GeMAFoCpMayNu207KYzI2QIbXhQ7WEAAPTx1D1jng4908qC+eSk/JLWgfjzC8O+u2kpmiou//CjS6IkmJkQQODwiGRpnyEsKxITQ1+G9Fr9L/UDTU/AhZaDQVnUeAHSMb0EtfjjcPdLwLojMJmTw+vRV9SE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tAWyvVIA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tAWyvVIA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFEDCC113CC;
	Mon, 15 Apr 2024 14:36:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191791;
	bh=LQj7z7i/PDxDsOBdcJs5Xayy7eWgu6qEcOKfavqY1gU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tAWyvVIA/gVO1sAlCJKnRpz7B5e6+a6kQKtB4rfEWfQIlFXoeeQceId++AS73/Dbt
	 dGr4WMPjn9PCC4QQHOX7z5sduQrN0Autu+SIVJgEbeZ9+FKlaaRTwImsyXXovPQnoI
	 gfDeS4u6EZELSCdsD/Fu9LrAl/6YUut9gGFC/x7g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 049/122] Bluetooth: ISO: Dont reject BT_ISO_QOS if parameters are unset
Date: Mon, 15 Apr 2024 16:20:14 +0200
Message-ID: <20240415141954.845594190@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141953.365222063@linuxfoundation.org>
References: <20240415141953.365222063@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit b37cab587aa3c9ab29c6b10aa55627dad713011f ]

Consider certain values (0x00) as unset and load proper default if
an application has not set them properly.

Fixes: 0fe8c8d07134 ("Bluetooth: Split bt_iso_qos into dedicated structures")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/iso.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/net/bluetooth/iso.c b/net/bluetooth/iso.c
index 698d0b67c7ed4..2f63ea9e62ecd 100644
--- a/net/bluetooth/iso.c
+++ b/net/bluetooth/iso.c
@@ -1301,8 +1301,8 @@ static bool check_ucast_qos(struct bt_iso_qos *qos)
 
 static bool check_bcast_qos(struct bt_iso_qos *qos)
 {
-	if (qos->bcast.sync_factor == 0x00)
-		return false;
+	if (!qos->bcast.sync_factor)
+		qos->bcast.sync_factor = 0x01;
 
 	if (qos->bcast.packing > 0x01)
 		return false;
@@ -1325,6 +1325,9 @@ static bool check_bcast_qos(struct bt_iso_qos *qos)
 	if (qos->bcast.skip > 0x01f3)
 		return false;
 
+	if (!qos->bcast.sync_timeout)
+		qos->bcast.sync_timeout = BT_ISO_SYNC_TIMEOUT;
+
 	if (qos->bcast.sync_timeout < 0x000a || qos->bcast.sync_timeout > 0x4000)
 		return false;
 
@@ -1334,6 +1337,9 @@ static bool check_bcast_qos(struct bt_iso_qos *qos)
 	if (qos->bcast.mse > 0x1f)
 		return false;
 
+	if (!qos->bcast.timeout)
+		qos->bcast.sync_timeout = BT_ISO_SYNC_TIMEOUT;
+
 	if (qos->bcast.timeout < 0x000a || qos->bcast.timeout > 0x4000)
 		return false;
 
-- 
2.43.0



