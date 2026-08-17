Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F93070836;
	Mon, 17 Aug 2026 15:21:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786980114; cv=none; b=s4aK5uR4kNeOA07XS2YYElowJlxC473IZvsxu8SJmFtZrF2GrA99O+FcjXRAkHmU+WPi+UQdt2BnIXa4wr79TXsD7ax2gAl9ixZaZlw1JJHnpjNMjL6Nus9aftfHy9IDXy4nRR/YhyMqf2qak4GdPp23p1VH5+NRCdgbg+s4/fQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786980114; c=relaxed/simple;
	bh=GazEeqJIhTlH1qylK5FvNrI19GSV7RxYFiwK2XBAC5A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K07irFrQGfvep0mOTrB9jHVniVjQXBBw/D4GA4bitUw1CgM87WWBcaqO6PlWpPlxY+vhe4UIYiNU6Jcr5npclM5UQv/AlmWrxgK1SRqVz17eIukHxN6dZFv9OzjFSV5RiA5S3CEtvLT+aCBb4EJt926rYf+cPS4PGwMLko12ycs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VrIouLg3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VrIouLg3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AAC31F000E9;
	Mon, 17 Aug 2026 15:21:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786980113;
	bh=eHSKzHZZ1JdODykdmGqhmP9ztCzw7Ha6iLDJC5BFx3c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VrIouLg3fNrS8oEbXU8C01BaQCdGAgV4zb4CPhm2IG/6+lNFec6x2G8J6UsSTEVzr
	 X0aaRVlBDhW+38B3v5czkZnt9JESNaVantf6IJDU1Q/UMea5Ahe6toePUgfZ3kIyIT
	 Zu5FGyb8h5rcpqsTtk3yPUjnA4MIOgjQBvpOtgo8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avi Weiss <thnkslprpt@gmail.com>,
	Pavel Pisa <pisa@fel.cvut.cz>,
	stable@kernel.org,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 6.1 461/609] can: ctucanfd: use self-test mode for PRESUME_ACK
Date: Mon, 17 Aug 2026 15:32:37 +0200
Message-ID: <20260817132559.439250277@linuxfoundation.org>
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


