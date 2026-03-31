Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E64B22FE042;
	Tue, 31 Mar 2026 17:04:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976696; cv=none; b=F1YkB+pt/y1BJ5r/ETdSIiBb/Ogbez7bMKaKeeB/hOXh6gkt2n4Or+EPIsLXNq6z2ObOcyrJMgH+M04ggPfpws/ouOjLoGBx3DEbPkdvCvt6/2yRxeelD0I4fKJhnvqZ8PeSUrVAwd9480PDpc4YVOcmx/iE1Elww+5FYmixEmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976696; c=relaxed/simple;
	bh=qD6CKMYxdq3rOQCjQg35OUzPGmH6UQLg1pQiWbCqkPY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SWlr5oIqSsuW1EwhAPly4ng3JLA+SURmOVya5E1JEuV4jdIGo4/IBar94EFMDyQ7obotaoQgut95IU8tvwL9w+Vv1znEzoacRy4JZs5XYWvzP57L8lMXwD66tOYVkz0g/5wPxIhRkVoM6ioCYiAd7zgG+QiY2xvsckczEVXuJlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oOm2/ORP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oOm2/ORP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CE48C19423;
	Tue, 31 Mar 2026 17:04:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976695;
	bh=qD6CKMYxdq3rOQCjQg35OUzPGmH6UQLg1pQiWbCqkPY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oOm2/ORPKpCSnSYsZl7zP26tlkJct8tyrM5d9n2P4hQ7kaVXzOjNO7/iPmSkPeMRh
	 vXGKevqJphhqRF5VXyz9A47ZJ0RgA1e1vAuay4gVIDnzgZAmjaMKPqiyOfC8k01Idh
	 h9ifsPEyV2sgOoactdTRCsdLatDaC5ztvyB62fAw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 6.18 192/309] can: netlink: can_changelink(): add missing error handling to call can_ctrlmode_changelink()
Date: Tue, 31 Mar 2026 18:21:35 +0200
Message-ID: <20260331161800.523828106@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161753.468533260@linuxfoundation.org>
References: <20260331161753.468533260@linuxfoundation.org>
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

From: Marc Kleine-Budde <mkl@pengutronix.de>

commit cadf6019231b614ebbd9ec2a16e5997ecbd8d016 upstream.

In commit e1a5cd9d6665 ("can: netlink: add can_ctrlmode_changelink()") the
CAN Control Mode (IFLA_CAN_CTRLMODE) handling was factored out into the
can_ctrlmode_changelink() function. But the call to
can_ctrlmode_changelink() is missing the error handling.

Add the missing error handling and propagation to the call
can_ctrlmode_changelink().

Cc: stable@vger.kernel.org
Fixes: e1a5cd9d6665 ("can: netlink: add can_ctrlmode_changelink()")
Link: https://patch.msgid.link/20260310-can_ctrlmode_changelink-add-error-handling-v1-1-0daf63d85922@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/dev/netlink.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/net/can/dev/netlink.c
+++ b/drivers/net/can/dev/netlink.c
@@ -407,7 +407,9 @@ static int can_changelink(struct net_dev
 	/* We need synchronization with dev->stop() */
 	ASSERT_RTNL();
 
-	can_ctrlmode_changelink(dev, data, extack);
+	err = can_ctrlmode_changelink(dev, data, extack);
+	if (err)
+		return err;
 
 	if (data[IFLA_CAN_BITTIMING]) {
 		struct can_bittiming bt;


