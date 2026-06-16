Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7137633A9EB;
	Tue, 16 Jun 2026 16:53:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781628790; cv=none; b=cPCOt1On4QLwHjmldK82GHQyxSz09wt7NYIJYX5launpXR5FLgAgp17/pd0BHYmRnIY6HCUUsjvmIhsmuNjYpSxxV4virjci5OsFLLCbAPLEHnDgxEc19nlwhDzdxG/FQULFpsxAPeMCd6R7KtMmvtKm6r00auPMTQ/c/Xtft7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781628790; c=relaxed/simple;
	bh=r5Qs0ml6ihJjFaXeRs8/vLI4oNZ7r89dR58DyBvnnUI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sosUF28NML+kyEukwvFnZSjeVIJLzh/7gHiOOn8MZ5bcfuhEYJ2ZkyZZQMVjZpPP5OiI+BW6AgI36gxMNjSeMwCNN4pRDRqt0+2iGT5foSVLnLx1likg9NI4d1Avj29in1oFYiBfmOS1EEiRS81K/pgQqrxuT+yTLJFJHfgzvSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ENoNsr4G; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ENoNsr4G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F2EB1F000E9;
	Tue, 16 Jun 2026 16:53:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781628789;
	bh=fL4D729GY17gTs5kKow+m6tl9Eszjwd84qAIusulwwE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ENoNsr4GcIYM/b9d6BbPRDfm39i0J3cfNwRlzN06Sy4gv2azjRe55pvuPdfvee3Pk
	 yp4UfOnaGhBE0cGKhtpj2xtuH2tnQ8e7EjVStLdTDTRmKEiria+Heh2cnZwdnNYrZg
	 Ye2AQnPmAwfuFKUgpA5FIApE9nSThC3HMMtdNgVg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Lunn <andrew@lunn.ch>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.6 163/452] USB: serial: mxuport: fix memory corruption with small endpoint
Date: Tue, 16 Jun 2026 20:26:30 +0530
Message-ID: <20260616145126.362470494@linuxfoundation.org>
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

commit 4085f0dbb1ce2251c9a5938d693de6593f0ab2bd upstream.

Make sure that the bulk-out endpoint max packet size is at least eight
bytes to avoid user-controlled slab corruption should a malicious device
report a smaller size.

Fixes: ee467a1f2066 ("USB: serial: add Moxa UPORT 12XX/14XX/16XX driver")
Cc: stable@vger.kernel.org	# 3.14
Cc: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/mxuport.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/usb/serial/mxuport.c
+++ b/drivers/usb/serial/mxuport.c
@@ -962,6 +962,14 @@ static int mxuport_calc_num_ports(struct
 	 */
 	BUILD_BUG_ON(ARRAY_SIZE(epds->bulk_out) < 16);
 
+	/*
+	 * The bulk-out buffers must be large enough for the four-byte header
+	 * (and following data), but assume anything smaller than eight bytes
+	 * is broken.
+	 */
+	if (usb_endpoint_maxp(epds->bulk_out[0]) < 8)
+		return -EINVAL;
+
 	for (i = 1; i < num_ports; ++i)
 		epds->bulk_out[i] = epds->bulk_out[0];
 


