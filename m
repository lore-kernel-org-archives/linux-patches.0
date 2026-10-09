Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BC01BA45;
	Fri,  9 Oct 2026 14:39:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556771; cv=none; b=nqNs/wPW9CK9UajPLbuLR4bQTvs5CWE02uYZFLgfBqvlLDH3OZ26bPoIEYjgwmdx+piNzCLzHOVZRwykATCejJfrTXuesvIrJmxsMyRnkMYSOWy/JVoAAk/+TSGPyQ3G+U4NuhnYPPuONI1dB+dB4gpIg68twdf1Bq7RFpUmziA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556771; c=relaxed/simple;
	bh=deq68+e08DRLgFnuP2lBEpabUqbOKOr1AH54iepvrHw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sFuXWmLnh3Wl/lmMHpYAODx9q16rnPERLpDIEZvbeNuRzcFV6yPm+n2tuUGppayDLJcrqnRx4BiNuRh9Hz7XrLE9a49yz5qpyz5D7JUo1jInMEGUnVetPoPdN4/TH2bgYpab3KJIaFe+8SsYQrsNHXJGkMGnLR+ICS5lFbcZH3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y8bpOTyy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y8bpOTyy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67CAB1F000FF;
	Fri,  9 Oct 2026 14:39:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556770;
	bh=D3Xvdg11hRgT70xe9q7m0JBo5YPlP7JBxYoY/ASKoEo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y8bpOTyy9pr7uI8+Md7s4TDwG4svwa4PvXjtqXRehFPNw9qWzgFgC+PgPrGaBGeo7
	 2RrgVuc30iXfebpDFenDjfou5F2gUGi3URDnvChyV2A5P9ctLu89sQM5fip+JaDmVC
	 dnjLnbHf2MrekYYl75kEvtDqMvcUCJH5zW4amMss=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Joshua Rogers <linux@joshua.hu>,
	Jiri Slaby <jirislaby@kernel.org>
Subject: [PATCH 7.2 239/428] tty: vcc: zero-initialize control packet in vcc_send_ctl()
Date: Fri,  9 Oct 2026 16:09:36 +0200
Message-ID: <20261009140951.360526202@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joshua Rogers <linux@joshua.hu>

commit 1f71f565e3585da1098ff19ca3c24687dab59185 upstream.

The stack-allocated struct vio_vcc pkt was partially initialized,
leaving the tag.stype_env field uninitialized before being sent via
ldc_write(), potentially leaking kernel stack data to the LDC peer.

Assisted-by: AISLE:Snapshot
Cc: stable <stable@kernel.org>
Signed-off-by: Joshua Rogers <linux@joshua.hu>
Reviewed-by: Jiri Slaby <jirislaby@kernel.org>
Link: https://patch.msgid.link/20260803-aisle-tty-vcc-v2-1-a50bc9b15193@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/vcc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/tty/vcc.c
+++ b/drivers/tty/vcc.c
@@ -492,7 +492,7 @@ static ssize_t domain_show(struct device
 
 static int vcc_send_ctl(struct vcc_port *port, int ctl)
 {
-	struct vio_vcc pkt;
+	struct vio_vcc pkt = {};
 	int rv;
 
 	pkt.tag.type = VIO_TYPE_CTRL;


