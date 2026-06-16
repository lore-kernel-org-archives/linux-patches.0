Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1EDA169AD2;
	Tue, 16 Jun 2026 16:55:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781628939; cv=none; b=YTdIOIFZraOuV9wNKXOq+Hwj69gczBthTDo4qrtZXpMWCskNKqj4ARrPPHvU8TFvfElu8bji1rWHfs30tp20Z/jNSLabyl3NDy0TWB/4DkWBoiOkJnwJpiWZVX01Dg2vfvBpLr6P68SS2/knocOXc/e3Oo+jaCk3riv+axTRa9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781628939; c=relaxed/simple;
	bh=StS3bzZGLOTLHbhtScqUlwvHJS79dvZGqNSEHnxiZAI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RmR2vTe2oXdrjZtBbkmU8BKwvwgF7fczBkYZZJu0v/P5g2zUD/TJ/jxP61wMllxCA+3ZZmjWyFoYXWspWQsaWhgCFnzxjg3ToG/U/kAfQ2SjnMb9ySY7++oj1h+wEovPIm5MygFo8ETk+SfeRABuvsQjDIFgAte2Pd8k4QZmBKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fCRfb03X; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fCRfb03X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA82D1F000E9;
	Tue, 16 Jun 2026 16:55:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781628938;
	bh=z34dSYW8Ioov80/niWCa16JS8xUwHWX++dfqeTZwhgA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fCRfb03Xn1B0O5xodlWMhP3R+xnC2RoCZ4v4kxB/1XY5P1pgy1XavaKrRDvrl9Spl
	 eAy9J63tr1GmtztxcK66SOV2oE/U9Zihyz1Fqhw++0Uah4EbZ3rrp6O0L8EaIk9xc5
	 TDZjOThSpHidtEfKNMuIYxeIt8CgeEci1k+3gUh0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 191/452] USB: serial: cypress_m8: fix memory corruption with small endpoint
Date: Tue, 16 Jun 2026 20:26:58 +0530
Message-ID: <20260616145127.870165606@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit e1a9d791fd66ab2431b9e6f6f835823809869047 upstream.

Make sure that the interrupt-out endpoint max packet size is at least
eight bytes to avoid user-controlled slab corruption or NULL-pointer
dereference should a malicious device report a smaller size.

Fixes: 3416eaa1f8f8 ("USB: cypress_m8: Packet format is separate from characteristic size")
Cc: stable@vger.kernel.org	# 2.6.26
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
[ johan: adjust context for 6.18 ]
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/serial/cypress_m8.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/usb/serial/cypress_m8.c b/drivers/usb/serial/cypress_m8.c
index 4c625e77da3a8f..f567617c8f2314 100644
--- a/drivers/usb/serial/cypress_m8.c
+++ b/drivers/usb/serial/cypress_m8.c
@@ -448,6 +448,14 @@ static int cypress_generic_port_probe(struct usb_serial_port *port)
 		return -ENODEV;
 	}
 
+	/*
+	 * The buffer must be large enough for the one or two-byte header (and
+	 * following data), but assume anything smaller than eight bytes is
+	 * broken.
+	 */
+	if (port->interrupt_out_size < 8)
+		return -EINVAL;
+
 	priv = kzalloc(sizeof(struct cypress_private), GFP_KERNEL);
 	if (!priv)
 		return -ENOMEM;
-- 
2.53.0



