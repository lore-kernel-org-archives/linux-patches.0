Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D2C43ABD99;
	Mon, 17 Aug 2026 15:18:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979929; cv=none; b=LYD67S6+jBkzNSHatpS03gtDhw0cJEW/rLLMKB1Lqd+q1gghtgiGwYXpyK/IUGNljC+IXRgHxPFsg+DlgVFHMLpj5T9oTGBgDm0U3JdvxF1U/Xo6LdAo7IfvJwgKQIshu/bR0QhwSsTVeg/DBJ1mQcYv8Bm55qxxxuyXwMMPP94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979929; c=relaxed/simple;
	bh=YXishAGw+5+KypKHgyX7ETmi0ELjsnMALNXPsyr/dNg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QfJQConWfceJPmW+EHNlwlCwxU2O+gf9dJWxJ39ExYVcPQwF0cFSMWCK62yaDIShAn9MlH4+4Xy8Vs95NrEb8hJoFjCEFZDP65fCOPTjeI7ZVddxrDfq9qZbcV9Tg3dwBEVUzX37c2DjdDC+q1JOaaDBu+4MGdJEo+X7g1Cosvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dENHLUeR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dENHLUeR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86C311F000E9;
	Mon, 17 Aug 2026 15:18:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979928;
	bh=c/lTWlDs1L1lKIjW8kRgBHhGMUS0ov4V/BoDlsR+vSU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dENHLUeRFA0z+0vXsDNIj15NprYaYQ+gVnJ7Y7Q6Ez+5A+OHR+F4NDZuYy7+VhG5v
	 RAKnlynD9Yna2h5tOY2YgTR0+DQBoytG2fSkQhDIL6Eo5CxqFNFZC+8GsMsAipZNCK
	 Iougq6UhHgE0vg9SMmwekn41qa80yva+cFltO+0w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sangho Lee <kudo3228@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.1 395/609] Bluetooth: HIDP: validate numbered report payloads
Date: Mon, 17 Aug 2026 15:31:31 +0200
Message-ID: <20260817132557.444323180@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


