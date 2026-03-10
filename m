Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0436833A9C6;
	Tue, 10 Mar 2026 11:26:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773142010; cv=none; b=paSkx7csA/nmb0CB6vbewDSQykGAFEXhGQ7mfrep7S1xyCHNgP8JPhJZnJa9J6nrUwbMMXLlfrQQoUIcXEdGj7ewM359pVVQmNos7C6n10GwtPR5jxYRJj3gh+z0KPZasmqb2UDwknwy18HvbBRr8WjTVoL96wwBDExhU1mhSJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773142010; c=relaxed/simple;
	bh=jt85BVncvHIdkZiZ2NEjZThQNdp77XXPatolFkMZ2rM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mxhlyq5mK7TzCxRfmd6P7588MNnyg8i1gEOlwLNHT4sbJTZzk9KZax/RqX9oxhmMZZNml40LkOnqoLti6UC72eia8dIVLHGYPwd/tLA/+5qwDiqLJVUxSlmdHTAedBCd8gAQVUC58l3KWUORgdJ8P5eiroSmE4sasA5IpJfr0wY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YwQzP64a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YwQzP64a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D21CC19423;
	Tue, 10 Mar 2026 11:26:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773142009;
	bh=jt85BVncvHIdkZiZ2NEjZThQNdp77XXPatolFkMZ2rM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YwQzP64aMhsvZrBVMPnKd/UhH8Uyhu9Q11POZn02brmvS2S2/wPVkYoezAQxO7C5T
	 P6g5Zi/QhvDXXm8qDyE1IvcwuPEpI2Qh/lvcQyU+6Rgmxq7EOoCjHuZ7QtB32T/JEU
	 EMoRSDdJQXbgULp3pvoU3WkwOpQUAkpdtDGk4WB5MGLJxuwQ6ymVo62xncK404KFtW
	 Iv+7j2TMD0qcnBQ9LgnRkBgUKTCoJiE0uGcYSf9j/UgqsEiBd8mWlfkYP7itzS4dX5
	 hoLGH/3YkEfjrmE5mQI0bhJLtDRXl78gd0h7gUoCaa8ls0nqZa8WI0epn5UN4zfkrM
	 Ro7B+gOysZfQQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Petko Manolov <petkan@nucleusys.com>,
	stable <stable@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 136/314] net: usb: pegasus: validate USB endpoints
Date: Tue, 10 Mar 2026 07:16:35 -0400
Message-ID: <7e8e1e56a1a9f2349d5d7ff1d65381bd4a2095fc.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 11de1d3ae5565ed22ef1f89d73d8f2d00322c699 upstream.

The pegasus driver should validate that the device it is probing has the
proper number and types of USB endpoints it is expecting before it binds
to it.  If a malicious device were to not have the same urbs the driver
will crash later on when it blindly accesses these endpoints.

Cc: Petko Manolov <petkan@nucleusys.com>
Cc: stable <stable@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Link: https://patch.msgid.link/2026022347-legibly-attest-cc5c@gregkh
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/pegasus.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/net/usb/pegasus.c b/drivers/net/usb/pegasus.c
index 0f16a133c75d1..475b066081c7f 100644
--- a/drivers/net/usb/pegasus.c
+++ b/drivers/net/usb/pegasus.c
@@ -815,8 +815,19 @@ static void unlink_all_urbs(pegasus_t *pegasus)
 
 static int alloc_urbs(pegasus_t *pegasus)
 {
+	static const u8 bulk_ep_addr[] = {
+		1 | USB_DIR_IN,
+		2 | USB_DIR_OUT,
+		0};
+	static const u8 int_ep_addr[] = {
+		3 | USB_DIR_IN,
+		0};
 	int res = -ENOMEM;
 
+	if (!usb_check_bulk_endpoints(pegasus->intf, bulk_ep_addr) ||
+	    !usb_check_int_endpoints(pegasus->intf, int_ep_addr))
+		return -ENODEV;
+
 	pegasus->rx_urb = usb_alloc_urb(0, GFP_KERNEL);
 	if (!pegasus->rx_urb) {
 		return res;
@@ -1171,6 +1182,7 @@ static int pegasus_probe(struct usb_interface *intf,
 
 	pegasus = netdev_priv(net);
 	pegasus->dev_index = dev_index;
+	pegasus->intf = intf;
 
 	res = alloc_urbs(pegasus);
 	if (res < 0) {
@@ -1182,7 +1194,6 @@ static int pegasus_probe(struct usb_interface *intf,
 
 	INIT_DELAYED_WORK(&pegasus->carrier_check, check_carrier);
 
-	pegasus->intf = intf;
 	pegasus->usb = dev;
 	pegasus->net = net;
 
-- 
2.51.0

