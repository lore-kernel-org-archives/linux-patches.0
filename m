Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5667334D90C;
	Tue, 16 Jun 2026 15:22:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781623334; cv=none; b=BXYHLnb1ri4xhs9qaQMLTRvvYyjj+CX/S6ZeNOxZdrKCo0RC0S+acpgajLMaumtI72XCr7RW6fGF/ng8x0Ajy36CpbgBs+MbPRPrgYf6x55YCZtW0Kiimr6kvAOOLxvrwId4+fSO0k3zWMNAruroUjnvT2HOsxloIn27e7IHcLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781623334; c=relaxed/simple;
	bh=r7v6V+GKY9cYMb042Ybx7lSiWP0QF26/ekQGZ8TTGGc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EnBhk0wRXedPb8iPlNd7exSU/fXepVy49kYQ6eEGfAfh2LhjuznbGHSVPy7wMbKWnwIs0Q6Y2LfKJjxWr2y0Cf3C3iXGVF6HyE/D11Pid/iFKq8MXw/QU2hkFaOEcyE6enevm3jHiHQQzs/TCJ80+G6J5iu8MS1P4tO3Yfhkvis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xaM3W0GQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xaM3W0GQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41FCF1F000E9;
	Tue, 16 Jun 2026 15:22:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781623333;
	bh=iVWgYD8tWdYlf+fEu/Q25HriO9b3cV8AmsAnRKAZOf8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xaM3W0GQAu1CnlaTopmNjGt9234Bd51wQQr/gqyhZExQCibnRdWzySEbVqQ8T7kCH
	 Al2pGI26YS9p6kA0cVPJABf/0/vfRKsaKkE0CBQnbH90HXHb7lQSfsa9ANOkjEYLfe
	 TbxrbPScpoPd6GcXZwJ6UBziyoEdK/7jXHosRM7s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeremy Kerr <jk@codeconstruct.com.au>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 128/378] net: mctp: usb: dont fail mctp_usb_rx_queue on a deferred submission
Date: Tue, 16 Jun 2026 20:25:59 +0530
Message-ID: <20260616145117.066985454@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeremy Kerr <jk@codeconstruct.com.au>

[ Upstream commit 881a3113b74964918cdd72747e3bc119c02b0c0c ]

In the ndo_open path, a deferred queue open will report a failure, and
so the netdev will not be ndo_stop()ed, leaving us with the rx_retry
work potentially pending.

Don't report a deferred queue as an error, as we are still operational.
This means we use the ndo_stop() path for future cleanup, which handles
rx_retry_work cancellation.

Fixes: 0791c0327a6e ("net: mctp: Add MCTP USB transport driver")
Signed-off-by: Jeremy Kerr <jk@codeconstruct.com.au>
Link: https://patch.msgid.link/20260608-dev-mctp-usb-rx-requeue-v2-2-29a3aa507609@codeconstruct.com.au
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/mctp/mctp-usb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/mctp/mctp-usb.c b/drivers/net/mctp/mctp-usb.c
index cf6f6a93a45112..fade65f2f26995 100644
--- a/drivers/net/mctp/mctp-usb.c
+++ b/drivers/net/mctp/mctp-usb.c
@@ -154,7 +154,7 @@ static int mctp_usb_rx_queue(struct mctp_usb *mctp_usb, gfp_t gfp)
 	if (!mctp_usb->rx_stopped)
 		schedule_delayed_work(&mctp_usb->rx_retry_work, RX_RETRY_DELAY);
 	spin_unlock_irqrestore(&mctp_usb->rx_lock, flags);
-	return rc;
+	return 0;
 }
 
 static void mctp_usb_in_complete(struct urb *urb)
-- 
2.53.0



