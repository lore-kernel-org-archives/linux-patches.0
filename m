Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FAFC346FCF;
	Thu, 12 Mar 2026 20:20:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773346836; cv=none; b=riuoVBKeAhUhPz4yYUk1f/nYMyG0KxLzqgBSYc446EAMcXekqzBq3ZUj3DrdajN+cY/Suq6R+Cca6OHjokMGyeNCId1KXbjZz/aKdqvaY5zEqqZeLSflVkOthnzGcAnHNzazuQYylAlap3SyuFy+aDgWnw+1JSC/IxYACciFqW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773346836; c=relaxed/simple;
	bh=ojjFTejNfmb16sakFGrEfedxwXuenvkjD2lWkSw7y+I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cUoBkI6IW8DzIVXuMVez+aD11Px9FvpZovu+PDcFOnP1Dd2qy/9JtGMRjHGig1dia312E2e8ahGdegZK01I9RZrQ+7Dk1Ka8zp2G85SXwNchIq+hBeYu+NUCLiQ72z0LZ23FMXM/cXM1663wV8xoX11cxscgvsdtCA3dnS/KZvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z1t/feQK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z1t/feQK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F856C4CEF7;
	Thu, 12 Mar 2026 20:20:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773346835;
	bh=ojjFTejNfmb16sakFGrEfedxwXuenvkjD2lWkSw7y+I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z1t/feQKf+kXXeBnlANAekAxYNPvGQCVo5yG6UJ5wgV36kyIEEDMrDDx2jp7R0DBA
	 2tac0s5Nvc/R/HsmjEd7BLd4qlXOAgYSJ+EKxTO+3EK9jjOzo2MUiT4BNroC5AyaMe
	 7PqoLy/bzs2dB8IdsLNaugp78+6pVJxByQ2v3rXU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Ji-Ze Hong (Peter Hong)" <peter_hong@fintek.com.tw>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Vincent Mailhol <mailhol@kernel.org>,
	stable@kernel.org
Subject: [PATCH 6.12 137/265] can: usb: f81604: handle short interrupt urb messages properly
Date: Thu, 12 Mar 2026 21:08:44 +0100
Message-ID: <20260312201023.204780348@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260312201018.128816016@linuxfoundation.org>
References: <20260312201018.128816016@linuxfoundation.org>
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

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 7299b1b39a255f6092ce4ec0b65f66e9d6a357af upstream.

If an interrupt urb is received that is not the correct length, properly
detect it and don't attempt to treat the data as valid.

Cc: Ji-Ze Hong (Peter Hong) <peter_hong@fintek.com.tw>
Cc: Marc Kleine-Budde <mkl@pengutronix.de>
Cc: Vincent Mailhol <mailhol@kernel.org>
Cc: stable@kernel.org
Assisted-by: gkh_clanker_2000
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Link: https://patch.msgid.link/2026022331-opal-evaluator-a928@gregkh
Fixes: 88da17436973 ("can: usb: f81604: add Fintek F81604 support")
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/usb/f81604.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/net/can/usb/f81604.c
+++ b/drivers/net/can/usb/f81604.c
@@ -626,6 +626,12 @@ static void f81604_read_int_callback(str
 		netdev_info(netdev, "%s: Int URB aborted: %pe\n", __func__,
 			    ERR_PTR(urb->status));
 
+	if (urb->actual_length < sizeof(*data)) {
+		netdev_warn(netdev, "%s: short int URB: %u < %zu\n",
+			    __func__, urb->actual_length, sizeof(*data));
+		goto resubmit_urb;
+	}
+
 	switch (urb->status) {
 	case 0: /* success */
 		break;


