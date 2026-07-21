Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D226043E488;
	Tue, 21 Jul 2026 22:19:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672389; cv=none; b=e7E6XiTmVRTz2mOtCLWtXs9dLTcgN3qzS/lsXiRWUwnBM08BP09j4dNFXtIQoD+cy4bfurRkGy0xW4gNk6c5QoSRNLYowIGKKuRFJ403kPLrvY3+OcjBXqHt2/nGhvjq4j6rYsCerss2TcvLlh5vT46V2jklpvsE1brSbBcSKII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672389; c=relaxed/simple;
	bh=6enKODJ9XYsm6tRafduCcxyHVFH1KVnjEyOcVEXjlhs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c8e9jBcJ52m2648If4jVx2jD25IoYkwKJBixc2gTxz5GGa6jZsG4ftx/Z6571z8+Oa1Yn8sVt3QPyhAhKK/HeIcv/imSaAMwggv5nsD4SoFe1E+D01SLmlGenh4lxn6Up4EjtJ75SWpJgqLFcW4bRSEMf2JQ1kHv29LkguNEJMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x/e8EskW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x/e8EskW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 432FC1F000E9;
	Tue, 21 Jul 2026 22:19:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672388;
	bh=oApBa4XqEKAVRQOp4CkEen+xoZj0QFFBfXIKY+0PfHU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x/e8EskWgC8c44cPhg/0PVctUbBczEVMesJTpTD3ILugXWkXOBu9XuAvREvTxps4K
	 ZP8h/tEnlDgctNtHKOyPpSMKu/vHdc6WYnWHSf/SWhxmOLa0agZ+S0gMqMAldsuFDC
	 88A7/1IRE+6W+Lx5Ab0W/rSrKVoMXNNmjYO/OOd0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.15 606/843] MIPS: ip22-gio: fix gio device memory leak
Date: Tue, 21 Jul 2026 17:24:01 +0200
Message-ID: <20260721152419.681954931@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 7de9a1b45f5a95b58145653c525c8fb80292d9ab upstream.

The gio device release callback was never wired up so gio devices are
not freed when the last reference is dropped.

Fixes: e84de0c61905 ("MIPS: GIO bus support for SGI IP22/28")
Cc: stable@vger.kernel.org	# 3.3
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/mips/sgi-ip22/ip22-gio.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/mips/sgi-ip22/ip22-gio.c
+++ b/arch/mips/sgi-ip22/ip22-gio.c
@@ -101,6 +101,8 @@ int gio_device_register(struct gio_devic
 {
 	giodev->dev.bus = &gio_bus_type;
 	giodev->dev.parent = &gio_bus;
+	giodev->dev.release = gio_release_dev;
+
 	return device_register(&giodev->dev);
 }
 EXPORT_SYMBOL_GPL(gio_device_register);


