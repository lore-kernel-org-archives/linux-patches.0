Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9BE83AE6E6;
	Mon, 23 Mar 2026 14:48:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774277281; cv=none; b=RFuBhc6y6zmGj9T+LZLHnQ0pG+xyN/nHkxAxkdky4MIBGTXX7oij3LH1RZe8uIQjmcB6iVmH5xn1Jx8j9yzQ9Z4k9NJpoVGVgLLJ0uJQqTyyVoSqWcwDv13sypB8sVWbsONs2b/gU1AzI8Bmfu5RQCNc97L8hInW97jWBJ4E5u0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774277281; c=relaxed/simple;
	bh=eSRemrrplmsUqIc4p3Zz1/sqQ26eHUNIXEWeoBB0ll8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rQiNIL4lMqu7otHmLoQhwWaO0CA8nejJ5uVnZ9abZJf5+CEx6tG0e0X2OZmnY3qqmmOvB3uEMrW3G/a5H1JwcUAk8iE/Uvv0bsfGIDCezeXPTeTJbwEklQmGARA+iSfSc9zlD8tGcKcVQZBvTMG2+N465qwu7jomOLeCTumNmhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MWyIiXaJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MWyIiXaJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30392C4CEF7;
	Mon, 23 Mar 2026 14:48:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774277281;
	bh=eSRemrrplmsUqIc4p3Zz1/sqQ26eHUNIXEWeoBB0ll8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MWyIiXaJnaoc6VTlKGqW+wjGD9f5Q9vhzeybKegc27YWiNKjcSmdQ8REgJxmQn6f8
	 p+ZR/d9e5ZYwDeXTFD+EHLlMwFNv8cim46IwHtzf017zHfw7UZPTegpGvdeVt8OHmt
	 fSodt6Wfqg48g8Y/J3dMyxlLU6KZAENs9tbmfhpQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Jander <david@protonic.nl>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.12 338/460] spi: fix use-after-free on controller registration failure
Date: Mon, 23 Mar 2026 14:45:34 +0100
Message-ID: <20260323134534.836267401@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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
@@ -3367,10 +3367,8 @@ int spi_register_controller(struct spi_c
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
@@ -3393,6 +3391,8 @@ int spi_register_controller(struct spi_c
 
 destroy_queue:
 	spi_destroy_queue(ctlr);
+del_ctrl:
+	device_del(&ctlr->dev);
 free_bus_id:
 	mutex_lock(&board_lock);
 	idr_remove(&spi_master_idr, ctlr->bus_num);


