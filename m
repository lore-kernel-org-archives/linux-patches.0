Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 016683AE1A2;
	Tue, 16 Jun 2026 18:48:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781635720; cv=none; b=BiRtCuRSWPeIk74QMorTWLHQex29t4Two0yRVVDbvY7cz+MfbFi5jNvf6qxoYB4wqA6Zoho+ud1sHBM4r+hc41o3OZ676AGUBPyM2Cdtkbz1p4Dqj5LayknrQUymIVYG3ZIepotYnAzd9KIeqMms5F0HnGMReCkmZObzr8wp/XY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781635720; c=relaxed/simple;
	bh=DHA4SQIMLnvJ+X2xqPcIRxZr0JHYgaapNW07vZQc/3I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VOOxPoMZtIOSSGDo+BtmjnR1hXGFqM2xl4twxXTwpjsb+81dozpuAb88mWzenw0O+hL7DeVSxoDA65M9esEF9lbc8S9M3Zd7Ql9OVObgMTy2+P661BkBlTwd1Vdm3IWA2WUHF0jjaTnYq5l7yjjy0uGc8YEYArh74iOqzhEM/r4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t0LywBkh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t0LywBkh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 007481F000E9;
	Tue, 16 Jun 2026 18:48:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781635719;
	bh=IQyu4QkQlMCsPVD3sKAGTvjqXmE6zuSt8cbTyfbegxc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t0LywBkhqr/pWXAqQJmOrO7tTELKKS5AnZRVqip73QFh7LRI/LXB92zOa23z5Uezf
	 NsjcK8dJngZEB9tF/IHOHfxDdDUSbUNkNY91HIj87NOfsur6N+PNzfIeds6siDwDyH
	 XziB0fUsnjpw8jT7O39aNGtNSHtjorRFlp1EB7NY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.10 103/342] USB: serial: mct_u232: fix missing interrupt-in transfer sanity check
Date: Tue, 16 Jun 2026 20:26:39 +0530
Message-ID: <20260616145053.027516195@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145048.348037099@linuxfoundation.org>
References: <20260616145048.348037099@linuxfoundation.org>
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

From: Johan Hovold <johan@kernel.org>

commit 245aba83e3c288e176ed037a1f6b618b09e92ed8 upstream.

Add the missing sanity check on the size of interrupt-in transfers to
avoid parsing stale or uninitialised slab data (and leaking it to user
space).

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/mct_u232.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/usb/serial/mct_u232.c
+++ b/drivers/usb/serial/mct_u232.c
@@ -545,6 +545,11 @@ static void mct_u232_read_int_callback(s
 		goto exit;
 	}
 
+	if (urb->actual_length < 2) {
+		dev_warn_ratelimited(&port->dev, "short interrupt-in packet\n");
+		goto exit;
+	}
+
 	/*
 	 * The interrupt-in pipe signals exceptional conditions (modem line
 	 * signal changes and errors). data[0] holds MSR, data[1] holds LSR.


