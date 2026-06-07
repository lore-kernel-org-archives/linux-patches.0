Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A7432580CF;
	Sun,  7 Jun 2026 10:46:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780829178; cv=none; b=ukjwbHIxqhHb/wyOyg3EfacivMDVQAMNDnSqhPykuLVRXOj/ku1ZChlo7x3jzdX3h1Sbh/HHcIrIz/uO+SCnemJP2mt09B9sr5aibwCiS6F87UgPRvedbtrzoe+LB0lPFSB0NnOxNTc8nCu35Z37++g50ATVhncg98HOgsyfiJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780829178; c=relaxed/simple;
	bh=T1QdNa/x3I+uTKn0s2ZedzQMgryCTnPei+uoo8ayTbQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W4fYctsuOXbdnhrRTl+57wRdGfPF4O9+awe+6L1mJQ08VhZRC4iTzrNTvaoPOzlT/hD30GPvqhxF5Wdl5PDDvBh1BFBPElUpw5GXddacbL64ytHS/68G5ccdSQ/OGLbHH/4btvWQorEDVycSfGEoGrv0E77bQOMDm3jWe5+hoBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NS765rrr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NS765rrr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47A6F1F00893;
	Sun,  7 Jun 2026 10:46:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780829177;
	bh=QbiPRY6vR/N+CJKbpcBCcEclbbuSj3DjLU4d6k+wGVE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NS765rrrCCYOpQyVCASx2eu+xB8TxHOIPpWmwT0rw6Vaoabbv2sUiapSCSHSBYLTl
	 st8scBSk3HJW/mfn/uKFA54D5mTzr6EEkRnc2qXu1REHYFuwX3E3s34DJcxWnSfsPk
	 5UrbVJzuXlKL4IuItiMgKomJ+i7nNJbbfglDZjBI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Pecio <michal.pecio@gmail.com>,
	Tao Xue <xuetao09@huawei.com>
Subject: [PATCH 6.18 223/315] usb: core: Fix up Interrupt IN endpoints with bogus wBytesPerInterval
Date: Sun,  7 Jun 2026 12:00:10 +0200
Message-ID: <20260607095735.767730574@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.528828913@linuxfoundation.org>
References: <20260607095727.528828913@linuxfoundation.org>
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
@@ -191,7 +191,14 @@ static void usb_parse_ss_endpoint_compan
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


