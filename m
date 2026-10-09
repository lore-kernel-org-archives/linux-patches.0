Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6325E3B19DE;
	Fri,  9 Oct 2026 14:39:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556768; cv=none; b=mwKA5TOuOHEGwa83w/9Qoj3E/2nrhqQ683IpqtTYPj19K95jiOD9FoeMZCIAiHTR2EXG0pGxbQpxk49b3XjaloI2qJYUsaZnjSFVCkmYdTQCrJliE2NCeymgYiaJkHoXafMfoSRdQJRHWWiZCuo5GJ4vUwBl5aZYh4GNeI9aNos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556768; c=relaxed/simple;
	bh=FkN7FrYKezkmKLumljsAcdS7OeyRE+ISPUA7ZzOHL9g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i4pLLCGCNlxOSkZUALFI5Ht06PoxU3QWDhS/J9KI96XfCnnbUxR8axNowZlA/Z5XqUTF0kJfXFuyvpmIwLHOch7FlzxHAImLz9h3rkHbKjYR0HjZ/iO6Kp2/tSiOnZC786Dy4Ho/3FEvn4Neoo1qk0SFC3TCVUdMafvoavO1tAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0E787mVy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0E787mVy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 750131F00893;
	Fri,  9 Oct 2026 14:39:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556767;
	bh=hb2QWsOzUUWccqIofkD86kcSrP1Ot5Z6F931n0WVK94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0E787mVy2N2d7hrrpqEt5gYWmRnbk783vqIHnv4/EzxBjBU56muAo+YejUJkmix79
	 /Dim7aeF0KHZGQqs2Jlf793iRCyeVKCQJAO1iaY4r1+JNC1l0aqrEfutdIGxTghqQI
	 99rvFjFnslKLnHCuHusMM1h4TpniwC7hDOwB/U20=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Peter <sven@kernel.org>,
	Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 6.18 290/403] thunderbolt: Tear down inactive DP tunnels when the domain is stopped
Date: Fri,  9 Oct 2026 16:10:51 +0200
Message-ID: <20261009140958.983229160@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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
@@ -2946,11 +2946,12 @@ static void tb_stop(struct tb *tb)
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


