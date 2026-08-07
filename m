Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B8512E736E;
	Fri,  7 Aug 2026 14:48:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114131; cv=none; b=dVJ7cSuv3bDITXA2aNxKuSwHBDYRjpG1jk/2GFN/kF0QUgpCqcVZQAs5NtJ+ZM1rlyuoUDF5NqNIuipZH1chXcsG9RPqvWr7xF/gAPjAvLjBOhkIS8dUb0JW+vjXgl8It5eemZN139FsJBgragI94rVPXR8QpfD6YYKmIg2ludo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114131; c=relaxed/simple;
	bh=Bz64UxOfwCYu7XeeSS5Ylp/pEKeRiTfcNp8kltk81Tk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LoFcD2hoMSBNLHQS4pDK0SeV2ll1lcWaHfTTMA8FDLMdEdsC5FLKwOVpavJwHYCOkypY+4UOPer5cQck8AmwsQhFz4GNMpKb+lhJQJv4VWEicuwXDw6XO6QraOlC/T+mWEFZO5VUFK3bDBXfXkvGc6VaWo+TEkm2wa/uaC1rQU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xqjYVqel; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xqjYVqel"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44C421F000E9;
	Fri,  7 Aug 2026 14:48:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114127;
	bh=R3hcBZWiUmHGS5xeA+jpHSREw+hsvY4DyuLo5dkohMc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xqjYVqel27fRBV0QiOFxWsIf3EV7yF1q7yPnTJsqYE5XR8/NiDghVV5IJu1qLFnyo
	 Y+KfRpwKxbqp7Oyr2zmC3kfYA7YcljJj6k46JsjVbnkkZJJKUkU4jAAeHqjOy27QvG
	 b1hnNN/XrbDCISDLp5Y908d+TI7j59O1nknx7xUw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sangho Lee <kudo3228@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.12 153/337] Bluetooth: HIDP: validate numbered report payloads
Date: Fri,  7 Aug 2026 16:35:56 +0200
Message-ID: <20260807143421.868865177@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
References: <20260807143418.516897842@linuxfoundation.org>
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


