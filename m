Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7F201C84D0;
	Fri,  7 Aug 2026 15:21:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116091; cv=none; b=kwxrJCxqun48Jyv01XtsDMiS/MtrU470E0odvPI0n72ezTiYLOqJa9c3wLiVUhEgcGQprMV8TUXS2FPqJe+dL1mBajmM73+OkHb3nfEHaO5+q9+ewgq8Y9Oj1gLAkEvb6nhz+2HEjcQduHFF5kRB/gpCuX7+IFuvi8ZHeYaXH60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116091; c=relaxed/simple;
	bh=DL/7697ByndPh3BvyK+fYpeHQ/g5QZt43hawAZv8yv8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uATV+v7hAdAO1M88thJZd/FE03I7xA9r+5yFw/95ymXTDD/nG0UgxkcO+wokjl4HSc89hy+AAwdqDDtwtujFOj6OAl1/Cwf218iE4m6ER49oTvy41pzTFcvdMj7e4EgHql8kSB/tb/qeu2Yz9/0eKQ32V6MbubUc9y1LqhQNlqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DZz24qvf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DZz24qvf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C9401F000E9;
	Fri,  7 Aug 2026 15:21:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116090;
	bh=xNw+sS0oRjlGuiTSTQYT5/LBPEOtyr1fkBxNHZW4w9o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DZz24qvfaZTdroRC6+SxiETO/cDYEqrCF8ypqt/38vDf1Aj5yR8uqpMSuuPZwWxkV
	 3vDOT4Mdn6rxc1V56Gv0PAW6FDVyedoU2DDCM4SLIsv0uldi9XMDC84dbvKCplnd3T
	 Q4C/Q5nl3Bof9rEDt10XQMUvfePD9Om/TrmX21p0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sangho Lee <kudo3228@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.6 107/261] Bluetooth: HIDP: validate numbered report payloads
Date: Fri,  7 Aug 2026 16:37:44 +0200
Message-ID: <20260807143417.687725404@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143415.358597922@linuxfoundation.org>
References: <20260807143415.358597922@linuxfoundation.org>
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

From: Sangho Lee <kudo3228@gmail.com>

commit 34f53d27b81a16a02828c8fdfa4e02badc326f17 upstream.

When hidp_get_raw_report() waits for a numbered report,
hidp_process_data() compares the expected report number with skb->data[0].
A connected HIDP peer can reply with only a DATA transaction header,
leaving the skb empty after the header is removed.

KMSAN reports an uninitialized-value use in hidp_session_run(), with the
value originating in __alloc_skb() through vhci_write(). The transaction
header checks remove the empty-frame reports, but this report remains until
the payload check is added.

The comparison can also consume a peer-controlled byte beyond the declared
L2CAP PDU. A DATA | FEATURE response followed by an extra 0x01 byte made
the current code accept that byte as report ID 1 and complete
HIDIOCGFEATURE with a zero-byte result. With this change the malformed
response is rejected with -EIO, while a subsequent valid response still
succeeds.

Require a payload byte before comparing a numbered report ID. Unnumbered
reports continue to accept an empty payload.

Fixes: 0ff1731a1ae5 ("HID: bt: Add support for hidraw HIDIOCGFEATURE and HIDIOCSFEATURE")
Cc: stable@vger.kernel.org
Signed-off-by: Sangho Lee <kudo3228@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/hidp/core.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/net/bluetooth/hidp/core.c
+++ b/net/bluetooth/hidp/core.c
@@ -546,9 +546,10 @@ static int hidp_process_data(struct hidp
 	}
 
 	if (test_bit(HIDP_WAITING_FOR_RETURN, &session->flags) &&
-				param == session->waiting_report_type) {
+	    param == session->waiting_report_type) {
 		if (session->waiting_report_number < 0 ||
-		    session->waiting_report_number == skb->data[0]) {
+		    (skb->len &&
+		     session->waiting_report_number == skb->data[0])) {
 			/* hidp_get_raw_report() is waiting on this report. */
 			session->report_return = skb;
 			done_with_skb = 0;


