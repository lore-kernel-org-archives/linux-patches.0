Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4F8B47ACD0;
	Sat, 12 Sep 2026 12:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789214415; cv=none; b=s76sjTmxRFrztagqzCxHq0E5+qHPNaKbEvFV46Fy6d5Wwb17QGgmnBR5JhuU9h7CflIBY7KIWI6EJixJoj0z15PB+7cDf6oZ5XscgLGiKNWpV/z+IUsFhIxza17iFyfZdIP/ETb+lX09ZCHgIkqRKw7VuyXIxfHGZXXmSdKJd9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789214415; c=relaxed/simple;
	bh=RxXaqqW++xDUsHg9Guk72mpWbRyAfC1I+qyFJT6gNOk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IlN1NpRC2EWmkhc9Ft8lXDh+J2CQ0iAnysm8r+AfcvKWk6BvifD1khZmpYam0FOou52VSyCBU7mVkhhD509zWg5tweCDVWZfrE1tN/58MkcCnT0GTy3Z+qJYrYCv7uywKj8q0X9To0l6ZL41QzauU+jt9sy/BHSLAX9p7aBRl60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hyADbmV9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hyADbmV9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D6111F000FF;
	Sat, 12 Sep 2026 12:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789214413;
	bh=uNtdmFfUFYBcXJIIi81Nez/EKUvbjO0+fbhr+tQNRj4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hyADbmV9Zwo1qZuyt1ufQTrhUMboBUonUoz1xhpN0ja8dLhMsNUoQ//0pBQlLAiCP
	 ZMNY5Q4W2aTEsiLKlhEr+khEi7qrb1OFKy7IbC1m1WGEe0Qjyvyyn7a4L+65czq12u
	 0Shkjy/rDPZG1IiREmUxwDyM7y113tSjFQJdEUhg=
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
Subject: [PATCH 6.12 0320/1376] platform/chrome: cros_ec_typec: Reject out-of-bounds PD cap count
Date: Sat, 12 Sep 2026 08:45:46 +0200
Message-ID: <20260912065614.680545406@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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
index ca665b901010e..8c0b814973c04 100644
--- a/drivers/platform/chrome/cros_ec_typec.c
+++ b/drivers/platform/chrome/cros_ec_typec.c
@@ -989,6 +989,12 @@ static void cros_typec_register_partner_pdos(struct cros_typec_data *typec,
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



