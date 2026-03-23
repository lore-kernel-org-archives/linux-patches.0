Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97292275AF5;
	Mon, 23 Mar 2026 15:16:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774278967; cv=none; b=DX5x+CTYp/cpZGgK2i5DfC39yfvBourkh46AJ0PfiXORzgXVponEBO6cyn0mDEG9q7NQXFhB0f7qnmM8XRV5x0xLua/QFfjAoMdD1XyRwkq5jiZ0kpRQro0IkI9lV71r5o4tr8h0oyjSV75l/tpwjEYKEwtZPWn3VdddhAf6Gss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774278967; c=relaxed/simple;
	bh=/RIkYjeJ2H7HHXR2824IcBGScQxj3k9UrT7z6dsEYu4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZPSAmhqRIuK3lIqAllPSrH3IQs6B2458ui8v3GhfiVOEDptgQR1LeoStW3vJdXQdEfmvvRsbc6glzjbic4Ps3y6aBNV/MSZtQt3g4PgFYDRvh2t2T+n60vUTSULNI7y6OjePKhtJJaMDBq+f8dQJiHj+Jt2u1xgoANSP9AX5Ngc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c/qTpTOV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c/qTpTOV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AC35C2BC9E;
	Mon, 23 Mar 2026 15:16:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774278967;
	bh=/RIkYjeJ2H7HHXR2824IcBGScQxj3k9UrT7z6dsEYu4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c/qTpTOVcgs4NB8PvhlbTdQ6RnkaCUEeOLpgpib3PomEcRAmg4N0DRJ47S2nduNDf
	 1KiUew7FjWtQXs189IpCVpzbEnvt/9ImHonpNndY9CLEMycGXV4NJPCsSYTwBvKsak
	 8bMGnLNN+l4Y5SEZyxpv5qiYDpk8glLwEOdmzb0k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Jander <david@protonic.nl>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.6 477/567] spi: fix use-after-free on controller registration failure
Date: Mon, 23 Mar 2026 14:46:37 +0100
Message-ID: <20260323134545.782843827@linuxfoundation.org>
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

From: Johan Hovold <johan@kernel.org>

commit 8634e05b08ead636e926022f4a98416e13440df9 upstream.

Make sure to deregister from driver core also in the unlikely event that
per-cpu statistics allocation fails during controller registration to
avoid use-after-free (of driver resources) and unclocked register
accesses.

Fixes: 6598b91b5ac3 ("spi: spi.c: Convert statistics to per-cpu u64_stats_t")
Cc: stable@vger.kernel.org	# 6.0
Cc: David Jander <david@protonic.nl>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260312151817.32100-2-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -3213,10 +3213,8 @@ int spi_register_controller(struct spi_c
 		dev_info(dev, "controller is unqueued, this is deprecated\n");
 	} else if (ctlr->transfer_one || ctlr->transfer_one_message) {
 		status = spi_controller_initialize_queue(ctlr);
-		if (status) {
-			device_del(&ctlr->dev);
-			goto free_bus_id;
-		}
+		if (status)
+			goto del_ctrl;
 	}
 	/* Add statistics */
 	ctlr->pcpu_statistics = spi_alloc_pcpu_stats(dev);
@@ -3239,6 +3237,8 @@ int spi_register_controller(struct spi_c
 
 destroy_queue:
 	spi_destroy_queue(ctlr);
+del_ctrl:
+	device_del(&ctlr->dev);
 free_bus_id:
 	mutex_lock(&board_lock);
 	idr_remove(&spi_master_idr, ctlr->bus_num);


