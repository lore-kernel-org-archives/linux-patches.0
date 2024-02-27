Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88D3713DB98;
	Tue, 27 Feb 2024 13:56:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042206; cv=none; b=Ls91vM/OGo+I3xwgAEBjKkrpdJrc6Imyg9ylDtEp6yCO6Sh5EeeuxqKe2KU1cYJO+K7H+shBJ5hdwbwAQnbKS4UElKbEPxjyHKHldxdnPnCM0WRl3JJabxCxXp4DB457QHJt5lNWTprxGlDlVmKJti6footUQRWAeDUMHOT9Tbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042206; c=relaxed/simple;
	bh=2fhX7ucvqwRiImLEId31RB5S9FHCRdkavXYm+GCScrk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bXa7dtcY3QwUb+YJ9L2ent39okaNRdwqxRHM89eY9OKmmvUz+rJxQOa7uRFGsRlMbTWa5odEmf39dz5d4LnkYLGJ28TwFrMDf5K9rbbScs9fFkB7pmgsBlhGoidKngkVim2dakrzmFkyt09QLs0cjPbZg3Xhhsmali43i/KXruE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lmfYG7S1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lmfYG7S1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 059E0C433F1;
	Tue, 27 Feb 2024 13:56:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042206;
	bh=2fhX7ucvqwRiImLEId31RB5S9FHCRdkavXYm+GCScrk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lmfYG7S1wMAGM+G6QIz0a+pSYA/dG7LopBiGYwduU6kRvn2PzhdwerqQpYh30ZEtE
	 Sh2aSPovKASLZ4qjPYyTesrSuJxfTavtMIgQJR1UctZriDlucNayOfzthclbMr9yKW
	 r8MDyJTYvRgob4S5hUzL5NI0Jm79cDNm8hxueCZg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Roger Quadros <rogerq@kernel.org>,
	Peter Chen <peter.chen@kernel.org>
Subject: [PATCH 6.6 187/299] usb: cdns3: fix memory double free when handle zero packet
Date: Tue, 27 Feb 2024 14:24:58 +0100
Message-ID: <20240227131631.851018580@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
References: <20240227131625.847743063@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Frank Li <Frank.Li@nxp.com>

commit 5fd9e45f1ebcd57181358af28506e8a661a260b3 upstream.

829  if (request->complete) {
830          spin_unlock(&priv_dev->lock);
831          usb_gadget_giveback_request(&priv_ep->endpoint,
832                                    request);
833          spin_lock(&priv_dev->lock);
834  }
835
836  if (request->buf == priv_dev->zlp_buf)
837      cdns3_gadget_ep_free_request(&priv_ep->endpoint, request);

Driver append an additional zero packet request when queue a packet, which
length mod max packet size is 0. When transfer complete, run to line 831,
usb_gadget_giveback_request() will free this requestion. 836 condition is
true, so cdns3_gadget_ep_free_request() free this request again.

Log:

[ 1920.140696][  T150] BUG: KFENCE: use-after-free read in cdns3_gadget_giveback+0x134/0x2c0 [cdns3]
[ 1920.140696][  T150]
[ 1920.151837][  T150] Use-after-free read at 0x000000003d1cd10b (in kfence-#36):
[ 1920.159082][  T150]  cdns3_gadget_giveback+0x134/0x2c0 [cdns3]
[ 1920.164988][  T150]  cdns3_transfer_completed+0x438/0x5f8 [cdns3]

Add check at line 829, skip call usb_gadget_giveback_request() if it is
additional zero length packet request. Needn't call
usb_gadget_giveback_request() because it is allocated in this driver.

Cc: stable@vger.kernel.org
Fixes: 7733f6c32e36 ("usb: cdns3: Add Cadence USB3 DRD Driver")
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Reviewed-by: Roger Quadros <rogerq@kernel.org>
Acked-by: Peter Chen <peter.chen@kernel.org>
Link: https://lore.kernel.org/r/20240202154217.661867-2-Frank.Li@nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/cdns3/cdns3-gadget.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/usb/cdns3/cdns3-gadget.c
+++ b/drivers/usb/cdns3/cdns3-gadget.c
@@ -828,7 +828,11 @@ void cdns3_gadget_giveback(struct cdns3_
 			return;
 	}
 
-	if (request->complete) {
+	/*
+	 * zlp request is appended by driver, needn't call usb_gadget_giveback_request() to notify
+	 * gadget composite driver.
+	 */
+	if (request->complete && request->buf != priv_dev->zlp_buf) {
 		spin_unlock(&priv_dev->lock);
 		usb_gadget_giveback_request(&priv_ep->endpoint,
 					    request);


