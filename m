Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9144338C437;
	Tue, 16 Jun 2026 18:43:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781635430; cv=none; b=pkrNRdmF+6nW4Cd9uIGuw4EdHjr9ltDRz1+tl8iW8hSN2oCaWGlqkSLta42qWdKr7xmiVuh+wzC3bAjGgtyDoWG1dSNY9M9xhp+6U/C8Or3pLz1FPO+Kg7X8+rrleso8r9KqJFrIc0kAexYTzbL1WjxIrkVx6bO67eg+Fb98sZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781635430; c=relaxed/simple;
	bh=nLGIIPMBDgkq+E9J/1hsiIYb5J6P04uTBWXj32LjXQo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hiCoWw0lLonXMGhpPVyeyABlZDOSwhu4IQBWz3MIxtosLmUfDpmmZ7yIvqcAF5pheQ413EWwmqPoicrdPr5tAG27+VBIKARAlUDEKK+x4XeEF0+sM6KuK6za4ZgRf5TmYoL5HoVHjkRLiZb3X1PiLMt6zLm0zeUnzJViEWAzBAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vzh2OzJn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vzh2OzJn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B2E71F000E9;
	Tue, 16 Jun 2026 18:43:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781635429;
	bh=JtvqrI7tgWhwQMGXGR7+yDwP7MkPu09k2i61khtqMn4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Vzh2OzJnsFQgOgwJFdbZm09cBpp6SWfKi8im2L1rCoO4CxQmdiBPW+XfNPPt1VoiR
	 C3aPJEdmK74HJ7jxNYQ47fv8TcMcSGU6yNXq1ENMYAd/PaaL1OPwSvCID4JLZH0rSO
	 F9WqtKKvz7kVi8zMbHK9Lfc+p9vH/uewV0SChr8w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pooja Katiyar <pooja.katiyar@intel.com>,
	Johan Hovold <johan@kernel.org>,
	stable <stable@kernel.org>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 5.10 046/342] usb: typec: ucsi: displayport: NAK DP_CMD_CONFIGURE without a payload VDO
Date: Tue, 16 Jun 2026 20:25:42 +0530
Message-ID: <20260616145050.408395050@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145048.348037099@linuxfoundation.org>
References: <20260616145048.348037099@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -211,6 +211,10 @@ static int ucsi_displayport_vdm(struct t
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


