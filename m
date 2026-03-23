Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFAFA2737EB;
	Mon, 23 Mar 2026 14:58:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774277887; cv=none; b=jhAqqnnwgbo26p1v9fvqXz/gflaqh4ZremwdlhMvIkLbZ9GdhOfQZhW3pXwEtN/050tWPfD85JlHo5+cT8G1ljK29KkzdfuooGXoEin1x3QHFdPCoH18E83PCxSPmNkdKWjl6mj4cZ6NgTBCpVnMue7tt/bT+gNk5JBUmqJEbVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774277887; c=relaxed/simple;
	bh=9mWObq2gcZiFQK3EyBzlQRSBypqv0wXMkXOwiCeEQp0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EYzh96EHg61KQvYGNvGWLuGpxVW3GpMsloK+0HMp76GfJe2XCJfkPtdkP34mRDoJ+9oWNEi3thMovl7M1VX8fRUdr04kqM1jAOoivGaRAbsdATqWu1c4ltGQEX4bI5+nhzoGiDyOilvsHlTySCwy7UFiveGrsIseLJN/BPRVkiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ejm1juGo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ejm1juGo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 527E0C4CEF7;
	Mon, 23 Mar 2026 14:58:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774277887;
	bh=9mWObq2gcZiFQK3EyBzlQRSBypqv0wXMkXOwiCeEQp0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ejm1juGo1VCnsdGayyNpntCy1M7CFhDWyf+bojZ8xt6TVtgqXi84jT847L8d2KCf2
	 lnm71dpZjFUBU91oCaS1cbQkSk9wZa2HDZQw5j307Tvt7WAxlhGEb/jp6eGkBXXZ1u
	 o6vG2xL4/MSyMr92uiCu7hKb23vXMa9/S8e3Z5WU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Ji-Ze Hong (Peter Hong)" <peter_hong@fintek.com.tw>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Vincent Mailhol <mailhol@kernel.org>,
	stable@kernel.org
Subject: [PATCH 6.6 097/567] can: usb: f81604: handle short interrupt urb messages properly
Date: Mon, 23 Mar 2026 14:40:17 +0100
Message-ID: <20260323134536.229183819@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


