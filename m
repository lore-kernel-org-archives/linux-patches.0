Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 725DE2E762C;
	Fri,  7 Aug 2026 14:52:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114372; cv=none; b=HDwCG6JsQyE1AW7BhEatQoTJM44poLg6/SEW5ybDatR1E+uSVOxQwkXwRIKQPZf4o9UFqZ7ZGquYMvUTQUZla1abtNLxrt03dil9A5dgBbX5BoC+Qe4tcm6livYASzOTWibmaYWorY25H4BTHwIR1pe4KeE+Kz9qV9KEAnXgqTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114372; c=relaxed/simple;
	bh=tqax+OnYg8LSxzcP94W40cuJsRK8bTekQT4j9+15J/k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UvF5nlhGDraKDl2io/uZhpOpTBidcin8X4bfUOQru4aVBlCtWPKX9byI29oZlJkXL5oaaoFbIWm8SZSMJv2TIOdWQqSJPnGgU4TqxkTyV+OWGxFEk1j3g6hxr++bOUfNIheTxPNstuy99jCd5CAQA9ppZYxvBw6/YQ0W3wi39kg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B15jpSAz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B15jpSAz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8C661F000E9;
	Fri,  7 Aug 2026 14:52:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114371;
	bh=UYDX9uuEWcnnai2LH0OV2/1psNZya8Q2dghpb/bkZxA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B15jpSAzbvHcbure38xQlKeqxa4TIBvsUomsMWltLm0PV9OzjPivbmmZmORz3xFqK
	 iuhplaRi6aNLzKRC1bwqOvG6vanwC78oKrMFXcVJVWcdMzLlpncCatz1TNW+1MJC7f
	 U/F3VxIoGrBdCILpYXl4c6YBo0k6yNXGl8rW1Si8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avi Weiss <thnkslprpt@gmail.com>,
	Pavel Pisa <pisa@fel.cvut.cz>,
	stable@kernel.org,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 6.12 240/337] can: ctucanfd: use self-test mode for PRESUME_ACK
Date: Fri,  7 Aug 2026 16:37:23 +0200
Message-ID: <20260807143423.750522165@linuxfoundation.org>
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

commit c31a435933f18be0f874302161333e9f16e200a0 upstream.

Use self-test mode for CAN_CTRLMODE_PRESUME_ACK so transmitted
frames can complete without receiving an ACK.

ACK forbidden mode prevents the controller from acknowledging
received frames and does not implement the presume-ack behavior.

Fixes: 2dcb8e8782d8 ("can: ctucanfd: add support for CTU CAN FD open-source IP core - bus independent part.")
Signed-off-by: Avi Weiss <thnkslprpt@gmail.com>
Acked-by: Pavel Pisa <pisa@fel.cvut.cz>
Link: https://patch.msgid.link/20260722192726.230729-1-thnkslprpt@gmail.com
Cc: stable@kernel.org
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/ctucanfd/ctucanfd_base.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/can/ctucanfd/ctucanfd_base.c
+++ b/drivers/net/can/ctucanfd/ctucanfd_base.c
@@ -340,8 +340,8 @@ static void ctucan_set_mode(struct ctuca
 			(mode_reg & ~REG_MODE_FDE);
 
 	mode_reg = (mode->flags & CAN_CTRLMODE_PRESUME_ACK) ?
-			(mode_reg | REG_MODE_ACF) :
-			(mode_reg & ~REG_MODE_ACF);
+			(mode_reg | REG_MODE_STM) :
+			(mode_reg & ~REG_MODE_STM);
 
 	mode_reg = (mode->flags & CAN_CTRLMODE_FD_NON_ISO) ?
 			(mode_reg | REG_MODE_NISOFD) :


