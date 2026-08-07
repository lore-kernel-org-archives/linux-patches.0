Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E667B443A9A;
	Fri,  7 Aug 2026 15:46:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117619; cv=none; b=FRVBoFum4bGeQDmbF0pDmRp1iwo0phQivF+2pEu+JjLnhwGJgahyE1cV/DMfaNOS0WVJShBKZys4NKPm767xV9QTEq45h+sK9bkdO1ozH4R1Sq8vozQc2vBHSb1hL1lqLCV7G1Kl4C36zcsgoUAr5pFn5DVmMptaC6QDtdcrW2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117619; c=relaxed/simple;
	bh=3iZyJ4NkMFNAaG3upP3E+6ZTGE978hxldEjIw1ZasR4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bTVqPUbJG0UNdMFS5NFV39fgq0PL2yfECgpQcsSueSlaDwftp0WCHHW85W1D6cRP+6LX1uRdnEaOI2e4VXC/s3CbMrdFIG3duKOR6waGr2my6I0daFli6us2q5rKfOphJv3fAIPC8s95/gX+bvkYoaPsYYU5BGVNzIbNCad3Xfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BZxua1P9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BZxua1P9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F74F1F000E9;
	Fri,  7 Aug 2026 15:46:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786117617;
	bh=MPnDpVBut7SHaxUMNvxuqTgiz7SGoYux+H92wb/LWrI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BZxua1P9c9TBwTurp6zQ2MDFvDoFfIHFsun6yD0ApG/2YqEzE65/FNkYgDKZ7JoRW
	 +i5c7xP/ZfEeOGfC6QA//P5GzHKXcsOAa7VbWnss642mbVLfabv+lZrplu2C74p/ly
	 8ve6lbjxyeD4W7wBuGOm486k/2GQezLQ2kP9Qmwo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avi Weiss <thnkslprpt@gmail.com>,
	stable@kernel.org,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 7.1 381/438] can: ctucanfd: mark error-active controller status valid
Date: Fri,  7 Aug 2026 16:39:37 +0200
Message-ID: <20260807143436.090680097@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Avi Weiss <thnkslprpt@gmail.com>

commit 4e735cbe3affe88001428fdd9cae8e685ce92f21 upstream.

In the CAN_STATE_ERROR_ACTIVE case, cf->data[1] is set to
CAN_ERR_CRTL_ACTIVE, but cf->can_id is not set with CAN_ERR_CRTL in
that path.

Set CAN_ERR_CRTL so consumers know the controller-status information
in cf->data[1] is valid.

Fixes: 9bd24927e3ee ("can: ctucanfd: handle skb allocation failure")
Signed-off-by: Avi Weiss <thnkslprpt@gmail.com>
Link: https://patch.msgid.link/20260723155543.318414-1-thnkslprpt@gmail.com
Cc: stable@kernel.org
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/ctucanfd/ctucanfd_base.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/can/ctucanfd/ctucanfd_base.c
+++ b/drivers/net/can/ctucanfd/ctucanfd_base.c
@@ -869,7 +869,7 @@ static void ctucan_err_interrupt(struct
 			break;
 		case CAN_STATE_ERROR_ACTIVE:
 			if (skb) {
-				cf->can_id |= CAN_ERR_CNT;
+				cf->can_id |= CAN_ERR_CRTL | CAN_ERR_CNT;
 				cf->data[1] = CAN_ERR_CRTL_ACTIVE;
 				cf->data[6] = bec.txerr;
 				cf->data[7] = bec.rxerr;


