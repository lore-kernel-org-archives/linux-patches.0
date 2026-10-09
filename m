Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B8934E36F8;
	Fri,  9 Oct 2026 14:52:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557536; cv=none; b=kumfzrXHNh8Ke41M9sJVw+zF+HZgmqRaTRaQPCVvq0hO9WyOAatjbn9hJOICSWOkYPKFi+Jb1cx+Jz4gnLuLxKzq3kNsxl3VzN0rVL6WV5Mb94jOXECd1lIRbjlLc0ZHEfTHdd8x+6XCVvw/PcocATq5FepCVLVbkgfh/bV9rZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557536; c=relaxed/simple;
	bh=4aPXEXR81kbSA6k0RxfDF0y0GDcfPwc4F1OhcoFqknU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ogSijxE8YqaCQggDyTTT1+5dNBW/oLhPzVDvbiG2YCqll4EGj5dk0ojROenIuMRX4GO7PTnCfJ47H6cdDAcoSaKxbrGcHbXjBFo2VdLhwiLO5SdqTZhk+cUgmOgCwIOLHgAyNVbDSJzHyQ7205KZVHbcKudfWRBoAJPbbvuqczM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JieZbcON; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JieZbcON"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A841D1F000FF;
	Fri,  9 Oct 2026 14:52:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791557535;
	bh=1KsznxGQNpNGzTUY2KrTAxeoJBLpFEIauj4Hl7i2aXo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JieZbcONUe0uzL7RBrWF3T9UHX6oHhxAcfzEY9cu9/U5AKUaPU1L08jZall33B46Z
	 LoKteWqxzJfdope05bxZANRYZnFxyjw6EUaqAV6XhVnf2hTzPEVyHzl49DyTgJURoO
	 hfoMwIUMtAmJ7oIZ1TxT+WQ7dzPSuR3nMj8Sh7F8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Peter <sven@kernel.org>,
	Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 7.2 354/428] thunderbolt: Tear down inactive DP tunnels when the domain is stopped
Date: Fri,  9 Oct 2026 16:11:31 +0200
Message-ID: <20261009140953.943841133@linuxfoundation.org>
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

From: Sven Peter <sven@kernel.org>

commit 0b457c6733f73421a3fb03786f13d67c618b5119 upstream.

tb_stop() only tears down DMA tunnels so a DP tunnel that is still
waiting for dprx_work to complete keeps that work queued while the
routers are removed and the control channel is stopped. The work only
stops once the DPRX timeout has passed and because it requeues itself
until then the flush_workqueue() in tb_domain_remove() won't wait for its
final run. The callback then runs against a domain that is already torn
down. A reference to that domain is kept so the completion waiting for
that domain to disappear in unbind will block until the timeout is
eventually reached.

Tear down DP tunnels that are not active yet as well which also cancels
that work. Tunnels for displays that are already alive are untouched and
keep working.

Fixes: d6d458d42e1e ("thunderbolt: Handle DisplayPort tunnel activation asynchronously")
Cc: stable@vger.kernel.org
Signed-off-by: Sven Peter <sven@kernel.org>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thunderbolt/tb.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/drivers/thunderbolt/tb.c
+++ b/drivers/thunderbolt/tb.c
@@ -2950,11 +2950,12 @@ static void tb_stop(struct tb *tb)
 	/* tunnels are only present after everything has been initialized */
 	list_for_each_entry_safe(tunnel, n, &tcm->tunnel_list, list) {
 		/*
-		 * DMA tunnels require the driver to be functional so we
-		 * tear them down. Other protocol tunnels can be left
-		 * intact.
+		 * DMA tunnels and DP tunnels which are not yet active require
+		 * the driver to be functional so we tear them down.
+		 * Other protocol tunnels can be left intact.
 		 */
-		if (tb_tunnel_is_dma(tunnel))
+		if (tb_tunnel_is_dma(tunnel) ||
+		    (tb_tunnel_is_dp(tunnel) && !tb_tunnel_is_active(tunnel)))
 			tb_tunnel_deactivate(tunnel);
 		tb_tunnel_put(tunnel);
 	}


