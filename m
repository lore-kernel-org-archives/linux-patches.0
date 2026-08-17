Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59E0B70836;
	Mon, 17 Aug 2026 15:22:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786980125; cv=none; b=EPK3tQWy2TvTU/LK8Fj2a/7a7nYYMa+NFD2odJI5WRlm9m6vYxplnSfSAcuIAoBCXUoMBoFlMN2bGtafgfv480KydcdW8uz9xIswUDxfp8VN/u/6deFpBEJrcj75Ieidz5zZSqk5jrWdVwLVBYgLuFUnrNNJWVq0FjQJVFrgBbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786980125; c=relaxed/simple;
	bh=oImgZNceK2IGjQ96LSrVOTQ1qAncRXfghke7ErtEkfI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dwEDa3yjKaSzbodP7o1w23+1USw/Ce5MvIQ3sXfIPogMBHP0ahOhidrXAtAPed96Yn/mBgAOZ8UpQ2n4ddtsWU8rsPsPzq+sjue8oX5bA9q9d/nWy38aQnszxlJ56OG4uIeQQ/mP2JR05IYCOEYvEOA0HWiqU5oEZbZV38YPryE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YW8QBGiQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YW8QBGiQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7C151F000E9;
	Mon, 17 Aug 2026 15:22:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786980124;
	bh=3TDe7ExWdbyTkjV7TLxTXePgTIV5rIslL+DpBBkm3Rg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YW8QBGiQ1q9o6qrMrB28h58P5G5x7eaAa+btC45udeqhVMzksHvcd5BTJFhqF9PKW
	 joA6yxl/FHQ9scLx6HjdtnMS0lcghJd/KE70F/CtylVfdI4csf40z3oJd+/JCgbeOh
	 CcpftHs9KB0gbk3KYiQgx0InZmEsQbcsjbgKnELM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avi Weiss <thnkslprpt@gmail.com>,
	stable@kernel.org,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 6.1 464/609] can: ctucanfd: mark error-active controller status valid
Date: Mon, 17 Aug 2026 15:32:40 +0200
Message-ID: <20260817132559.528056924@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -868,7 +868,7 @@ static void ctucan_err_interrupt(struct
 			break;
 		case CAN_STATE_ERROR_ACTIVE:
 			if (skb) {
-				cf->can_id |= CAN_ERR_CNT;
+				cf->can_id |= CAN_ERR_CRTL | CAN_ERR_CNT;
 				cf->data[1] = CAN_ERR_CRTL_ACTIVE;
 				cf->data[6] = bec.txerr;
 				cf->data[7] = bec.rxerr;


