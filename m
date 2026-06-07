Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E2372DFF04;
	Sun,  7 Jun 2026 10:49:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780829361; cv=none; b=ELTFtpu/13Wq4yCEj72/G3iw23hSKRJFlXGCSTjRIkQxoBHf+UZuIMMSTrDAwy63KpxppAcBSbqiXsbqfhB+D/LP3E9FnCexy7XoHuJBsDtK+2EpiqMpWxqo2XelptmaJ8GNAmq6lT9w0keFLrO98PW0maJZ/ERuxatrIkkaY3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780829361; c=relaxed/simple;
	bh=lxcSILrbi5S7OXBSyffILS5l2ydIJXXj2c7dVR4+ZwM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fm7WliysntAY+eASWfn9UFlZFAh3BB3ksZ4Tzlq9TOkh6pTXnRo3cPWIy0gE2pznl7NGF358KURTHoesZPJNuF/v7mlkXltRb75hzkUFy1/EVy/iHVA0akRzQoksWUQFOdvb9NjeMmiosYjK5KCEZZmofHYBSlNSEa3f3awMwRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QE35UVq/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QE35UVq/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3EBE1F00893;
	Sun,  7 Jun 2026 10:49:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780829360;
	bh=/eA/+8aEbqyKCVzHdb9IMepH+p+0m228jidPOE4y0rc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QE35UVq/4p/bD7xAvvnyix5E3Of6h+RwcWC76+TxdA25nEAxhWN1Yh59QcqyJ917S
	 0CpJr91043tRzX7Dh+OoxPy0kstQIlG+NMuaHdfXq+6sn3oQ+hEkKlEYr6lgE0H+Gd
	 l6PfxEEhK+2dTJgvAgJQ9eYsmXrEkmLBcMcsAC20=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 7.0 272/332] USB: serial: mct_u232: fix missing interrupt-in transfer sanity check
Date: Sun,  7 Jun 2026 12:00:41 +0200
Message-ID: <20260607095738.033839604@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
@@ -544,6 +544,11 @@ static void mct_u232_read_int_callback(s
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


