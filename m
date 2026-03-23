Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27B7F3AEF51;
	Mon, 23 Mar 2026 14:03:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774274624; cv=none; b=anafqwvU5IQLzt7ySUL/NQI+zrCNtyXMM+vHDtWUmYqrSkKXxy9GK2rJYynQGuDrBV/KV0+12kwtaP1GRll3ggUnDnvBiNZaFZgaWqtBWBChjj1EpdZvI1lISMuCwN1G7Ki8R5dClmCrCdbuyQncRK1oNWgIkAH9xCe6KyDq7wk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774274624; c=relaxed/simple;
	bh=3CmYyc6tsUtWcPvFVSyIbwen5jaGWjKRSIh+8VkrZXI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bItZRWb9aTmWZwIKkm/fv10v+be1obFSOV9YyAS6YNaLFsX8vcXacbBvQonZ5QiCvDJpoKzdKsI8QNM9S7uYIsFzyGL/9B1GFIbXFRxgL8k3U7xI1QT61EbwTqUUiBK88X23OYzAd/bn2KGIesGgNxxgxGN4m96wywSwkJM60yo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YIRGdHZa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YIRGdHZa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0288C4CEF7;
	Mon, 23 Mar 2026 14:03:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774274624;
	bh=3CmYyc6tsUtWcPvFVSyIbwen5jaGWjKRSIh+8VkrZXI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YIRGdHZaEEOZT4zRAeX88ZrUBetZeIaTu94+o1oDD7Dltquv9sqpoY/Ne+JGo3DVj
	 k2ZJ5P5mZKhlxppmvcvSK4LCH/+zhieMz+Su3nimr1DVLvvMKO/FEz4H4WOmakLTcF
	 2Fsr1Uh0XAoryISIU3Qz31MQxfNjOp9SErd6B4ZU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Jander <david@protonic.nl>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.18 056/212] spi: fix use-after-free on controller registration failure
Date: Mon, 23 Mar 2026 14:44:37 +0100
Message-ID: <20260323134505.538665618@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134503.770111826@linuxfoundation.org>
References: <20260323134503.770111826@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3344,10 +3344,8 @@ int spi_register_controller(struct spi_c
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
@@ -3370,6 +3368,8 @@ int spi_register_controller(struct spi_c
 
 destroy_queue:
 	spi_destroy_queue(ctlr);
+del_ctrl:
+	device_del(&ctlr->dev);
 free_bus_id:
 	mutex_lock(&board_lock);
 	idr_remove(&spi_controller_idr, ctlr->bus_num);


