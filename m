Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63E782DFF04;
	Sun,  7 Jun 2026 10:49:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780829354; cv=none; b=mPgeX42cLKrcJcoahwr6Mk0wXVJholW7/xRh9oj24HBGBH0XqJCiVAsB73DoY/wb0wLRYaPy12uR0s37hu33dD9stnt78f6Q100m7r5v50pwvh4q3p319uyJv/7QL99vsTPSx3DncFWa5XOBgVDma0RQpleEvTG5LqkjuIEjAuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780829354; c=relaxed/simple;
	bh=Xa1rwWiA3m+6ML/3Jg0U4R9ya4CsX1xf4AaAge/QzIE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Br3qTjCFzSTe9sc70WhK1RhfCUAK7AyMJ085YSb5mcaP+nzOLZ/GZ/HSdLvGcPCRcbDGGBsqnyM031l9Up+ikWl0lB168nXnaBVyn1zKEmbJJ6pAkx94kGtTGv687GIFuCwTqz1MbifBM3ncorT/l2FiQauWK+BmRKluZpBbKdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yBxMfijj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yBxMfijj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8D071F00893;
	Sun,  7 Jun 2026 10:49:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780829353;
	bh=ciyLYzYmNwVY1daFJtfiCbdpd1rUYpzeH8p/5JpAeiw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yBxMfijjXDxxYub2KoJZRHvBziKHIFSm/4kMzqOZrWyICMcritcgylMKxLHUQrYe6
	 W1jtg6DsY29sLJEuhulzCRVywRXTMF7i6JMzEVM7ug0gY+sKFHQwmLahDZIlW4cpKi
	 /s8zbOqU5D+dau8LgXNImEbEvgJWIbns9UvpPgdE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.18 240/315] USB: serial: mct_u232: fix missing interrupt-in transfer sanity check
Date: Sun,  7 Jun 2026 12:00:27 +0200
Message-ID: <20260607095736.382228087@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.528828913@linuxfoundation.org>
References: <20260607095727.528828913@linuxfoundation.org>
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
@@ -543,6 +543,11 @@ static void mct_u232_read_int_callback(s
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


