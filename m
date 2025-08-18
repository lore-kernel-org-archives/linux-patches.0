Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F80321507C;
	Mon, 18 Aug 2025 14:02:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525759; cv=none; b=hjv2k2blqeg9dly77/BwBj/i+nwV69PXabqoM9i2CamAuoExQajwirJHXGNbcxVTNnBM2qSxww1FgTy8mmcy/c+WtJXHls1D4PaECGEGdOS2LCwRQxD+GmYDt6RD3lZo4n0ZRTejjMWZq6OAryS1VGkqV8rdzV9Izi97CmxPCHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525759; c=relaxed/simple;
	bh=vPQT1dat0dEnnB4U4wANiBukb1+1tlCREUO10Rzg1r0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MdLUBofMsPUbL/ACxR16QGBBdIy/CqY97WjWYpMjdkRJg2oWOqB8AhiKi72bbRn8nLm5X568pcw7aogIt1IFHd/3x/x5tRomuore/xCX1AG96Uh2rFEkekbSKbFZUkuyHmzIXbLcsMf0UPY39R7dTD3F94ct38UCi99aKtuRWxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VSiZiQF5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VSiZiQF5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA5D5C4CEEB;
	Mon, 18 Aug 2025 14:02:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525759;
	bh=vPQT1dat0dEnnB4U4wANiBukb1+1tlCREUO10Rzg1r0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VSiZiQF5Oowo0qZpklOcc/MuLr6IEY3DrxSp0aNRRAqB6/o0I3Y6dGAkaDmxjeVL1
	 EkqUfo/bPGOGbZ34ERjwNXEKmVKN05Lw0JXr6WYY80zXSkEInkG7fHH0ZoPrOkd/e9
	 ElOpF0qezOjo7FykKXa25XGrTiK6RgqCL3SxcDPY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hari Kalavakunta <kalavakunta.hari.prasad@gmail.com>,
	Paul Fertser <fercerpav@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 341/570] net: ncsi: Fix buffer overflow in fetching version id
Date: Mon, 18 Aug 2025 14:45:28 +0200
Message-ID: <20250818124518.990208138@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hari Kalavakunta <kalavakunta.hari.prasad@gmail.com>

[ Upstream commit 8e16170ae972c7fed132bc928914a2ffb94690fc ]

In NC-SI spec v1.2 section 8.4.44.2, the firmware name doesn't
need to be null terminated while its size occupies the full size
of the field. Fix the buffer overflow issue by adding one
additional byte for null terminator.

Signed-off-by: Hari Kalavakunta <kalavakunta.hari.prasad@gmail.com>
Reviewed-by: Paul Fertser <fercerpav@gmail.com>
Link: https://patch.msgid.link/20250610193338.1368-1-kalavakunta.hari.prasad@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ncsi/internal.h | 2 +-
 net/ncsi/ncsi-rsp.c | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ncsi/internal.h b/net/ncsi/internal.h
index e76c6de0c784..adee6dcabdc3 100644
--- a/net/ncsi/internal.h
+++ b/net/ncsi/internal.h
@@ -110,7 +110,7 @@ struct ncsi_channel_version {
 	u8   update;		/* NCSI version update */
 	char alpha1;		/* NCSI version alpha1 */
 	char alpha2;		/* NCSI version alpha2 */
-	u8  fw_name[12];	/* Firmware name string                */
+	u8  fw_name[12 + 1];	/* Firmware name string                */
 	u32 fw_version;		/* Firmware version                   */
 	u16 pci_ids[4];		/* PCI identification                 */
 	u32 mf_id;		/* Manufacture ID                     */
diff --git a/net/ncsi/ncsi-rsp.c b/net/ncsi/ncsi-rsp.c
index 472cc68ad86f..271ec6c3929e 100644
--- a/net/ncsi/ncsi-rsp.c
+++ b/net/ncsi/ncsi-rsp.c
@@ -775,6 +775,7 @@ static int ncsi_rsp_handler_gvi(struct ncsi_request *nr)
 	ncv->alpha1 = rsp->alpha1;
 	ncv->alpha2 = rsp->alpha2;
 	memcpy(ncv->fw_name, rsp->fw_name, 12);
+	ncv->fw_name[12] = '\0';
 	ncv->fw_version = ntohl(rsp->fw_version);
 	for (i = 0; i < ARRAY_SIZE(ncv->pci_ids); i++)
 		ncv->pci_ids[i] = ntohs(rsp->pci_ids[i]);
-- 
2.39.5



