Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7229E35AC3E;
	Tue, 16 Jun 2026 16:46:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781628376; cv=none; b=Nw+Uy13a/oZw6jfMCC5IFAR4o3T/8V4RVnYCVG+ldeyZEYhMlyn6B8VUDpF8xCpE+g5+YpkkxpXHPYunYJiUh2sjWyJ7xWR3jWM/0j+JusLpfJuwvsYCiQxj1j0A2JCNfvkjWGRQfWQPFhVJ64hI/mj023nArrm7OYX4xzp8jks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781628376; c=relaxed/simple;
	bh=c8ZR65HCrnGd4fyk3vaXuqE+bCRZr9qA1IO7XHk85Jk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=swcH/mpfnfEgqCtKBhDBSJHANNHWG2HPAmkgIfjeD6gq1/axqpanqtM+6wGVogGfwSfD6WMBGyHaPk/kC6K5YhsqGwhHi71Q98yJty/5Ll6ZEnEXqHBOowZvbIW84nA7I9ZyAL8PwJKvFNBxOp94AXLCDzZ5aDJ2fcCtTt7cI+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AY0heq+/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AY0heq+/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 755C81F00A3A;
	Tue, 16 Jun 2026 16:46:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781628375;
	bh=vPY06TTsJBu1WlEyDaShrCFdoLZw2QLMCu2RZaZqDbk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AY0heq+/LPxcbzi59ms89lI27yA4EPM/1MvFM7EiLD7mcOQJ+3jlAtaTdWwAkhnlz
	 yirMv5NF0wOdBYL5I5eO90ByTpAn8qoGWxAD1Q9wemWNO4cmKCXUE/VZTAMsxdBN+6
	 /NUaB812in6eU+HdlUf02WI4Ox12czAzOE9+B9Sk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pooja Katiyar <pooja.katiyar@intel.com>,
	Johan Hovold <johan@kernel.org>,
	stable <stable@kernel.org>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 6.6 084/452] usb: typec: ucsi: displayport: NAK DP_CMD_CONFIGURE without a payload VDO
Date: Tue, 16 Jun 2026 20:25:11 +0530
Message-ID: <20260616145122.276625645@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


