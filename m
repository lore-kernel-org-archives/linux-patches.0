Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2014E425CD9;
	Tue, 31 Mar 2026 16:40:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975229; cv=none; b=EDl+0rKmtPOJbApXK+xWA6UTT7TitnLUYGmx7Fz0DlWqxicVXVUoUdEgfuSWDYInXpY63N+tO3igScDf9PPx5cZrw5QYsIb51LmzL2jcagZRuedXx0jiW7BdJJZL3iVoyS3HI/1Fuvh7dmDGj9Q7MkA7y5+vCGg7yEKD/k15JJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975229; c=relaxed/simple;
	bh=7yNGKiq6UrxQfZWXv2OU+0X16FadKQE0zRDIqPUs2k4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lL8By35oIOFBfDELIedAIUjRYsYPIJLXz1TbeSkOcdWX+9c4Hm35adNoZOqo1UaKFZ9CQRFyCP3fd+zqP4pXxMJW+JlbmTmmu9gytO9rhIEKG01n6mODj/Fr+PFQags7A11i9hiT53h4uk8ZP4AJmjZ7R0SsngSkd4PMFtMzbMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hPFgNdEu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hPFgNdEu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8769C19423;
	Tue, 31 Mar 2026 16:40:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975229;
	bh=7yNGKiq6UrxQfZWXv2OU+0X16FadKQE0zRDIqPUs2k4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hPFgNdEuuD7jSJmbdTOoZGmLuV1yOR+DPsWoMRsJO6KujQAuJQuXXGPRB9uoAjYnD
	 sZo4qhhBefl2OsNkF2TMFOuf8yuDlNxZKZkfOZhqukZCYqBOk2KWjwy6hbvcIuBJeF
	 fuQ1nix9CSVxkGtYoyTuirzqAYaNLKsg+Tjn4DZI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 6.19 214/342] can: netlink: can_changelink(): add missing error handling to call can_ctrlmode_changelink()
Date: Tue, 31 Mar 2026 18:20:47 +0200
Message-ID: <20260331161806.853414921@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>
References: <20260331161758.909578033@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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
@@ -601,7 +601,9 @@ static int can_changelink(struct net_dev
 	/* We need synchronization with dev->stop() */
 	ASSERT_RTNL();
 
-	can_ctrlmode_changelink(dev, data, extack);
+	err = can_ctrlmode_changelink(dev, data, extack);
+	if (err)
+		return err;
 
 	if (data[IFLA_CAN_BITTIMING]) {
 		struct can_bittiming bt;


