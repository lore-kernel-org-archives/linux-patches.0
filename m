Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 334154502F;
	Tue, 16 Jun 2026 16:53:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781628801; cv=none; b=NwGT1bznLcufASKVyNhy4X8OOrswc3z3ZIhGUJjUzRijHI3qM2kzaWI//969o32tNNWCF8UWfVUu0mfxsINOTPM5A0DfLsf5sa30l1wbun68IXkqFbGw+2RIqf+l4X6mMdI8PM8cxMo927B185zyOzZB555rrcgeQ2WOlq4RNeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781628801; c=relaxed/simple;
	bh=HhtGHiJdjvvoyBAdAqyG/8E9YuLH0Ga4tdyOoTILTRI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LFq4wm7AVrEBdva/hf5PWIQsFoYWiXcfkH/EnnOlj+KHT+w/I0kwB7URSV9JKC05iFiT8TzV35NtCOBcw/fmGUMQGf3OGmHuw/olr7983U7NIXmeHifP5oP65R4qfIpl2uNBIeDPpQl5sgHDHiBpt6M11Rn3eFX+J6p29nX8jVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gZBB0MC9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gZBB0MC9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1461F1F000E9;
	Tue, 16 Jun 2026 16:53:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781628799;
	bh=RjWQGiF8oTG0GZJMYDDjsefQHpF386N89DzjRddjVno=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gZBB0MC9Ysd8bVPR8nBRtpCV7JI2zQW/8/G2EJJmoA/3kIygHamISIANzu7gFZAn0
	 Yi+EFBVN8dQ/SJzJMcuD9Orz8VmCEXWUH+XNpmjLS+u5LlLFUPiS+cdtHe5nqk9Y9N
	 Cc/zvuLKYvgwGbS2Ss11cIELePVAX1JIxvqEURf4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.6 164/452] USB: serial: mct_u232: fix missing interrupt-in transfer sanity check
Date: Tue, 16 Jun 2026 20:26:31 +0530
Message-ID: <20260616145126.438016129@linuxfoundation.org>
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


