Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D15043CE6B;
	Mon, 17 Aug 2026 14:14:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976069; cv=none; b=YahSVCgOe1NC+f6MlIkJwerbHDfmNOT9WjOvpRdtjhgKYw1kXJ2q4XmmZkC4Ddjp3rOcjDM6m48ypNSWHMLIVdg4pYf+0RIS5K4YPy6RK+A2imh9HBgzNrxdT1gVf6uNgUWkqXloXe4Uncohp0ehKVBvODJAo2sh1YaVfrNaQBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976069; c=relaxed/simple;
	bh=bGonsvVMmw5vFFUHNenUZTYH4luZrgUgB3N4/0kmg1Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j8JP1A1wUAsOKocKS/wQeZH5FUc8kWFbSIdWZjlYODbrmalT+Mqmr1aGpSfD4hSPAC/Nyr4+GTdHWcHzKMRi8Cv0jPns42VWFDxgeAV5dWc1FxYaI4HPU1UqwRalEgnePivtf0GI71RohSPodTHw6kT8XaaBrp+LBveuYXAh2Zg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hiepxQEM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hiepxQEM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E65CC1F00A3A;
	Mon, 17 Aug 2026 14:14:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976068;
	bh=nIUWlqbCVqthkKc9ybTp9a7aW7LD4eopyhyFRC4cbzY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hiepxQEM5D1h34VNpoT6YOAfNaoWifWIQ+trMhdsIV5/WovOOoZP2ySY6eP3nPaVG
	 Gys5gglUZnGWoV6RCYS0Uso/JZnpZ8u8UJsd4Mg8FABH9tOgB0yU0QkucziE2KFZc4
	 KHrejFxjPKDvL7bzk8d5E0oeQEL/ln2saKcGCTGg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sangho Lee <kudo3228@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 5.10 247/389] Bluetooth: HIDP: validate numbered report payloads
Date: Mon, 17 Aug 2026 15:31:26 +0200
Message-ID: <20260817132548.905554806@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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
@@ -533,9 +533,10 @@ static int hidp_process_data(struct hidp
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


