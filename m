Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F3FD3D8125;
	Tue, 16 Jun 2026 18:11:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781633498; cv=none; b=b6xe+hk3xTSLaEGtfezONcNRNavCgrKSkGprDu82wROb8UGBSDSSSQGd+5BY0/kZLeu3UFHPyahqQ8aReIgqFzbpP6cFlsdr8gsdHwj4D1UrLuDEEqA7ugVE1dN96TMogJIZyB1zYYatDtk18bde0qxMFR4L2+mKVi8A2zElCTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781633498; c=relaxed/simple;
	bh=nN12wk0370q6BTku3SLslm6dT0VA/tb/+YPOo3lAcoA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sOuZf/Nd1M0zzW5Z4snBQDlS7WIuOE4RPGuIZpOfxMNf32pR7OtLNSBKg1pObWXV+CNSbMtWC0MPU5GjXtrMBoNndnFZeUHvOAkRRyXsF5pG7Mo50Hp3QGT528tHjd/LgiEoT3OTa6OlllfeQ5onB7YkaUCTE5rnEab6gp47YsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1tT5HAPU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1tT5HAPU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B0E11F000E9;
	Tue, 16 Jun 2026 18:11:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781633497;
	bh=2Li4RzrfXdeQO8miKKoACVpfnoGFjrEDdZK3UWa4xUo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1tT5HAPUNjpIEAOSCZbA4Gg6+dQiJb4CeOO8f+58Jw1zVV3UCiwXlSbgsuNc1k/Dc
	 62f2NttaXMG4xP96wFOnpVQmL/RgxUIu96Sbd8gqBl007CxIJG7aiUtWge2pnBk2dB
	 2d1GgZxwfFr5KAbSX6qBvnBITAQ0/9d26uTwf8N8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pooja Katiyar <pooja.katiyar@intel.com>,
	Johan Hovold <johan@kernel.org>,
	stable <stable@kernel.org>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 5.15 057/411] usb: typec: ucsi: displayport: NAK DP_CMD_CONFIGURE without a payload VDO
Date: Tue, 16 Jun 2026 20:24:55 +0530
Message-ID: <20260616145103.311911976@linuxfoundation.org>
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

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 167dd8d12226587ee554f520aed0256b7769cd5d upstream.

ucsi_displayport_vdm() handles a DP_CMD_CONFIGURE by copying the first
payload VDO from data[], but unlike the equivalent handler in
altmodes/displayport.c it does not check that count covers a VDO beyond
the header.  A header-only Configure VDM (count == 1) would read one u32
past the caller's array.

In the normal UCSI path the caller controls count, so this is hardening
for non-standard delivery paths.  NAK and bail when no configuration VDO
is present, matching the generic DP altmode driver's existing guard.

Assisted-by: gkh_clanker_t1000
Cc: Pooja Katiyar <pooja.katiyar@intel.com>
Cc: Johan Hovold <johan@kernel.org>
Cc: stable <stable@kernel.org>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://patch.msgid.link/2026051351-vividly-flattered-eb3d@gregkh
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/ucsi/displayport.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/usb/typec/ucsi/displayport.c
+++ b/drivers/usb/typec/ucsi/displayport.c
@@ -240,6 +240,10 @@ static int ucsi_displayport_vdm(struct t
 				dp->header |= VDO_CMDT(CMDT_RSP_ACK);
 			break;
 		case DP_CMD_CONFIGURE:
+			if (count < 2) {
+				dp->header |= VDO_CMDT(CMDT_RSP_NAK);
+				break;
+			}
 			dp->data.conf = *data;
 			if (ucsi_displayport_configure(dp)) {
 				dp->header |= VDO_CMDT(CMDT_RSP_NAK);


