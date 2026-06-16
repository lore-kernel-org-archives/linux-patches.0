Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D6C8355F5F;
	Tue, 16 Jun 2026 17:31:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781631100; cv=none; b=Wx5V1Fl3DIxHud3qWsk/J7/YRP6u94yVpr9ZI6y/b339a1+8lWWmkhbInbEwv9hLMvXAX5WiABn7P79/MtnD54uYkAij1VKI5RxIoHEbcREkWYzqKsxeqcUmfI8K61u/RDrVoGxihvyGS9NFhNoxQ3CTMykCREN22/Pj23ChWYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781631100; c=relaxed/simple;
	bh=sBmJqtTnqBZjehE25r/4ntaHyWL1EK+MbvHjvjWKYRE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qmr3PTGFc2xPe6ga4gei8WLfAOQSAKmiOlygLJ1oe0WRsxj27s9UG+fldGzQ7iTS4CA2Va2S6CiyUQoSWQkUeI6agimUQ1rr9n7Ho/FkIc892qOsKCuxM9Yjcfbw4i05Z+pelR9hyqFPQ6h2eTSBqTeEtf+Ui9uR8lNgCJNjoTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JPAnJDoR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JPAnJDoR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E8B81F000E9;
	Tue, 16 Jun 2026 17:31:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781631099;
	bh=6HHY1nKQusPOvfUzhLUM5s+nX2GEGWqlDGRYcttCOTk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JPAnJDoRE66RKCyWsYZ8EMXBAG3jciftfp3RH4PsAaKiDXQAmJgbN1nPIgpNLbrWH
	 ZW/EXv6OywPLPGncZKZLi7JluKbPVCMmC/wneCWA8VFxAq0xdLvSBwicvFkATyBYfT
	 tFWWFIg5efWaoEIJlfEKD1WM71FehZnvqA3Xi9B8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.1 156/522] USB: serial: mct_u232: fix missing interrupt-in transfer sanity check
Date: Tue, 16 Jun 2026 20:25:03 +0530
Message-ID: <20260616145133.405664321@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


