Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23D94331200;
	Fri,  7 Aug 2026 15:06:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115207; cv=none; b=a/UdzKOaQSMQTnYfBLS0RLB24+2Q/h5Vaneezm3+1Fqrdaf18ClJIR3OmRpSOZWy6BFs4kh4pCT65Vnk6xAadCXtcACjU+4f6hF6zHptK2FCwU8CiLSVZtRnouNnWaAp7v4XfOys/7uANEqWgzXUFJRPAhdcyCqsaAiPnfHJWn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115207; c=relaxed/simple;
	bh=74A2t1Ly8eLX1UQ3WHof+kkCE2y5ujGrHNU/+eZ0ty0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=joFOJ79tfcb+RQsKkQa24RT+erqLdbxRae0RFKZmMTUwcx8dJpbPbCFyEwVQmLJm/WD3ybvvJkk2KBjaEkx8TedVtfM52mSEiUa9pFbGClawSTilr0079IS8z0VFXDI5Ae7MXqL55HVrqN3OZ3K3FK4UCNcg0f4mp6PV5t4wOKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y4iMAKv3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y4iMAKv3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 808FB1F000E9;
	Fri,  7 Aug 2026 15:06:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115206;
	bh=MwIeiqzu+IX3YixAPLJaRjARLHt5rwPqlMJ+Hyi5fCQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y4iMAKv3NyEMq45TE1MhRxQOI7GSJwiCM0o78nFoUSAuDdHgMlRFwJ4BpYuhBD1I5
	 G5q8TEuS30XZsddSRwXb6UPYUM6FH6k+MFYu+jt79jo1TnqWEd2OlpXdE4NTOfAgE6
	 s/eRAazAWWbG1eJ9nfrEnhEG42YSApfq99o6cbRU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sangho Lee <kudo3228@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.18 196/396] Bluetooth: HIDP: validate numbered report payloads
Date: Fri,  7 Aug 2026 16:35:56 +0200
Message-ID: <20260807143428.510821973@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


