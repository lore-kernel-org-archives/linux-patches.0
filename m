Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E68C1339387;
	Fri,  7 Aug 2026 14:52:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114381; cv=none; b=KB97bHQ55ZWdpNk8lhTcFJO2PHphGQyRTKCCLiSzwRk0HERr8MNg8vxxDg5dFroUpSHWssr1052jveUA/W4cZakJeUNVsWpIUk375DS5jnpyRpmPFzPyGmezxPLsiLCghzI7OHxNZE1D8V5dh9jbTCnpyx4yf472sV4iqQbOwMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114381; c=relaxed/simple;
	bh=g2Zx4X/wFT6HydXFcs3QoSXzGl99QUr5Lymhe9Dbi9M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lCr8SE1Ag88DftQnT1Csk63pMC00S/sk1YhqNKB9umwFBi/DhGvbGZbWRXiLKgQvsDYgpvHIRwWGkQDSpuHDvN0kzo9RVBU0duw4qeWj+tXuagwYbJ8NJKczvvr1zSk65gm/6zDeUgUE4HMCNJlh1KjOPpTTObCfz3POOtqJ11U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ddryp1OC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ddryp1OC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36B331F00A3A;
	Fri,  7 Aug 2026 14:52:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114379;
	bh=mMa84cMCDdQIihbd+xsewHnK+ceVI4UtrZmT2qqdHu8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ddryp1OCuAN0/gkbJ2bu8Gj5+mZKIvz23SBnil6Y5Geu7qxTbU95QRouSiGMrEB4s
	 tVTdSI23VHK2wHbbDzbZ4huRwElI65vf2Rij2YkkUegiWTvhzLysuGmxD3yYgow1GH
	 sVjKOar+7c8s9hZQdioEWdIoqmdfwgJohd7/EU8M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avi Weiss <thnkslprpt@gmail.com>,
	stable@kernel.org,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 6.12 243/337] can: ctucanfd: mark error-active controller status valid
Date: Fri,  7 Aug 2026 16:37:26 +0200
Message-ID: <20260807143423.816803946@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
References: <20260807143418.516897842@linuxfoundation.org>
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


