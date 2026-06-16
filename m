Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C173A2C0261;
	Tue, 16 Jun 2026 18:48:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781635710; cv=none; b=G59xhJkTr+313V6TmiIly//Ecy7sK/hPJAhJ9E+Clazz8fSOCm1BPf3ilUK3eTPtxmhLzRsJKp57Sa6XtqDvHuVZL0fxWFqzflUBemMMchizWOjh8jfIkdXcWadr+iTWKuBu5YxPsELSumnvgrTepfpowyIkdMs24iKLVOlwQHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781635710; c=relaxed/simple;
	bh=Q0CymfwSRind67AOTsbJFT2RYyLdfr7NQBUej8wr2hw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N0zUilAIyV7hgjcIKLjr8sMS1dtjequ8mteGLpzGM7zZxSlXtbBK0S9NKTN7Y6xcPgOwRziAcGKg4OEhUqyfvdANhCeoXhQD/quoXdGnm1I9zyqOitBwoeJ3MIyX/YsxBeqzKvT6DyVfKqD90iziph5BF57C7J2Ld9iBnhVKH8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fG3c+iYM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fG3c+iYM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BC811F00A3A;
	Tue, 16 Jun 2026 18:48:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781635709;
	bh=fVDPkUrB2oYFnAGglY/qz70WXVRNjoGsF7m30c8dKCU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fG3c+iYMIhNYUR72lhWQVI35/NtdouUTVNlIyur59f0wsHabuPnLY56RqN6FPedYc
	 2c34E3FQyCL/nwHTzWjPJ9DpqKdJH8USeYgoz99rOBufkIPNbWnbvRu6KNJLzFlwTp
	 JF2YpBVW26NaL6BN4WRfGUu4lYltljrDElzz+QVM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.10 101/342] USB: serial: keyspan: fix missing indat transfer sanity check
Date: Tue, 16 Jun 2026 20:26:37 +0530
Message-ID: <20260616145052.935864812@linuxfoundation.org>
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

commit ab8336a7e414f018430aa1af3a46944032f7ff96 upstream.

Add the missing sanity check on the size of usa49wg indat transfers to
avoid parsing stale or uninitialised slab data.

Fixes: 0ca1268e109a ("USB Serial Keyspan: add support for USA-49WG & USA-28XG")
Cc: stable@vger.kernel.org	# 2.6.23
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/keyspan.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/usb/serial/keyspan.c
+++ b/drivers/usb/serial/keyspan.c
@@ -1204,6 +1204,10 @@ static void usa49wg_indat_callback(struc
 	len = 0;
 
 	while (i < urb->actual_length) {
+		if (urb->actual_length - i < 3) {
+			dev_warn_ratelimited(&urb->dev->dev, "malformed indat packet\n");
+			break;
+		}
 
 		/* Check port number from message */
 		if (data[i] >= serial->num_ports) {


