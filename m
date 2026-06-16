Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADFA03AE1A2;
	Tue, 16 Jun 2026 18:50:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781635841; cv=none; b=pxFxmDiLwiULaRAvx5znsVQRGs3Pwx3oLtZAbpX6uUidJCaRu+8wusTpphY3okoNVwMSBxrOoQUHA/KdtGQwnlxeXC1dBdE6zmTVah2cC3Jr5OQcU0C5ec8Nox8b7kv3Q9gfDqD0yTeagfF6yGcVNdaDt8y1fUKrgPvye1hQL+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781635841; c=relaxed/simple;
	bh=huzT0t+1Vez2jtKlrsAzEsaC6PElUr5mAjCV/muOPlk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ohnkPGZJzr7JsrvxbqvYooH7BcMIeR0lmYOXKu/WWhWJBwtz3Fv/80ZzIih5CI7BQi5KOQAdBEoSGCDhmsh5rHtvXCEQ2HUyQx8Xt/q4JVAXuMliVDiqVeqAAS6ADRuOc0pl8KgCR3X61mPWQHj4ChIhh58ZyvH0dwBZ3vXmjHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Foex2lD0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Foex2lD0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 921631F000E9;
	Tue, 16 Jun 2026 18:50:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781635840;
	bh=CuvfmKLQKCLUbV7WfTPpfF2Qn3l+JgEe1GZTYqQfYMo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Foex2lD0Ael4xjEycks2/mAXfADPYMtOwBuXXaJrPfyInZurSY5Ks+AXK5xCoGdfs
	 XgwLSCTcf8B/uDfWvsO5P/a+P6ta0nLoVUO86ZU+3yRL63vl6mQFPsH+2O47qmui7f
	 t+45RY065wreWus4ADrnms5gmPdnWG1TJBxtlsnk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Pecio <michal.pecio@gmail.com>,
	Tao Xue <xuetao09@huawei.com>
Subject: [PATCH 5.10 091/342] usb: core: Fix up Interrupt IN endpoints with bogus wBytesPerInterval
Date: Tue, 16 Jun 2026 20:26:27 +0530
Message-ID: <20260616145052.478013954@linuxfoundation.org>
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

From: Michal Pecio <michal.pecio@gmail.com>

commit 727d045d064b7c9a24db3bce9c0485a382cb768b upstream.

Tao Xue found that some common devices violate USB 3.x section 9.6.7
by reporting wBytesPerInterval lower than the size of packets they
actually send. I confirmed that AX88179 may set it to 0 and RTL8153
CDC configuration sets it to 8 but sends both 8 and 16 byte packets:

S Ii:11:007:3 -115:128 16 <
C Ii:11:007:3 0:128 8 = a1000000 01000000
S Ii:11:007:3 -115:128 16 <
C Ii:11:007:3 0:128 16 = a12a0000 01000800 00000000 00000000

Most xHCI host controllers neglect interrupt bandwidth reservations
and let such devices exceed theirs, some fail the URB with EOVERFLOW.

Assume that wBytesPerInterval lower than wMaxPacketSize is bogus and
increase it to the worst case maximum on interrupt IN endpoints. This
solves xHCI problems and appears to have no other effect. Interrupt
transfers are not limited to one interval and drivers submit URBs of
class defined size without looking at wBytesPerInterval. Any multi-
interval transfer is considered terminated by a packet shorter than
wMaxPacketSize regardless of wBytesPerInterval - see USB3 8.10.3.

Stay in spec on OUT endpoints and isochronous. No buggy devices are
known and we don't want to risk sending more data than the device
is prepared to handle or confusing isoc drivers regarding altsetting
capacities guaranteed by the device itself. And don't complain when
wMaxPacketSize <= wBytesPerInterval < wMaxPacketSize * (bMaxBurst+1)
because enabling this seems to be the exact goal of the spec.

Reported-and-tested-by: Tao Xue <xuetao09@huawei.com>
Closes: https://lore.kernel.org/linux-usb/20260402021400.28853-1-xuetao09@huawei.com/
Cc: stable@vger.kernel.org
Signed-off-by: Michal Pecio <michal.pecio@gmail.com>
Link: https://patch.msgid.link/20260518073207.5b7d26e7.michal.pecio@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/config.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/drivers/usb/core/config.c
+++ b/drivers/usb/core/config.c
@@ -165,7 +165,14 @@ static void usb_parse_ss_endpoint_compan
 			(desc->bMaxBurst + 1);
 	else
 		max_tx = 999999;
-	if (le16_to_cpu(desc->wBytesPerInterval) > max_tx) {
+	/*
+	 * wBytesPerInterval > max_tx is bogus, but USB3 spec doesn't forbid the opposite.
+	 * Experience shows that wBytesPerInterval < wMaxPacketSize on common interrupt IN
+	 * endpoints is usually bogus too, and recent HCs enforce interrupt BW limits.
+	 */
+	if (le16_to_cpu(desc->wBytesPerInterval) > max_tx ||
+	    (le16_to_cpu(desc->wBytesPerInterval) < usb_endpoint_maxp(&ep->desc) &&
+	     usb_endpoint_is_int_in(&ep->desc))) {
 		dev_notice(ddev, "%s endpoint with wBytesPerInterval of %d in "
 				"config %d interface %d altsetting %d ep %d: "
 				"setting to %d\n",


