Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66D983A961B;
	Mon, 23 Mar 2026 13:51:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774273909; cv=none; b=rW8VZ6IshYQEBiW4Es3XQwqf4kgI7d7IDDOIPnGigtkNKJ4rgGVel3KL8DnhrgHBsN90YPlEQkkWKTTHg92aR9N4WjVpLGL2HW8c2pHZ81ZuQh+QDxi/F5n7aZRbgmwQHQjtfrZ++ucPBAe7AZqJ8ITOrA3tsSAUSWYkdYkLhxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774273909; c=relaxed/simple;
	bh=Jk63OrMps+XosBadNcDv6b8pTEqtrADP/qACJI4jvRY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rp7L0Jv4AW9Rjcm9F6nxqKit1Ng8nW7GifbmX5nKH9Sl3F4qVPXa5LK4YoYJl8YJCDSyzPjh1wKwSEaj7lobflNlh59CTTSw2FHCiBfy7kVe+c3iwGjV9sg1ZtSPlDAsj1tVJevK0kfLmjcfB7qYuyX8+azwoE+ntA7pKpBJzkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JlNFIcYp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JlNFIcYp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0BCCC4CEF7;
	Mon, 23 Mar 2026 13:51:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774273909;
	bh=Jk63OrMps+XosBadNcDv6b8pTEqtrADP/qACJI4jvRY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JlNFIcYpF8Axy/VSIB+cA17w7Uc7mM6KyAElH2E3tyOJ6mjRIxrDPo1gmBbI0a5HT
	 09XB4LMC3GrFxWplrWF9vvskdYVhR2vC2fPvrmCrslOa/B2YgAlwbvSNw8M7+BdGmG
	 BVBmprcWR1TZUVqUKxuYcbBxlJw/hlePtZgQjCjQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Jander <david@protonic.nl>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.19 047/220] spi: fix use-after-free on controller registration failure
Date: Mon, 23 Mar 2026 14:43:44 +0100
Message-ID: <20260323134506.074275295@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134504.575022936@linuxfoundation.org>
References: <20260323134504.575022936@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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


