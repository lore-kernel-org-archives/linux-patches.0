Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EDAB38333C;
	Sat, 12 Sep 2026 19:25:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789241156; cv=none; b=ijv8hJBdwerMJvTLGRIx3dPsVz3c4CiwdUl8PTNvX96Sq+BWfuQ9dZyqm0C2t7a7OS3sFl4BXj8cIVYG0QGXeVp60e6qOgAQJmsctqnvlxUzgdBrawlb2Bx5eJ6qFenVxI+DTs25Mx5Y4gmzwSrMx3LHhGn/003gycPpLPX2M5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789241156; c=relaxed/simple;
	bh=7urkWv5jDTqyLboa2Mz3ruX1Np6oLHSVlKs3O0fpE9c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eInjl2qOhlRqdwTQXf15h4ExGThN+oYYn5zRxobLwHqDEqB+KUhAKi/xmJ34TsShrK6ZDghCzqYOu5GXp0+H/iBuh9/Wcs5yAEzWZCg9B51g0e6Ctr9muRH2/fjwVIyzDnB7mMRgKFj5sczkOAuIbGRNvV5+8rYf7LsHAIxnaic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wRNW4AHF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wRNW4AHF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F1A51F000FF;
	Sat, 12 Sep 2026 19:25:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789241154;
	bh=8SKi+lePPyU+tCtt6wMhuKOKlKtq7TmXqjQSlr+/7is=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wRNW4AHFZ5ySI7IMuRZMcCWVO4fLpI0leE1lDPgbfAHHF+wbd/A40G7rWYtJzWzIs
	 kzkfzz7+Dby5V3b/rnuu5ozOXi8wkP+9hYt/yBM1aPfsc0DVN5pymravchd7vTML3o
	 LeROdUDCSiy75LGRsFYY5OpOtMezz2LtO+BWlyQE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiangshan Yi <yijiangshan@kylinos.cn>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 078/798] bnx2x: fix double free in bnx2x_init_firmware() error path
Date: Sat, 12 Sep 2026 08:55:06 +0200
Message-ID: <20260912065518.752974080@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiangshan Yi <yijiangshan@kylinos.cn>

commit d2796ffe38cb4155afe0eab23636295b096c27a5 upstream.

bnx2x_init_firmware() frees bp->init_ops, bp->init_data and
bp->init_ops_offsets in its error path without setting them to NULL.
The cleanup function bnx2x_release_firmware() frees the same three
pointers unconditionally, so if init_firmware fails and
release_firmware is later called (e.g. from __bnx2x_remove or through
the function state machine), all three are freed a second time.

Set each pointer to NULL after kfree() in the error path so that the
subsequent kfree(NULL) in bnx2x_release_firmware() is a safe no-op.

Fixes: 94a78b79cb5f ("bnx2x: Separated FW from the source.")
Cc: stable@vger.kernel.org
Signed-off-by: Jiangshan Yi <yijiangshan@kylinos.cn>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260815122149.951215-1-yijiangshan@kylinos.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
@@ -13548,10 +13548,13 @@ static int bnx2x_init_firmware(struct bn
 
 iro_alloc_err:
 	kfree(bp->init_ops_offsets);
+	bp->init_ops_offsets = NULL;
 init_offsets_alloc_err:
 	kfree(bp->init_ops);
+	bp->init_ops = NULL;
 init_ops_alloc_err:
 	kfree(bp->init_data);
+	bp->init_data = NULL;
 request_firmware_exit:
 	release_firmware(bp->firmware);
 	bp->firmware = NULL;


