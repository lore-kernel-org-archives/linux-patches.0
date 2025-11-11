Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E7152DC32A;
	Tue, 11 Nov 2025 01:14:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823695; cv=none; b=Vs/GW/lByt0dulNZSXX5k8QayAGPK5DREP+YcIEz17I3ryJvUGy2TRqISYn8r78qleO4l5t8PT/zY0DfT30D/SgZ92iLwQpjTPB1+caTDdK6AwbfsiTBhZ/J9/ThZ1R9TCX/ZKLP0PwufRj4FsviOpmfcIPTdrIM1WO3Rhxm2aQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823695; c=relaxed/simple;
	bh=bufA4e2q/eVbxe+KPHeiCSO1uaFVFqfuiJ6n/Fz13GM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rROy5UWOMl9BfZFcKfzxOUklYMSPD0atkRhuFx3Gf0+IN4Xt1xPD8HfElUU79FqotXYzmo7T2rxul9p/pM7i9Ur0l6sWgOlWzC2r+GAddM9ornDXymHNEZogeTwaJ+Se/0olQtovLQXwb+b7PQXHhHEliab+XGgkanuFjJinpRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=POuAzF/O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="POuAzF/O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E698C19422;
	Tue, 11 Nov 2025 01:14:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823695;
	bh=bufA4e2q/eVbxe+KPHeiCSO1uaFVFqfuiJ6n/Fz13GM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=POuAzF/O3UEJuGtwBlnOwqqLa5kGTNlowTyv9RsLUFhaCg6ZT8ma1IAg55YZ3vtv8
	 X78BTS22/V9s/DDqoeZOQlq25edgYaYTINs/zAH0ZEvDn/eY3Dj3M2DV2vnhxGd2DK
	 WI9FZfmGSMj+A4t1W+Gb5iBji15PLlqDva/7ueD0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Colin Foster <colin.foster@in-advantage.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 302/565] smsc911x: add second read of EEPROM mac when possible corruption seen
Date: Tue, 11 Nov 2025 09:42:38 +0900
Message-ID: <20251111004533.671982343@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Colin Foster <colin.foster@in-advantage.com>

[ Upstream commit 69777753a8919b0b8313c856e707e1d1fe5ced85 ]

When the EEPROM MAC is read by way of ADDRH, it can return all 0s the
first time. Subsequent reads succeed.

This is fully reproduceable on the Phytec PCM049 SOM.

Re-read the ADDRH when this behaviour is observed, in an attempt to
correctly apply the EEPROM MAC address.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
Link: https://patch.msgid.link/20250903132610.966787-1-colin.foster@in-advantage.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/smsc/smsc911x.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/smsc/smsc911x.c b/drivers/net/ethernet/smsc/smsc911x.c
index 74f1ccc964599..7e8cad0515e86 100644
--- a/drivers/net/ethernet/smsc/smsc911x.c
+++ b/drivers/net/ethernet/smsc/smsc911x.c
@@ -2163,10 +2163,20 @@ static const struct net_device_ops smsc911x_netdev_ops = {
 static void smsc911x_read_mac_address(struct net_device *dev)
 {
 	struct smsc911x_data *pdata = netdev_priv(dev);
-	u32 mac_high16 = smsc911x_mac_read(pdata, ADDRH);
-	u32 mac_low32 = smsc911x_mac_read(pdata, ADDRL);
+	u32 mac_high16, mac_low32;
 	u8 addr[ETH_ALEN];
 
+	mac_high16 = smsc911x_mac_read(pdata, ADDRH);
+	mac_low32 = smsc911x_mac_read(pdata, ADDRL);
+
+	/* The first mac_read in some setups can incorrectly read 0. Re-read it
+	 * to get the full MAC if this is observed.
+	 */
+	if (mac_high16 == 0) {
+		SMSC_TRACE(pdata, probe, "Re-read MAC ADDRH\n");
+		mac_high16 = smsc911x_mac_read(pdata, ADDRH);
+	}
+
 	addr[0] = (u8)(mac_low32);
 	addr[1] = (u8)(mac_low32 >> 8);
 	addr[2] = (u8)(mac_low32 >> 16);
-- 
2.51.0



