Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32EC74EF13B;
	Tue, 13 Oct 2026 11:48:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892097; cv=none; b=RmJ0tam2XODj/1Xai0cU4J0vd8YGU0SDDWLnGPH3LUAmlY779ElhA2roepDzd5xe/GNDykwyuvZAepjjx7BFyh+MDuBBTruN0oUGxaJLWqDNt1iKtxkOICwa1EdJSUW18kT0Btu1znT1hzwjVuzjA/iE3UmJu+L/+yQY/2M0HcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892097; c=relaxed/simple;
	bh=GtUetH9c7ykA5EKRc69CU2Ezp/LQht8dW3kLmqQJslg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uj1XxLjWdxw7r/zg7f3Np+CCAcdbnYRPgGn3mHt8VWZM8m6OfIPAmC8b8DCyNpAdk6GpbXjvp9YJILQEmALf7Feam89oFIQFCysLTZkMGgA9HvQIyL7At92fnGUAm8ElOuQqs3jwF55Tkquuqp1KHpz7ZY5lpBD7BfsgUgkRaHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mN5JPoSA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mN5JPoSA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AA831F000FF;
	Tue, 13 Oct 2026 11:48:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892096;
	bh=vrbwTXN+LFHRVAHuRF41btqVNt1aEkkVB3k32zo361s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mN5JPoSA8F4GcBmLR5wfmyrIOQF6dRVOSJk3Him5L/6ux7M9nq7ZwB96N4SFfiPWe
	 MQRfFhtZb76MO5B7ipr7HDeYVhv2WTbRkRH4LKaPE98+CD2iu1TCZc4YE7pcwCMiY+
	 rgyHaCh6tiLzhSV/7qht38mjhjoDyw5nwS2YyCro=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Hostetler <thostet@google.com>,
	Jordan Rhee <jordanrhee@google.com>,
	Joshua Washington <joshwash@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.2 058/281] gve: fix XSK buffer leak when rings are stopped
Date: Tue, 13 Oct 2026 13:36:14 +0200
Message-ID: <20261013112856.461732204@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
References: <20261013112855.045212108@linuxfoundation.org>
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

From: Joshua Washington <joshwash@google.com>

commit 73670ddb91a4d22e1deb3efd962242de1ec48e90 upstream.

GVE does not free XSK buffers when resetting ring state as a part of
stopping queues. This causes all XSK buffers which are posted to the
NIC to be leaked.

Free XSK buffers attached to an allocated buf_state when stopping rings.

This issue was hit in production.

Fixes: c1fffc5d66a7 ("gve: implement DQO RX datapath and control path for AF_XDP zero-copy")
Cc: stable@vger.kernel.org
Reviewed-by: Tim Hostetler <thostet@google.com>
Reviewed-by: Jordan Rhee <jordanrhee@google.com>
Signed-off-by: Joshua Washington <joshwash@google.com>
Link: https://patch.msgid.link/20260930214735.3288780-2-joshwash@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/google/gve/gve_rx_dqo.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/net/ethernet/google/gve/gve_rx_dqo.c
+++ b/drivers/net/ethernet/google/gve/gve_rx_dqo.c
@@ -113,6 +113,12 @@ static void gve_rx_reset_ring_dqo(struct
 				gve_free_to_page_pool(rx, bs, false);
 			else
 				gve_free_qpl_page_dqo(bs);
+
+			if (gve_buf_state_is_allocated(rx, bs) &&
+			    bs->xsk_buff) {
+				xsk_buff_free(bs->xsk_buff);
+				bs->xsk_buff = NULL;
+			}
 		}
 	}
 


