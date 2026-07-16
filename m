Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B311542A16C;
	Thu, 16 Jul 2026 14:10:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211010; cv=none; b=TmEgUCqHxbXAdBE0cTSfPenSw85WJ6Wl2UMMOTaJJ04U1AqSCcXwQTLY2WJX01j9+qukcIri/m8izS/ZSwC1Q5iBPL9iLT6stVKQN6tBA9AiQ40Qj91fnGNMPaZV8TM5PvIR/hXXWe4jRZ2UIOhsyDflk2mrMdJSOCa1CZ/sPXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211010; c=relaxed/simple;
	bh=vzCc4wfz77+oACKSgusl6QP0A20xqYImVVBR7hUys+I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HvNsrH4J8dzKD3YR7XQJwmqhT6+031Wp1U62ypUTknBokFkJZNcsc0SaN58/Jwx5ChGm1tIAmezy9Sf2j5L1rvByIniO1HsXUmUA3GstwkgwKzExSlNuyz/Ln5+czt/EKkyNpx2dv7rxQPaWRxjFk9dGPSRFcqLE1jOLWEH3Abg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TnnNTbjz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TnnNTbjz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 250CB1F00A3F;
	Thu, 16 Jul 2026 14:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211009;
	bh=mq/PPZukIParLzIquto9wzOhr69ufL/PXoq/eu0TaaI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TnnNTbjzqO7S6oHVxIFVuiLeymsKSxD7Qoeewzm45hWHvWtBItvenixta7KXeZw+n
	 t7ijFSQtAyZ05RP10p4o+8rUa3DAvIMhNYAnJPYvTh7RHp5AyvHv2bbI4FqGQ/quZp
	 q6QHEpOf76Eu9dMBYqdEpqnD3oYOQZkGafrdHqFA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko-bot <sashiko-bot@kernel.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Jinmo Yang <jinmo44.yang@gmail.com>,
	Benjamin Tissoires <bentiss@kernel.org>
Subject: [PATCH 6.18 264/480] HID: wacom: use GFP_ATOMIC in wacom_wac_queue_flush()
Date: Thu, 16 Jul 2026 15:30:11 +0200
Message-ID: <20260716133050.530052145@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jinmo Yang <jinmo44.yang@gmail.com>

commit 55f1ad573e34abf9a0443c34bc5a63d74edba7d7 upstream.

wacom_wac_queue_flush() is called via the .raw_event callback
(wacom_raw_event → wacom_wac_pen_serial_enforce → wacom_wac_queue_flush).
For USB HID devices, this callback is invoked from hid_irq_in(), which
is a URB completion handler running in atomic context. Using GFP_KERNEL
in this path can sleep, leading to a "scheduling while atomic" bug.

Use GFP_ATOMIC instead. The existing code already handles allocation
failure by skipping the fifo entry and continuing.

Reported-by: Sashiko-bot <sashiko-bot@kernel.org>
Fixes: 5e013ad20689 ("HID: wacom: Remove static WACOM_PKGLEN_MAX limit")
Cc: stable@vger.kernel.org
Reviewed-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Jinmo Yang <jinmo44.yang@gmail.com>
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/wacom_sys.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hid/wacom_sys.c
+++ b/drivers/hid/wacom_sys.c
@@ -76,7 +76,7 @@ static void wacom_wac_queue_flush(struct
 		unsigned int count;
 		int err;
 
-		buf = kzalloc(size, GFP_KERNEL);
+		buf = kzalloc(size, GFP_ATOMIC);
 		if (!buf) {
 			kfifo_skip(fifo);
 			continue;


