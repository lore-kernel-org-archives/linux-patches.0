Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E3803BE175;
	Sat, 12 Sep 2026 07:08:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789196922; cv=none; b=aOoUSQe6PriqU/N6QmxdV8JU7Po7TEHZ85VWqWKjR2DzFx/3UdSyHZ/2dTw15fCOXy9hgSm0B/5WjNwR8x3/OmTETuDiOSSBddTNwo9jOQwkOjiRsN90/FqXJOvP4Qiq7FeFc/+lfq1A0qVmd9fHBRuhCQEgZlqwFBNKvYU+2Mk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789196922; c=relaxed/simple;
	bh=UQo1E7/Nf3owOadyCaSZk0hpguanDp4+ZLwKT8v39OM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pRCT7uHhpNHLu7gfYWNGdxYtSmRp6XKtMXULvM8NA55JPsX0lQXlh2Ih1DXF3pYrzoyO2DWmHKFrkjK7EXnE+yuqDTo64nwdslAYYcJaQ4etJF31Pz7fUUkNn/5tFfX/AECehOgm0H219mgyhQ+UR92ijJPuIBJY21VwfVDvUXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QEuMEE3v; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QEuMEE3v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72A9F1F000FF;
	Sat, 12 Sep 2026 07:08:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789196920;
	bh=dynHfwLZ2sGZJ01jTIqw9CpPEfN41bEResp2QA4ElFE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QEuMEE3vc+yayRVTJfoRVPOEjUD6jzmIt62AdHo900etRAUucnMKHTz+Ks8NcMmnr
	 X+mav228MZ7kyuN8pb2A0IF9iWCW4Mj0q0Zc9saB1GI7v2KydoSozAj1Dslc35fChL
	 hmgL3UvDa/JN2sXnKv9Euc6l3pg54Bqe6Hq6G55k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrei Kuchynski <akuchynski@chromium.org>,
	Kaixuan Li <kaixuan.li@ntu.edu.sg>,
	Maoyi Xie <maoyixie.tju@gmail.com>,
	Benson Leung <bleung@chromium.org>,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0064/1815] platform/chrome: cros_ec_typec: Reject out-of-bounds PD cap count
Date: Sat, 12 Sep 2026 08:30:14 +0200
Message-ID: <20260912065650.512063120@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maoyi Xie <maoyixie.tju@gmail.com>

[ Upstream commit a0a8cd9fc9c48b95095bcec4b146f7a99486f58e ]

cros_typec_register_partner_pdos() copies the partner PDOs from the EC
TYPEC_STATUS response into the fixed caps_desc.pdo[PDO_MAX_OBJECTS] array.

	memcpy(caps_desc.pdo, resp->source_cap_pdos,
	       sizeof(u32) * resp->source_cap_count);
	...
	memcpy(caps_desc.pdo, resp->sink_cap_pdos,
	       sizeof(u32) * resp->sink_cap_count);

PDO_MAX_OBJECTS is 7. source_cap_count and sink_cap_count are u8 fields
from the EC. The only check is that they are not both zero. If either is
larger than 7, the memcpy writes past the end of the array on the stack.
A count of 255 overflows it by about 1 KB. The EC source arrays are only
seven entries wide. A larger count reads past them too.

The ChromeOS EC firmware caps these counts today, so a compliant setup
does not hit this. The kernel should still validate these values rather
than trust them.

Validate the counts in cros_typec_register_partner_pdos() next to the
memcpy. Skip the PDO registration if either count is above PDO_MAX_OBJECTS.
The rest of cros_typec_handle_status() still runs so events are handled
and cleared.

Fixes: 348a2e8c93d3 ("platform/chrome: cros_ec_typec: Register partner PDOs")
Suggested-by: Andrei Kuchynski <akuchynski@chromium.org>
Co-developed-by: Kaixuan Li <kaixuan.li@ntu.edu.sg>
Signed-off-by: Kaixuan Li <kaixuan.li@ntu.edu.sg>
Signed-off-by: Maoyi Xie <maoyixie.tju@gmail.com>
Reviewed-by: Benson Leung <bleung@chromium.org>
Reviewed-by: Andrei Kuchynski <akuchynski@chromium.org>
Link: https://lore.kernel.org/r/20260625130056.3378097-1-maoyixie.tju@gmail.com
Signed-off-by: Tzung-Bi Shih <tzungbi@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/chrome/cros_ec_typec.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/platform/chrome/cros_ec_typec.c b/drivers/platform/chrome/cros_ec_typec.c
index c0806c562bb93..50a68819ceb7b 100644
--- a/drivers/platform/chrome/cros_ec_typec.c
+++ b/drivers/platform/chrome/cros_ec_typec.c
@@ -1119,6 +1119,12 @@ static void cros_typec_register_partner_pdos(struct cros_typec_data *typec,
 	if (!resp->source_cap_count && !resp->sink_cap_count)
 		return;
 
+	if (resp->source_cap_count > PDO_MAX_OBJECTS ||
+	    resp->sink_cap_count > PDO_MAX_OBJECTS) {
+		dev_warn(typec->dev, "Invalid PDO count from EC, port: %d\n", port_num);
+		return;
+	}
+
 	port->partner_pd = typec_partner_usb_power_delivery_register(port->partner, &desc);
 	if (IS_ERR(port->partner_pd)) {
 		dev_warn(typec->dev, "Failed to register partner PD device, port: %d\n", port_num);
-- 
2.53.0



