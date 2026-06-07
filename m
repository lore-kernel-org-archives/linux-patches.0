Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C58953195FD;
	Sun,  7 Jun 2026 10:35:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780828525; cv=none; b=r/KdyshpsV/5sjJ+9EEoNMfbVJ9s+14jNOfKm4Tqg/mQUWGlgIXAw/zLKSIcaptnEF9ODZA6ATpz9O4FDy4S+JhqfLZ7UnCHfCpLeWK24ZwVhzTwuJfHoyh1CrxPBU7vHJOhCs9s++dJnUwtRA4F9df4KoknURTqZ94wpa22EO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780828525; c=relaxed/simple;
	bh=6dDb/wJjAXE60DF6i1DTZdlXbA7ukE/HwfbPEq318NE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b3kMW463Cqcg5ezCa8Ibyg9qUUdegv87Nq4zdt3JsMPp2o4m+3BmUocupBr4oa5foD0U37z2gs2fqhUkVdO5xduX9EjkboMIGTFCDjLyGXNmPeQaZzO9C0I1it2sLMhanYJLPxhHM4Hwt4Qfipd/bZuZ8OZi0jq1+t4XvrIYaxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AlfTW39+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AlfTW39+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EEC71F00893;
	Sun,  7 Jun 2026 10:35:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780828524;
	bh=XMR9InYowQLqujOusb4/79q7n1Apq3qFg/iKVvQ+UhQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AlfTW39+WfqgpKmZVpN0AapQy+fPq9RT6Hq4IRQVUlEKQG0A0DaZb9RXnDAtf4CUj
	 aqNesbUpntxBbHFR2UMbyQtSwY9Jj6v/q/SnSuMoV8YpjhbcJTwHwrYrLAxrT0kzDQ
	 3OTwRMxPxdjXwG9zBeYe/cIAjm8WD+R2nPenslvI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Bilal <meatuni001@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.12 145/307] Bluetooth: HIDP: fix missing length checks in hidp_input_report()
Date: Sun,  7 Jun 2026 11:59:02 +0200
Message-ID: <20260607095733.057779658@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.647295505@linuxfoundation.org>
References: <20260607095727.647295505@linuxfoundation.org>
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

From: Muhammad Bilal <meatuni001@gmail.com>

commit 2a3ac9ee11dbb9845f3947cef4a79dba658cf6f6 upstream.

hidp_input_report() reads keyboard and mouse payload data from an skb
without first verifying that skb->len contains enough data.

hidp_recv_intr_frame() pulls the 1-byte HIDP header before dispatching
to hidp_input_report(). If a paired device sends a truncated packet,
the handler reads beyond the valid skb data, resulting in an
out-of-bounds read of skb data. The OOB bytes may be interpreted as
phantom key presses or spurious mouse movement.

Replace the open-coded length tracking and pointer arithmetic with
skb_pull_data() calls. skb_pull_data() returns NULL if the requested
bytes are not present, eliminating the need for a manual size variable
and the separate skb->len guard.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Muhammad Bilal <meatuni001@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/hidp/core.c |   23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

--- a/net/bluetooth/hidp/core.c
+++ b/net/bluetooth/hidp/core.c
@@ -179,12 +179,21 @@ static void hidp_input_report(struct hid
 {
 	struct input_dev *dev = session->input;
 	unsigned char *keys = session->keys;
-	unsigned char *udata = skb->data + 1;
-	signed char *sdata = skb->data + 1;
-	int i, size = skb->len - 1;
+	unsigned char *udata;
+	signed char *sdata;
+	u8 *hdr;
+	int i;
+
+	hdr = skb_pull_data(skb, 1);
+	if (!hdr)
+		return;
 
-	switch (skb->data[0]) {
+	switch (*hdr) {
 	case 0x01:	/* Keyboard report */
+		udata = skb_pull_data(skb, 8);
+		if (!udata)
+			break;
+
 		for (i = 0; i < 8; i++)
 			input_report_key(dev, hidp_keycode[i + 224], (udata[0] >> i) & 1);
 
@@ -213,6 +222,10 @@ static void hidp_input_report(struct hid
 		break;
 
 	case 0x02:	/* Mouse report */
+		sdata = skb_pull_data(skb, 3);
+		if (!sdata)
+			break;
+
 		input_report_key(dev, BTN_LEFT,   sdata[0] & 0x01);
 		input_report_key(dev, BTN_RIGHT,  sdata[0] & 0x02);
 		input_report_key(dev, BTN_MIDDLE, sdata[0] & 0x04);
@@ -222,7 +235,7 @@ static void hidp_input_report(struct hid
 		input_report_rel(dev, REL_X, sdata[1]);
 		input_report_rel(dev, REL_Y, sdata[2]);
 
-		if (size > 3)
+		if (skb->len > 0)
 			input_report_rel(dev, REL_WHEEL, sdata[3]);
 		break;
 	}


